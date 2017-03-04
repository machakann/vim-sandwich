" textobj object

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_2coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \ }

" types
let s:type_fref = type(function('tr'))

" common functions
let s:lib = textobj#sandwich#lib#get()
"}}}

function! textobj#sandwich#textobj#new(kind, a_or_i, mode, count, recipes, opt) abort  "{{{
  let textobj = deepcopy(s:textobj)
  let textobj.kind = a:kind
  let textobj.a_or_i = a:a_or_i
  let textobj.mode = a:mode
  let textobj.count = a:count
  let textobj.recipes = a:recipes
  let textobj.opt = a:opt

  " NOTE: The cursor position should be recorded in textobj#sandwich#auto()/textobj#sandwich#query().
  "       It is impossible to get it in textobj#sandwich#select() if in visual mode.
  let textobj.cursor = getpos('.')[1:2]
  return textobj
endfunction
"}}}

" s:textobj "{{{
let s:textobj = {
      \   'state'  : 1,
      \   'kind'   : '',
      \   'a_or_i' : 'i',
      \   'mode'   : '',
      \   'count'  : 0,
      \   'cursor' : copy(s:null_coord),
      \   'view'   : {},
      \   'recipes': {
      \     'arg'       : [],
      \     'arg_given' : 0,
      \     'integrated': [],
      \   },
      \   'visual': {
      \     'mode': '',
      \     'head': copy(s:null_coord),
      \     'tail': copy(s:null_coord),
      \   },
      \   'basket': [],
      \   'opt'   : {},
      \   'done'  : 0,
      \   'clock' : sandwich#clock#new(),
      \   'syntax_on': 0,
      \ }
"}}}
function! s:textobj.initialize() dict abort  "{{{
  let self.done = 0
  let self.count = !self.state && self.count != v:count1 ? v:count1 : self.count
  let self.syntax_on = exists('g:syntax_on') || exists('g:syntax_manual')
  if self.state
    let self.basket = map(copy(self.recipes.integrated), 'textobj#sandwich#stuff#new(v:val, self.opt)')
    call filter(self.basket, 'v:val != {}')
  else
    let self.cursor = getpos('.')[1:2]
  endif
  if self.mode ==# 'x'
    let self.visual.mode = visualmode() ==# "\<C-v>" ? "\<C-v>" : 'v'
    let self.visual.head = getpos("'<")[1:2]
    let self.visual.tail = getpos("'>")[1:2]
  else
    let self.visual.mode = 'v'
  endif
  for stuff in self.basket
    call stuff.startpos(self.cursor)
  endfor
endfunction
"}}}
function! s:textobj.list(stimeoutlen) dict abort  "{{{
  let clock = self.clock

  " gather candidates
  let candidates = []
  call clock.start()
  while filter(copy(self.basket), 'v:val.range.valid') != []
    for stuff in self.basket
      let candidates += self.search(stuff, a:stimeoutlen)
    endfor
    call s:uniq_candidates(candidates, self.a_or_i)
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
function! s:textobj.search(stuff, stimeoutlen) dict abort "{{{
  if a:stuff.searchby ==# 'buns'
    if a:stuff.opt.of('nesting')
      let candidates = self._search_with_nest(a:stuff, a:stimeoutlen)
    else
      let candidates = self._search_without_nest(a:stuff, a:stimeoutlen)
    endif
  elseif a:stuff.searchby ==# 'external'
    let candidates = self._get_region(a:stuff, a:stimeoutlen)
  else
    let candidates = []
  endif
  return candidates
endfunction
"}}}
function! s:textobj._search_with_nest(stuff, stimeoutlen) dict abort  "{{{
  let clock = self.clock
  let buns  = a:stuff.get_buns(self.state, clock)
  let range = a:stuff.range
  let coord = a:stuff.coord
  let opt   = a:stuff.opt
  let candidates = []

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif
  if !range.valid | return candidates | endif

  " check whether the cursor is on the buns[1] or not
  let cursorpos = coord.head
  call cursor(cursorpos)
  let _head = searchpos(buns[1], 'bcW', range.top, a:stimeoutlen)
  let _tail = searchpos(buns[1], 'cenW', range.bottom, a:stimeoutlen)
  if _head != s:null_coord && _tail != s:null_coord && s:is_in_between(cursorpos, _head, _tail)
    call cursor(_head)
  else
    call cursor(cursorpos)
  endif

  while 1
    " search head
    let flag = searchpos(buns[1], 'cn', range.bottom, a:stimeoutlen) == getpos('.')[1:2]
          \ ? 'b' : 'bc'
    let head = searchpairpos(buns[0], '', buns[1], flag, 's:skip(1, self.syntax_on, a:stuff.opt, a:stuff.syntax)', range.top, a:stimeoutlen)
    if head == s:null_coord | break | endif
    let coord.head = head

    let a:stuff.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

    " search tail
    let tail = searchpairpos(buns[0], '', buns[1], '', 's:skip(0, self.syntax_on, a:stuff.opt, a:stuff.syntax)', range.bottom, a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let tail = searchpos(buns[1], 'ce', range.bottom, a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let coord.tail = tail

    call coord.get_inner(buns, opt.of('skip_break'))

    " add to candidates
    if self.is_valid_candidate(a:stuff, self.syntax_on)
      let candidate = deepcopy(a:stuff)
      " this is required for the case of 'expr' option is 2.
      let candidate.buns[0:1] = buns
      let candidate.visualmode = self.visual.mode
      let candidates += [candidate]
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
  return candidates
endfunction
"}}}
function! s:textobj._search_without_nest(stuff, stimeoutlen) dict abort  "{{{
  let clock = self.clock
  let buns  = a:stuff.get_buns(self.state, clock)
  let range = a:stuff.range
  let coord = a:stuff.coord
  let opt   = a:stuff.opt
  let candidates = []

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif

  if !range.valid | return candidates | endif

  " search nearest head
  call cursor(coord.head)
  let head = s:searchpos(buns[0], a:stuff, 'bc', range.top, a:stimeoutlen, 1, self.syntax_on)
  if head == s:null_coord
    call range.next()
    return candidates
  endif
  let _tail = searchpos(buns[0], 'ce', range.bottom, a:stimeoutlen)

  let a:stuff.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

  " search nearest tail
  call cursor(coord.tail)
  let tail = s:searchpos(buns[1], a:stuff, 'ce',  range.bottom, a:stimeoutlen, 0, self.syntax_on)
  if tail == s:null_coord
    call range.next()
    return candidates
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
    if pos == s:null_coord | return candidates | endif

    if odd
      " pos is head
      let head = pos

      let a:stuff.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(head)] : []

      " search tail
      call search(buns[0], 'ce', range.bottom, a:stimeoutlen)
      let tail = s:searchpos(buns[1], a:stuff, 'e',  range.bottom, a:stimeoutlen, 0, self.syntax_on)
      if tail == s:null_coord
        call range.next()
        return candidates
      endif
    else
      " pos is tail
      call cursor(pos)
      let tail = s:searchpos(buns[1], a:stuff, 'ce',  range.bottom, a:stimeoutlen, 1, self.syntax_on)

      let a:stuff.syntax = self.syntax_on && opt.of('match_syntax') ? [s:get_displaysyntax(tail)] : []

      " search head
      call search(buns[1], 'bc', range.top, a:stimeoutlen)
      let head = s:searchpos(buns[0], a:stuff, 'b',  range.top, a:stimeoutlen, 0, self.syntax_on)
      if head == s:null_coord
        call range.next()
        return candidates
      endif
    endif
  endif
  let coord.head = head
  let coord.tail = tail
  call coord.get_inner(buns, a:stuff.opt.of('skip_break'))

  if self.is_valid_candidate(a:stuff, self.syntax_on)
    let candidate = deepcopy(a:stuff)
    " this is required for the case of 'expr' option is 2.
    unlet candidate.buns
    let candidate.buns = buns
    let candidate.visualmode = self.visual.mode
    let candidates += [candidate]
  endif
  let range.valid = 0
  return candidates
endfunction
"}}}
function! s:textobj._get_region(stuff, stimeoutlen) dict abort "{{{
  let range = a:stuff.range
  let coord = a:stuff.coord
  let opt   = a:stuff.opt
  let candidates = []

  if !range.valid | return candidates | endif

  if opt.of('noremap')
    let cmd = 'normal!'
    let v = self.visual.mode
  else
    let cmd = 'normal'
    let v = self.visual.mode ==# 'v' ? "\<Plug>(sandwich-v)" :
          \ self.visual.mode ==# 'V' ? "\<Plug>(sandwich-V)" :
          \ "\<Plug>(sandwich-CTRL-v)"
  endif

  if self.mode ==# 'x'
    let initpos = [self.visual.head, self.visual.tail]
  else
    let initpos = [self.cursor, self.cursor]
  endif
  try
    while 1
      let [prev_head, prev_tail] = [coord.head, coord.tail]
      let [prev_inner_head, prev_inner_tail] = [coord.inner_head, coord.inner_tail]
      " get outer positions
      let [head, tail, visualmode_a] = s:get_textobj_region(initpos, cmd, v, range.count, a:stuff.external[1])

      " get inner positions
      if head != s:null_coord && tail != s:null_coord
        let [inner_head, inner_tail, visualmode_i] = s:get_textobj_region(initpos, cmd, v, range.count, a:stuff.external[0])
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

          if self.is_valid_candidate(a:stuff, self.syntax_on)
            let candidate = deepcopy(a:stuff)
            let candidate.visualmode = self.a_or_i ==# 'a' ? visualmode_a : visualmode_i
            let candidates += [candidate]
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
    execute 'normal! ' . self.visual.mode
    execute "normal! \<Esc>"
    call cursor(self.cursor)
    " restore marks
    call setpos("'<", s:lib.c2p(self.visual.head))
    call setpos("'>", s:lib.c2p(self.visual.tail))
  endtry
  return candidates
endfunction
"}}}
function! s:textobj.is_valid_candidate(stuff, is_syntax_on) dict abort "{{{
  let visual = self.visual
  let coord  = a:stuff.coord
  let opt    = a:stuff.opt

  if self.a_or_i ==# 'i'
    let [head, tail] = [coord.inner_head, coord.inner_tail]
  else
    let [head, tail] = [coord.head, coord.tail]
  endif

  " specific condition in visual mode
  if self.mode !=# 'x'
    let visual_mode_affair = 1
  else
    " self.visual.mode ==# 'V' never comes.
    if self.visual.mode ==# 'v'
      " character-wise
      if self.a_or_i ==# 'i'
        let visual_mode_affair = s:is_ahead(visual.head, head)
                            \ || s:is_ahead(tail, visual.tail)
      else
        let visual_mode_affair = (s:is_ahead(visual.head, head) && s:is_equal_or_ahead(tail, visual.tail))
                            \ || (s:is_equal_or_ahead(visual.head, head) && s:is_ahead(tail, visual.tail))
      endif
    else
      " block-wise
      let orig_pos = getpos('.')
      let visual_head = s:lib.get_displaycoord(visual.head)
      let visual_tail = s:lib.get_displaycoord(visual.tail)
      call s:lib.set_displaycoord([self.cursor[0], visual_head[1]])
      let thr_head = getpos('.')
      call s:lib.set_displaycoord([self.cursor[0], visual_tail[1]])
      let thr_tail = getpos('.')
      let visual_mode_affair = s:is_ahead(thr_head, head)
                          \ || s:is_ahead(tail, thr_tail)
      call setpos('.', orig_pos)
    endif
  endif

  " specific condition for the option 'matched_syntax' and 'inner_syntax'
  if a:is_syntax_on
    if opt.of('match_syntax') == 2
      let opt_syntax_affair = s:is_included_syntax(coord.inner_head, a:stuff.syntax)
                         \ && s:is_included_syntax(coord.inner_tail, a:stuff.syntax)
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
        \ && visual_mode_affair
        \ && opt_syntax_affair
endfunction
"}}}
function! s:textobj.elect(candidates) dict abort "{{{
  let elected = {}
  if len(a:candidates) >= self.count
    " election
    let map_rule = 'extend(v:val, {"len": s:get_buf_length(v:val.coord.inner_head, v:val.coord.inner_tail)})'
    call map(a:candidates, map_rule)
    call s:lib.sort(a:candidates, function('s:compare_buf_length'), self.count)
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
  if a:target == {}
    if self.mode ==# 'x'
      normal! gv
    endif
    return
  endif

  let head = self.a_or_i ==# 'i' ? a:target.coord.inner_head : a:target.coord.head
  let tail = self.a_or_i ==# 'i' ? a:target.coord.inner_tail : a:target.coord.tail
  if self.mode ==# 'x' && self.visual.mode ==# "\<C-v>"
    " trick for the blockwise visual mode
    if self.cursor[0] == self.visual.tail[0]
      let disp_coord = s:lib.get_displaycoord(head)
      let disp_coord[0] = self.visual.head[0]
      call s:lib.set_displaycoord(disp_coord)
      let head = getpos('.')[1:2]
    elseif self.cursor[0] == self.visual.head[0]
      let disp_coord = s:lib.get_displaycoord(tail)
      let disp_coord[0] = self.visual.tail[0]
      call s:lib.set_displaycoord(disp_coord)
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

  call operator#sandwich#synchronize(self.kind, a:target.export(self.cursor))
  let self.done = 1
endfunction
"}}}
function! s:textobj.finalize(mark_latestjump) dict abort "{{{
  if self.done && a:mark_latestjump
    call setpos("''", s:lib.c2p(self.cursor))
  endif

  " flash echoing
  if !self.state
    echo ''
  endif

  let self.state = 0
endfunction
"}}}

" private functions
function! s:searchpos(pattern, stuff, flag, stopline, timeout, is_head, is_syntax_on) abort "{{{
  let flag = a:flag
  if a:pattern !=# ''
    let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    let flag = substitute(flag, '\Cc', '', 'g')
    while coord != s:null_coord && s:skip(a:is_head, a:is_syntax_on, a:stuff.opt, a:stuff.syntax, coord)
      let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    endwhile
  else
    let coord = copy(s:null_coord)
  endif
  return coord
endfunction
"}}}
function! s:skip(is_head, is_syntax_on, opt, syntax, ...) abort  "{{{
  " NOTE: for searchpairpos()/s:searchpos() functions.
  let cursor = getpos('.')[1:2]
  let coord = a:0 > 0 ? a:1 : cursor

  if coord == s:null_coord
    return 1
  endif

  " quoteescape option
  let skip_patterns = []
  if a:opt.of('quoteescape') && &quoteescape !=# ''
    for c in split(&quoteescape, '\zs')
      let c = s:lib.escape(c)
      let pattern = printf('[^%s]%s\%%(%s%s\)*\zs\%%#', c, c, c, c)
      let skip_patterns += [pattern]
    endfor
  endif

  " skip_regex option
  let skip_patterns += a:opt.of('skip_regex')
  let skip_patterns += a:is_head ? a:opt.of('skip_regex_head') : a:opt.of('skip_regex_tail')
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
  if a:is_syntax_on
    if a:is_head || !a:opt.of('match_syntax')
      let opt_syntax = a:opt.of('syntax')
      if opt_syntax != [] && !s:is_included_syntax(coord, opt_syntax)
        return 1
      endif
    else
      if !s:is_matched_syntax(coord, a:syntax)
        return 1
      endif
    endif
  endif

  " skip_expr option
  for Expr in a:opt.of('skip_expr')
    if s:eval(Expr, a:is_head, s:lib.c2p(coord))
      return 1
    endif
  endfor

  return 0
endfunction
"}}}
function! s:is_valid_region(head, tail, prev_head, prev_tail, count) abort  "{{{
  return a:head != s:null_coord && a:tail != s:null_coord && (a:count == 1 || s:is_ahead(a:prev_head, a:head) || s:is_ahead(a:tail, a:prev_tail))
endfunction
"}}}
function! s:get_textobj_region(initpos, cmd, visualmode, count, key_seq) abort "{{{
  call cursor(a:initpos[0])
  execute printf('%s %s', a:cmd, a:visualmode)
  call cursor(a:initpos[1])
  if a:cmd ==# 'normal!' && a:key_seq =~# '[ia]t'
    " workaround for {E33, E55} from textobjects it/at
    try
      execute printf('%s %d%s', a:cmd, a:count, a:key_seq)
    catch /^Vim\%((\a\+)\)\=:E\%(33\|55\)/
      if mode() ==? 'v' || mode() ==# "\<C-v>"
        execute "normal! \<Esc>"
      endif
      return [copy(s:null_coord), copy(s:null_coord), a:visualmode]
    endtry
  else
    execute printf('%s %d%s', a:cmd, a:count, a:key_seq)
  endif
  execute "normal! \<Esc>"
  let visualmode = visualmode()
  let [head, tail] = [getpos("'<")[1:2], getpos("'>")[1:2]]
  if head == a:initpos[0] && tail == a:initpos[1]
    let [head, tail] = [copy(s:null_coord), copy(s:null_coord)]
  elseif visualmode ==# 'V'
    let tail[2] = col([tail[1], '$'])
  endif
  return [head, tail, visualmode]
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
function! s:uniq_candidates(candidates, a_or_i) abort "{{{
  let i = 0
  if a:a_or_i ==# 'i'
    let filter = 'v:val.coord.inner_head != candidate.coord.inner_head || v:val.coord.inner_tail != candidate.coord.inner_tail'
  else
    let filter = 'v:val.coord.head == candidate.coord.head || v:val.coord.tail == candidate.coord.tail'
  endif
  while i+1 < len(a:candidates)
    let candidate = a:candidates[i]
    call filter(a:candidates[i+1 :], filter)
    let i += 1
  endwhile
  return a:candidates
endfunction
"}}}
function! s:get_displaysyntax(coord) abort  "{{{
  return synIDattr(synIDtrans(synID(a:coord[0], a:coord[1], 1)), 'name')
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
function! s:compare_buf_length(i1, i2) abort  "{{{
  return a:i1.len - a:i2.len
endfunction
"}}}
function! s:eval(expr, ...) abort "{{{
  return type(a:expr) == s:type_fref ? call(a:expr, a:000) : eval(a:expr)
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
