let s:save_cpo = &cpo
set cpo&vim

" variables "{{{
let s:FALSE = 0
let s:TRUE = 1
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

function! sandwich#magicchar#f#i(mode) abort  "{{{
  call sandwich#magicchar#f#textobj('i', a:mode)
endfunction
"}}}
function! sandwich#magicchar#f#a(mode) abort  "{{{
  call sandwich#magicchar#f#textobj('a', a:mode)
endfunction
"}}}
function! sandwich#magicchar#f#ip(mode) abort  "{{{
  call sandwich#magicchar#f#textobj('ip', a:mode)
endfunction
"}}}
function! sandwich#magicchar#f#ap(mode) abort  "{{{
  call sandwich#magicchar#f#textobj('ap', a:mode)
endfunction
"}}}
function! sandwich#magicchar#f#textobj(kind, mode, ...) abort "{{{
  let l:count = v:count1
  if a:0
    let pattern_list = a:1
  else
    let pattern_list = s:resolve_patterns()
  endif
  let searchlines = s:get('textobj_sandwich_function_searchlines' , 30)
  let stopline = {}
  if searchlines < 0
    let stopline.upper = 1
    let stopline.lower = line('$')
  else
    let stopline.upper = max([1, line('.') - searchlines])
    let stopline.lower = min([line('.') + searchlines, line('$')])
  endif

  let [start, end] = [s:null_pos, s:null_pos]
  let view = winsaveview()
  try
    let candidates = s:gather_candidates(a:kind, a:mode, l:count, pattern_list, stopline)
    let elected = s:elect(candidates, l:count)
    if elected != {}
      let [start, end] = s:to_range(a:kind, elected)
    endif
  finally
    call winrestview(view)
  endtry
  call s:select(start, end)
endfunction
"}}}


function! s:Candidate(head, bra, ket, tail, pat, rank) abort
  return {
    \   'head': a:head,
    \   'bra': a:bra,
    \   'ket': a:ket,
    \   'tail': a:tail,
    \   'rank': a:rank,
    \   'pattern': a:pat,
    \   'len': s:buflen(a:head, a:tail),
    \ }
endfunction


function! s:gather_candidates(kind, mode, count, pattern_list, stopline) abort  "{{{
  let curpos = getpos('.')[1:2]
  let rank = 0
  let candidates = []
  for pattern in a:pattern_list
    let rank += 1
    let candidates += s:search_pattern(pattern, a:kind, a:mode, a:count, rank, curpos, a:stopline)
    call cursor(curpos)
  endfor
  return a:kind[0] is# 'a' && candidates == []
        \ ? s:gather_candidates('i', a:mode, a:count, a:pattern_list, a:stopline)
        \ : candidates
endfunction
"}}}
function! s:search_pattern(pat, kind, mode, count, rank, curpos, stopline) abort "{{{
  let a:pat.head = a:pat.header . a:pat.bra
  let a:pat.tail = a:pat.ket . a:pat.footer

  let brapos = s:search_key_bra(a:kind, a:curpos, a:pat, a:stopline)
  if brapos == s:null_pos | return [] | endif
  let is_string = s:is_string_syntax(brapos)

  let candidates = []
  while len(candidates) < a:count
    let c = s:get_candidate(a:pat, a:kind, a:mode, a:rank, brapos, is_string, a:stopline)
    if c != {}
      call add(candidates, c)
    endif
    call cursor(brapos)

    " move to the next 'bra'
    let brapos = searchpairpos(a:pat.bra, '', a:pat.ket, 'b', '', a:stopline.upper)
    if brapos == s:null_pos | break | endif
    let is_string = s:is_string_syntax(brapos)
  endwhile
  return candidates
endfunction
"}}}
function! s:search_key_bra(kind, curpos, pat, stopline) abort  "{{{
  let brapos = s:null_pos
  if a:kind[0] is# 'a'
    " search for the first 'bra'
    if searchpos(a:pat.tail, 'cn', a:stopline.lower) == a:curpos
      let brapos = searchpairpos(a:pat.bra, '', a:pat.ket, 'b', '', a:stopline.upper)
    endif
    let brapos = searchpairpos(a:pat.bra, '', a:pat.ket, 'b', '', a:stopline.upper)
  elseif a:kind[0] is# 'i'
    let head_start = searchpos(a:pat.head, 'bc', a:stopline.upper)
    let head_end   = searchpos(a:pat.head, 'ce', a:stopline.lower)
    call cursor(a:curpos)
    let tail_start = searchpos(a:pat.tail, 'bc', a:stopline.upper)
    let tail_end   = searchpos(a:pat.tail, 'ce', a:stopline.lower)

    " check the initial position
    if s:is_in_between(a:curpos, head_start, head_end)
      " cursor is on a header
      call cursor(head_end)
    elseif s:is_in_between(a:curpos, tail_start, tail_end)
      " cursor is on a footer
      call cursor(tail_start)
      if tail_start[1] == 1
        normal! k$
      else
        normal! h
      endif
    else
      " cursor is in between a bra and a ket
      call cursor(a:curpos)
    endif

    " move to the corresponded 'bra'
    let brapos = searchpairpos(a:pat.bra, '', a:pat.ket, 'bc', '', a:stopline.upper)
  endif
  return brapos
endfunction
"}}}
function! s:get_candidate(pat, kind, mode, rank, brapos, is_string, stopline) abort "{{{
  " 'bra' should accompany with 'header'
  let headstart = searchpos(a:pat.head, 'bc', a:stopline.upper)
  let headend = searchpos(a:pat.head, 'ce', a:stopline.lower)
  call cursor(a:brapos)
  if !s:is_in_between(a:brapos, headstart, headend)
    return {}
  endif
  let headpos = headstart

  " search for the paired 'ket'
  let skip = 's:is_string_syntax(getpos(".")[1:2]) != a:is_string'
  let ketpos = searchpairpos(a:pat.bra, '', a:pat.ket, '', skip, a:stopline.lower)
  if ketpos == s:null_pos
    return {}
  endif
  let tailpos = searchpos(a:pat.tail, 'ce', a:stopline.lower)

  if searchpos(a:pat.tail, 'bcn', a:stopline.upper) != ketpos
    return {}
  endif

  let c = s:Candidate(headpos, a:brapos, ketpos, tailpos, a:pat, a:rank)
  if !s:is_valid_candidate(c, a:kind, a:mode, a:is_string)
    return {}
  endif
  return c
endfunction
"}}}
function! s:elect(candidates, count) abort "{{{
  if a:candidates == []
    return {}
  endif
  let filter = 'v:val.head != s:null_pos && v:val.bra != s:null_pos && v:val.ket != s:null_pos && v:val.tail != s:null_pos'
  call filter(a:candidates, filter)
  call sort(a:candidates, 's:compare')
  if len(a:candidates) < a:count
    return {}
  endif
  return a:candidates[a:count - 1]
endfunction
"}}}
function! s:to_range(kind, candidate) abort "{{{
  if a:kind[1] is# 'p'
    let [start, end] = s:parameter_region(a:candidate)
  else
    let start = a:candidate.head
    let end = a:candidate.tail
  endif
  return [start, end]
endfunction
"}}}
function! s:select(start, end) abort  "{{{
  if a:start == s:null_pos || a:end == s:null_pos
    return
  endif
  normal! v
  call cursor(a:start)
  normal! o
  call cursor(a:end)
  if &selection is# 'exclusive'
    normal! l
  endif
endfunction
"}}}
function! s:is_in_between(pos, start, end) abort "{{{
  return (a:pos != s:null_pos) && (a:start != s:null_pos) && (a:end != s:null_pos)
    \  && ((a:pos[0] > a:start[0]) || ((a:pos[0] == a:start[0]) && (a:pos[1] >= a:start[1])))
    \  && ((a:pos[0] < a:end[0])   || ((a:pos[0] == a:end[0])   && (a:pos[1] <= a:end[1])))
endfunction
"}}}
function! s:is_string_syntax(pos) abort "{{{
  return match(map(synstack(a:pos[0], a:pos[1]), 'synIDattr(synIDtrans(v:val), "name")'), 'String') > -1
endfunction
"}}}
function! s:is_continuous_syntax(brapos, ketpos) abort  "{{{
  let start_col = a:brapos[1]
  for lnum in range(a:brapos[0], a:ketpos[0])
    if lnum == a:ketpos[0]
      let end_col= a:ketpos[1]
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
function! s:is_valid_syntax(candidate, is_string) abort "{{{
  return !a:is_string || s:is_continuous_syntax(a:candidate.bra, a:candidate.ket)
endfunction
"}}}
function! s:is_same_or_adjacent(p1, p2) abort "{{{
  return a:p1 == a:p2 || (a:p1[0] == a:p2[0] && a:p1[1]+1 == a:p2[1])
endfunction
"}}}
function! s:is_wider(candidate, start, end) abort "{{{
  return (s:is_ahead(a:start, a:candidate.head) && s:is_same_or_ahead(a:candidate.tail, a:end)) ||
       \ (s:is_same_or_ahead(a:start, a:candidate.head) && s:is_ahead(a:candidate.tail, a:end))
endfunction
"}}}
function! s:is_ahead(p1, p2) abort "{{{
  return (a:p1[0] > a:p2[0]) || (a:p1[0] == a:p2[0] && a:p1[1] > a:p2[1])
endfunction
"}}}
function! s:is_same_or_ahead(p1, p2) abort "{{{
  return (a:p1[0] > a:p2[0]) || (a:p1[0] == a:p2[0] && a:p1[1] >= a:p2[1])
endfunction
"}}}
function! s:is_valid_candidate(c, kind, mode, is_string) abort "{{{
  if a:kind[1] is# 'p' && s:is_same_or_adjacent(a:c.bra, a:c.ket)
    return s:FALSE
  endif
  if a:mode is# 'x' && !s:is_wider(a:c, getpos("'<")[1:2], getpos("'>")[1:2])
    return s:FALSE
  endif
  if !s:is_valid_syntax(a:c, a:is_string)
    return s:FALSE
  endif
  return s:TRUE
endfunction
"}}}
function! s:resolve_patterns() abort  "{{{
  return deepcopy(get(b:, 'sandwich_magicchar_f_patterns',
                \ get(g:, 'sandwich#magicchar#f#patterns',
                \ g:sandwich#magicchar#f#default_patterns)))
endfunction
"}}}
function! s:parameter_region(candidate) abort "{{{
  let whichwrap  = &whichwrap
  let &whichwrap = 'h,l'
  let [visualhead, visualtail] = [getpos("'<"), getpos("'>")]
  try
    normal! v
    call cursor(a:candidate.bra)
    call search(a:candidate.pattern.bra, 'ce', a:candidate.ket[0])
    normal! l
    let head = getpos('.')[1:2]
    normal! o
    call cursor(a:candidate.ket)
    normal! h
    let tail = getpos('.')[1:2]
    execute "normal! \<Esc>"
  finally
    let &whichwrap = whichwrap
    call setpos("'<", visualhead)
    call setpos("'>", visualtail)
  endtry
  return [head, tail]
endfunction
"}}}
function! s:buflen(start, end) abort "{{{
  " start, end -> [lnum, col]
  if a:start[0] == a:end[0]
    let len = a:end[1] - a:start[1] + 1
  else
    let len = (line2byte(a:end[0]) + a:end[1]) - (line2byte(a:start[0]) + a:start[1]) + 1
  endif
  return len
endfunction
"}}}
function! s:compare(i1, i2) abort "{{{
  " i1, i2 -> Candidate
  if a:i1.len < a:i2.len
    return -1
  elseif a:i1.len > a:i2.len
    return 1
  else
    return a:i2.rank - a:i1.rank
  endif
endfunction
"}}}
function! s:get(name, default) abort "{{{
  return exists('b:' . a:name) ? b:[a:name]
     \ : exists('g:' . a:name) ? g:[a:name]
     \ : a:default
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
