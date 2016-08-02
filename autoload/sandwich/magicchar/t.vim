function! sandwich#magicchar#t#tag() abort "{{{
  call operator#sandwich#show()
  echohl MoreMsg
  let tag = input('Input tag: ')
  echohl NONE
  call operator#sandwich#quench()
  if tag ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return [printf('<%s>', tag), printf('</%s>', matchstr(tag, '^\a[^[:blank:]>/]*'))]
endfunction
"}}}
function! sandwich#magicchar#t#tagname() abort "{{{
  call operator#sandwich#show()
  echohl MoreMsg
  let tagname = input('Input tag name: ')
  echohl NONE
  call operator#sandwich#quench()
  if tagname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return [tagname, tagname]
endfunction
"}}}

function! sandwich#magicchar#t#i() abort "{{{
  call s:prototype('i')
endfunction
"}}}
function! sandwich#magicchar#t#a() abort "{{{
  call s:prototype('a')
endfunction
"}}}
function! s:prototype(kind) abort "{{{
  let view = winsaveview()
  let visualhead = getpos("'<")
  let visualtail = getpos("'>")
  execute printf('normal! v%dat', v:count1)
  execute "normal! \<Esc>"
  if getpos("'<") != getpos("'>")
    normal! gv
    let pat = a:kind ==# 'i' ? '</\ze\a[^[:blank:]>/]*' : '</\a[^[:blank:]>/]*\ze\s*>'
    call search(pat, 'be', line("'<"))
    normal! o
    let pat = a:kind ==# 'i' ? '<\a[^[:blank:]>/]*\zs.' : '<\zs\a[^[:blank:]>/]*'
    call search(pat, '', line("'>"))
  else
    call winrestview(view)
    call setpos("'<", visualhead)
    call setpos("'>", visualtail)
  endif
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:

