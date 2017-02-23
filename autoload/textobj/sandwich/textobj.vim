" textobj object

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_2coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \ }

" types
let s:type_num  = type(0)
"}}}

function! textobj#sandwich#textobj#new() abort  "{{{
  return deepcopy(s:textobj)
endfunction
"}}}

" s:textobj "{{{
let s:textobj = {
      \   'state'     : 0,
      \   'kind'      : '',
      \   'a_or_i'    : 'i',
      \   'mode'      : '',
      \   'count'     : 0,
      \   'cursor'    : copy(s:null_coord),
      \   'view'      : {},
      \   'recipes'   : {
      \     'arg'       : [],
      \     'integrated': [],
      \   },
      \   'basket'    : [],
      \   'visualmode': 'v',
      \   'visualmark': copy(s:null_2coord),
      \   'opt'       : {},
      \   'done'      : 0,
      \ }
"}}}
function! s:textobj.query() dict abort  "{{{
  let recipes = deepcopy(self.recipes.integrated)
  let clock   = sandwich#clock#new()
  let timeoutlen = max([0, s:get('timeoutlen', &timeoutlen)])

  " query phase
  let input   = ''
  let last_compl_match = ['', []]
  while 1
    let c = getchar(0)
    if empty(c)
      if clock.started && timeoutlen > 0 && clock.elapsed() > timeoutlen
        let [input, recipes] = last_compl_match
        break
      else
        sleep 20m
        continue
      endif
    endif

    let c = type(c) == s:type_num ? nr2char(c) : c
    let input .= c

    " check forward match
    let n_fwd = len(filter(recipes, 's:is_input_matched(v:val, input, self.opt, 0)'))

    " check complete match
    let n_comp = len(filter(copy(recipes), 's:is_input_matched(v:val, input, self.opt, 1)'))
    if n_comp
      if len(recipes) == n_comp
        break
      else
        call clock.stop()
        call clock.start()
        let last_compl_match = [input, copy(recipes)]
      endif
    else
      if clock.started && !n_fwd
        let [input, recipes] = last_compl_match
        " FIXME: Additional keypress, 'c', is ignored now, but it should be pressed.
        "        The problem is feedkeys() cannot be used for here...
        break
      endif
    endif

    if recipes == [] | break | endif
  endwhile
  call clock.stop()

  " pick up and register a recipe
  if filter(recipes, 's:is_input_matched(v:val, input, self.opt, 1)') != []
    let recipe = recipes[0]
  else
    if input ==# "\<Esc>" || input ==# "\<C-c>" || input ==# ''
      let recipe = {}
    else
      let c = split(input, '\zs')[0]
      let recipe = {'buns': [c, c], 'expr': 0, 'regex': 0}
    endif
  endif

  if has_key(recipe, 'buns') || has_key(recipe, 'external')
    let self.recipes.integrated = [recipe]
  else
    let self.recipes.integrated = []
  endif
endfunction
"}}}
function! s:textobj.start() dict abort "{{{
  call self.initialize()

  let stimeoutlen = max([0, s:get('stimeoutlen', 500)])
  let [virtualedit, whichwrap]   = [&virtualedit, &whichwrap]
  let [&virtualedit, &whichwrap] = ['onemore', 'h,l']
  try
    let candidates = self.list(stimeoutlen)
    let elected = self.elect(candidates)
    call self.select(elected)
  finally
    call self.finalize()
    let [&virtualedit, &whichwrap] = [virtualedit, whichwrap]
  endtry
endfunction
"}}}
function! s:textobj.initialize() dict abort  "{{{
  let self.count = !self.state && self.count != v:count1 ? v:count1 : self.count
  let self.done  = 0
  let is_syntax_on = exists('g:syntax_on') || exists('g:syntax_manual')

  if self.mode ==# 'x'
    let self.visualmark.head = getpos("'<")[1:2]
    let self.visualmark.tail = getpos("'>")[1:2]
  endif

  if self.state
    let self.visualmode = self.mode ==# 'x' && visualmode() ==# "\<C-v>" ? "\<C-v>" : 'v'

    " prepare basket
    for recipe in self.recipes.integrated
      let stuff = self.new_stuff(recipe)
      let stuff.syntax_on = is_syntax_on
      if stuff != {}
        let self.basket += [stuff]
      endif
    endfor
  else
    let self.cursor = getpos('.')[1:2]
    let self.view   = winsaveview()

    " prepare basket
    for stuff in self.basket
      let stuff.state  = self.state
      let stuff.cursor = self.cursor
      let stuff.syntax_on = is_syntax_on
      let stuff.coord.head = copy(self.cursor)
      let stuff.coord.tail = copy(s:null_coord)
      let stuff.coord.inner_head = copy(s:null_coord)
      let stuff.coord.inner_tail = copy(s:null_coord)

      let opt = stuff.opt
      call stuff.range.initialize(self.cursor[0], opt.of('expand_range'))
    endfor
  endif
endfunction
"}}}
function! s:textobj.new_stuff(recipe) dict abort "{{{
  let has_buns     = has_key(a:recipe, 'buns')
  let has_external = has_key(a:recipe, 'external')
  if !has_buns && !has_external
    return {}
  endif

  let stuff = textobj#sandwich#stuff#new()
  let stuff.state  = self.state
  let stuff.a_or_i = self.a_or_i
  let stuff.mode   = self.mode
  let stuff.cursor = self.cursor
  let stuff.evaluated  = 0
  let stuff.syntax_on  = 0
  let stuff.visualmode = self.visualmode
  let stuff.coord.head = copy(self.cursor)
  let stuff.visualmark = self.visualmark
  let stuff.opt        = copy(self.opt)
  let stuff.opt.recipe = {}
  call stuff.opt.update('recipe', a:recipe)

  call stuff.range.initialize(self.cursor[0], stuff.opt.of('expand_range'))

  if has_buns
    let stuff.buns = a:recipe.buns
    let stuff.searchby = 'buns'
    if stuff.opt.of('nesting')
      let stuff.search = stuff._search_with_nest
    else
      let stuff.search = stuff._search_without_nest
    endif
  elseif has_external
    let stuff.external = a:recipe.external
    let stuff.searchby = 'external'
    let stuff.search = stuff._get_region
  endif
  let stuff.recipe = a:recipe

  return stuff
endfunction
"}}}
function! s:textobj.list(stimeoutlen) dict abort  "{{{
  let clock = sandwich#clock#new()

  " gather candidates
  let candidates = []
  call clock.start()
  while filter(copy(self.basket), 'v:val.range.valid') != []
    for stuff in self.basket
      call stuff.search(candidates, clock, a:stimeoutlen)
    endfor

    if len(candidates) >= self.count
      break
    endif

    " time out
    if clock.started && a:stimeoutlen > 0
      let elapsed = clock.elapsed()
      if elapsed > a:stimeoutlen
        echo 'textobj-sandwich: Timed out.'
        break
      endif
    endif
  endwhile
  call clock.stop()

  return candidates
endfunction
"}}}
function! s:textobj.elect(candidates) dict abort "{{{
  let elected = {}
  if len(a:candidates) >= self.count
    " election
    let map_rule = 'extend(v:val, {"len": s:get_buf_length(v:val.coord.inner_head, v:val.coord.inner_tail)})'
    call map(a:candidates, map_rule)
    call s:sort(a:candidates, 's:compare_buf_length', self.count)
    let elected = a:candidates[self.count - 1]
  else
    if self.mode ==# 'x'
      normal! gv
    endif
  endif
  return elected
endfunction
"}}}
function! s:textobj.select(target) dict abort  "{{{
  if a:target != {}
    " restore view
    call winrestview(self.view)

    " select
    let head = self.a_or_i ==# 'i' ? a:target.coord.inner_head : a:target.coord.head
    let tail = self.a_or_i ==# 'i' ? a:target.coord.inner_tail : a:target.coord.tail
    if self.mode ==# 'x' && self.visualmode ==# "\<C-v>"
      " trick for the blockwise visual mode
      if self.cursor[0] == self.visualmark.tail[0]
        let disp_coord = s:get_displaycoord(head)
        let disp_coord[0] = self.visualmark.head[0]
        call s:set_displaycoord(disp_coord)
        let head = getpos('.')[1:2]
      elseif self.cursor[0] == self.visualmark.head[0]
        let disp_coord = s:get_displaycoord(tail)
        let disp_coord[0] = self.visualmark.tail[0]
        call s:set_displaycoord(disp_coord)
        let tail = getpos('.')[1:2]
      endif
    endif

    execute 'normal! ' . a:target.visualmode
    call cursor(head)
    normal! o
    call cursor(tail)

    " counter measure for the 'selection' option being 'exclusive'
    if &selection ==# 'exclusive'
      normal! l
    endif

    call operator#sandwich#synchronize(self.kind, a:target.synchronized_recipe())
    let self.done = 1
  else
    if self.mode ==# 'x'
      normal! gv
    endif
  endif
endfunction
"}}}
function! s:textobj.finalize() dict abort "{{{
  if s:get('latest_jump', 1)
    call setpos("''", [0] + self.cursor + [0])
  endif

  if !self.done
    call winrestview(self.view)
  endif

  " flash echoing
  if !self.state
    echo ''
  endif

  let self.state = 0
endfunction
"}}}
function! s:textobj.recipes.integrate(kind, mode, opt) dict abort  "{{{
  let self.integrated  = []
  if self.arg_given
    let self.integrated += self.arg
  else
    let self.integrated += sandwich#get_recipes()
    let self.integrated += textobj#sandwich#get_recipes()
  endif
  let filter = 's:has_filetype(v:val)
           \ && s:has_kind(v:val, a:kind)
           \ && s:has_mode(v:val, a:mode)
           \ && s:expr_filter(v:val)'
  call filter(self.integrated, filter)
  call reverse(self.integrated)
endfunction
"}}}

" filters
function! s:has_filetype(candidate) abort "{{{
  if !has_key(a:candidate, 'filetype')
    return 1
  else
    let filetypes = split(&filetype, '\.')
    if filetypes == []
      let filter = 'v:val ==# "all" || v:val ==# ""'
    else
      let filter = 'v:val ==# "all" || (v:val !=# "" && match(filetypes, v:val) > -1)'
    endif
    return filter(copy(a:candidate['filetype']), filter) != []
  endif
endfunction
"}}}
function! s:has_kind(candidate, kind) abort "{{{
  if !has_key(a:candidate, 'kind')
    return 1
  else
    let filter = 'v:val ==# a:kind || v:val ==# "textobj" || v:val ==# "all"'
    return filter(copy(a:candidate['kind']), filter) != []
  endif
endfunction
"}}}
function! s:has_mode(candidate, mode) abort "{{{
  if !has_key(a:candidate, 'mode')
    return 1
  else
    return stridx(join(a:candidate['mode'], ''), a:mode) > -1
  endif
endfunction
"}}}
function! s:expr_filter(candidate) abort  "{{{
  if !has_key(a:candidate, 'expr_filter')
    return 1
  else
    for filter in a:candidate['expr_filter']
      if !eval(filter)
        return 0
      endif
    endfor
    return 1
  endif
endfunction
"}}}

" private functions
function! s:is_input_matched(candidate, input, opt, flag) abort "{{{
  let has_buns = has_key(a:candidate, 'buns')
  let has_ext  = has_key(a:candidate, 'external') && has_key(a:candidate, 'input')
  if !(has_buns || has_ext)
    return 0
  elseif !a:flag && a:input ==# ''
    return 1
  endif

  let candidate = deepcopy(a:candidate)

  if has_buns
    call a:opt.update('recipe', candidate)

    " 'input' is necessary for 'expr' or 'regex' buns
    if (a:opt.of('expr') || a:opt.of('regex')) && !has_key(candidate, 'input')
      return 0
    endif

    let inputs = copy(get(candidate, 'input', candidate['buns']))
  elseif has_ext
    " 'input' is necessary for 'external' textobjects assignment
    if !has_key(candidate, 'input')
      return 0
    endif

    let inputs = copy(a:candidate['input'])
  endif

  " If a:flag == 0, check forward match. Otherwise, check complete match.
  if a:flag
    return filter(inputs, 'v:val ==# a:input') != []
  else
    let idx = strlen(a:input) - 1
    return filter(inputs, 'v:val[: idx] ==# a:input') != []
  endif
endfunction
"}}}
function! s:get_buf_length(start, end) abort  "{{{
  if a:start[0] == a:end[0]
    let len = a:end[1] - a:start[1] + 1
  else
    let len = (line2byte(a:end[0]) + a:end[1]) - (line2byte(a:start[0]) + a:start[1]) + 1
  endif
  return len
endfunction
"}}}

let [s:sort, s:get, s:get_displaycoord, s:set_displaycoord]
      \ = textobj#sandwich#lib#funcref(['sort', 'get', 'get_displaycoord', 'set_displaycoord'])


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
