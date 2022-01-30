" textobj object - search & select a sandwiched text

" variables "{{{
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SNR = printf("\<SNR>%s_", s:SID())
delfunction s:SID

nnoremap <SID>(v) v
nnoremap <SID>(V) V
nnoremap <SID>(CTRL-v) <C-v>

let s:KEY_v = printf('%s(v)', s:SNR)
let s:KEY_V = printf('%s(V)', s:SNR)
let s:KEY_CTRL_v = printf('%s(CTRL-v)', s:SNR)

" null valiables
let s:null_coord = [0, 0]

" common functions
let s:lib = textobj#sandwich#lib#import()
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
      \ }
"}}}
function! s:textobj.initialize() dict abort  "{{{
  let self.done = 0
  let self.count = !self.state && self.count != v:count1 ? v:count1 : self.count
  if self.state
    let self.basket = map(copy(self.recipes.integrated), 'textobj#sandwich#sandwich#new(v:val, self.opt)')
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
  let is_syntax_on = exists('g:syntax_on') || exists('g:syntax_manual')
  call map(self.basket, 'v:val.initialize(self.cursor, is_syntax_on)')
endfunction
"}}}
function! s:textobj.list(stimeoutlen) dict abort  "{{{
  let clock = self.clock

  " gather candidates
  let candidates = []
  call clock.stop()
  call clock.start()
  while filter(copy(self.basket), 'v:val.range.valid') != []
    for sandwich in self.basket
      let candidates += self.search(sandwich, a:stimeoutlen)
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
function! s:textobj.search(sandwich, stimeoutlen) dict abort "{{{
  if a:sandwich.searchby ==# 'buns'
    if a:sandwich.opt.of('nesting')
      let candidates = self._search_with_nest(a:sandwich, a:stimeoutlen)
    else
      let candidates = self._search_without_nest(a:sandwich, a:stimeoutlen)
    endif
  elseif a:sandwich.searchby ==# 'external'
    let candidates = self._get_region(a:sandwich, a:stimeoutlen)
  else
    let candidates = []
  endif
  return candidates
endfunction
"}}}
function! s:textobj._search_with_nest(sandwich, stimeoutlen) dict abort  "{{{
  let buns  = a:sandwich.bake_buns(self.state, self.clock)
  let range = a:sandwich.range
  let coord = a:sandwich.coord
  let opt   = a:sandwich.opt
  let candidates = []

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif
  if !range.valid | return candidates | endif

  " check whether the cursor is on the buns[1] or not
  call cursor(self.cursor)
  let _head = searchpos(buns[1], 'bcW', range.top, a:stimeoutlen)
  let _tail = searchpos(buns[1], 'cenW', range.bottom, a:stimeoutlen)
  if _head != s:null_coord && _tail != s:null_coord && s:is_in_between(self.cursor, _head, _tail)
    call cursor(_head)
  else
    call cursor(self.cursor)
  endif

  while 1
    " search head
    let head = a:sandwich.searchpair_head(a:stimeoutlen)
    if head == s:null_coord | break | endif
    let coord.head = head
    call a:sandwich.check_syntax(head)

    " search tail
    let tail = a:sandwich.searchpair_tail(a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let tail = searchpos(buns[1], 'ce', range.bottom, a:stimeoutlen)
    if tail == s:null_coord | break | endif
    let coord.tail = tail

    " add to candidates
    call coord.get_inner(buns, opt.of('skip_break'))
    if self.is_valid_candidate(a:sandwich)
      let candidate = deepcopy(a:sandwich)
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
function! s:textobj._search_without_nest(sandwich, stimeoutlen) dict abort  "{{{
  let buns  = a:sandwich.bake_buns(self.state, self.clock)
  let range = a:sandwich.range
  let coord = a:sandwich.coord
  let opt   = a:sandwich.opt
  let candidates = []

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif
  if !range.valid | return candidates | endif

  " search nearest head
  call cursor(self.cursor)
  let head = a:sandwich.search_head('bc', a:stimeoutlen)
  if head == s:null_coord
    call range.next()
    return candidates
  endif
  call a:sandwich.check_syntax(head)
  let _tail = searchpos(buns[0], 'ce', range.bottom, a:stimeoutlen)

  " search nearest tail
  call cursor(self.cursor)
  let tail = a:sandwich.search_tail('ce', a:stimeoutlen)
  if tail == s:null_coord
    call range.next()
    return candidates
  endif

  " If the cursor is right on a bun
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
      call a:sandwich.check_syntax(head)

      " search tail
      call search(buns[0], 'ce', range.bottom, a:stimeoutlen)
      let tail = a:sandwich.search_tail('e', a:stimeoutlen)
      if tail == s:null_coord
        call range.next()
        return candidates
      endif
    else
      " pos is tail
      call cursor(pos)
      let tail = a:sandwich.search_tail('ce', a:stimeoutlen)
      call a:sandwich.check_syntax(tail)

      " search head
      call search(buns[1], 'bc', range.top, a:stimeoutlen)
      let head = a:sandwich.search_head('b', a:stimeoutlen)
      if head == s:null_coord
        call range.next()
        return candidates
      endif
    endif
  endif
  let coord.head = head
  let coord.tail = tail
  call coord.get_inner(buns, a:sandwich.opt.of('skip_break'))

  if self.is_valid_candidate(a:sandwich)
    let candidate = deepcopy(a:sandwich)
    let candidate.visualmode = self.visual.mode
    let candidates += [candidate]
  endif
  let range.valid = 0
  return candidates
endfunction
"}}}
function! s:textobj._get_region(sandwich, stimeoutlen) dict abort "{{{
  " NOTE: Because of the restriction of vim, if a operator to get the assigned
  "       region is employed for 'external' user-defined textobjects, it makes
  "       impossible to repeat by dot command. Thus, 'external' is checked by
  "       using visual selection xmap in any case.
  let range = a:sandwich.range
  let coord = a:sandwich.coord
  let opt   = a:sandwich.opt
  let candidates = []

  if !range.valid | return candidates | endif

  if opt.of('noremap')
    let cmd = 'normal!'
    let v = self.visual.mode
  else
    let cmd = 'normal'
    let v = self.visual.mode ==# 'v' ? s:KEY_v :
          \ self.visual.mode ==# 'V' ? s:KEY_V :
          \ s:KEY_CTRL_v
  endif

  if self.mode ==# 'x'
    let initpos = [self.visual.head, self.visual.tail]
  else
    let initpos = [self.cursor, self.cursor]
  endif

  let selection = &selection
  set selection=inclusive
  try
    while 1
      let [prev_head, prev_tail] = [coord.head, coord.tail]
      let [prev_inner_head, prev_inner_tail] = [coord.inner_head, coord.inner_tail]
      " get outer positions
      let [head, tail, visualmode_a] = s:get_textobj_region(initpos, cmd, v, range.count, a:sandwich.external[1])

      " get inner positions
      if head != s:null_coord && tail != s:null_coord
        let [inner_head, inner_tail, visualmode_i] = s:get_textobj_region(initpos, cmd, v, range.count, a:sandwich.external[0])
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

          if self.is_valid_candidate(a:sandwich)
            let candidate = deepcopy(a:sandwich)
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
    " restore options
    let &selection = selection
  endtry
  return candidates
endfunction
"}}}
function! s:textobj.is_valid_candidate(sandwich) dict abort "{{{
  let coord = a:sandwich.coord
  if !s:is_in_between(self.cursor, coord.head, coord.tail)
    return 0
  endif

  if self.a_or_i ==# 'i'
    let [head, tail] = [coord.inner_head, coord.inner_tail]
  else
    let [head, tail] = [coord.head, coord.tail]
  endif
  if head == s:null_coord || tail == s:null_coord || s:is_ahead(head, tail)
    return 0
  endif

  " specific condition in visual mode
  if self.mode !=# 'x'
    let visual_mode_affair = 1
  else
    let visual_mode_affair = s:visual_mode_affair(
          \ head, tail, self.a_or_i, self.cursor, self.visual)
  endif
  if !visual_mode_affair
    return 0
  endif

  " specific condition for the option 'matched_syntax' and 'inner_syntax'
  let opt_syntax_affair = s:opt_syntax_affair(a:sandwich)
  if !opt_syntax_affair
    return 0
  endif

  return 1
endfunction
"}}}
function! s:textobj.elect(candidates) dict abort "{{{
  let elected = {}
  if len(a:candidates) >= self.count
    " election
    let cursor = self.cursor
    let map_rule = 'extend(v:val, {"len": s:representative_length(v:val.coord, cursor)})'
    call map(a:candidates, map_rule)
    call s:lib.sort(a:candidates, function('s:compare_buf_length'), self.count)
    let elected = a:candidates[self.count - 1]
  endif
  return elected
endfunction
"}}}
function! s:textobj.select(sandwich) dict abort  "{{{
  if a:sandwich == {}
    if self.mode ==# 'x'
      normal! gv
    endif
    let self.done = 1
    return
  endif

  let head = self.a_or_i ==# 'i' ? a:sandwich.coord.inner_head : a:sandwich.coord.head
  let tail = self.a_or_i ==# 'i' ? a:sandwich.coord.inner_tail : a:sandwich.coord.tail
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

  execute 'normal! ' . a:sandwich.visualmode
  call cursor(head)
  normal! o
  call cursor(tail)

  " counter measure for the 'selection' option being 'exclusive'
  if &selection ==# 'exclusive'
    normal! l
  endif

  call operator#sandwich#synchronize(self.kind, a:sandwich.export_recipe())
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

function! s:is_valid_region(head, tail, prev_head, prev_tail, count) abort  "{{{
  return a:head != s:null_coord && a:tail != s:null_coord && (a:count == 1 || s:is_ahead(a:prev_head, a:head) || s:is_ahead(a:tail, a:prev_tail))
endfunction
"}}}
function! s:get_textobj_region(initpos, cmd, visualmode, count, key_seq) abort "{{{
  call cursor(a:initpos[0])
  execute printf('silent! %s %s', a:cmd, a:visualmode)
  call cursor(a:initpos[1])
  execute printf('silent! %s %d%s', a:cmd, a:count, a:key_seq)
  if mode() ==? 'v' || mode() ==# "\<C-v>"
    execute "normal! \<Esc>"
  else
    return [copy(s:null_coord), copy(s:null_coord), a:visualmode]
  endif
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
function! s:visual_mode_affair(head, tail, a_or_i, cursor, visual) abort "{{{
  " a:visual.mode ==# 'V' never comes.
  if a:visual.mode ==# 'v'
    " character-wise
    if a:a_or_i ==# 'i'
      let visual_mode_affair = s:is_ahead(a:visual.head, a:head)
                          \ || s:is_ahead(a:tail, a:visual.tail)
    else
      let visual_mode_affair = (s:is_ahead(a:visual.head, a:head) && s:is_equal_or_ahead(a:tail, a:visual.tail))
                          \ || (s:is_equal_or_ahead(a:visual.head, a:head) && s:is_ahead(a:tail, a:visual.tail))
    endif
  else
    " block-wise
    let orig_pos = getpos('.')
    let visual_head = s:lib.get_displaycoord(a:visual.head)
    let visual_tail = s:lib.get_displaycoord(a:visual.tail)
    call s:lib.set_displaycoord([a:cursor[0], visual_head[1]])
    let thr_head = getpos('.')
    call s:lib.set_displaycoord([a:cursor[0], visual_tail[1]])
    let thr_tail = getpos('.')
    let visual_mode_affair = s:is_ahead(thr_head, a:head)
                        \ || s:is_ahead(a:tail, thr_tail)
    call setpos('.', orig_pos)
  endif
  return visual_mode_affair
endfunction
"}}}
function! s:opt_syntax_affair(sandwich) abort "{{{
  if !a:sandwich.syntax_on
    return 1
  endif

  let coord = a:sandwich.coord
  let opt = a:sandwich.opt
  if opt.of('match_syntax') == 2
    let opt_syntax_affair = s:lib.is_included_syntax(coord.inner_head, a:sandwich.syntax)
                        \ && s:lib.is_included_syntax(coord.inner_tail, a:sandwich.syntax)
  elseif opt.of('match_syntax') == 3
    " check inner syntax independently
    if opt.of('inner_syntax') == []
      let syntax = [s:lib.get_displaysyntax(coord.inner_head)]
      let opt_syntax_affair = s:lib.is_included_syntax(coord.inner_tail, syntax)
    else
      if s:lib.is_included_syntax(coord.inner_head, opt.of('inner_syntax'))
        let syntax = [s:lib.get_displaysyntax(coord.inner_head)]
        let opt_syntax_affair = s:lib.is_included_syntax(coord.inner_tail, syntax)
      else
        let opt_syntax_affair = 0
      endif
    endif
  else
    if opt.of('inner_syntax') == []
      let opt_syntax_affair = 1
    else
      let opt_syntax_affair = s:lib.is_included_syntax(coord.inner_head, opt.of('inner_syntax'))
                          \ && s:lib.is_included_syntax(coord.inner_tail, opt.of('inner_syntax'))
    endif
  endif
  return opt_syntax_affair
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
function! s:representative_length(coord, cursor) abort "{{{
  let inner_head = a:coord.inner_head
  let inner_tail = a:coord.inner_tail
  if s:is_in_between(a:cursor, inner_head, inner_tail)
    return s:get_buf_length(inner_head, inner_tail)
  else
    return s:get_buf_length(a:coord.head, a:coord.tail)
  endif
endfunction "}}}
function! s:compare_buf_length(i1, i2) abort  "{{{
  return a:i1.len - a:i2.len
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
