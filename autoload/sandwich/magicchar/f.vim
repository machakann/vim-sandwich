let s:save_cpo = &cpo
set cpo&vim

" variables "{{{
let s:type_list = type([])
let s:type_dict = type({})
let s:null_pos  = [0, 0]

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_1685 = has('patch-7.4.1685')
  let s:has_patch_7_4_2011 = has('patch-7.4.2011')
else
  let s:has_patch_7_4_1685 = v:version == 704 && has('patch1685')
  let s:has_patch_7_4_2011 = v:version == 704 && has('patch2011')
endif
"}}}

" default patterns
let g:sandwich#magicchar#f#default_patterns = [
      \   {
      \     'header' : '\<\h\k*',
      \     'bra'    : '(',
      \     'ket'    : ')',
      \     'footer' : '',
      \   },
      \ ]

function! sandwich#magicchar#f#fname() abort  "{{{
  call operator#sandwich#show()
  try
    echohl MoreMsg
    if &filetype ==# 'vim'
      let funcname = input('funcname: ', '', 'custom,sandwich#magicchar#f#fnamecompl_vim')
    else
      let funcname = input('funcname: ', '', 'custom,sandwich#magicchar#f#fnamecompl')
    endif
    " flash prompt
    echo ''
  finally
    echohl NONE
    call operator#sandwich#quench()
  endtry
  if funcname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return funcname . '('
endfunction
"}}}
function! sandwich#magicchar#f#fnamecompl(ArgLead, CmdLine, CursorPos) abort  "{{{
  return join(uniq(sort(s:buffer_completion())), "\n")
endfunction
"}}}
function! sandwich#magicchar#f#fnamecompl_vim(ArgLead, CmdLine, CursorPos) abort  "{{{
  if s:has_patch_7_4_2011
    let getcomp = map(filter(getcompletion(a:ArgLead, 'function'), 'v:val =~# ''\C^[a-z][a-zA-Z0-9_]*($'''), 'matchstr(v:val, ''\C^[a-z][a-zA-Z0-9_]*'')')
  else
    let getcomp = []
  endif
  let buffer = s:buffer_completion()
  return join(uniq(sort(getcomp + buffer)), "\n")
endfunction
"}}}
function! s:buffer_completion() abort "{{{
  " NOTE: This func does neither sort nor uniq.
  let list = []
  let lines = getline(1, '$')
  let pattern_list = s:resolve_patterns()
  for func in pattern_list
    let pat = printf('%s\ze%s', func.header, func.bra)
    for line in lines
      let list += s:extract_pattern(line, pat)
    endfor
  endfor
  return list
endfunction
"}}}
function! s:extract_pattern(string, pat) abort "{{{
  let list = []
  let end = 0
  while 1
    let [str, start, end] = s:matchstrpos(a:string, a:pat, end)
    if start < 0
      break
    endif
    let list += [str]
  endwhile
  return list
endfunction
"}}}
" function! s:matchstrpos(expr, pat, ...) abort "{{{
if s:has_patch_7_4_1685
  let s:matchstrpos = function('matchstrpos')
else
  function! s:matchstrpos(expr, pat, ...) abort
    if a:0 == 0
      return [matchstr(a:expr, a:pat), match(a:expr, a:pat), matchend(a:expr, a:pat)]
    elseif a:0 == 1
      return [matchstr(a:expr, a:pat, a:1), match(a:expr, a:pat, a:1), matchend(a:expr, a:pat, a:1)]
    else
      return [matchstr(a:expr, a:pat, a:1, a:2), match(a:expr, a:pat, a:1, a:2), matchend(a:expr, a:pat, a:1, a:2)]
    endif
  endfunction
endif
"}}}



" textobj-functioncall (bundle version)
" NOTE: https://github.com/machakann/vim-textobj-functioncall

function! sandwich#magicchar#f#ip() abort  "{{{
  return s:prototype('ip')
endfunction
"}}}
function! sandwich#magicchar#f#i() abort  "{{{
  return s:prototype('i')
endfunction
"}}}
function! sandwich#magicchar#f#ap() abort  "{{{
  return s:prototype('ap')
endfunction
"}}}
function! sandwich#magicchar#f#a() abort  "{{{
  return s:prototype('a')
endfunction
"}}}
function! s:prototype(mode) abort  "{{{
  let l:count = v:count1

  " user settings
  let opt = {}
  let opt.searchlines = s:get('textobj_sandwich_function_searchlines' , 30)

  " pattern-assignment
  let pattern_list = s:resolve_patterns()

  let view = winsaveview()
  try
    let candidates = s:gather_candidates(a:mode, l:count, pattern_list, opt)
    let range = s:get_range(a:mode, l:count, candidates)
  finally
    call winrestview(view)
  endtry
  call s:select(range)
endfunction
"}}}
function! s:gather_candidates(mode, count, pattern_list, opt) abort  "{{{
  let orig_pos = getpos('.')[1:2]

  " searching range limitation
  if a:opt.searchlines < 0
    let upper_line = 1
    let lower_line = line('$')
  else
    let upper_line = max([1, orig_pos[0] - a:opt.searchlines])
    let lower_line = min([orig_pos[0] + a:opt.searchlines, line('$')])
  endif

  let rank = 0
  let candidates = []
  for pattern in a:pattern_list
    let rank += 1
    call s:search_pattern(candidates, pattern, a:mode, a:count, rank, orig_pos, upper_line, lower_line)
    call cursor(orig_pos)
  endfor
  return a:mode[0] ==# 'a' && candidates == []
        \ ? s:gather_candidates('i', a:count, a:pattern_list, a:opt)
        \ : candidates
endfunction
"}}}
function! s:search_pattern(candidates, pattern, mode, count, rank, orig_pos, upper_line, lower_line) abort "{{{
  let candidates = []
  let header = a:pattern.header
  let bra    = a:pattern.bra
  let ket    = a:pattern.ket
  let footer = a:pattern.footer

  let loop = 0
  let head = header . bra
  let tail = ket . footer

  let bra_pos = s:search_key_bra(a:mode, a:orig_pos, bra, ket, head, tail, a:upper_line, a:lower_line)
  if bra_pos == s:null_pos | return [] | endif
  let is_string_at_bra = s:is_string_literal(bra_pos)

  while loop < a:count
    " 'bra' should accompany with 'header'
    if searchpos(head, 'bcen', a:upper_line) == bra_pos
      let head_pos = searchpos(head, 'bcn', a:upper_line)

      " search for the paired 'ket'
      let ket_pos = searchpairpos(bra, '', ket, '', 's:is_string_literal(getpos(".")[1:2]) != is_string_at_bra', a:lower_line)
      if ket_pos != s:null_pos
        let tail_pos = searchpos(tail, 'ce', a:lower_line)
        if tail_pos == s:null_pos
          break
        elseif searchpos(tail, 'bcn', a:upper_line) == ket_pos
          " syntax check
          if !is_string_at_bra || s:is_continuous_syntax(bra_pos, ket_pos)
            " found the corresponded tail
            call add(a:candidates, [head_pos, bra_pos, ket_pos, tail_pos, a:rank, s:get_buf_length(head_pos, tail_pos)])
            let loop += 1
          endif
        endif
      endif
      call cursor(bra_pos)
    endif

    " move to the next 'bra'
    let bra_pos = searchpairpos(bra, '', ket, 'b', '', a:upper_line)
    if bra_pos == s:null_pos | break | endif
    let is_string_at_bra = s:is_string_literal(bra_pos)
  endwhile
  return candidates
endfunction
"}}}
function! s:search_key_bra(mode, orig_pos, bra, ket, head, tail, upper_line, lower_line) abort  "{{{
  let bra_pos = s:null_pos
  if a:mode[0] ==# 'a'
    " search for the first 'bra'
    if searchpos(a:tail, 'cn', a:lower_line) == a:orig_pos
      let bra_pos = searchpairpos(a:bra, '', a:ket, 'b', '', a:upper_line)
    endif
    let bra_pos = searchpairpos(a:bra, '', a:ket, 'b', '', a:upper_line)
  elseif a:mode[0] ==# 'i'
    let head_start = searchpos(a:head, 'bc', a:upper_line)
    let head_end   = searchpos(a:head, 'ce', a:lower_line)
    call cursor(a:orig_pos)
    let tail_start = searchpos(a:tail, 'bc', a:upper_line)
    let tail_end   = searchpos(a:tail, 'ce', a:lower_line)

    " check the initial position
    if s:is_in_the_range(a:orig_pos, head_start, head_end)
      " cursor is on a header
      call cursor(head_end)
    elseif s:is_in_the_range(a:orig_pos, tail_start, tail_end)
      " cursor is on a footer
      call cursor(tail_start)
      if tail_start[1] != 1
        normal! h
      endif
    else
      " cursor is in between a bra and a ket
      call cursor(a:orig_pos)
    endif

    " move to the corresponded 'bra'
    let bra_pos = searchpairpos(a:bra, '', a:ket, 'bc', '', a:upper_line)
  endif
  return bra_pos
endfunction
"}}}
function! s:get_range(mode, count, candidates) abort "{{{
  if a:candidates == []
    return [s:null_pos, s:null_pos]
  endif

  let line_numbers = map(copy(a:candidates), 'v:val[0][0]') + map(copy(a:candidates), 'v:val[3][0]')
  let top_line = min(line_numbers)
  let bottom_line = max(line_numbers)
  let sorted_candidates = s:sort_candidates(a:candidates, top_line, bottom_line)
  if len(sorted_candidates) < a:count
    return [s:null_pos, s:null_pos]
  endif

  let [head_pos, bra_pos, ket_pos, tail_pos, _, _] = sorted_candidates[a:count - 1]
  if a:mode[1] ==# 'p'
    let [head, tail] = s:get_narrower_region(bra_pos, ket_pos)
  else
    let head = head_pos
    let tail = tail_pos
  endif
  return [head, tail]
endfunction
"}}}
function! s:select(range) abort  "{{{
  let [head, tail] = a:range
  if head != s:null_pos && tail != s:null_pos
    " select textobject
    normal! v
    call cursor(head)
    normal! o
    call cursor(tail)

    " counter measure for the 'selection' option being 'exclusive'
    if &selection ==# 'exclusive'
      normal! l
    endif
  endif
endfunction
"}}}
function! s:is_in_the_range(pos, head, tail) abort  "{{{
  return (a:pos != s:null_pos) && (a:head != s:null_pos) && (a:tail != s:null_pos)
    \  && ((a:pos[0] > a:head[0]) || ((a:pos[0] == a:head[0]) && (a:pos[1] >= a:head[1])))
    \  && ((a:pos[0] < a:tail[0]) || ((a:pos[0] == a:tail[0]) && (a:pos[1] <= a:tail[1])))
endfunction
"}}}
function! s:is_string_literal(pos) abort  "{{{
  return match(map(synstack(a:pos[0], a:pos[1]), 'synIDattr(synIDtrans(v:val), "name")'), 'String') > -1
endfunction
"}}}
function! s:is_continuous_syntax(bra_pos, ket_pos) abort  "{{{
  let start_col = a:bra_pos[1]
  for lnum in range(a:bra_pos[0], a:ket_pos[0])
    if lnum == a:ket_pos[0]
      let end_col= a:ket_pos[1]
    else
      let end_col= col([lnum, '$'])
    endif
    for col in range(start_col, end_col)
      if match(map(synstack(lnum, col), 'synIDattr(synIDtrans(v:val), "name")'), 'String') < 0
        return 0
      endif
    endfor
    let start_col = 1
  endfor
  return 1
endfunction
"}}}
function! s:resolve_patterns() abort  "{{{
  return deepcopy(get(b:, 'sandwich_magicchar_f_patterns',
                \ get(g:, 'sandwich#magicchar#f#patterns',
                \ g:sandwich#magicchar#f#default_patterns)))
endfunction
"}}}
function! s:get_narrower_region(head_edge, tail_edge) abort "{{{
  if a:head_edge == a:tail_edge
    return [s:null_pos, s:null_pos]
  endif
  if a:head_edge[0] == a:tail_edge[0] && a:head_edge[1]+1 == a:tail_edge[1]
    " head_edge and tail_edge are just adjucent, no narrower
    return [s:null_pos, s:null_pos]
  endif

  let whichwrap  = &whichwrap
  let &whichwrap = 'h,l'
  try
    call cursor(a:head_edge)
    normal! l
    let head = getpos('.')[1:2]
    call cursor(a:tail_edge)
    normal! h
    let tail = getpos('.')[1:2]
  finally
    let &whichwrap = whichwrap
  endtry
  return [head, tail]
endfunction
"}}}
function! s:sort_candidates(candidates, top_line, bottom_line) abort  "{{{
  " NOTE: candidates == [[head_pos], [bra_pos], [ket_pos], [tail_pos], rank, distance]
  call filter(a:candidates, 'v:val[0] != s:null_pos && v:val[1] != s:null_pos && v:val[2] != s:null_pos && v:val[3] != s:null_pos')
  return sort(a:candidates, 's:compare')
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
function! s:compare(i1, i2) abort "{{{
  if a:i1[5] < a:i2[5]
    return -1
  elseif a:i1[5] > a:i2[5]
    return 1
  else
    return a:i2[4] - a:i1[4]
  endif
endfunction
"}}}
function! s:get(name, default) abort  "{{{
  return exists('b:' . a:name) ? b:[a:name]
     \ : exists('g:' . a:name) ? g:[a:name]
     \ : a:default
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
