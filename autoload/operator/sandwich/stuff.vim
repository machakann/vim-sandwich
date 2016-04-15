" stuff object - managing a line on buffer

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

" types
let s:type_list = type([])

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_771 = has('patch-7.4.771')
  let s:has_patch_7_4_362 = has('patch-7.4.362')
  let s:has_patch_7_4_358 = has('patch-7.4.358')
else
  let s:has_patch_7_4_771 = v:version == 704 && has('patch771')
  let s:has_patch_7_4_310 = v:version == 704 && has('patch310')
  let s:has_patch_7_4_362 = v:version == 704 && has('patch362')
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
      \   'message'  : {},
      \   'highlight': {
      \     'target': {'status': 0, 'group': '', 'id': []},
      \     'added' : {'status': 0, 'group': '', 'id': []},
      \     'stuff' : {'status': 0, 'group': '', 'id': []},
      \   },
      \ }
"}}}
function! s:stuff.initialize(count, cursor, modmark, message) dict abort  "{{{
  let self.active = 1
  let self.acts = map(range(a:count), 'operator#sandwich#act#new()')
  let self.added = []
  let self.message = a:message
  call map(self.highlight, 'extend(v:val, {"status": 0, "group": "", "id": []})')
  for act in self.acts
    call act.initialize(a:cursor, a:modmark, self.added, a:message)
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
function! s:stuff.match(recipes, opt) dict abort "{{{
  if !self.active
    return 0
  endif

  let edges = self.edges
  let edges_saved = deepcopy(edges)
  if s:is_valid_2pos(edges) && s:is_ahead(edges.tail, edges.head)
    let edge_chars = ['', '']
    if self._match_recipes(a:recipes, a:opt) || self._match_edges(a:recipes, a:opt, edge_chars)
      " found!
      return 1
    else
      let [head_c, tail_c] = edge_chars
      if head_c =~# '\s' || tail_c =~# '\s'
        call self.skip_space()
        if s:is_ahead(edges.head, edges.tail)
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
    if filter(target_list, 's:is_valid_4pos(v:val)') != []
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

      if s:is_valid_4pos(target)
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
    if s:is_ahead(self.edges.head, self.edges.tail)
      let self.active = 0
    endif
  endif
endfunction
"}}}
function! s:stuff.show(place, hi_group, linewise) dict abort "{{{
  let highlight = get(self.highlight, a:place, {})
  let success = 0
  if self.active && highlight != {}
    if highlight.status && a:hi_group !=# highlight.group
      call self.quench(a:place)
    endif

    if !highlight.status
      let order_list = self.highlight_order(a:place, a:linewise)
      if order_list != []
        for order in order_list
          let highlight.id += s:matchaddpos(a:hi_group, order)
        endfor
        let highlight.status = 1
        let highlight.group = a:hi_group
        call filter(highlight.id, 'v:val > 0')
        let success = 1
      endif
    endif
  endif
  return success
endfunction
"}}}
function! s:stuff.quench(place) dict abort "{{{
  let highlight = get(self.highlight, a:place, {'status': 0})
  let success = 0
  if self.active && highlight.status
    call map(highlight.id, 'matchdelete(v:val)')
    call filter(highlight.id, 'v:val > 0')
    let highlight.status = 0
    let highlight.group = ''
    let success = 1
  endif
  return success
