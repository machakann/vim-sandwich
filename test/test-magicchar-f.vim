scriptencoding utf-8

let s:suite = themis#suite('magicchar-f: ')

function! s:suite.before() abort  "{{{
  nmap sd <Plug>(sandwich-delete)
  xmap sd <Plug>(sandwich-delete)
endfunction
"}}}
function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  unlet! g:sandwich#magicchar#f#patterns
  unlet! b:sandwich_magicchar_f_patterns
  unlet! g:sandwich#recipes g:operator#sandwich#recipes
  unlet! b:sandwich_recipes b:operator_sandwich_recipes
  call operator#sandwich#set_default()
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  nunmap sd
  xunmap sd
endfunction
"}}}

function! s:suite.default_pattern() abort "{{{
  call setline('.', 'foo(bar)')
  call cursor(1, 1)
  normal sdf
  call g:assert.equals(getline('.'), 'bar', 'failed at #1')
endfunction "}}}
function! s:suite.global_pattern() abort "{{{
  let g:sandwich#magicchar#f#patterns = [
    \   {
    \     'header' : '\<\%(\h\k*\.\)*\h\k*',
    \     'bra'    : '(',
    \     'ket'    : ')',
    \     'footer' : '',
    \   },
    \ ]
  call setline('.', 'foo.bar(baz)')
  call cursor(1, 5)
  normal sdf
  call g:assert.equals(getline('.'), 'baz', 'failed at #1')
endfunction "}}}
function! s:suite.local_pattern() abort "{{{
  let g:sandwich#magicchar#f#patterns = [
    \   {
    \     'header' : '\<\h\k*\.\h\k*',
    \     'bra'    : '(',
    \     'ket'    : ')',
    \     'footer' : '',
    \   },
    \ ]
  let b:sandwich_magicchar_f_patterns = [
    \   {
    \     'header' : '\<\%(\h\k*\.\)*\h\k*',
    \     'bra'    : '(',
    \     'ket'    : ')',
    \     'footer' : '',
    \   },
    \ ]
  call setline('.', 'foo.bar.baz(qux)')
  call cursor(1, 9)
  normal sdf
  call g:assert.equals(getline('.'), 'qux', 'failed at #1')
endfunction "}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
