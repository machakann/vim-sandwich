" textobj-sandwich: pick up a sandwich!
" NOTE: Because of the restriction of vim, if a operator to get the assigned
"       region is employed for 'external' user-defined textobjects, it makes
"       impossible to repeat by dot command. Thus, 'external' is checked by
"       using visual selection (xmap) in any case.

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_2coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \ }
let s:null_4coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \   'inner_head': copy(s:null_coord),
      \   'inner_tail': copy(s:null_coord),
      \ }

" types
let s:type_num  = type(0)
let s:type_str  = type('')
let s:type_list = type([])
let s:type_fref = type(function('tr'))

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_358 = has('patch-7.4.358')
else
  let s:has_patch_7_4_358 = v:version == 704 && has('patch358')
endif

" syntax
" NOTE: this would be evaluated every in textobj.initialize()
let s:is_syntax_on = 0

" features
let s:has_reltime_and_float = has('reltime') && has('float')
"}}}

""" Public funcs
function! textobj#sandwich#auto(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  let g:textobj#sandwich#object = deepcopy(s:textobj)
  let textobj = g:textobj#sandwich#object

  " set prerequisite initial values
  let textobj.state  = 1
  let textobj.kind   = 'auto'
  let textobj.mode   = a:mode
  let textobj.a_or_i = a:a_or_i
  let textobj.count  = v:count1
  let textobj.cursor = getpos('.')[1:2]
  let textobj.view   = winsaveview()
  let textobj.recipes.arg = get(a:000, 1, [])
  let textobj.recipes.arg_given = a:0 > 1
  let textobj.opt.filter = s:default_opt.filter
  call textobj.opt.update('arg', get(a:000, 0, {}))
  call textobj.opt.update('default', g:textobj#sandwich#options[textobj.kind])
  call textobj.recipes.integrate(textobj.kind, textobj.mode, textobj.opt)

  " uniq recipes
  let opt = textobj.opt
  call s:uniq_recipes(textobj.recipes.integrated, opt.of('regex'), opt.of('expr'), opt.of('noremap'))

  if textobj.recipes.integrated != []
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#query(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  let g:textobj#sandwich#object = deepcopy(s:textobj)
  let textobj = g:textobj#sandwich#object

  " set prerequisite initial values
  let textobj.state  = 1
  let textobj.kind   = 'query'
  let textobj.mode   = a:mode
  let textobj.a_or_i = a:a_or_i
  let textobj.count  = v:count1
  let textobj.cursor = getpos('.')[1:2]
  let textobj.view   = winsaveview()
  let textobj.recipes.arg = get(a:000, 1, [])
  let textobj.recipes.arg_given = a:0 > 1
  let textobj.opt.filter = s:default_opt.filter
  call textobj.opt.update('arg', get(a:000, 0, {}))
  call textobj.opt.update('default', g:textobj#sandwich#options[textobj.kind])
  call textobj.recipes.integrate(textobj.kind, textobj.mode, textobj.opt)

  call textobj.query()

  if textobj.recipes.integrated != []
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#select() abort  "{{{
  call g:textobj#sandwich#object.start()
endfunction
"}}}



""" Objects
" opt object  "{{{
function! s:opt_integrate() dict abort  "{{{
  call self.integrated.clear()
  let default = filter(copy(self.default), self.filter)
  let arg     = filter(copy(self.arg),     self.filter)
  let recipe  = filter(copy(self.recipe),  self.filter)
  call extend(self.integrated, default, 'force')
  call extend(self.integrated, arg,     'force')
  call extend(self.integrated, recipe,  'force')
endfunction
"}}}
function! s:opt_clear(target) dict abort "{{{
  call filter(self[a:target], 0)
endfunction
"}}}
function! s:opt_update(target, dict) dict abort "{{{
  call self.clear(a:target)
  call extend(self[a:target], filter(deepcopy(a:dict), self.filter), 'force')
endfunction
"}}}
function! s:opt_has(opt_name) dict abort  "{{{
  return has_key(self.default, a:opt_name)
endfunction
"}}}
function! s:opt_of(opt_name, ...) dict abort  "{{{
  if has_key(self['recipe'], a:opt_name)
    return self['recipe'][a:opt_name]
  elseif has_key(self['arg'], a:opt_name)
    return self['arg'][a:opt_name]
  else
    return self['default'][a:opt_name]
  endif
endfunction
"}}}
let s:opt = {
      \   'recipe' : {},
      \   'default': {},
      \   'arg'    : {},
      \   'filter' : '',
      \   'clear'  : function('s:opt_clear'),
      \   'update' : function('s:opt_update'),
      \   'has'    : function('s:opt_has'),
      \   'of'     : function('s:opt_of'),
      \ }
"}}}
" clock object  "{{{
function! s:clock_start() dict abort  "{{{
  if self.started
    if self.paused
      let self.losstime += str2float(reltimestr(reltime(self.pause_at)))
      let self.paused = 0
    endif
  else
    if s:has_reltime_and_float
      let self.zerotime = reltime()
      let self.started  = 1
    endif
  endif
endfunction
"}}}
function! s:clock_pause() dict abort "{{{
  let self.pause_at = reltime()
  let self.paused   = 1
endfunction
"}}}
function! s:clock_elapsed() dict abort "{{{
  if self.started
    let total = str2float(reltimestr(reltime(self.zerotime)))
    return floor((total - self.losstime)*1000)
  else
    return 0
  endif
endfunction
"}}}
function! s:clock_stop() dict abort  "{{{
  let self.started  = 0
  let self.paused   = 0
  let self.losstime = 0
endfunction
"}}}
let s:clock = {
      \   'started' : 0,
      \   'paused'  : 0,
      \   'losstime': 0,
      \   'zerotime': reltime(),
      \   'pause_at': reltime(),
      \   'start'   : function('s:clock_start'),
      \   'pause'   : function('s:clock_pause'),
      \   'elapsed' : function('s:clock_elapsed'),
      \   'stop'    : function('s:clock_stop'),
      \ }
"}}}
" coord object"{{{
function! s:coord_get_inner(buns, cursor, skip_break) dict abort "{{{
  call cursor(self.head)
  call search(a:buns[0], 'ce', self.tail[0])
  normal! l
  if a:skip_break && col('.') == col([line('.'), '$'])
    let self.inner_head = searchpos('\_S', '', self.tail[0])
  else
    let self.inner_head = getpos('.')[1:2]
  endif

  call cursor(self.tail)
  call search(a:buns[1], 'bc', self.head[0])
  if a:skip_break && (col('.') < 2 || getline(line('.'))[: col('.')-2] =~# '^\s*$')
    let self.inner_tail = searchpos('\_S', 'be', self.head[0])
  else
    if getpos('.')[2] == 1
      normal! hl
    else
      normal! h
    endif
    let self.inner_tail = getpos('.')[1:2]
  endif
endfunction
"}}}
function! s:coord_next() dict abort  "{{{
  call cursor(self.head)
  normal! h
  let self.head = getpos('.')[1:2]
endfunction
"}}}
let s:coord = deepcopy(s:null_4coord)
let s:coord.get_inner = function('s:coord_get_inner')
let s:coord.next = function('s:coord_next')
"}}}
" range object"{{{
function! s:range_initialize(lnum, expand_range) dict abort "{{{
  let filehead    = 1
  let fileend     = line('$')
  let self.valid  = 1
  let self.top    = a:lnum
  let self.bottom = a:lnum
  if a:expand_range >= 0
    let self.toplim = max([filehead, a:lnum - a:expand_range])
    let self.botlim = min([a:lnum + a:expand_range, fileend])
  else
    let self.toplim = filehead
    let self.botlim = fileend
  endif
  let self.count = 1
endfunction
"}}}
function! s:range_next() dict abort  "{{{
  if (self.top == 1/0 && self.bottom < 1)
        \ || (self.top <= self.toplim && self.bottom >= self.botlim)
    let self.top    = 1/0
    let self.bottom = 0
    let self.valid  = 0
  else
    if self.top > self.toplim
      let self.top = self.top - self.stride
      let self.top = self.top < self.toplim ? self.toplim : self.top
    endif
    if self.bottom < self.botlim
      let self.bottom = self.bottom + self.stride
      let self.bottom = self.bottom > self.botlim ? self.botlim : self.bottom
    endif
  endif
endfunction
"}}}
let s:range = {
      \   'valid'     : 0,
      \   'top'       : 0,
      \   'bottom'    : 0,
      \   'toplim'    : 0,
      \   'botlim'    : 0,
      \   'stride'    : &lines,
      \   'count'     : 1,
      \   'initialize': function('s:range_initialize'),
      \   'next'      : function('s:range_next'),
      \ }
"}}}
" stuff object "{{{
function! s:stuff_search_with_nest(candidates, stimeoutlen) dict abort  "{{{
  let buns  = self.get_buns()
  let range = self.range
  let coord = self.coord
  let opt   = self.opt

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif

  if !range.valid | return | endif

  " check whether the cursor is on the buns[1] or not
  call cursor(coord.head)
  let _head = searchpos(buns[1], 'bc', range.top, a:stimeoutlen)
  let _tail = searchpos(buns[1], 'cen', range.bottom, a:stimeoutlen)
  if _head != s:null_coord && _tail != s:null_coord && s:is_in_between(coord.head, _head, _tail)
    call cursor(_head)
  else
    call cursor(coord.head)
  endif

  while 1
    " search head
    let flag = searchpos(buns[1], 'cn', range.bottom, a:stimeoutlen) == getpos('.')[1:2]
          \ ? 'b' : 'bc'
    let head = searchpairpos(buns[0], '', buns[1], flag, 'self.skip(1)', range.top, a:stimeoutlen)
    if head == s:null_coord | break | endif
    let coord.head = head

    let self.syntax = s:is_syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

    " search tail
    let tail = searchpairpos(buns[0], '', buns[1], '', 'self.skip(0)', range.bottom, a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let tail = searchpos(buns[1], 'ce', range.bottom, a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let coord.tail = tail

    call coord.get_inner(buns, self.cursor, opt.of('skip_break'))

    " add to candidates
    if self.is_valid_candidate(a:candidates)
      let candidate = deepcopy(self)
      " this is required for the case of 'expr' option is 2.
      let candidate.buns[0:1] = buns
      call add(a:candidates, candidate)
    endif

    if coord.head == [1, 1]
      " finish!
      let range.valid = 0
      break
    else
      call coord.next()
    endif
  endwhile
  call range.next()
endfunction
"}}}
function! s:stuff_search_without_nest(candidates, stimeoutlen) dict abort  "{{{
  let buns  = self.get_buns()
  let range = self.range
  let coord = self.coord
  let opt   = self.opt

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif

  if !range.valid | return | endif

  " search nearest head
  call cursor(self.cursor)
  let head = self.searchpos(buns[0], 'bc', range.top, a:stimeoutlen, 1)
  if head == s:null_coord
    call range.next()
    return
  endif
  let _tail = searchpos(buns[0], 'ce', range.bottom, a:stimeoutlen)

  let self.syntax = s:is_syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

  " search nearest tail
  call cursor(self.cursor)
  let tail = self.searchpos(buns[1], 'ce',  range.bottom, a:stimeoutlen, 0)
  if tail == s:null_coord
    call range.next()
    return
  endif

  if tail == _tail
    " check whether it is head or tail
    let odd = 1
    call cursor([range.top, 1])
    let pos = searchpos(buns[0], 'c', range.top, a:stimeoutlen)
    while pos != head && pos != s:null_coord
      let odd = !odd
      let pos = searchpos(buns[0], '', range.top, a:stimeoutlen)
    endwhile
    if pos == s:null_coord | return | endif

    if odd
      " pos is head
      let head = pos

      let self.syntax = s:is_syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

      " search tail
      call search(buns[0], 'ce', range.bottom, a:stimeoutlen)
      let tail = self.searchpos(buns[1], 'e',  range.bottom, a:stimeoutlen, 0)
      if tail == s:null_coord
        call range.next()
        return
      endif
    else
      " pos is tail
      call cursor(pos)
      let tail = self.searchpos(buns[1], 'ce',  range.bottom, a:stimeoutlen, 1)

      let self.syntax = s:is_syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(tail)] : []

      " search head
      call search(buns[1], 'bc', range.top, a:stimeoutlen)
      let head = self.searchpos(buns[0], 'b',  range.top, a:stimeoutlen, 0)
      if head == s:null_coord
        call range.next()
        return
      endif
    endif
  endif

  let coord.head = head
  let coord.tail = tail
  call coord.get_inner(buns, self.cursor, self.opt.of('skip_break'))

  if self.is_valid_candidate(a:candidates)
    let candidate = deepcopy(self)
    " this is required for the case of 'expr' option is 2.
    let candidate.buns[0:1] = buns
    call add(a:candidates, candidate)
  endif

  let range.valid = 0
endfunction
"}}}
function! s:stuff_get_region(candidates, stimeoutlen) dict abort "{{{
  let range = self.range
  let coord = self.coord
  let opt   = self.opt

  if !range.valid | return | endif

  if opt.of('noremap')
    let cmd = 'normal!'
    let v = self.visualmode
  else
    let cmd = 'normal'
    let v = self.visualmode ==# 'v' ? "\<Plug>(sandwich-v)" :
          \ self.visualmode ==# 'V' ? "\<Plug>(sandwich-V)" :
          \ "\<Plug>(sandwich-CTRL-v)"
  endif

  let visualmode = self.visualmode
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  try
    while 1
      let [prev_head, prev_tail] = [coord.head, coord.tail]
      let [prev_inner_head, prev_inner_tail] = [coord.inner_head, coord.inner_tail]
      " get outer positions
      let [head, tail, visualmode_a] = s:get_textobj_region(self.cursor, cmd, v, range.count, self.external[1])

      " get inner positions
      let [inner_head, inner_tail, visualmode_i] = s:get_textobj_region(self.cursor, cmd, v, range.count, self.external[0])

      if (self.a_or_i ==# 'i' && s:is_valid_region(inner_head, inner_tail, prev_inner_head, prev_inner_tail, range.count))
       \ || (self.a_or_i ==# 'a' && s:is_valid_region(head, tail, prev_head, prev_tail, range.count))
        if head[0] >= range.top && tail[0] <= range.bottom
          let coord.head = head
          let coord.tail = tail
          let coord.inner_head = inner_head
          let coord.inner_tail = inner_tail

          if self.is_valid_candidate(a:candidates)
            let self.visualmode = self.a_or_i ==# 'a' ? visualmode_a : visualmode_i
            call add(a:candidates, deepcopy(self))
          endif
        else
          call range.next()
          break
        endif
      else
        let range.valid = 0
        break
      endif

      let range.count += 1
    endwhile
  finally
    " restore visualmode
    execute 'normal! ' . visualmode
    execute 'normal! ' . "\<Esc>"
    call cursor(self.cursor)
    " restore marks
    call setpos("'<", visual_head)
    call setpos("'>", visual_tail)
  endtry
endfunction
"}}}
function! s:stuff_searchpos(pattern, flag, stopline, timeout, is_head) dict abort "{{{
  let flag = a:flag
  if a:pattern !=# ''
    let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    let flag = substitute(flag, '\Cc', '', 'g')
    while coord != s:null_coord && self.skip(a:is_head, coord)
      let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    endwhile
  else
    let coord = copy(s:null_coord)
  endif
  return coord
endfunction
"}}}
function! s:stuff_skip(is_head, ...) dict abort  "{{{
  let cursor = getpos('.')[1:2]
  let coord = a:0 > 0 ? a:1 : cursor
  let opt = self.opt

  if coord == s:null_coord
    return 1
  endif

  " quoteescape option
  let skip_patterns = []
  if opt.of('quoteescape') && &quoteescape !=# ''
    for c in split(&quoteescape, '\zs')
      let c = s:escape(c)
      let pattern = printf('[^%s]%s\%%(%s%s\)*\zs\%%#', c, c, c, c)
      let skip_patterns += [pattern]
    endfor
  endif

  " skip_regex option
  let skip_patterns += opt.of('skip_regex')
  let skip_patterns += a:is_head ? opt.of('skip_regex_head') : opt.of('skip_regex_tail')
  if skip_patterns != []
    call cursor(coord)
    for pattern in skip_patterns
      let skip = searchpos(pattern, 'cn', cursor[0]) == coord
      if skip
        return 1
      endif
    endfor
  endif

  " syntax, match_syntax option
  if s:is_syntax_on
    if a:is_head || !opt.of('match_syntax')
      let opt_syntax = opt.of('syntax')
      if opt_syntax != [] && !s:is_included_syntax(coord, opt_syntax)
        return 1
      endif
    else
      if !s:is_matched_syntax(coord, self.syntax)
        return 1
      endif
    endif
  endif

  " skip_expr option
  for Expr in opt.of('skip_expr')
    if s:eval(Expr, a:is_head, s:c2p(coord))
      return 1
    endif
  endfor

  return 0
endfunction
"}}}
function! s:stuff_is_valid_candidate(candidates) dict abort "{{{
  let coord      = self.coord
  let opt        = self.opt
  let visualmark = self.visualmark

  if self.a_or_i ==# 'i'
    let [head, tail] = [coord.inner_head, coord.inner_tail]
    let filter = 'v:val.coord.inner_head == self.coord.inner_head && v:val.coord.inner_tail == self.coord.inner_tail'
  else
    let [head, tail] = [coord.head, coord.tail]
    let filter = 'v:val.coord.head == self.coord.head && v:val.coord.tail == self.coord.tail'
  endif

  " specific condition in visual mode
  if self.mode !=# 'x'
    let visual_mode_affair = 1
  else
    " self.visualmode ==# 'V' never comes.
    if self.visualmode ==# 'v'
      " character-wise
      if self.a_or_i ==# 'i'
        let visual_mode_affair = s:is_ahead(visualmark.head, head)
                            \ || s:is_ahead(tail, visualmark.tail)
      else
        let visual_mode_affair = (s:is_ahead(visualmark.head, head) && s:is_equal_or_ahead(tail, visualmark.tail))
                            \ || (s:is_equal_or_ahead(visualmark.head, head) && s:is_ahead(tail, visualmark.tail))
      endif
    else
      " block-wise
      let orig_pos = getpos('.')
      let visual_head = s:get_displaycoord(visualmark.head)
      let visual_tail = s:get_displaycoord(visualmark.tail)
      call s:set_displaycoord([self.cursor[0], visual_head[1]])
      let thr_head = getpos('.')
      call s:set_displaycoord([self.cursor[0], visual_tail[1]])
      let thr_tail = getpos('.')
      let visual_mode_affair = s:is_ahead(thr_head, head)
                          \ || s:is_ahead(tail, thr_tail)
      call setpos('.', orig_pos)
    endif
  endif

  " specific condition for the option 'matched_syntax' and 'inner_syntax'
  if s:is_syntax_on
    if opt.of('match_syntax') == 2
      let opt_syntax_affair = s:is_included_syntax(coord.inner_head, self.syntax)
                        \ && s:is_included_syntax(coord.inner_tail, self.syntax)
    elseif opt.of('match_syntax') == 3
      " check inner syntax independently
      if opt.of('inner_syntax') == []
        let syntax = [s:get_displaysyntax(coord.inner_head)]
        let opt_syntax_affair = s:is_included_syntax(coord.inner_tail, syntax)
      else
        if s:is_included_syntax(coord.inner_head, opt.of('inner_syntax'))
          let syntax = [s:get_displaysyntax(coord.inner_head)]
          let opt_syntax_affair = s:is_included_syntax(coord.inner_tail, syntax)
        else
          let opt_syntax_affair = 0
        endif
      endif
    else
      if opt.of('inner_syntax') == []
        let opt_syntax_affair = 1
      else
        let opt_syntax_affair = s:is_included_syntax(coord.inner_head, opt.of('inner_syntax'))
                          \ && s:is_included_syntax(coord.inner_tail, opt.of('inner_syntax'))
      endif
    endif
  else
    let opt_syntax_affair = 1
  endif

  return head != s:null_coord && tail != s:null_coord
        \ && s:is_equal_or_ahead(tail, head)
        \ && s:is_in_between(self.cursor, coord.head, coord.tail)
        \ && filter(copy(a:candidates), filter) == []
        \ && visual_mode_affair
        \ && opt_syntax_affair
endfunction
"}}}
function! s:stuff_get_buns() dict abort  "{{{
  let buns  = self.buns
  let clock = deepcopy(s:clock)
  let opt_expr  = self.opt.of('expr')
  let opt_regex = self.opt.of('regex')

  if (opt_expr && !self.evaluated) || opt_expr == 2
    call clock.pause()
    echo ''
    let buns = opt_expr == 2 ? deepcopy(buns) : buns
    let buns[0] = s:eval(buns[0], 1)
    if buns[0] !=# ''
      let buns[1] = s:eval(buns[1], 0)
    endif
    let self.evaluated = 1
    redraw
    echo ''
    call clock.start()
  endif

  if self.state && !opt_regex && !self.escaped
    call map(buns, 's:escape(v:val)')
    let self.escaped = 1
  endif

  return buns
endfunction
"}}}
function! s:stuff_synchronize() dict abort  "{{{
  " For the cooperation with operator-sandwich
  " NOTE: After visual selection by a user-defined textobject, v:operator is set as ':'
  " NOTE: 'synchro' option is not valid for visual mode, because there is no guarantee that g:operator#sandwich#object exists.
  if self.opt.of('synchro') && exists('g:operator#sandwich#object')
        \ && ((self.searchby ==# 'buns' && v:operator ==# 'g@') || (self.searchby ==# 'external' && v:operator =~# '\%(:\|g@\)'))
        \ && &operatorfunc =~# '^operator#sandwich#\%(delete\|replace\)'
    let recipe = {}
    if self.searchby ==# 'buns'
      call extend(recipe, {'buns': self.buns})
      call extend(recipe, {'expr': 0})
    elseif self.searchby ==# 'external'
      call extend(recipe, {'external': self.external})
      call extend(recipe, {'excursus': [self.range.count, [0] + self.cursor + [0]]})
    endif
    call extend(recipe, self.opt.recipe, 'keep')

    " If the recipe has 'kind' key and has no 'delete', 'replace' keys, then add these items.
    if has_key(recipe, 'kind') && filter(copy(recipe.kind), 'v:val ==# "delete" || v:val ==# "replace"') == []
      let recipe.kind += ['delete', 'replace']
    endif

    " Add 'delete' item to 'action' filter, if the recipe is not valid in 'delete' action.
    if has_key(recipe, 'action') && filter(copy(recipe.action), 'v:val ==# "delete"') == []
      let recipe.action += ['delete']
    endif

    let g:operator#sandwich#object.recipes.synchro = [recipe]
  endif
endfunction
"}}}
function! s:is_valid_region(head, tail, prev_head, prev_tail, count) abort  "{{{
  return a:head != s:null_coord && a:tail != s:null_coord && (a:count == 1 || s:is_ahead(a:prev_head, a:head) || s:is_ahead(a:tail, a:prev_tail))
endfunction
"}}}
function! s:get_textobj_region(cursor, cmd, visualmode, count, key_seq) abort "{{{
  call cursor(a:cursor)
  execute printf('%s %s%d%s', a:cmd, a:visualmode, a:count, a:key_seq)
  execute "normal! \<Esc>"
  let visualmode = visualmode()
  let [head, tail] = [getpos("'<")[1:2], getpos("'>")[1:2]]
  " NOTE: V never comes for v. Thus if head == tail == self.cursor, then
  "       it is failed.
  if head == a:cursor && tail == a:cursor
    let [head, tail] = [copy(s:null_coord), copy(s:null_coord)]
  elseif visualmode ==# 'V'
    let tail[2] = col([tail[1], '$'])
  endif
  return [head, tail, visualmode]
endfunction
"}}}
let s:stuff = {
      \   'buns'     : [],
      \   'external' : [],
      \   'searchby' : '',
      \   'state'    : 0,
      \   'a_or_i'   : '',
      \   'mode'     : '',
      \   'cursor'   : deepcopy(s:null_coord),
      \   'coord'    : deepcopy(s:coord),
      \   'range'    : deepcopy(s:range),
      \   'syntax'   : [],
      \   'opt'      : {},
      \   'escaped'  : 0,
      \   'evaluated': 0,
      \   'searchpos': function('s:stuff_searchpos'),
      \   'skip'     : function('s:stuff_skip'),
      \   'get_buns' : function('s:stuff_get_buns'),
      \   'synchronize'         : function('s:stuff_synchronize'),
      \   'is_valid_candidate'  : function('s:stuff_is_valid_candidate'),
      \   '_search_with_nest'   : function('s:stuff_search_with_nest'),
      \   '_search_without_nest': function('s:stuff_search_without_nest'),
      \   '_get_region'         : function('s:stuff_get_region'),
      \ }
"}}}
" textobj object  "{{{
function! s:textobj_query() dict abort  "{{{
  let recipes = deepcopy(self.recipes.integrated)
  let clock   = deepcopy(s:clock)
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
function! s:textobj_start() dict abort "{{{
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
function! s:textobj_initialize() dict abort  "{{{
  let self.count = !self.state && self.count != v:count1 ? v:count1 : self.count
  let self.done  = 0
  let s:is_syntax_on = exists('g:syntax_on') || exists('g:syntax_manual')

  if self.mode ==# 'x'
    let self.visualmark.head = getpos("'<")[1:2]
    let self.visualmark.tail = getpos("'>")[1:2]
  endif

  if self.state
    let self.visualmode = self.mode ==# 'x' && visualmode() ==# "\<C-v>" ? "\<C-v>" : 'v'

    " prepare basket
    for recipe in self.recipes.integrated
      let stuff = self.new_stuff(recipe)
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
function! s:textobj_new_stuff(recipe) dict abort "{{{
  let has_buns     = has_key(a:recipe, 'buns')
  let has_external = has_key(a:recipe, 'external')
  if !has_buns && !has_external
    return {}
  endif

  let stuff = deepcopy(s:stuff)
  let stuff.state  = self.state
  let stuff.a_or_i = self.a_or_i
  let stuff.mode   = self.mode
  let stuff.cursor = self.cursor
  let stuff.evaluated  = 0
  let stuff.visualmode = self.visualmode
  let stuff.coord.head = copy(self.cursor)
  let stuff.visualmark = self.visualmark
  let stuff.opt        = copy(self.opt)
  let stuff.opt.recipe = {}
  call stuff.opt.update('recipe', a:recipe)

  call stuff.range.initialize(self.cursor[0], stuff.opt.of('expand_range'))

  if has_buns
    let stuff.buns = remove(a:recipe, 'buns')
    let stuff.searchby = 'buns'
    if stuff.opt.of('nesting')
      let stuff.search = stuff._search_with_nest
    else
      let stuff.search = stuff._search_without_nest
    endif
  elseif has_external
    let stuff.external = remove(a:recipe, 'external')
    let stuff.searchby = 'external'
    let stuff.search = stuff._get_region
  endif

  return stuff
endfunction
"}}}
function! s:textobj_list(stimeoutlen) dict abort  "{{{
  let clock = deepcopy(s:clock)

  " gather candidates
  let candidates = []
  call clock.start()
  while filter(copy(self.basket), 'v:val.range.valid') != []
    for stuff in self.basket
      call stuff.search(candidates, a:stimeoutlen)
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
function! s:textobj_elect(candidates) dict abort "{{{
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
function! s:textobj_select(target) dict abort  "{{{
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

    call a:target.synchronize()
    let self.done = 1
  else
    if self.mode ==# 'x'
      normal! gv
    endif
  endif
endfunction
"}}}
function! s:textobj_finalize() dict abort "{{{
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
function! s:textobj_recipes_integrate(kind, mode, opt) dict abort  "{{{
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
function! s:uniq_recipes(recipes, opt_regex, opt_expr, opt_noremap) abort "{{{
  let recipes = copy(a:recipes)
  call filter(a:recipes, 0)
  while recipes != []
    let recipe = remove(recipes, 0)
    call add(a:recipes, recipe)
    if has_key(recipe, 'buns')
      call filter(recipes, '!s:is_duplicated_buns(v:val, recipe, a:opt_regex, a:opt_expr)')
    elseif has_key(recipe, 'external')
      call filter(recipes, '!s:is_duplicated_external(v:val, recipe, a:opt_noremap)')
    endif
  endwhile
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
      \     'integrate' : function('s:textobj_recipes_integrate'),
      \   },
      \   'basket'    : [],
      \   'visualmode': 'v',
      \   'visualmark': copy(s:null_2coord),
      \   'opt'       : deepcopy(s:opt),
      \   'done'      : 0,
      \   'query'     : function('s:textobj_query'),
      \   'start'     : function('s:textobj_start'),
      \   'initialize': function('s:textobj_initialize'),
      \   'new_stuff' : function('s:textobj_new_stuff'),
      \   'list'      : function('s:textobj_list'),
      \   'elect'     : function('s:textobj_elect'),
      \   'select'    : function('s:textobj_select'),
      \   'finalize'  : function('s:textobj_finalize'),
      \ }
"}}}



""" Private funcs
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
function! s:get(name, default) abort  "{{{
  return get(g:, 'textobj#sandwich#' . a:name, a:default)
endfunction
"}}}
function! s:get_buf_length(start, end) abort  "{{{
  if a:start[0] == a:end[0]
    let len = a:end[1] - a:start[1] + 1
  else
    let length_list = map(getline(a:start[0], a:end[0]), 'len(v:val) + 1')
    let idx = 0
    let accumm_length = 0
    let accumm_list   = [0]
    for length in length_list[1:]
      let accumm_length  = accumm_length + length_list[idx]
      let accumm_list   += [accumm_length]
      let idx += 1
    endfor
    let len = accumm_list[a:end[0] - a:start[0]] + a:end[1] - a:start[1] + 1
  endif
  return len
endfunction
"}}}
function! s:compare_buf_length(i1, i2) abort  "{{{
  return a:i1.len - a:i2.len
endfunction
"}}}
function! s:escape(string) abort  "{{{
  return escape(a:string, '~"\.^$[]*')
endfunction
"}}}
function! s:is_matched_syntax(coord, syntaxID) abort  "{{{
  if a:coord == s:null_coord
    return 0
  elseif a:syntaxID == []
    return 1
  else
    return s:get_displaysyntax(a:coord) ==? a:syntaxID[0]
  endif
endfunction
"}}}
function! s:is_included_syntax(coord, syntaxID) abort  "{{{
  let synstack = map(synstack(a:coord[0], a:coord[1]),
        \ 'synIDattr(synIDtrans(v:val), "name")')

  if a:syntaxID == []
    return 1
  elseif synstack == []
    if a:syntaxID == ['']
      return 1
    else
      return 0
    endif
  else
    return filter(map(copy(a:syntaxID), '''\c'' . v:val'), 'match(synstack, v:val) > -1') != []
  endif
endfunction
"}}}
function! s:is_in_between(coord, head, tail) abort  "{{{
  return (a:coord != s:null_coord) && (a:head != s:null_coord) && (a:tail != s:null_coord)
    \  && ((a:coord[0] > a:head[0]) || ((a:coord[0] == a:head[0]) && (a:coord[1] >= a:head[1])))
    \  && ((a:coord[0] < a:tail[0]) || ((a:coord[0] == a:tail[0]) && (a:coord[1] <= a:tail[1])))
endfunction
"}}}
function! s:is_ahead(coord1, coord2) abort  "{{{
  return a:coord1[0] > a:coord2[0] || (a:coord1[0] == a:coord2[0] && a:coord1[1] > a:coord2[1])
endfunction
"}}}
function! s:is_equal_or_ahead(coord1, coord2) abort  "{{{
  return a:coord1[0] > a:coord2[0] || (a:coord1[0] == a:coord2[0] && a:coord1[1] >= a:coord2[1])
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

    let inputs = get(candidate, 'input', candidate['buns'])
  elseif has_ext
    " 'input' is necessary for 'external' textobjects assignment
    if !has_key(candidate, 'input')
      return 0
    endif

    let inputs = a:candidate['input']
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
function! s:get_displaycoord(coord) abort "{{{
  let [lnum, col] = a:coord

  if [lnum, col] != s:null_coord
    let disp_col = col == 1 ? 1 : strdisplaywidth(getline(lnum)[: col - 2]) + 1
  else
    let disp_col = 0
  endif
  return [lnum, disp_col]
endfunction
"}}}
function! s:set_displaycoord(disp_coord) abort "{{{
  if a:disp_coord != s:null_coord
    execute 'normal! ' . a:disp_coord[0] . 'G' . a:disp_coord[1] . '|'
  endif
endfunction
"}}}
function! s:get_displaysyntax(coord) abort  "{{{
  return synIDattr(synIDtrans(synID(a:coord[0], a:coord[1], 1)), 'name')
endfunction
"}}}
function! s:c2p(coord) abort  "{{{
  return [0] + a:coord + [0]
endfunction
"}}}
" function! s:sort(list, func, count) abort  "{{{
if s:has_patch_7_4_358
  function! s:sort(list, func, count) abort
    return sort(a:list, a:func)
  endfunction
else
  function! s:sort(list, func, count) abort
    " NOTE: len(a:list) is always larger than count or same.
    " FIXME: The number of item in a:list would not be large, but if there was
    "        any efficient argorithm, I would rewrite here.
    let len = len(a:list)
    for i in range(a:count)
      if len - 2 >= i
        let min = len - 1
        for j in range(len - 2, i, -1)
          if a:list[min]['len'] >= a:list[j]['len']
            let min = j
          endif
        endfor

        if min > i
          call insert(a:list, remove(a:list, min), i)
        endif
      endif
    endfor
    return a:list
  endfunction
endif
"}}}
function! s:eval(expr, ...) abort "{{{
  return type(a:expr) == s:type_fref ? call(a:expr, a:000) : eval(a:expr)
endfunction
"}}}

" recipe  "{{{
function! textobj#sandwich#get_recipes() abort  "{{{
  let default = exists('g:textobj#sandwich#no_default_recipes')
            \ ? [] : g:textobj#sandwich#default_recipes
  return deepcopy(s:get('recipes', default))
endfunction
"}}}
if exists('g:textobj#sandwich#default_recipes')
  unlockvar! g:textobj#sandwich#default_recipes
endif
let g:textobj#sandwich#default_recipes = [
      \   {'buns': ['input("textobj-sandwich:head: ")', 'input("textobj-sandwich:tail: ")'], 'kind': ['query'], 'expr': 1, 'regex': 1, 'synchro': 1, 'input': ['i']},
      \ ]
lockvar! g:textobj#sandwich#default_recipes
"}}}

" options "{{{
let s:default_opt = {}
let s:default_opt.auto = {
      \   'expr'           : 0,
      \   'regex'          : 0,
      \   'skip_regex'     : [],
      \   'skip_regex_head': [],
      \   'skip_regex_tail': [],
      \   'quoteescape'    : 0,
      \   'expand_range'   : -1,
      \   'nesting'        : 0,
      \   'synchro'        : 0,
      \   'noremap'        : 1,
      \   'syntax'         : [],
      \   'inner_syntax'   : [],
      \   'match_syntax'   : 0,
      \   'skip_break'     : 0,
      \   'skip_expr'      : [],
      \ }
let s:default_opt.query = {
      \   'expr'           : 0,
      \   'regex'          : 0,
      \   'skip_regex'     : [],
      \   'skip_regex_head': [],
      \   'skip_regex_tail': [],
      \   'quoteescape'    : 0,
      \   'expand_range'   : -1,
      \   'nesting'        : 0,
      \   'synchro'        : 0,
      \   'noremap'        : 1,
      \   'syntax'         : [],
      \   'inner_syntax'   : [],
      \   'match_syntax'   : 0,
      \   'skip_break'     : 0,
      \   'skip_expr'      : [],
      \ }
let s:default_opt.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['auto']), '\|'))
function! s:initialize_options(...) abort  "{{{
  let manner = a:0 ? a:1 : 'keep'
  let g:textobj#sandwich#options = s:get('options', {})
  for kind in ['auto', 'query']
    if !has_key(g:textobj#sandwich#options, kind)
      let g:textobj#sandwich#options[kind] = {}
    endif
    call extend(g:textobj#sandwich#options[kind],
          \ deepcopy(s:default_opt[kind]), manner)
  endfor
endfunction
call s:initialize_options()
"}}}
function! textobj#sandwich#set_default() abort  "{{{
  call s:initialize_options('force')
endfunction
"}}}
function! textobj#sandwich#set(kind, option, value) abort "{{{
  if !(a:kind ==# 'auto' || a:kind ==# 'query' || a:kind ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid kind "' . a:kind . '".'
    echohl NONE
    return
  endif

  if filter(keys(s:default_opt[a:kind]), 'v:val ==# a:option') == []
    echohl WarningMsg
    echomsg 'Invalid option name "' . a:kind . '".'
    echohl NONE
    return
  endif

  if type(a:value) != type(s:default_opt[a:kind][a:option])
    echohl WarningMsg
    echomsg 'Invalid type of value. ' . string(a:value)
    echohl NONE
    return
  endif

  if a:kind ==# 'all'
    let kinds = ['auto', 'query']
  else
    let kinds = [a:kind]
  endif

  for kind in kinds
    let g:textobj#sandwich#options[a:kind][a:option] = a:value
  endfor
endfunction
"}}}
"}}}

unlet! g:textobj#sandwich#object


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
