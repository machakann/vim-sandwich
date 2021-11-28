" stuff object - managing a line on buffer

let s:lib = operator#sandwich#lib#import()

" variables "{{{
" null valiables
let s:null_coord = [0, 0]
let s:null_pos   = [0, 0, 0, 0]
let s:null_2pos  = {
      \   'head': copy(s:null_pos),
      \   'tail': copy(s:null_pos),
      \ }
let s:null_4pos  = {
      \   'head1': copy(s:null_pos),
      \   'tail1': copy(s:null_pos),
      \   'head2': copy(s:null_pos),
      \   'tail2': copy(s:null_pos),
      \ }
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SNR = printf("\<SNR>%s_", s:SID())
delfunction s:SID

nnoremap <SID>(v) v

let s:KEY_v = printf('%s(v)', s:SNR)

" types
let s:type_list = type([])

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_771 = has('patch-7.4.771')
  let s:has_patch_7_4_358 = has('patch-7.4.358')
else
  let s:has_patch_7_4_771 = v:version == 704 && has('patch771')
  let s:has_patch_7_4_358 = v:version == 704 && has('patch358')
endif
"}}}

function! operator#sandwich#stuff#new() abort "{{{
  return deepcopy(s:stuff)
endfunction
"}}}

" s:stuff "{{{
let s:stuff = {
      \   'active'   : 1,
      \   'edges'    : copy(s:null_2pos),
      \   'target'   : copy(s:null_4pos),
      \   'acts'     : [],
      \   'added'    : [],
      \ }
"}}}
function! s:stuff.initialize(count, cursor, modmark) dict abort  "{{{
  let self.active = 1
  let self.acts = map(range(a:count), 'operator#sandwich#act#new()')
  let self.added = []
  for act in self.acts
    call act.initialize(a:cursor, a:modmark, self.added)
  endfor
endfunction
"}}}
function! s:stuff.set_target() dict abort  "{{{
  if self.active
    let head = copy(self.edges.head)
    let tail = copy(self.edges.tail)
    let self.target.head1 = head
    let self.target.tail1 = head
    let self.target.head2 = tail
    let self.target.tail2 = tail
  endif
endfunction
"}}}
function! s:stuff.match(recipes, opt, ...) dict abort "{{{
  if !self.active
    return 0
  endif

  let edges = self.edges
  let edges_saved = deepcopy(edges)
  let match_edges = get(a:000, 0, 1)
  if s:lib.is_valid_2pos(edges) && s:lib.is_ahead(edges.tail, edges.head)
    let edge_chars = ['', '']
    if self._match_recipes(a:recipes, a:opt) || (match_edges && self._match_edges(a:recipes, a:opt, edge_chars))
      " found!
      return 1
    else
      let [head_c, tail_c] = edge_chars
      if head_c =~# '\s' || tail_c =~# '\s'
        call self.skip_space()
        if s:lib.is_ahead(edges.head, edges.tail)
          " invalid edges after skip spaces
          let self.active = 0
          return 0
        else
          if self._match_recipes(a:recipes, a:opt, 1) || self._match_edges(a:recipes, a:opt, edge_chars)
            " found
            return 1
          endif
        endif
      endif
    endif
    let edges = edges_saved

    " skip characters
    let target_list = []
    for candidate in a:recipes
      call a:opt.update('recipe_delete', candidate)
      if a:opt.of('skip_char') && has_key(candidate, 'buns')
        let head = edges.head
        let tail = edges.tail
        let opt_regex = a:opt.of('regex')
        let patterns = s:get_patterns(candidate, opt_regex)
        let target_list += [s:search_edges(head, tail, patterns)]
      endif
    endfor
    if filter(target_list, 's:lib.is_valid_4pos(v:val)') != []
      " found
      let self.target = s:shortest(target_list)
      return 1
    endif

    call a:opt.clear('recipe_delete')
  endif
  let self.active = 0
  return 0
endfunction
"}}}
function! s:stuff._match_recipes(recipes, opt, ...) dict abort "{{{
  let is_space_skipped = get(a:000, 0, 0)

  let found = 0
  for candidate in a:recipes
    call a:opt.update('recipe_delete', candidate)
    if !is_space_skipped || a:opt.of('skip_space')
      if has_key(candidate, 'buns')
        " search buns
        let patterns = s:get_patterns(candidate, a:opt.of('regex'))
        let target = s:check_edges(self.edges.head, self.edges.tail, patterns)
      elseif has_key(candidate, 'external')
        " get difference of external motion/textobject
        let target = s:check_textobj_diff(self.edges.head, self.edges.tail, candidate, a:opt.of('noremap', 'recipe_delete'))
      else
        let target = deepcopy(s:null_4pos)
      endif

      if s:lib.is_valid_4pos(target)
        let found = 1
        let self.target = target
        break
      endif
    endif
  endfor
  return found
endfunction
"}}}
function! s:stuff._match_edges(recipes, opt, edge_chars) dict abort "{{{
  let head = self.edges.head
  let tail = self.edges.tail
  let head_c = s:get_cursorchar(head)
  let tail_c = s:get_cursorchar(tail)

  let found = 0
  if head_c ==# tail_c
    " check duplicate with recipe
    for candidate in a:recipes
      call a:opt.update('recipe_delete', candidate)
      if has_key(candidate, 'buns') && !a:opt.of('regex')
            \ && candidate.buns[0] ==# head_c
            \ && candidate.buns[1] ==# tail_c
        " The pair has already checked by a recipe.
        return 0
      endif
    endfor

    " both edges are matched
    call a:opt.clear('recipe_delete')
    if !(a:opt.of('skip_space') == 2 && head_c =~# '\s')
      let found = 1
      let self.target = {
            \   'head1': head, 'tail1': head,
            \   'head2': tail, 'tail2': tail,
            \ }
    endif
  endif

  let a:edge_chars[0] = head_c
  let a:edge_chars[1] = tail_c
  return found
endfunction
"}}}
function! s:stuff.skip_space() dict abort  "{{{
  if self.active
    call s:skip_space(self.edges.head, self.edges.tail)
    if s:lib.is_ahead(self.edges.head, self.edges.tail)
      let self.active = 0
    endif
  endif
endfunction
"}}}
function! s:stuff.hi_list(place, linewise) dict abort "{{{
  if !self.active
    return []
  endif

  let orderlist = []
  if a:place ==# 'target'
    let orderlist += [[self.target, [a:linewise, a:linewise]]]
  elseif a:place ==# 'added'
    for added in self.added
      let orderlist += [[added, added.linewise]]
    endfor
  elseif a:place ==# 'stuff'
    let stuff = {'head1': self.edges.head, 'tail1': self.edges.tail, 'head2': copy(s:null_pos), 'tail2': copy(s:null_pos)}
    let orderlist += [[stuff, [0, 0]]]
  endif
  return orderlist
endfunction
"}}}

" private functions
function! s:check_edges(head, tail, patterns) abort  "{{{
  if a:patterns[0] ==# '' || a:patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(a:patterns[0], 'c', a:tail[1])

  if head1 != a:head[1:2] | return s:null_4pos | endif

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, a:patterns[1], a:head[1])

  if tail2 != a:tail[1:2] | return s:null_4pos | endif

  let head2 = searchpos(a:patterns[1], 'bc', a:head[1])
  call setpos('.', a:head)
  let tail1 = searchpos(a:patterns[0], 'ce', a:tail[1])

  if head1 == s:null_coord || tail1 == s:null_coord
        \ || head2 == s:null_coord || tail2 == s:null_coord
        \ || s:lib.is_equal_or_ahead(s:lib.c2p(tail1), s:lib.c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:lib.c2p(v:val)')
endfunction
"}}}
function! s:search_edges(head, tail, patterns) abort "{{{
  if a:patterns[0] ==# '' || a:patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(a:patterns[0], 'c', a:tail[1])

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, a:patterns[1], a:head[1])

  if head1 == s:null_coord || tail2 == s:null_coord
        \ || s:lib.is_equal_or_ahead(s:lib.c2p(head1), s:lib.c2p(tail2))
    return s:null_4pos
  endif

  let head2 = searchpos(a:patterns[1], 'bc', head1[0])
  call setpos('.', s:lib.c2p(head1))
  let tail1 = searchpos(a:patterns[0], 'ce', head2[0])

  if tail1 == s:null_coord || head2 == s:null_coord
        \ || s:lib.is_ahead(s:lib.c2p(head1), s:lib.c2p(tail1))
        \ || s:lib.is_ahead(s:lib.c2p(head2), s:lib.c2p(tail2))
        \ || s:lib.is_equal_or_ahead(s:lib.c2p(tail1), s:lib.c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:lib.c2p(v:val)')
endfunction
"}}}
function! s:check_textobj_diff(head, tail, candidate, opt_noremap) abort  "{{{
  let target = deepcopy(s:null_4pos)
  if has_key(a:candidate, 'excursus')
    let coord = a:candidate.excursus.coord
    let target.head1 = s:lib.c2p(coord.head)
    let target.tail1 = s:lib.get_left_pos(s:lib.c2p(coord.inner_head))
    let target.head2 = s:lib.get_right_pos(s:lib.c2p(coord.inner_tail))
    let target.tail2 = s:lib.c2p(coord.tail)

    if target.head1 == a:head && target.tail2 == a:tail
          \ && target.tail1 != s:null_pos && target.head2 != s:null_pos
          \ && s:lib.is_equal_or_ahead(target.tail1, target.head1)
          \ && s:lib.is_equal_or_ahead(target.tail2, target.head2)
      return target
    endif
  endif

  let [textobj_i, textobj_a] = a:candidate.external
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  let visualmode = visualmode()
  if a:opt_noremap
    let cmd = 'silent! normal!'
    let v   = 'v'
  else
    let cmd = 'silent! normal'
    let v   = s:KEY_v
  endif

  let order_list = [[1, a:head], [1, a:tail]]
  if has_key(a:candidate, 'excursus')
    let order_list = [[a:candidate.excursus.count, a:candidate.excursus.cursor]] + order_list
  endif

  let found = 0
  for [l:count, cursor] in order_list
    " get outer positions
    let [target.head1, target.tail2, motionwise_a] = s:get_textobj_region(cursor, cmd, v, l:count, textobj_a)

    " get inner positions
    let [target.tail1, target.head2, motionwise_i] = s:get_textobj_region(cursor, cmd, v, l:count, textobj_i)
    if motionwise_i ==# "\<C-v>"
      normal! gv
      if getpos('.')[1] == target.head2[1]
        normal! O
        let target.tail1 = getpos('.')
        normal! o
        let target.head2 = getpos('.')
      else
        normal! O
        let target.head2 = getpos('.')
        normal! o
        let target.tail1 = getpos('.')
      endif
      execute "normal! \<Esc>"
    endif

    " check validity
    if target.head1 == a:head && target.tail2 == a:tail
          \ && target.tail1 != s:null_pos && target.head2 != s:null_pos
          \ && s:lib.is_ahead(target.tail1, target.head1)
          \ && s:lib.is_ahead(target.tail2, target.head2)
      let [target.tail1, target.head2] = s:lib.get_wider_region(target.tail1, target.head2)
      let found = 1
      break
    endif
  endfor

  " restore visualmode
  if visualmode ==# ''
    call visualmode(1)
  else
    execute 'normal! ' . visualmode
    execute 'normal! ' . "\<Esc>"
  endif
  " restore marks
  call setpos("'<", visual_head)
  call setpos("'>", visual_tail)

  if found
    return target
  else
    return s:null_4pos
  endif
endfunction
"}}}
function! s:get_textobj_region(cursor, cmd, visualmode, count, key_seq) abort "{{{
  call setpos('.', a:cursor)
  execute printf('%s %s%d%s', a:cmd, a:visualmode, a:count, a:key_seq)
  if mode() ==? 'v' || mode() ==# "\<C-v>"
    execute "normal! \<Esc>"
  else
    return [copy(s:null_coord), copy(s:null_coord), a:visualmode]
  endif
  let visualmode = visualmode()
  let [head, tail] = [getpos("'<"), getpos("'>")]
  " NOTE: V never comes for v. Thus if head == tail == self.cursor, then
  "       it is failed.
  if head == a:cursor && tail == a:cursor
    let [head, tail] = [copy(s:null_pos), copy(s:null_pos)]
  elseif visualmode ==# 'V'
    let tail[2] = col([tail[1], '$'])
  endif
  return [head, tail, visualmode]
endfunction
"}}}
function! s:get_patterns(candidate, opt_regex) abort "{{{
  let patterns = deepcopy(a:candidate.buns)
  if !a:opt_regex
    let patterns = map(patterns, 's:lib.escape(v:val)')
  endif

  " substitute a break "\n" to a regular expression pattern '\n'
  let patterns = map(patterns, 'substitute(v:val, ''\n'', ''\\n'', ''g'')')
  return patterns
endfunction
"}}}
" function! s:searchpos_bce(curpos, pattern, stopline)  "{{{
if s:has_patch_7_4_771
  function! s:searchpos_bce(curpos, pattern, stopline) abort
    return searchpos(a:pattern, 'bce', a:stopline)
  endfunction
else
  " workaround for unicode string (because of a bug of vim)
  " If the cursor is on a unicode character(uc), searchpos(uc, 'bce', stopline) always returns [0, 0],
  " though searchpos(uc, 'bce') returns a correct value.
  function! s:searchpos_bce(curpos, pattern, stopline) abort
    if a:curpos[1] == line('$') && a:curpos[2] == col([line('$'), '$'])
      silent! normal! h
      return searchpos(a:pattern, 'e', a:stopline)
    else
      silent! normal! l
      return searchpos(a:pattern, 'be', a:stopline)
    endif
  endfunction
endif
"}}}
function! s:get_cursorchar(pos) abort "{{{
  let reg = ['"', getreg('"'), getregtype('"')]
  try
    call setpos('.', a:pos)
    silent noautocmd normal! yl
    let c = @@
  finally
    call call('setreg', reg)
  endtry
  return c
endfunction
"}}}
" function! s:shortest(list) abort  "{{{
if s:has_patch_7_4_358
  function! s:shortest(list) abort
    call map(a:list, '[v:val, s:get_buf_length(v:val.head1, v:val.tail2)]')
    call sort(a:list, 's:compare_buf_length')
    return a:list[0][0]
  endfunction

  function! s:compare_buf_length(i1, i2) abort
    return a:i2[1] - a:i1[1]
  endfunction
else
  function! s:shortest(list) abort
    call map(a:list, '[v:val, s:get_buf_length(v:val.head1, v:val.tail2)]')
    let len = len(a:list)
    let min = len - 1
    if len - 2 >= 0
      for i in range(len - 2, 0, -1)
        if a:list[min][1] >= a:list[i][1]
          let min = i
        endif
      endfor
    endif
    return a:list[min][0]
  endfunction
endif
"}}}
function! s:get_buf_length(start, end) abort  "{{{
  if a:start[1] == a:end[1]
    let len = a:end[2] - a:start[2] + 1
  else
    let length_list = map(getline(a:start[1], a:end[1]), 'len(v:val) + 1')
    let idx = 0
    let accumm_length = 0
    let accumm_list   = [0]
    for length in length_list[1:]
      let accumm_length  = accumm_length + length_list[idx]
      let accumm_list   += [accumm_length]
      let idx += 1
    endfor
    let len = accumm_list[a:end[1] - a:start[1]] + a:end[2] - a:start[2] + 1
  endif
  return len
endfunction
"}}}
function! s:skip_space(head, tail) abort  "{{{
  " NOTE: This function is destructive, directly update a:head and a:tail.
  call setpos('.', a:head)
  if a:head[2] == col([a:head[1], '$'])
    " if the cursor is on a line breaking, it should not be skipped.
    let head = a:head
  else
    let head = s:lib.c2p(searchpos('\_S', 'c', a:tail[1]))
  endif

  call setpos('.', a:tail)
  if a:tail[2] == 1
    let tail = a:tail
  else
    let tail = s:lib.c2p(searchpos('\_S', 'bc', a:head[1]))
  endif

  if head != s:null_pos && tail != s:null_pos && s:lib.is_equal_or_ahead(tail, head)
    let a:head[0:3] = head[0:3]
    let a:tail[0:3] = tail[0:3]
  endif
endfunction
"}}}



" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
