" stuff object

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_4coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \   'inner_head': copy(s:null_coord),
      \   'inner_tail': copy(s:null_coord),
      \ }

" types
let s:type_num = type(0)
let s:type_str = type('')
let s:type_list = type([])
let s:type_fref = type(function('tr'))
"}}}

function! textobj#sandwich#stuff#new() abort  "{{{
  return deepcopy(s:stuff)
endfunction
"}}}

" coord object"{{{
let s:coord = deepcopy(s:null_4coord)
function! s:coord.get_inner(buns, cursor, skip_break) dict abort "{{{
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
function! s:coord.next() dict abort  "{{{
  call cursor(self.head)
  normal! h
  let self.head = getpos('.')[1:2]
endfunction
"}}}
"}}}
" range object"{{{
let s:range = {
      \   'valid'     : 0,
      \   'top'       : 0,
      \   'bottom'    : 0,
      \   'toplim'    : 0,
      \   'botlim'    : 0,
      \   'stride'    : &lines,
      \   'count'     : 1,
      \ }
function! s:range.initialize(lnum, expand_range) dict abort "{{{
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
function! s:range.next() dict abort  "{{{
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
"}}}

" s:stuff "{{{
let s:stuff = {
      \   'buns'     : [],
      \   'recipe'   : {},
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
      \   'syntax_on': 0,
      \   'synchro_buns': [],
      \ }
"}}}
function! s:stuff._search_with_nest(candidates, clock, stimeoutlen) dict abort  "{{{
  let buns  = self.get_buns(a:clock)
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

    let self.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

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
function! s:stuff._search_without_nest(candidates, clock, stimeoutlen) dict abort  "{{{
  let buns  = self.get_buns(a:clock)
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

  let self.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

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

      let self.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

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

      let self.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(tail)] : []

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
    unlet candidate.buns
    let candidate.buns = buns
    call add(a:candidates, candidate)
  endif

  let range.valid = 0
endfunction
"}}}
function! s:stuff._get_region(candidates, clock, stimeoutlen) dict abort "{{{
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
      if head != s:null_coord && tail != s:null_coord
        let [inner_head, inner_tail, visualmode_i] = s:get_textobj_region(self.cursor, cmd, v, range.count, self.external[0])
      else
        let [inner_head, inner_tail, visualmode_i] = [copy(s:null_coord), copy(s:null_coord), 'v']
      endif

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
    execute "normal! \<Esc>"
    call cursor(self.cursor)
    " restore marks
    call setpos("'<", visual_head)
    call setpos("'>", visual_tail)
  endtry
endfunction
"}}}
function! s:stuff.searchpos(pattern, flag, stopline, timeout, is_head) dict abort "{{{
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
function! s:stuff.skip(is_head, ...) dict abort  "{{{
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
  if self.syntax_on
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
function! s:stuff.is_valid_candidate(candidates) dict abort "{{{
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
  if self.syntax_on
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
function! s:stuff.get_buns(clock) dict abort  "{{{
  let opt_listexpr = self.opt.of('listexpr')
  let opt_expr = self.opt.of('expr')
  let opt_regex = self.opt.of('regex')

  call a:clock.pause()
  if opt_listexpr == 2
    let buns = eval(self.buns)
  elseif opt_listexpr == 1 && !self.evaluated
    let buns = eval(self.buns)
    unlet self.buns
    let self.buns = buns
    let self.evaluated = 1
  elseif opt_expr == 2
    let buns = ['', '']
    let buns[0] = eval(self.buns[0])
    if buns[0] !=# ''
      let buns[1] = eval(self.buns[1])
    endif
  elseif opt_expr == 1 && !self.evaluated
    let buns = self.buns
    let buns[0] = eval(buns[0])
    if buns[0] !=# ''
      let buns[1] = eval(buns[1])
    endif
    let self.evaluated = 1
  else
    let buns = self.buns
  endif
  call a:clock.start()

  if !s:valid_buns(buns)
    return ['', '']
  endif

  if !self.escaped
    let self.synchro_buns = copy(buns)
    if self.state && !opt_regex
      call map(buns, 's:escape(v:val)')
      if buns is self.buns
        let self.escaped = 1
      endif
    endif
  endif
  return buns
endfunction
"}}}
function! s:stuff.synchronized_recipe() dict abort  "{{{
  " For the cooperation with operator-sandwich
  " NOTE: After visual selection by a user-defined textobject, v:operator is set as ':'
  " NOTE: 'synchro' option is not valid for visual mode, because there is no guarantee that g:operator#sandwich#object exists.
  if self.opt.of('synchro') && exists('g:operator#sandwich#object')
        \ && ((self.searchby ==# 'buns' && v:operator ==# 'g@') || (self.searchby ==# 'external' && v:operator =~# '\%(:\|g@\)'))
        \ && &operatorfunc =~# '^operator#sandwich#\%(delete\|replace\)'
    let recipe = self.recipe
    if self.searchby ==# 'buns'
      call extend(recipe, {'buns': self.synchro_buns}, 'force')
      call extend(recipe, {'expr': 0}, 'force')
    elseif self.searchby ==# 'external'
      let excursus = {
            \   'count' : self.range.count,
            \   'cursor': [0] + self.cursor + [0],
            \   'coord' : self.coord,
            \ }
      call extend(recipe, {'excursus': excursus}, 'force')
    endif
    call extend(recipe, {'action': ['delete']}, 'force')
  else
    let recipe = {}
  endif
  return recipe
endfunction
"}}}

function! s:is_valid_region(head, tail, prev_head, prev_tail, count) abort  "{{{
  return a:head != s:null_coord && a:tail != s:null_coord && (a:count == 1 || s:is_ahead(a:prev_head, a:head) || s:is_ahead(a:tail, a:prev_tail))
endfunction
"}}}
function! s:get_textobj_region(cursor, cmd, visualmode, count, key_seq) abort "{{{
  call cursor(a:cursor)
  if a:cmd ==# 'normal!' && a:key_seq =~# '[ia]t'
    " workaround for {E33, E55} from textobjects it/at
    try
      execute printf('%s %s%d%s', a:cmd, a:visualmode, a:count, a:key_seq)
    catch /^Vim\%((\a\+)\)\=:E\%(33\|55\)/
      if mode() ==? 'v' || mode() ==# "\<C-v>"
        execute "normal! \<Esc>"
      endif
      return [copy(s:null_coord), copy(s:null_coord), a:visualmode]
    endtry
  else
    execute printf('%s %s%d%s', a:cmd, a:visualmode, a:count, a:key_seq)
  endif
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
function! s:get_displaysyntax(coord) abort  "{{{
  return synIDattr(synIDtrans(synID(a:coord[0], a:coord[1], 1)), 'name')
endfunction
"}}}
function! s:valid_buns(buns) abort  "{{{
  return type(a:buns) == s:type_list && s:check_a_bun(a:buns[0]) && s:check_a_bun(a:buns[1])
endfunction
"}}}
function! s:check_a_bun(bun) abort  "{{{
  let type_bun = type(a:bun)
  return type_bun ==# s:type_num || (type_bun ==# s:type_str && a:bun !=# '')
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
function! s:eval(expr, ...) abort "{{{
  return type(a:expr) == s:type_fref ? call(a:expr, a:000) : eval(a:expr)
endfunction
"}}}

let [s:c2p, s:escape, s:get_displaycoord, s:set_displaycoord]
      \ = textobj#sandwich#lib#funcref(['c2p', 'escape', 'get_displaycoord', 'set_displaycoord'])


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
