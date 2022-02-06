" recipes object

" variables "{{{
let s:TRUE = 1
let s:FALSE = 0

" types
let s:type_num = type(0)
let s:type_str = type('')
"}}}

function! textobj#sandwich#recipes#new(kind, mode, ...) abort "{{{
  let recipes = deepcopy(s:recipes)
  if a:0 > 0
    let recipes.arg = a:1
    let recipes.arg_given = 1
  endif
  call recipes._integrate(a:kind, a:mode)
  return recipes
endfunction
"}}}

" s:recipes "{{{
let s:recipes = {
      \   'arg': [],
      \   'arg_given': 0,
      \   'integrated': [],
      \ }
"}}}
function! s:recipes.uniq(opt) dict abort "{{{
  let opt_regex = a:opt.of('regex')
  let opt_expr = a:opt.of('expr')
  let opt_noremap = a:opt.of('noremap')
  let recipes = copy(self.integrated)
  call filter(self.integrated, 0)
  while recipes != []
    let recipe = remove(recipes, 0)
    call add(self.integrated, recipe)
    if has_key(recipe, 'buns')
      call filter(recipes, '!s:is_duplicated_buns(v:val, recipe, opt_regex, opt_expr)')
    elseif has_key(recipe, 'external')
      call filter(recipes, '!s:is_duplicated_external(v:val, recipe, opt_noremap)')
    endif
  endwhile
endfunction
"}}}
function! s:recipes.query(opt, timeout, timeoutlen) dict abort "{{{
  let recipes = deepcopy(self.integrated)
  let clock = sandwich#clock#new()
  let input = ''
  let last_compl_match = ['', []]
  while 1
    let c = getchar(0)
    if empty(c)
      if clock.started && a:timeout && a:timeoutlen > 0 && clock.elapsed() > a:timeoutlen
        let [input, recipes] = last_compl_match
        break
      else
        sleep 20m
        continue
      endif
    endif

    let c = type(c) == s:type_num ? nr2char(c) : c

    " exit loop if <Esc> is pressed
    if c is# "\<Esc>"
      let input = "\<Esc>"
      break
    endif

    let input .= c

    " check forward match
    let n_fwd = len(filter(recipes, 's:is_input_matched(v:val, input, a:opt, 0)'))

    " check complete match
    let n_comp = len(filter(copy(recipes), 's:is_input_matched(v:val, input, a:opt, 1)'))
    if n_comp || strchars(input) == 1
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

  if filter(recipes, 's:is_input_matched(v:val, input, a:opt, 1)') != []
    let recipe = recipes[0]
    if has_key(recipe, 'buns') || has_key(recipe, 'external')
      let self.integrated = [recipe]
    else
      let self.integrated = []
    endif
  else
    if s:is_input_fallback(input)
      let c = split(input, '\zs')[0]
      let recipe = {'buns': [c, c], 'expr': 0, 'regex': 0}
      let self.integrated = [recipe]
    else
      let self.integrated = []
    endif
  endif
endfunction
"}}}
function! s:recipes._integrate(kind, mode) dict abort  "{{{
  let self.integrated = []
  if self.arg_given
    let self.integrated += self.arg
  else
    let self.integrated += sandwich#get_recipes()
    let self.integrated += textobj#sandwich#get_recipes()
  endif
  let filter = 's:has_filetype(v:val)
           \ && s:has_kind(v:val, a:kind)
           \ && s:has_mode(v:val, a:mode)
           \ && s:has_action(v:val)
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
      let filter = 'v:val ==# "all" || index(filetypes, v:val) > -1'
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
function! s:has_action(candidate) abort "{{{
  if !has_key(a:candidate, 'action')
    return 1
  endif
  let filter = 'v:val ==# "delete" || v:val ==# "all"'
  return filter(copy(a:candidate['action']), filter) != []
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

function! s:is_duplicated_buns(item, ref, opt_regex, opt_expr) abort  "{{{
  if has_key(a:item, 'buns')
        \ && type(a:ref['buns'][0]) == s:type_str
        \ && type(a:ref['buns'][1]) == s:type_str
        \ && type(a:item['buns'][0]) == s:type_str
        \ && type(a:item['buns'][1]) == s:type_str
        \ && a:ref['buns'][0] ==# a:item['buns'][0]
        \ && a:ref['buns'][1] ==# a:item['buns'][1]
    let regex_r = get(a:ref,  'regex', a:opt_regex)
    let regex_i = get(a:item, 'regex', a:opt_regex)
    let expr_r  = get(a:ref,  'expr',  a:opt_expr)
    let expr_i  = get(a:item, 'expr',  a:opt_expr)

    let expr_r = expr_r ? 1 : 0
    let expr_i = expr_i ? 1 : 0

    if regex_r == regex_i && expr_r == expr_i
      return 1
    endif
  endif
  return 0
endfunction
"}}}
function! s:is_duplicated_external(item, ref, opt_noremap) abort "{{{
  if has_key(a:item, 'external')
        \ && a:ref['external'][0] ==# a:item['external'][0]
        \ && a:ref['external'][1] ==# a:item['external'][1]
    let noremap_r = get(a:ref,  'noremap', a:opt_noremap)
    let noremap_i = get(a:item, 'noremap', a:opt_noremap)

    if noremap_r == noremap_i
      return 1
    endif
  endif

  return 0
endfunction
"}}}
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
function! s:is_input_fallback(input) abort "{{{
  if a:input ==# "\<Esc>" || a:input ==# '' || a:input =~# '^[\x80]'
    return s:FALSE
  endif
  let input_fallback = get(g:, 'sandwich#input_fallback', s:TRUE)
  if !input_fallback
    return s:FALSE
  endif
  return s:TRUE
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
