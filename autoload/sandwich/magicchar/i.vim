let s:last_inserted = []
let s:last_searched = []

" variables "{{{
" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_1685 = has('patch-7.4.1685')
else
  let s:has_patch_7_4_1685 = v:version == 704 && has('patch1685')
endif
"}}}

function! sandwich#magicchar#i#input(kind, ...) abort "{{{
  let storepoint = a:kind ==# 'operator' ? 'last_inserted' : 'last_searched'
  let former = s:input(a:kind . '-sandwich:head: ')
  let quit_if_empty = get(a:000, 0, 0)
  if quit_if_empty && former ==# ''
    let s:{storepoint} = []
    return ['', '']
  endif
  let latter = s:input(a:kind . '-sandwich:tail: ')
  let s:{storepoint} = [former, latter]
  return copy(s:{storepoint})
endfunction
"}}}
function! sandwich#magicchar#i#lastinput(kind, ...) abort "{{{
  let storepoint = a:kind ==# 'operator' ? 'last_inserted' : 'last_searched'
  let cancel_if_invalid = get(a:000, 0, 0)
  if cancel_if_invalid && s:{storepoint} == []
    throw 'OperatorSandwichCancel'
  endif
  return s:{storepoint} != [] ? copy(s:{storepoint}) : ['', '']
endfunction
"}}}
function! sandwich#magicchar#i#compl(ArgLead, CmdLine, CursorPos) abort  "{{{
  let list = []
  let lines = getline(1, '$')
  if a:ArgLead ==# ''
    let list += s:extract_patterns_from_lines(lines, '\<\k\{3,}\>')
  else
    let list += s:extract_patterns_from_lines(lines, printf('\<%s.\{-}\>', a:ArgLead))
    if list == []
      let tail = matchstr(a:ArgLead, '\<\k\+$')
      if tail !=# '' && tail !=# a:ArgLead
        let list += s:extract_patterns_from_lines(lines, tail . '.\{-}\>')
      endif
    endif
  endif
  return join(uniq(sort(list)), "\n")
endfunction
"}}}
function! s:input(mes) abort "{{{
  echohl MoreMsg
  try
    let input = input(a:mes, '', 'custom,sandwich#magicchar#i#compl')
    " flash prompt
    echo ''
  finally
    echohl NONE
  endtry
  return input
endfunction
"}}}
function! s:extract_patterns_from_lines(lines, pat) abort "{{{
  let list = []
  for line in a:lines
    let list += s:extract_pattern(line, a:pat)
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

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