endfunction
"}}}
function! s:stuff.highlight_order(place, linewise) dict abort "{{{
  if a:place ==# 'target'
    let order_list = s:highlight_order(self.target, a:linewise)
  elseif a:place ==# 'added'
    let order_list = []
    for added in self.added
      let order_list += s:highlight_order(added, added.linewise)
    endfor
  elseif a:place ==# 'stuff'
    let stuff = {'head1': self.edges.head, 'tail1': self.edges.tail, 'head2': copy(s:null_pos), 'tail2': copy(s:null_pos)}
    let order_list = s:highlight_order(stuff, a:linewise)
  else
    let order_list = []
  endif
  return order_list
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
        \ || s:is_equal_or_ahead(s:c2p(tail1), s:c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:c2p(v:val)')
endfunction
"}}}
function! s:search_edges(head, tail, patterns) abort "{{{
  if a:patterns[0] ==# '' || a:patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(a:patterns[0], 'c', a:tail[1])

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, a:patterns[1], a:head[1])

  if head1 == s:null_coord || tail2 == s:null_coord
        \ || s:is_equal_or_ahead(s:c2p(head1), s:c2p(tail2))
    return s:null_4pos
  endif

  let head2 = searchpos(a:patterns[1], 'bc', head1[0])
  call setpos('.', s:c2p(head1))
  let tail1 = searchpos(a:patterns[0], 'ce', head2[0])

  if tail1 == s:null_coord || head2 == s:null_coord
        \ || s:is_ahead(s:c2p(head1), s:c2p(tail1))
        \ || s:is_ahead(s:c2p(head2), s:c2p(tail2))
        \ || s:is_equal_or_ahead(s:c2p(tail1), s:c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:c2p(v:val)')
endfunction
"}}}
function! s:check_textobj_diff(head, tail, candidate, opt_noremap) abort  "{{{
  let target = deepcopy(s:null_4pos)
  let [textobj_i, textobj_a] = a:candidate.external
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  let visualmode = visualmode()

  if a:opt_noremap
    let cmd = 'normal!'
    let v   = 'v'
  else
    let cmd = 'normal'
    let v   = "\<Plug>(sandwich-v)"
  endif

  let order_list = [[1, a:head], [1, a:tail]]
  if has_key(a:candidate, 'excursus')
    let order_list = [a:candidate.excursus] + order_list
  endif

  " try twice (at least)
  let found = 0
  for [l:count, cursor] in order_list
    " get outer positions
    call setpos('.', cursor)
    execute printf('%s %s%d%s', cmd, v, l:count, textobj_a)
    execute "normal! \<Esc>"
    let motionwise_a = visualmode()
    let [target.head1, target.tail2] = [getpos("'<"), getpos("'>")]
    if target.head1 == cursor && target.tail2 == cursor
      let [target.head1, target.tail2] = [copy(s:null_coord), copy(s:null_coord)]
    elseif motionwise_a ==# 'V'
      let target.tail2[2] = col([target.tail2[1], '$'])
    endif

    " get inner positions
    call setpos('.', cursor)
    execute printf('%s %s%d%s', cmd, v, l:count, textobj_i)
    execute "normal! \<Esc>"
    let motionwise_i = visualmode()
    " FIXME: How should I treat a line breaking?
    let [target.tail1, target.head2] = s:get_wider_region(getpos("'<"), getpos("'>"))
    if target.tail1 == cursor && target.head2 == cursor
      let [target.tail1, target.head2] = [copy(s:null_coord), copy(s:null_coord)]
    elseif motionwise_i ==# 'V'
      let target.head2[2] = col([target.head2[1], '$'])
    endif
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
      let [target.tail1, target.head2] = s:get_wider_region(target.tail1, target.head2)
    endif

    " check validity
    if target.head1 == a:head && target.tail2 == a:tail
          \ && target.tail1 != s:null_pos && target.head2 != s:null_pos
          \ && s:is_equal_or_ahead(target.tail1, target.head1)
          \ && s:is_equal_or_ahead(target.tail2, target.head2)
      let found = 1
      break
    endif
  endfor

  " restore visualmode
  execute 'normal! ' . visualmode . "\<Esc>"
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
function! s:get_patterns(candidate, opt_regex) abort "{{{
  let patterns = deepcopy(a:candidate.buns)
  if !a:opt_regex
    let patterns = map(patterns, 's:escape(v:val)')
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
      normal! h
      return searchpos(a:pattern, 'e', a:stopline)
    else
      normal! l
      return searchpos(a:pattern, 'be', a:stopline)
    endif
  endfunction
endif
"}}}
function! s:get_cursorchar(pos) abort "{{{
  let reg = ['"', getreg('"'), getregtype('"')]
  try
    call setpos('.', a:pos)
    normal! yl
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
    let head = s:c2p(searchpos('\_S', 'c', a:tail[1]))
  endif

  call setpos('.', a:tail)
  if a:tail[2] == 1
    let tail = a:tail
  else
    let tail = s:c2p(searchpos('\_S', 'bc', a:head[1]))
  endif

  if head != s:null_pos && tail != s:null_pos && s:is_equal_or_ahead(tail, head)
    let a:head[0:3] = head[0:3]
    let a:tail[0:3] = tail[0:3]
  endif
endfunction
"}}}
function! s:highlight_order(target, linewise) abort "{{{
  let order = []
  let order_list = []
  for [head, tail, linewise] in [[a:target.head1, a:target.tail1, a:linewise[0]],
                              \  [a:target.head2, a:target.tail2, a:linewise[1]]]
    if linewise
      call s:highlight_order_linewise(order_list, order, head, tail)
    else
      call s:highlight_order_charwise(order_list, order, head, tail)
    endif
  endfor
  if order != []
    call add(order_list, order)
  endif
  return order_list
endfunction
"}}}
function! s:highlight_order_charwise(order_list, order, head, tail) abort  "{{{
  let n = len(a:order)
  if a:head != s:null_pos && a:tail != s:null_pos && s:is_equal_or_ahead(a:tail, a:head)
    if a:head[1] == a:tail[1]
      call add(a:order, a:head[1:2] + [a:tail[2] - a:head[2] + 1])
      let n += 1
    else
      for lnum in range(a:head[1], a:tail[1])
        if lnum == a:head[1]
          call add(a:order, a:head[1:2] + [col([a:head[1], '$']) - a:head[2] + 1])
        elseif lnum == a:tail[1]
          call add(a:order, [a:tail[1], 1] + [a:tail[2]])
        else
          call add(a:order, [lnum])
        endif

        if n == 7
          call add(a:order_list, deepcopy(a:order))
          call filter(a:order, 0)
          let n = 0
        else
          let n += 1
        endif
      endfor
    endif
  endif
endfunction
"}}}
function! s:highlight_order_linewise(order_list, order, head, tail) abort  "{{{
  let n = len(a:order)
  if a:head != s:null_pos && a:tail != s:null_pos && a:head[1] <= a:tail[1]
    for lnum in range(a:head[1], a:tail[1])
      call add(a:order, [lnum])
      if n == 7
        call add(a:order_list, deepcopy(a:order))
        call filter(a:order, 0)
        let n = 0
      else
        let n += 1
      endif
    endfor
  endif
endfunction
"}}}
" function! s:matchaddpos(group, pos) abort "{{{
if s:has_patch_7_4_362
  function! s:matchaddpos(group, pos) abort
    return [matchaddpos(a:group, a:pos)]
  endfunction
else
  function! s:matchaddpos(group, pos) abort
    let id_list = []
    for pos in a:pos
      if len(pos) == 1
        let id_list += [matchadd(a:group, printf('\%%%dl', pos[0]))]
      else
        let id_list += [matchadd(a:group, printf('\%%%dl\%%>%dc.*\%%<%dc', pos[0], pos[1]-1, pos[1]+pos[2]))]
      endif
    endfor
    return id_list
  endfunction
endif
"}}}

let [s:get_wider_region, s:c2p, s:is_valid_2pos, s:is_valid_4pos, s:is_ahead, s:is_equal_or_ahead, s:escape]
      \ = operator#sandwich#lib#funcref(['get_wider_region', 'c2p', 'is_valid_2pos', 'is_valid_4pos', 'is_ahead', 'is_equal_or_ahead', 'escape'])


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
