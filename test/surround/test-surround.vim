scriptencoding utf-8

let s:suite = themis#suite('keymappings')

function! s:suite.before() abort "{{{
  runtime macros/sandwich/keymap/surround.vim
endfunction "}}}
function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  call operator#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  mapclear
  unlet g:sandwich_no_default_key_mappings
  unlet g:operator_sandwich_no_default_key_mappings
  unlet g:textobj_sandwich_no_default_key_mappings
  runtime plugin/sandwich.vim
  runtime plugin/operator/sandwich.vim
  runtime plugin/textobj/sandwich.vim
endfunction
"}}}


function! s:suite.surround() abort "{{{
  call setline('.', 'foo')
  normal 0ysiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  call setline('.', 'foo bar')
  normal 0yss(
  call g:assert.equals(getline('.'), '(foo bar)', 'failed at #2')

  call setline('.', 'foo bar')
  normal 04lyS(
  call g:assert.equals(getline('.'), 'foo (bar)', 'failed at #3')

  call setline('.', '[(foo)]')
  normal 02lds(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  call setline('.', '[(foo)]')
  normal 02lds[
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  call setline('.', '[(foo)]')
  normal 02ldss
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')

  call setline('.', '"''foo''"')
  normal 02ldss
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  call setline('.', '[(foo)]')
  normal 02lcs({
  call g:assert.equals(getline('.'), '[{foo}]', 'failed at #8')

  call setline('.', '[(foo)]')
  normal 02lcs[{
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #9')

  call setline('.', '[(foo)]')
  normal 02lcss{
  call g:assert.equals(getline('.'), '[{foo}]', 'failed at #10')

  call setline('.', '"''foo''"')
  normal 02lcss`
  call g:assert.equals(getline('.'), '"`foo`"', 'failed at #11')

  call setline('.', 'foo')
  normal 0viwS(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #12')
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
