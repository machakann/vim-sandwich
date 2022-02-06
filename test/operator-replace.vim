scriptencoding utf-8

let s:suite = themis#suite('operator-sandwich: replace:')
let s:object = 'g:operator#sandwich#object'
call themis#helper('command').with(s:)

function! s:suite.before() abort  "{{{
  nmap sr <Plug>(operator-sandwich-replace)
  xmap sr <Plug>(operator-sandwich-replace)
endfunction
"}}}
function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
  set autoindent&
  set smartindent&
  set cindent&
  set cinkeys&
  set indentexpr=
  set indentkeys&
  set virtualedit&
  silent! mapc!
  silent! ounmap ii
  silent! ounmap ssr
  silent! xunmap i{
  silent! xunmap a{
  call operator#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  unlet! g:sandwich#input_fallback
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  nmap sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap sr <Plug>(operator-sandwich-replace)
endfunction
"}}}

" Input
function! s:suite.input() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']']},
        \ ]

  " #1
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'input': ['a', 'b']},
        \   {'buns': ['[', ']']},
        \ ]

  " #2
  call setline('.', '[foo]')
  normal 0sra[a
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  normal 0sra[b
  call g:assert.equals(getline('.'), '(foo)', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(', 'failed at #4')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['`', '`']},
        \   {'buns': ['``', '``']},
        \   {'buns': ['```', '```']},
        \ ]

  " #5
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '``foo``', 'failed at #6')

  " #7
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #7')

  " #8
  call setline('.', "'foo'")
  execute "normal 0sr2i'`\<Esc>"
  call g:assert.equals(getline('.'), "'foo'", 'failed at #8')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #9
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #9')

  " #10
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #10')

  " #11
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #11')

  " #12
  call setline('.', "'foo'")
  execute "normal 0sr2i'`\<Esc>"
  call g:assert.equals(getline('.'), "'foo'", 'failed at #12')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #13
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #13')

  " #14
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #15')

  " #16
  call setline('.', "'foo'")
  execute "normal 0sr2i'`\<Esc>"
  call g:assert.equals(getline('.'), "'foo'", 'failed at #16')
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim'], 'input': ['(', ')']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #1
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0sra(<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  set filetype=vim

  " #5
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  " #7
  call setline('.', '(foo)')
  normal 0sra(<
  call g:assert.equals(getline('.'), '<foo<', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '<foo>', 'failed at #8')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['add']},
        \ ]

  " #2
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['delete']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['replace']},
        \ ]

  " #4
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['operator']},
        \ ]

  " #5
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #6
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  " #1
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['{']},
        \ ]

  " #4
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['{']},
        \ ]

  " #7
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #7')

  " #8
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #8')

  " #9
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['{']},
        \ ]

  " #10
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #10')

  " #11
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #11')

  " #12
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #12')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['{']},
        \ ]

  " #13
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #13')

  " #14
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #14')

  " #15
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #15')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['{']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['{']},
        \ ]

  " #5
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['{']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['{']},
        \ ]

  " #5
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['{']},
        \ ]

  " #7
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #7')

  " #8
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')
endfunction
"}}}
function! s:suite.filter_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'expr_filter': ['FilterValid()']},
        \   {'buns': ['{', '}'], 'expr_filter': ['FilterInvalid()']},
        \ ]

  function! FilterValid() abort
    return 1
  endfunction

  function! FilterInvalid() abort
    return 0
  endfunction

  " #1
  call setline('.', '"foo"')
  normal 0sr2i"(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '"foo"')
  normal 0sr2i"[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  " #3
  call setline('.', '"foo"')
  normal 0sr2i"{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  call setline('.', '[foo]')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sra[{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sra{<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #72')

  " #73
  call setline('.', '(foo)')
  normal 0sra(]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #73')

  " #74
  call setline('.', '[foo]')
  normal 0sra[}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #74')

  " #75
  call setline('.', '{foo}')
  normal 0sra{>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #75')

  " #76
  call setline('.', '<foo>')
  normal 0sra<)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #76')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #1
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '+foo+')
  normal 0sr$*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #1
  call setline('.', '(foo)bar')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foo(bar)')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #2')

  " #3
  call setline('.', 'foo(bar)baz')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #3')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))'], 'input': ['(']}, {'buns': ['[', ']']}]

  " #4
  call setline('.', 'foo((bar))baz')
  normal 0srii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #4')

  " #5
  call setline('.', 'foo((bar))baz')
  normal 02lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #5')

  " #6
  call setline('.', 'foo((bar))baz')
  normal 03lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #6')

  " #7
  call setline('.', 'foo((bar))baz')
  normal 04lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #7')

  " #8
  call setline('.', 'foo((bar))baz')
  normal 05lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #8')

  " #9
  call setline('.', 'foo((bar))baz')
  normal 07lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #9')

  " #10
  call setline('.', 'foo((bar))baz')
  normal 08lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #10')

  " #11
  call setline('.', 'foo((bar))baz')
  normal 09lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #11')

  " #12
  call setline('.', 'foo((bar))baz')
  normal 010lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #12')

  " #13
  call setline('.', 'foo((bar))baz')
  normal 012lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #13')

  " #14
  call setline('.', 'foo[[bar]]baz')
  normal 03lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0],     'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #14')

  " #15
  call setline('.', 'foo[[bar]]baz')
  normal 09lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #15')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #16
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsr13l[
  call g:assert.equals(getline(1),   '[foo',       'failed at #16')
  call g:assert.equals(getline(2),   'bar',        'failed at #16')
  call g:assert.equals(getline(3),   'baz]',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #16')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[a]',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   'a',          'failed at #2')
  call g:assert.equals(getline(3),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[a',         'failed at #3')
  call g:assert.equals(getline(2),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(', 'a)'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #4')
  call g:assert.equals(getline(2),   'a]',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0sra([
  call g:assert.equals(getline('.'), '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #1')

  " #2
  call setline('.', 'foo()bar')
  normal 03lsra([
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #3')
  call g:assert.equals(getline(2),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #1
  call setline('.', '([foo])')
  normal 02sr%[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', '[({foo})]')
  normal 03sr%{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')

  " #3
  call setline('.', '[foo ]bar')
  normal 0sr6l(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  " #4
  call setline('.', '[foo bar]')
  normal 0sr9l(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #4')

  " #5
  call setline('.', '{[foo bar]}')
  normal 02sr11l[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #5')

  " #6
  call setline('.', 'foo{[bar]}baz')
  normal 03l2sr7l[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #6')

  " #7
  call setline('.', 'foo({[bar]})baz')
  normal 03l3sr9l{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #7')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '(foo)')
  normal 0sr5la
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', '(foo)')
  normal 0sr5lb
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #4')
  call g:assert.equals(getline(4),   'bbb',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15lb
  call g:assert.equals(getline(1),   'bb',         'failed at #5')
  call g:assert.equals(getline(2),   'bbb',        'failed at #5')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #5')
  call g:assert.equals(getline(4),   'bbb',        'failed at #5')
  call g:assert.equals(getline(5),   'bb',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21la
  call g:assert.equals(getline(1),   'aa',         'failed at #6')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #6')
  call g:assert.equals(getline(3),   'aa',         'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['aa', 'aaaaa', 'aaafooaaa', 'aaaaa', 'aa'])
  normal gg2sr27lbb
  call g:assert.equals(getline(1),   'bb',         'failed at #7')
  call g:assert.equals(getline(2),   'bbb',        'failed at #7')
  call g:assert.equals(getline(3),   'bbbb',       'failed at #7')
  call g:assert.equals(getline(4),   'bbb',        'failed at #7')
  call g:assert.equals(getline(5),   'bbfoobb',    'failed at #7')
  call g:assert.equals(getline(6),   'bbb',        'failed at #7')
  call g:assert.equals(getline(7),   'bbbb',       'failed at #7')
  call g:assert.equals(getline(8),   'bbb',        'failed at #7')
  call g:assert.equals(getline(9),   'bb',         'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['bb', 'bbb', 'bbbb', 'bbb', 'bbfoobb', 'bbb', 'bbbb', 'bbb', 'bb'])
  normal gg2sr39laa
  call g:assert.equals(getline(1),   'aa',         'failed at #8')
  call g:assert.equals(getline(2),   'aaaaa',      'failed at #8')
  call g:assert.equals(getline(3),   'aaafooaaa',  'failed at #8')
  call g:assert.equals(getline(4),   'aaaaa',      'failed at #8')
  call g:assert.equals(getline(5),   'aa',         'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #8')

  %delete
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 8)<CR>

  " #9
  call setline('.', ['foo(bar)baz'])
  normal 0sriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #9')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #9')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #9')

  %delete

  " #10
  call setline('.', ['foo(bar)baz'])
  normal 02lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #10')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #10')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #10')

  %delete

  " #11
  call setline('.', ['foo(bar)baz'])
  normal 03lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #11')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #11')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #11')

  %delete

  " #12
  call setline('.', ['foo(bar)baz'])
  normal 04lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #12')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #12')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #12')

  %delete

  " #13
  call setline('.', ['foo(bar)baz'])
  normal 06lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #13')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #13')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #13')

  %delete

  " #14
  call setline('.', ['foo(bar)baz'])
  normal 07lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #14')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #14')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #14')

  %delete

  " #15
  call setline('.', ['foo(bar)baz'])
  normal 08lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #15')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #15')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #15')

  %delete

  " #16
  call setline('.', ['foo(bar)baz'])
  normal 010lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #16')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #16')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #16')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>

  " #17
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #17')

  %delete

  " #18
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #18')

  %delete

  " #19
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #19')

  %delete

  " #20
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #20')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #20')

  %delete

  " #21
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #21')

  %delete

  " #22
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #22')

  %delete

  " #23
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #23')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #23')

  %delete

  " #24
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #24')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #24')

  %delete

  " #25
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #25')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #25')

  %delete

  " #26
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #26')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #26')

  %delete

  " #27
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #27')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #27')

  %delete

  " #28
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #28')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #28')

  %delete

  " #29
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #29')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #29')

  %delete

  " #30
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #30')

  %delete

  " #31
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #31')
  call g:assert.equals(getline(2),   'bbb',        'failed at #31')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #31')
  call g:assert.equals(getline(4),   'bbb',        'failed at #31')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #31')

  %delete

  " #32
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #32')
  call g:assert.equals(getline(2),   'bbb',        'failed at #32')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #32')
  call g:assert.equals(getline(4),   'bbb',        'failed at #32')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #32')

  %delete

  " #33
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #33')
  call g:assert.equals(getline(2),   'bbb',        'failed at #33')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #33')
  call g:assert.equals(getline(4),   'bbb',        'failed at #33')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #33')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #33')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #33')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #33')

  %delete

  " #34
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #34')
  call g:assert.equals(getline(2),   'bbb',        'failed at #34')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #34')
  call g:assert.equals(getline(4),   'bbb',        'failed at #34')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #34')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #34')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #34')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #34')

  %delete

  " #35
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #35')
  call g:assert.equals(getline(2),   'bbb',        'failed at #35')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #35')
  call g:assert.equals(getline(4),   'bbb',        'failed at #35')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #35')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #35')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #35')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #35')

  %delete

  " #36
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #36')
  call g:assert.equals(getline(2),   'bbb',        'failed at #36')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #36')
  call g:assert.equals(getline(4),   'bbb',        'failed at #36')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #36')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #36')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #36')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #36')

  %delete

  " #37
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #37')
  call g:assert.equals(getline(2),   'bbb',        'failed at #37')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #37')
  call g:assert.equals(getline(4),   'bbb',        'failed at #37')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #37')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #37')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #37')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #37')

  %delete

  " #38
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #38')
  call g:assert.equals(getline(2),   'bbb',        'failed at #38')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #38')
  call g:assert.equals(getline(4),   'bbb',        'failed at #38')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #38')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #38')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #38')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #38')

  %delete

  " #39
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #39')
  call g:assert.equals(getline(2),   'bbb',        'failed at #39')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #39')
  call g:assert.equals(getline(4),   'bbb',        'failed at #39')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #39')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #39')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #39')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #39')

  %delete

  " #40
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #40')
  call g:assert.equals(getline(2),   'bbb',        'failed at #40')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #40')
  call g:assert.equals(getline(4),   'bbb',        'failed at #40')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #40')
  call g:assert.equals(getpos('.'),  [0, 3, 6, 0], 'failed at #40')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #40')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #40')

  %delete

  " #41
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj7lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #41')
  call g:assert.equals(getline(2),   'bbb',        'failed at #41')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #41')
  call g:assert.equals(getline(4),   'bbb',        'failed at #41')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #41')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #41')

  %delete

  " #42
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #42')
  call g:assert.equals(getline(2),   'bbb',        'failed at #42')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #42')
  call g:assert.equals(getline(4),   'bbb',        'failed at #42')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #42')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #42')

  %delete

  " #43
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #43')
  call g:assert.equals(getline(2),   'bbb',        'failed at #43')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #43')
  call g:assert.equals(getline(4),   'bbb',        'failed at #43')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #43')

  %delete

  " #44
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #44')
  call g:assert.equals(getline(2),   'bbb',        'failed at #44')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #44')
  call g:assert.equals(getline(4),   'bbb',        'failed at #44')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #44')

  %delete

  " #45
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #45')
  call g:assert.equals(getline(2),   'bbb',        'failed at #45')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #45')
  call g:assert.equals(getline(4),   'bbb',        'failed at #45')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #45')

  %delete

  " #46
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #46')
  call g:assert.equals(getline(2),   'bbb',        'failed at #46')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #46')
  call g:assert.equals(getline(4),   'bbb',        'failed at #46')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 5, 5, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #46')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 5, 2)<CR>

  " #47
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #47')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #47')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #47')

  %delete

  " #48
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #48')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #48')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #48')

  %delete

  " #49
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #49')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #49')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #49')

  %delete

  " #50
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #50')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #50')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #50')

  %delete

  " #51
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #51')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #51')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #51')

  %delete

  " #52
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #52')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #52')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #52')

  %delete

  " #53
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggj2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #53')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #53')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #53')

  %delete

  " #54
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #54')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #54')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #54')

  %delete

  " #55
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #55')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #55')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #55')

  %delete

  " #56
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #56')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #56')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #56')

  %delete

  " #57
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #57')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #57')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #57')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #57')

  %delete

  " #58
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j5lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #58')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #58')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #58')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #58')

  %delete

  " #59
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j6lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #59')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #59')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0], 'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #59')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #59')

  %delete

  " #60
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #60')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #60')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #60')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #60')

  %delete

  " #61
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #61')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #61')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #61')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #61')

  %delete

  " #62
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #62')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #62')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #62')

  %delete

  " #63
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #63')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #63')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #63')

  %delete

  " #64
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #64')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #64')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #64')

  %delete

  " #65
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #65')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #65')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #65')

  %delete

  " #66
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #66')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #66')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #66')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call setline('.', '{[(foo)]}')
  normal 02lsr5l"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0lsr7l"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #2')

  " #3
  call setline('.', '{[(foo)]}')
  normal 0sr9l"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'aαa')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(α)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #1')

  " #2
  call setline('.', 'aaαa')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #2')

  " #3
  call setline('.', 'βαβ')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(α)',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #3')

  " #4
  call setline('.', 'βaαβ')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'αaα',       'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #5')

  " #6
  call setline('.', 'aαa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'ααα',       'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #6')

  " #7
  call setline('.', 'aaαa')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'αaα',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #8')

  " #9
  call setline('.', 'βαβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'ααα',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #9')

  " #10
  call setline('.', 'βaαβ')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #11')

  " #12
  call setline('.', 'aαa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #12')

  " #13
  call setline('.', 'aaαa')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #13')

  " #14
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #14')

  " #15
  call setline('.', 'βαβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'βaαβ')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call setline('.', 'a“a')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(“)',        'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #17')

  " #18
  call setline('.', 'aa“a')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #18')

  " #19
  call setline('.', 'β“β')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(“)',        'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #19')

  " #20
  call setline('.', 'βa“β')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“a“',        'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #21')

  " #22
  call setline('.', 'a“a')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“““',        'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #22')

  " #23
  call setline('.', 'aa“a')
  normal 0sr4la
  call g:assert.equals(getline('.'), '“a““',       'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #23')

  " #24
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“a“',        'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #24')

  " #25
  call setline('.', 'β“β')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“““',        'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #25')

  " #26
  call setline('.', 'βa“β')
  normal 0sr4la
  call g:assert.equals(getline('.'), '“a““',       'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #27')

  " #28
  call setline('.', 'a“a')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #28')

  " #29
  call setline('.', 'aa“a')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #29')

  " #30
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #30')

  " #31
  call setline('.', 'β“β')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #31')

  " #32
  call setline('.', 'βa“β')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #1')

  " #2
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["[\n    ", "\n]"], 'input':['a']}]
  call setline('.', '(foo)')
  normal 0sra(a
  call g:assert.equals(getline(1), '[',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ']',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  unlet! g:operator#sandwich#recipes

  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #4')

  " #5
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #6')

  " #7
  normal lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #8')

  " #9
  normal hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')

  " #11
  normal 3lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #12')

  " #13
  normal 3hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  normal 0sra[1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #1')

  " #2
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #4')

  """ off
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #7')

  " #8
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  """ 1
  " #1
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #3')

  " #4
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)

  " #6
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #8')

  " #9
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #15')
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  " #1
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '[(foo)]')
  normal 0ffsra("
  call g:assert.equals(getline('.'), '[]', 'failed at #1')

  " #2
  call operator#sandwich#set('replace', 'char', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '[(foo)]')
  normal 0ffsra("
  call g:assert.equals(getline('.'), '[]', 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa]',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa]',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   ']',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   ']',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ']',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #9')
  call g:assert.equals(getline(2),   'foo',        'failed at #9')
  call g:assert.equals(getline(3),   ']',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   '[',          'failed at #10')
  call g:assert.equals(getline(3),   ']',          'failed at #10')
  call g:assert.equals(getline(4),   'bb',         'failed at #10')
  call g:assert.equals(getline(5),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   ']',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #1')

  " #2
  call setline('.', '"""foo"""')
  normal 03sr$1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  call operator#sandwich#set('replace', 'char', 'query_once', 1)

  " #3
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', '"""foo"""')
  normal 03sr$0[{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #1')

  " #2
  call setline('.', '"foo"')
  normal 0sra"1
  call g:assert.equals(getline('.'), '2foo3', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3', 'failed at #3')

  " #4
  call setline('.', '"foo"')
  normal 0sra"b
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0,   'failed at #4')

  " #5
  call setline('.', '"foo"')
  normal 0sra"c
  call g:assert.equals(getline('.'), '"foo"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0,   'failed at #5')

  " #6
  call setline('.', '"''foo''"')
  normal 02sra"ab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,       'failed at #6')

  " #7
  call setline('.', '"''foo''"')
  normal 02sra"ac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,       'failed at #7')

  " #8
  call setline('.', '"''foo''"')
  normal 02sra"ba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0,       'failed at #8')

  " #9
  call setline('.', '"''foo''"')
  normal 02sra"ca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0,       'failed at #9')

  " #10
  call setline('.', '"foo"')
  normal 0sra"0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0sra"a
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  normal 0sra"1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'char', 'listexpr', 1)
  call setline('.', '"bar"')
  normal 0sra"a
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  normal 0sra"b
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0sra"0
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  normal 0sra"1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    "foo"')
  " normal ^sr2i"a
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"0
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.charwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  normal ^sr2i"1
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  normal ^sr2i"1
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #6')

  " #7
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #7')

  " #8
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #1
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #1
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #2')

  " #3
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #3')

  " #4
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz]',       'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #4')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   'a',          'failed at #2')
  call g:assert.equals(getline(3),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #3')
  call g:assert.equals(getline(2),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #4')
  call g:assert.equals(getline(2),   'a]',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #1')

  " #2
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #3')
  call g:assert.equals(getline(2),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #1
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')

  " #3
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #3')

  " #4
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #4')

  " #5
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #5')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #4')
  call g:assert.equals(getline(4),   'bbb',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #2')

  " #3
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'aαa')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(α)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #1')

  " #2
  call setline('.', 'aaαa')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #2')

  " #3
  call setline('.', 'βαβ')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(α)',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #3')

  " #4
  call setline('.', 'βaαβ')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'αaα',       'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #5')

  " #6
  call setline('.', 'aαa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'ααα',       'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #6')

  " #7
  call setline('.', 'aaαa')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'αaα',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #8')

  " #9
  call setline('.', 'βαβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'ααα',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #9')

  " #10
  call setline('.', 'βaαβ')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #11')

  " #12
  call setline('.', 'aαa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #12')

  " #13
  call setline('.', 'aaαa')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #13')

  " #14
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #14')

  " #15
  call setline('.', 'βαβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'βaαβ')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call setline('.', 'a“a')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(“)',        'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #17')

  " #18
  call setline('.', 'aa“a')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #18')

  " #19
  call setline('.', 'β“β')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(“)',        'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #19')

  " #20
  call setline('.', 'βa“β')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“a“',        'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #21')

  " #22
  call setline('.', 'a“a')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“““',        'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #22')

  " #23
  call setline('.', 'aa“a')
  normal 0v3lsra
  call g:assert.equals(getline('.'), '“a““',       'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #23')

  " #24
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“a“',        'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #24')

  " #25
  call setline('.', 'β“β')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“““',        'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #25')

  " #26
  call setline('.', 'βa“β')
  normal 0v3lsra
  call g:assert.equals(getline('.'), '“a““',       'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #27')

  " #28
  call setline('.', 'a“a')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #28')

  " #29
  call setline('.', 'aa“a')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #29')

  " #30
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #30')

  " #31
  call setline('.', 'β“β')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #31')

  " #32
  call setline('.', 'βa“β')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #1')

  " #2
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["[\n    ", "\n]"], 'input':['a']}]
  call setline('.', '(foo)')
  normal 0sra(a
  call g:assert.equals(getline(1), '[',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ']',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  unlet! g:operator#sandwich#recipes

  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #4')

  " #5
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #6')

  " #7
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #8')

  " #9
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')

  " #11
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #12')

  " #13
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  normal 0va[sr1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #1')

  " #2
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #4')

  """ off
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #7')

  " #8
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  """ 1
  " #1
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #3')

  " #4
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)

  " #6
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #8')

  " #9
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #15')
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)

  " #2
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #2')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  " #1
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '[(foo)]')
  normal 0ffva(sr"
  call g:assert.equals(getline('.'), '[]', 'failed at #1')

  " #2
  call operator#sandwich#set('replace', 'char', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '[(foo)]')
  normal 0ffsra("
  call g:assert.equals(getline('.'), '[]', 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa]',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa]',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   ']',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  """ 2
  %delete
  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   ']',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ']',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #9')
  call g:assert.equals(getline(2),   'foo',        'failed at #9')
  call g:assert.equals(getline(3),   ']',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   '[',          'failed at #10')
  call g:assert.equals(getline(3),   ']',          'failed at #10')
  call g:assert.equals(getline(4),   'bb',         'failed at #10')
  call g:assert.equals(getline(5),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   ']',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', '"""foo"""')
  normal 0v$3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #1')

  " #2
  call setline('.', '"""foo"""')
  normal 0v$3sr1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 0v$3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', '"""foo"""')
  normal 0v$3sr0[{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  " #2
  call setline('.', '"foo"')
  normal 0va"sr1
  call g:assert.equals(getline('.'), '2foo3', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '2foo3', 'failed at #3')

  " #4
  call setline('.', '"foo"')
  normal 0va"srb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0,   'failed at #4')

  " #5
  call setline('.', '"foo"')
  normal 0va"src
  call g:assert.equals(getline('.'), '"foo"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0,   'failed at #5')

  " #6
  call setline('.', '"''foo''"')
  normal 0va"2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,       'failed at #6')

  " #7
  call setline('.', '"''foo''"')
  normal 0va"2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,       'failed at #7')

  " #8
  call setline('.', '"''foo''"')
  normal 0va"2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0,       'failed at #8')

  " #9
  call setline('.', '"''foo''"')
  normal 0va"2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0,       'failed at #9')

  " #10
  call setline('.', '"foo"')
  normal 0va"sr0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0va"sra
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  normal 0va"sr1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'char', 'listexpr', 1)
  call setline('.', '"bar"')
  normal 0va"sra
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  normal 0va"srb
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0va"sr0
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  normal 0va"sr1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    "foo"')
  " normal ^v2i"sra
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sr0
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.charwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  normal ^v2i"sr1
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  normal ^v2i"sr1
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   ']',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #5')

  " #6
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  " #7
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '>',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  " #8
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ')',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #1
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'b',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '*',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'bar',        'failed at #1')
  call g:assert.equals(getline(4),   'baz',        'failed at #1')
  call g:assert.equals(getline(5),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   '[',          'failed at #2')
  call g:assert.equals(getline(3),   'bar',        'failed at #2')
  call g:assert.equals(getline(4),   ']',          'failed at #2')
  call g:assert.equals(getline(5),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz]',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   '(',          'failed at #3')
  call g:assert.equals(getline(3),   '{',          'failed at #3')
  call g:assert.equals(getline(4),   '[',          'failed at #3')
  call g:assert.equals(getline(5),   'bar',        'failed at #3')
  call g:assert.equals(getline(6),   ']',          'failed at #3')
  call g:assert.equals(getline(7),   '}',          'failed at #3')
  call g:assert.equals(getline(8),   ')',          'failed at #3')
  call g:assert.equals(getline(9),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #4')
  call g:assert.equals(getline(4),   'bbb',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #5')
  call g:assert.equals(getline(2),   '(',          'failed at #5')
  call g:assert.equals(getline(3),   'foo',        'failed at #5')
  call g:assert.equals(getline(4),   ')',          'failed at #5')
  call g:assert.equals(getline(5),   ')',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #6')
  call g:assert.equals(getline(2),   '(',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ')',          'failed at #6')
  call g:assert.equals(getline(5),   ')',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_external_textobj() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call append(0, ['a', 'α', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #1')
  call g:assert.equals(getline(2), 'α', 'failed at #1')
  call g:assert.equals(getline(3), ')', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  " #2
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #2')
  call g:assert.equals(getline(2), 'aα', 'failed at #2')
  call g:assert.equals(getline(3), ')',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  " #3
  call append(0, ['β', 'α', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #3')
  call g:assert.equals(getline(2), 'α', 'failed at #3')
  call g:assert.equals(getline(3), ')', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  " #4
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #4')
  call g:assert.equals(getline(2), 'aα', 'failed at #4')
  call g:assert.equals(getline(3), ')',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #5')
  call g:assert.equals(getline(2), 'a', 'failed at #5')
  call g:assert.equals(getline(3), 'α', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #5')

  " #6
  call append(0, ['a', 'α', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #6')
  call g:assert.equals(getline(2), 'α', 'failed at #6')
  call g:assert.equals(getline(3), 'α', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #6')

  " #7
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α',  'failed at #7')
  call g:assert.equals(getline(2), 'aα', 'failed at #7')
  call g:assert.equals(getline(3), 'α',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #7')

  " #8
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #8')
  call g:assert.equals(getline(2), 'a', 'failed at #8')
  call g:assert.equals(getline(3), 'α', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #8')

  " #9
  call append(0, ['β', 'α', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #9')
  call g:assert.equals(getline(2), 'α', 'failed at #9')
  call g:assert.equals(getline(3), 'α', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #9')

  " #10
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α',  'failed at #10')
  call g:assert.equals(getline(2), 'aα', 'failed at #10')
  call g:assert.equals(getline(3), 'α',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #11')
  call g:assert.equals(getline(2), 'a',  'failed at #11')
  call g:assert.equals(getline(3), 'aα', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #11')

  " #12
  call append(0, ['a', 'α', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #12')
  call g:assert.equals(getline(2), 'α',  'failed at #12')
  call g:assert.equals(getline(3), 'aα', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #12')

  " #13
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #13')
  call g:assert.equals(getline(2), 'aα', 'failed at #13')
  call g:assert.equals(getline(3), 'aα', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #13')

  " #14
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #14')
  call g:assert.equals(getline(2), 'a',  'failed at #14')
  call g:assert.equals(getline(3), 'aα', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #14')

  " #15
  call append(0, ['β', 'α', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #15')
  call g:assert.equals(getline(2), 'α',  'failed at #15')
  call g:assert.equals(getline(3), 'aα', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #15')

  " #16
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #16')
  call g:assert.equals(getline(2), 'aα', 'failed at #16')
  call g:assert.equals(getline(3), 'aα', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call append(0, ['a', '“', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #17')
  call g:assert.equals(getline(2), '“', 'failed at #17')
  call g:assert.equals(getline(3), ')', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #17')

  " #18
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #18')
  call g:assert.equals(getline(2), 'a“', 'failed at #18')
  call g:assert.equals(getline(3), ')',  'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #18')

  " #19
  call append(0, ['β', '“', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #19')
  call g:assert.equals(getline(2), '“', 'failed at #19')
  call g:assert.equals(getline(3), ')', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #19')

  " #20
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #20')
  call g:assert.equals(getline(2), 'a“', 'failed at #20')
  call g:assert.equals(getline(3), ')',  'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #21')
  call g:assert.equals(getline(2), 'a', 'failed at #21')
  call g:assert.equals(getline(3), '“', 'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #21')

  " #22
  call append(0, ['a', '“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #22')
  call g:assert.equals(getline(2), '“', 'failed at #22')
  call g:assert.equals(getline(3), '“', 'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #22')

  " #23
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“',  'failed at #23')
  call g:assert.equals(getline(2), 'a“', 'failed at #23')
  call g:assert.equals(getline(3), '“',  'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #23')

  " #24
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #24')
  call g:assert.equals(getline(2), 'a', 'failed at #24')
  call g:assert.equals(getline(3), '“', 'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #24')

  " #25
  call append(0, ['β', '“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #25')
  call g:assert.equals(getline(2), '“', 'failed at #25')
  call g:assert.equals(getline(3), '“', 'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #25')

  " #26
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“',  'failed at #26')
  call g:assert.equals(getline(2), 'a“', 'failed at #26')
  call g:assert.equals(getline(3), '“',  'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #27')
  call g:assert.equals(getline(2), 'a',  'failed at #27')
  call g:assert.equals(getline(3), 'a“', 'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #27')

  " #28
  call append(0, ['a', '“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #28')
  call g:assert.equals(getline(2), '“',  'failed at #28')
  call g:assert.equals(getline(3), 'a“', 'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #28')

  " #29
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #29')
  call g:assert.equals(getline(2), 'a“', 'failed at #29')
  call g:assert.equals(getline(3), 'a“', 'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #29')

  " #30
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #30')
  call g:assert.equals(getline(2), 'a',  'failed at #30')
  call g:assert.equals(getline(3), 'a“', 'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #30')

  " #31
  call append(0, ['β', '“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #31')
  call g:assert.equals(getline(2), '“',  'failed at #31')
  call g:assert.equals(getline(3), 'a“', 'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #31')

  " #32
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #32')
  call g:assert.equals(getline(2), 'a“', 'failed at #32')
  call g:assert.equals(getline(3), 'a“', 'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["[\n    ", "\n]"], 'input':['a']}]
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1), '[',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ']',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  unlet! g:operator#sandwich#recipes

  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')

  " #5
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #6')

  " #7
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #8')

  " #9
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #12')

  " #13
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  normal 0srVl1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ off
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #1
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #3')

  " #4
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 1
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)

  " #6
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #8')

  " #9
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #15')
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])
  call append(0, ['[', '(foo)', ']'])
  normal ggjsrVl"
  call g:assert.equals(getline(1), '[', 'failed at #1')
  call g:assert.equals(getline(2), '',  'failed at #1')
  call g:assert.equals(getline(3), ']', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('replace', 'line', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['[', '(foo)', ']'])
  normal ggjsrVl"
  call g:assert.equals(getline(1), '[', 'failed at #2')
  call g:assert.equals(getline(2), '',  'failed at #2')
  call g:assert.equals(getline(3), ']', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  """ 0
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '  ]',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa]',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa]',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 1}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   ']',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  """ 2
  %delete
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   ']',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ']',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #9')
  call g:assert.equals(getline(2),   'foo',        'failed at #9')
  call g:assert.equals(getline(3),   ']',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   '[',          'failed at #10')
  call g:assert.equals(getline(3),   ']',          'failed at #10')
  call g:assert.equals(getline(4),   'bb',         'failed at #10')
  call g:assert.equals(getline(5),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   ']',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #1')

  " #2
  call setline('.', '"""foo"""')
  normal 03srVl1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  call operator#sandwich#set('replace', 'line', 'query_once', 1)

  " #3
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', '"""foo"""')
  normal 03srVl0[{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  " #2
  call setline('.', '"foo"')
  normal 0srVl1
  call g:assert.equals(getline('.'), '2foo3', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3', 'failed at #3')

  " #4
  call setline('.', '"foo"')
  normal 0srVlb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0,   'failed at #4')

  " #5
  call setline('.', '"foo"')
  normal 0srVlc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"''foo''"')
  normal 02srVlab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0, 'failed at #6')

  " #7
  call setline('.', '"''foo''"')
  normal 02srVlac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0, 'failed at #7')

  " #8
  call setline('.', '"''foo''"')
  normal 02srVlba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  " #9
  call setline('.', '"''foo''"')
  normal 02srVlca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  " #10
  call setline('.', '"foo"')
  normal 0srVl0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0srVla
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  normal 0srVl1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'line', 'listexpr', 1)
  call setline('.', '"bar"')
  normal 0srVla
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  normal 0srVlb
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0srVl0
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  normal 0srVl1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ -1
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getline(4),   '    foo',    'failed at #1')
  call g:assert.equals(getline(5),   '',           'failed at #1')
  call g:assert.equals(getline(6),   ']',          'failed at #1')
  call g:assert.equals(getline(7),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '',           'failed at #2')
  call g:assert.equals(getline(4),   '    foo',    'failed at #2')
  call g:assert.equals(getline(5),   '',           'failed at #2')
  call g:assert.equals(getline(6),   '    ]',      'failed at #2')
  call g:assert.equals(getline(7),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #3')
  call g:assert.equals(getline(2),   '    [',       'failed at #3')
  call g:assert.equals(getline(3),   '',            'failed at #3')
  call g:assert.equals(getline(4),   '    foo',     'failed at #3')
  call g:assert.equals(getline(5),   '',            'failed at #3')
  call g:assert.equals(getline(6),   '    ]',       'failed at #3')
  call g:assert.equals(getline(7),   '}',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #4')
  call g:assert.equals(getline(2),   '    [',       'failed at #4')
  call g:assert.equals(getline(3),   '',            'failed at #4')
  call g:assert.equals(getline(4),   '    foo',     'failed at #4')
  call g:assert.equals(getline(5),   '',            'failed at #4')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #4')
  call g:assert.equals(getline(7),   '}',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #4')
  call g:assert.equals(&l:autoindent,  1,           'failed at #4')
  call g:assert.equals(&l:smartindent, 1,           'failed at #4')
  call g:assert.equals(&l:cindent,     1,           'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call append(0, ['    "', '    foo', '    "'])
  " normal ggsr2ja
  " call g:assert.equals(getline(1),   '       {',              'failed at #5')
  " call g:assert.equals(getline(2),   '           [',          'failed at #5')
  " call g:assert.equals(getline(3),   '',                      'failed at #5')
  " call g:assert.equals(getline(4),   '    foo',               'failed at #5')
  " call g:assert.equals(getline(5),   '',                      'failed at #5')
  " call g:assert.equals(getline(6),   '            ]',         'failed at #5')
  " call g:assert.equals(getline(7),   '                    }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 4,  5, 0],           'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  1, 0],           'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 7, 22, 0],           'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                     'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                     'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                     'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',        'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getline(4),   '    foo',    'failed at #6')
  call g:assert.equals(getline(5),   '',           'failed at #6')
  call g:assert.equals(getline(6),   ']',          'failed at #6')
  call g:assert.equals(getline(7),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   '',           'failed at #7')
  call g:assert.equals(getline(4),   '    foo',    'failed at #7')
  call g:assert.equals(getline(5),   '',           'failed at #7')
  call g:assert.equals(getline(6),   ']',          'failed at #7')
  call g:assert.equals(getline(7),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   '',           'failed at #8')
  call g:assert.equals(getline(4),   '    foo',    'failed at #8')
  call g:assert.equals(getline(5),   '',           'failed at #8')
  call g:assert.equals(getline(6),   ']',          'failed at #8')
  call g:assert.equals(getline(7),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   '',           'failed at #9')
  call g:assert.equals(getline(4),   '    foo',    'failed at #9')
  call g:assert.equals(getline(5),   '',           'failed at #9')
  call g:assert.equals(getline(6),   ']',          'failed at #9')
  call g:assert.equals(getline(7),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',              'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   '',               'failed at #10')
  call g:assert.equals(getline(4),   '    foo',        'failed at #10')
  call g:assert.equals(getline(5),   '',               'failed at #10')
  call g:assert.equals(getline(6),   ']',              'failed at #10')
  call g:assert.equals(getline(7),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getline(4),   '    foo',    'failed at #11')
  call g:assert.equals(getline(5),   '',           'failed at #11')
  call g:assert.equals(getline(6),   '    ]',      'failed at #11')
  call g:assert.equals(getline(7),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '',           'failed at #12')
  call g:assert.equals(getline(4),   '    foo',    'failed at #12')
  call g:assert.equals(getline(5),   '',           'failed at #12')
  call g:assert.equals(getline(6),   '    ]',      'failed at #12')
  call g:assert.equals(getline(7),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '',           'failed at #13')
  call g:assert.equals(getline(4),   '    foo',    'failed at #13')
  call g:assert.equals(getline(5),   '',           'failed at #13')
  call g:assert.equals(getline(6),   '    ]',      'failed at #13')
  call g:assert.equals(getline(7),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '',           'failed at #14')
  call g:assert.equals(getline(4),   '    foo',    'failed at #14')
  call g:assert.equals(getline(5),   '',           'failed at #14')
  call g:assert.equals(getline(6),   '    ]',      'failed at #14')
  call g:assert.equals(getline(7),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '',               'failed at #15')
  call g:assert.equals(getline(4),   '    foo',        'failed at #15')
  call g:assert.equals(getline(5),   '',               'failed at #15')
  call g:assert.equals(getline(6),   '    ]',          'failed at #15')
  call g:assert.equals(getline(7),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #16')
  call g:assert.equals(getline(2),   '    [',       'failed at #16')
  call g:assert.equals(getline(3),   '',            'failed at #16')
  call g:assert.equals(getline(4),   '    foo',     'failed at #16')
  call g:assert.equals(getline(5),   '',            'failed at #16')
  call g:assert.equals(getline(6),   '    ]',       'failed at #16')
  call g:assert.equals(getline(7),   '}',           'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #17')
  call g:assert.equals(getline(2),   '    [',       'failed at #17')
  call g:assert.equals(getline(3),   '',            'failed at #17')
  call g:assert.equals(getline(4),   '    foo',     'failed at #17')
  call g:assert.equals(getline(5),   '',            'failed at #17')
  call g:assert.equals(getline(6),   '    ]',       'failed at #17')
  call g:assert.equals(getline(7),   '}',           'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #18')
  call g:assert.equals(getline(2),   '    [',       'failed at #18')
  call g:assert.equals(getline(3),   '',            'failed at #18')
  call g:assert.equals(getline(4),   '    foo',     'failed at #18')
  call g:assert.equals(getline(5),   '',            'failed at #18')
  call g:assert.equals(getline(6),   '    ]',       'failed at #18')
  call g:assert.equals(getline(7),   '}',           'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #19')
  call g:assert.equals(getline(2),   '    [',       'failed at #19')
  call g:assert.equals(getline(3),   '',            'failed at #19')
  call g:assert.equals(getline(4),   '    foo',     'failed at #19')
  call g:assert.equals(getline(5),   '',            'failed at #19')
  call g:assert.equals(getline(6),   '    ]',       'failed at #19')
  call g:assert.equals(getline(7),   '}',           'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',              'failed at #20')
  call g:assert.equals(getline(2),   '    [',          'failed at #20')
  call g:assert.equals(getline(3),   '',               'failed at #20')
  call g:assert.equals(getline(4),   '    foo',        'failed at #20')
  call g:assert.equals(getline(5),   '',               'failed at #20')
  call g:assert.equals(getline(6),   '    ]',          'failed at #20')
  call g:assert.equals(getline(7),   '}',              'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #21')
  call g:assert.equals(getline(2),   '    [',       'failed at #21')
  call g:assert.equals(getline(3),   '',            'failed at #21')
  call g:assert.equals(getline(4),   '    foo',     'failed at #21')
  call g:assert.equals(getline(5),   '',            'failed at #21')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #21')
  call g:assert.equals(getline(7),   '}',           'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #21')
  call g:assert.equals(&l:autoindent,  0,           'failed at #21')
  call g:assert.equals(&l:smartindent, 0,           'failed at #21')
  call g:assert.equals(&l:cindent,     0,           'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #22')
  call g:assert.equals(getline(2),   '    [',       'failed at #22')
  call g:assert.equals(getline(3),   '',            'failed at #22')
  call g:assert.equals(getline(4),   '    foo',     'failed at #22')
  call g:assert.equals(getline(5),   '',            'failed at #22')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #22')
  call g:assert.equals(getline(7),   '}',           'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #22')
  call g:assert.equals(&l:autoindent,  1,           'failed at #22')
  call g:assert.equals(&l:smartindent, 0,           'failed at #22')
  call g:assert.equals(&l:cindent,     0,           'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #23')
  call g:assert.equals(getline(2),   '    [',       'failed at #23')
  call g:assert.equals(getline(3),   '',            'failed at #23')
  call g:assert.equals(getline(4),   '    foo',     'failed at #23')
  call g:assert.equals(getline(5),   '',            'failed at #23')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #23')
  call g:assert.equals(getline(7),   '}',           'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #23')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #23')
  call g:assert.equals(&l:autoindent,  1,           'failed at #23')
  call g:assert.equals(&l:smartindent, 1,           'failed at #23')
  call g:assert.equals(&l:cindent,     0,           'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',           'failed at #24')
  call g:assert.equals(getline(2),   '    [',       'failed at #24')
  call g:assert.equals(getline(3),   '',            'failed at #24')
  call g:assert.equals(getline(4),   '    foo',     'failed at #24')
  call g:assert.equals(getline(5),   '',            'failed at #24')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #24')
  call g:assert.equals(getline(7),   '}',           'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #24')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #24')
  call g:assert.equals(&l:autoindent,  1,           'failed at #24')
  call g:assert.equals(&l:smartindent, 1,           'failed at #24')
  call g:assert.equals(&l:cindent,     1,           'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '',               'failed at #25')
  call g:assert.equals(getline(4),   '    foo',        'failed at #25')
  call g:assert.equals(getline(5),   '',               'failed at #25')
  " call g:assert.equals(getline(6),   '        ]',      'failed at #25')
  call g:assert.equals(getline(7),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2j0
  call g:assert.equals(getline(1),   '{',          'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   '',           'failed at #26')
  call g:assert.equals(getline(4),   '    foo',    'failed at #26')
  call g:assert.equals(getline(5),   '',           'failed at #26')
  call g:assert.equals(getline(6),   ']',          'failed at #26')
  call g:assert.equals(getline(7),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')

  %delete

  """ 4
  call operator#sandwich#set('replace', 'line', 'autoindent', 4)

  set cinkeys&
  set indentkeys&
  setlocal indentexpr=TestIndent()
  let g:sandwich#recipes = [{'buns': ['bar', 'bar'], 'line': 1, 'autoindent': 4, 'input': ['a']}, {'buns': ['baz', 'baz'], 'line': 1, 'autoindent': 4, 'input': ['b']}]
  let g:operator#sandwich#recipes = []
  call append(0, ['        foo', '    bar', '    foo', '    bar'])
  normal 2Gsr2jb
  call g:assert.equals(getline(1), '        foo', 'failed at #27')
  call g:assert.equals(getline(2), '    baz', 'failed at #27')
  call g:assert.equals(getline(3), '    foo', 'failed at #27')
  call g:assert.equals(getline(4), '    baz', 'failed at #27')
endfunction
"}}}
function! s:suite.linewise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{", "}"], 'input': ['a']},
        \   {'buns': ["{", "}"], 'indentkeys': '0},0),:,0#,!^F,o,e', 'input': ['1']},
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ cinkeys
  setlocal autoindent
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '    foo',    'failed at #1')
  call g:assert.equals(getline(3),   '    }',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #2
  setlocal cinkeys=0},0),:,0#,!^F,o,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    }',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2j1
  call g:assert.equals(getline(1),   '    {',      'failed at #4')
  call g:assert.equals(getline(2),   '    foo',    'failed at #4')
  call g:assert.equals(getline(3),   '    }',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #5')
  call g:assert.equals(getline(2),   '    foo',       'failed at #5')
  call g:assert.equals(getline(3),   '            }', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0},0),:,0#,!^F,o,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '       {',      'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #7')
  call g:assert.equals(getline(2),   '    foo',       'failed at #7')
  call g:assert.equals(getline(3),   '            }', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2j1
  call g:assert.equals(getline(1),   '    {',         'failed at #8')
  call g:assert.equals(getline(2),   '    foo',       'failed at #8')
  call g:assert.equals(getline(3),   '            }', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #8')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   ']',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #5')

  " #6
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  " #7
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '>',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  " #8
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ')',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #1
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'b',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '*',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'bar',        'failed at #1')
  call g:assert.equals(getline(4),   'baz',        'failed at #1')
  call g:assert.equals(getline(5),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   '[',          'failed at #2')
  call g:assert.equals(getline(3),   'bar',        'failed at #2')
  call g:assert.equals(getline(4),   ']',          'failed at #2')
  call g:assert.equals(getline(5),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz]',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #2')
  call g:assert.equals(getline(2),   ']',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   '(',          'failed at #3')
  call g:assert.equals(getline(3),   '{',          'failed at #3')
  call g:assert.equals(getline(4),   '[',          'failed at #3')
  call g:assert.equals(getline(5),   'bar',        'failed at #3')
  call g:assert.equals(getline(6),   ']',          'failed at #3')
  call g:assert.equals(getline(7),   '}',          'failed at #3')
  call g:assert.equals(getline(8),   ')',          'failed at #3')
  call g:assert.equals(getline(9),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #4')
  call g:assert.equals(getline(4),   'bbb',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #5')
  call g:assert.equals(getline(2),   '(',          'failed at #5')
  call g:assert.equals(getline(3),   'foo',        'failed at #5')
  call g:assert.equals(getline(4),   ')',          'failed at #5')
  call g:assert.equals(getline(5),   ')',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #6')
  call g:assert.equals(getline(2),   '(',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ')',          'failed at #6')
  call g:assert.equals(getline(5),   ')',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_external_textobj() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #1')
  call g:assert.equals(getline(2), 'α', 'failed at #1')
  call g:assert.equals(getline(3), ')', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  " #2
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #2')
  call g:assert.equals(getline(2), 'aα', 'failed at #2')
  call g:assert.equals(getline(3), ')',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  " #3
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #3')
  call g:assert.equals(getline(2), 'α', 'failed at #3')
  call g:assert.equals(getline(3), ')', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  " #4
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #4')
  call g:assert.equals(getline(2), 'aα', 'failed at #4')
  call g:assert.equals(getline(3), ')',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #5')
  call g:assert.equals(getline(2), 'a', 'failed at #5')
  call g:assert.equals(getline(3), 'α', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #5')

  " #6
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #6')
  call g:assert.equals(getline(2), 'α', 'failed at #6')
  call g:assert.equals(getline(3), 'α', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #6')

  " #7
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α',  'failed at #7')
  call g:assert.equals(getline(2), 'aα', 'failed at #7')
  call g:assert.equals(getline(3), 'α',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #7')

  " #8
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #8')
  call g:assert.equals(getline(2), 'a', 'failed at #8')
  call g:assert.equals(getline(3), 'α', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #8')

  " #9
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #9')
  call g:assert.equals(getline(2), 'α', 'failed at #9')
  call g:assert.equals(getline(3), 'α', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #9')

  " #10
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α',  'failed at #10')
  call g:assert.equals(getline(2), 'aα', 'failed at #10')
  call g:assert.equals(getline(3), 'α',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #11')
  call g:assert.equals(getline(2), 'a',  'failed at #11')
  call g:assert.equals(getline(3), 'aα', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #11')

  " #12
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #12')
  call g:assert.equals(getline(2), 'α',  'failed at #12')
  call g:assert.equals(getline(3), 'aα', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #12')

  " #13
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #13')
  call g:assert.equals(getline(2), 'aα', 'failed at #13')
  call g:assert.equals(getline(3), 'aα', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #13')

  " #14
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #14')
  call g:assert.equals(getline(2), 'a',  'failed at #14')
  call g:assert.equals(getline(3), 'aα', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #14')

  " #15
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #15')
  call g:assert.equals(getline(2), 'α',  'failed at #15')
  call g:assert.equals(getline(3), 'aα', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #15')

  " #16
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #16')
  call g:assert.equals(getline(2), 'aα', 'failed at #16')
  call g:assert.equals(getline(3), 'aα', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call append(0, ['a', '“', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #17')
  call g:assert.equals(getline(2), '“', 'failed at #17')
  call g:assert.equals(getline(3), ')', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #17')

  " #18
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #18')
  call g:assert.equals(getline(2), 'a“', 'failed at #18')
  call g:assert.equals(getline(3), ')',  'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #18')

  " #19
  call append(0, ['β', '“', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #19')
  call g:assert.equals(getline(2), '“', 'failed at #19')
  call g:assert.equals(getline(3), ')', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #19')

  " #20
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #20')
  call g:assert.equals(getline(2), 'a“', 'failed at #20')
  call g:assert.equals(getline(3), ')',  'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #21')
  call g:assert.equals(getline(2), 'a', 'failed at #21')
  call g:assert.equals(getline(3), '“', 'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #21')

  " #22
  call append(0, ['a', '“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #22')
  call g:assert.equals(getline(2), '“', 'failed at #22')
  call g:assert.equals(getline(3), '“', 'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #22')

  " #23
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“',  'failed at #23')
  call g:assert.equals(getline(2), 'a“', 'failed at #23')
  call g:assert.equals(getline(3), '“',  'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #23')

  " #24
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #24')
  call g:assert.equals(getline(2), 'a', 'failed at #24')
  call g:assert.equals(getline(3), '“', 'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #24')

  " #25
  call append(0, ['β', '“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #25')
  call g:assert.equals(getline(2), '“', 'failed at #25')
  call g:assert.equals(getline(3), '“', 'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #25')

  " #26
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“',  'failed at #26')
  call g:assert.equals(getline(2), 'a“', 'failed at #26')
  call g:assert.equals(getline(3), '“',  'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #27')
  call g:assert.equals(getline(2), 'a',  'failed at #27')
  call g:assert.equals(getline(3), 'a“', 'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #27')

  " #28
  call append(0, ['a', '“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #28')
  call g:assert.equals(getline(2), '“',  'failed at #28')
  call g:assert.equals(getline(3), 'a“', 'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #28')

  " #29
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #29')
  call g:assert.equals(getline(2), 'a“', 'failed at #29')
  call g:assert.equals(getline(3), 'a“', 'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #29')

  " #30
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #30')
  call g:assert.equals(getline(2), 'a',  'failed at #30')
  call g:assert.equals(getline(3), 'a“', 'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #30')

  " #31
  call append(0, ['β', '“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #31')
  call g:assert.equals(getline(2), '“',  'failed at #31')
  call g:assert.equals(getline(3), 'a“', 'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #31')

  " #32
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #32')
  call g:assert.equals(getline(2), 'a“', 'failed at #32')
  call g:assert.equals(getline(3), 'a“', 'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["[\n    ", "\n]"], 'input':['a']}]
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1), '[',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ']',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  unlet! g:operator#sandwich#recipes

  %delete

  """ inner_head
  " #1
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  """ keep
  " #3
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')

  " #4
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #4')

  """ inner_tail
  " #5
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #5')

  " #6
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #6')

  """ head
  " #7
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')

  " #8
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')

  """ tail
  " #9
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #9')

  " #10
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #10')

  """"" recipe option
  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  normal 0Vsr1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #11')
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{foo}')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ off
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{foo}')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '(foo)')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #1
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #3')

  " #4
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 1
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)

  " #6
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #8')

  " #9
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call setline('.', ' "foo"')
  normal 0Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #15')
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #1
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])
  call append(0, ['[', '(foo)', ']'])
  normal ggjVsr"
  call g:assert.equals(getline(1), '[', 'failed at #1')
  call g:assert.equals(getline(2), '',  'failed at #1')
  call g:assert.equals(getline(3), ']', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('replace', 'line', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['[', '(foo)', ']'])
  normal ggjVsr"
  call g:assert.equals(getline(1), '[', 'failed at #2')
  call g:assert.equals(getline(2), '',  'failed at #2')
  call g:assert.equals(getline(3), ']', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  """ 0
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '  ]',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa]',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa]',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 1}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   ']',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  """ 2
  %delete
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   ']',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   ']',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #9')
  call g:assert.equals(getline(2),   'foo',        'failed at #9')
  call g:assert.equals(getline(3),   ']',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   '[',          'failed at #10')
  call g:assert.equals(getline(3),   ']',          'failed at #10')
  call g:assert.equals(getline(4),   'bb',         'failed at #10')
  call g:assert.equals(getline(5),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   ']',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #1')

  " #2
  call setline('.', '"""foo"""')
  normal 0V3sr1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  call operator#sandwich#set('replace', 'line', 'query_once', 1)

  " #2
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  " #4
  call setline('.', '"""foo"""')
  normal 0V3sr0[{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  " #2
  call setline('.', '"foo"')
  normal Vsr1
  call g:assert.equals(getline('.'), '2foo3', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #3')

  " #4
  call setline('.', '"foo"')
  normal Vsrb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0,   'failed at #4')

  " #5
  call setline('.', '"foo"')
  normal Vsrc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0,   'failed at #5')

  " #6
  call setline('.', '"''foo''"')
  normal V2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,       'failed at #6')

  " #7
  call setline('.', '"''foo''"')
  normal V2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,       'failed at #7')


  " #8
  call setline('.', '"''foo''"')
  normal V2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0,       'failed at #8')

  " #9
  call setline('.', '"''foo''"')
  normal V2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0,       'failed at #9')

  " #10
  call setline('.', '"foo"')
  normal Vsr0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0Vsra
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  normal 0Vsr1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'line', 'listexpr', 1)
  call setline('.', '"bar"')
  normal 0Vsra
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  normal 0Vsrb
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0Vsr0
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  normal 0Vsr1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_x_option_autoindent() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ -1
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getline(4),   '    foo',    'failed at #1')
  call g:assert.equals(getline(5),   '',           'failed at #1')
  call g:assert.equals(getline(6),   ']',          'failed at #1')
  call g:assert.equals(getline(7),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '',           'failed at #2')
  call g:assert.equals(getline(4),   '    foo',    'failed at #2')
  call g:assert.equals(getline(5),   '',           'failed at #2')
  call g:assert.equals(getline(6),   '    ]',      'failed at #2')
  call g:assert.equals(getline(7),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #3')
  call g:assert.equals(getline(2),   '    [',       'failed at #3')
  call g:assert.equals(getline(3),   '',            'failed at #3')
  call g:assert.equals(getline(4),   '    foo',     'failed at #3')
  call g:assert.equals(getline(5),   '',            'failed at #3')
  call g:assert.equals(getline(6),   '    ]',       'failed at #3')
  call g:assert.equals(getline(7),   '}',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #4')
  call g:assert.equals(getline(2),   '    [',       'failed at #4')
  call g:assert.equals(getline(3),   '',            'failed at #4')
  call g:assert.equals(getline(4),   '    foo',     'failed at #4')
  call g:assert.equals(getline(5),   '',            'failed at #4')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #4')
  call g:assert.equals(getline(7),   '}',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #4')
  call g:assert.equals(&l:autoindent,  1,           'failed at #4')
  call g:assert.equals(&l:smartindent, 1,           'failed at #4')
  call g:assert.equals(&l:cindent,     1,           'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call append(0, ['    "', '    foo', '    "'])
  " normal ggV2jsra
  " call g:assert.equals(getline(1),   '       {',              'failed at #5')
  " call g:assert.equals(getline(2),   '           [',          'failed at #5')
  " call g:assert.equals(getline(3),   '',                      'failed at #5')
  " call g:assert.equals(getline(4),   '    foo',               'failed at #5')
  " call g:assert.equals(getline(5),   '',                      'failed at #5')
  " call g:assert.equals(getline(6),   '            ]',         'failed at #5')
  " call g:assert.equals(getline(7),   '                    }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 4,  5, 0],           'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  1, 0],           'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 7, 22, 0],           'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                     'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                     'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                     'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',        'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getline(4),   '    foo',    'failed at #6')
  call g:assert.equals(getline(5),   '',           'failed at #6')
  call g:assert.equals(getline(6),   ']',          'failed at #6')
  call g:assert.equals(getline(7),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   '',           'failed at #7')
  call g:assert.equals(getline(4),   '    foo',    'failed at #7')
  call g:assert.equals(getline(5),   '',           'failed at #7')
  call g:assert.equals(getline(6),   ']',          'failed at #7')
  call g:assert.equals(getline(7),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   '',           'failed at #8')
  call g:assert.equals(getline(4),   '    foo',    'failed at #8')
  call g:assert.equals(getline(5),   '',           'failed at #8')
  call g:assert.equals(getline(6),   ']',          'failed at #8')
  call g:assert.equals(getline(7),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   '',           'failed at #9')
  call g:assert.equals(getline(4),   '    foo',    'failed at #9')
  call g:assert.equals(getline(5),   '',           'failed at #9')
  call g:assert.equals(getline(6),   ']',          'failed at #9')
  call g:assert.equals(getline(7),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   '',               'failed at #10')
  call g:assert.equals(getline(4),   '    foo',        'failed at #10')
  call g:assert.equals(getline(5),   '',               'failed at #10')
  call g:assert.equals(getline(6),   ']',              'failed at #10')
  call g:assert.equals(getline(7),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getline(4),   '    foo',    'failed at #11')
  call g:assert.equals(getline(5),   '',           'failed at #11')
  call g:assert.equals(getline(6),   '    ]',      'failed at #11')
  call g:assert.equals(getline(7),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '',           'failed at #12')
  call g:assert.equals(getline(4),   '    foo',    'failed at #12')
  call g:assert.equals(getline(5),   '',           'failed at #12')
  call g:assert.equals(getline(6),   '    ]',      'failed at #12')
  call g:assert.equals(getline(7),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '',           'failed at #13')
  call g:assert.equals(getline(4),   '    foo',    'failed at #13')
  call g:assert.equals(getline(5),   '',           'failed at #13')
  call g:assert.equals(getline(6),   '    ]',      'failed at #13')
  call g:assert.equals(getline(7),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '',           'failed at #14')
  call g:assert.equals(getline(4),   '    foo',    'failed at #14')
  call g:assert.equals(getline(5),   '',           'failed at #14')
  call g:assert.equals(getline(6),   '    ]',      'failed at #14')
  call g:assert.equals(getline(7),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '',               'failed at #15')
  call g:assert.equals(getline(4),   '    foo',        'failed at #15')
  call g:assert.equals(getline(5),   '',               'failed at #15')
  call g:assert.equals(getline(6),   '    ]',          'failed at #15')
  call g:assert.equals(getline(7),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #16')
  call g:assert.equals(getline(2),   '    [',       'failed at #16')
  call g:assert.equals(getline(3),   '',            'failed at #16')
  call g:assert.equals(getline(4),   '    foo',     'failed at #16')
  call g:assert.equals(getline(5),   '',            'failed at #16')
  call g:assert.equals(getline(6),   '    ]',       'failed at #16')
  call g:assert.equals(getline(7),   '}',           'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #17')
  call g:assert.equals(getline(2),   '    [',       'failed at #17')
  call g:assert.equals(getline(3),   '',            'failed at #17')
  call g:assert.equals(getline(4),   '    foo',     'failed at #17')
  call g:assert.equals(getline(5),   '',            'failed at #17')
  call g:assert.equals(getline(6),   '    ]',       'failed at #17')
  call g:assert.equals(getline(7),   '}',           'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #18')
  call g:assert.equals(getline(2),   '    [',       'failed at #18')
  call g:assert.equals(getline(3),   '',            'failed at #18')
  call g:assert.equals(getline(4),   '    foo',     'failed at #18')
  call g:assert.equals(getline(5),   '',            'failed at #18')
  call g:assert.equals(getline(6),   '    ]',       'failed at #18')
  call g:assert.equals(getline(7),   '}',           'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #19')
  call g:assert.equals(getline(2),   '    [',       'failed at #19')
  call g:assert.equals(getline(3),   '',            'failed at #19')
  call g:assert.equals(getline(4),   '    foo',     'failed at #19')
  call g:assert.equals(getline(5),   '',            'failed at #19')
  call g:assert.equals(getline(6),   '    ]',       'failed at #19')
  call g:assert.equals(getline(7),   '}',           'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #20')
  call g:assert.equals(getline(2),   '    [',          'failed at #20')
  call g:assert.equals(getline(3),   '',               'failed at #20')
  call g:assert.equals(getline(4),   '    foo',        'failed at #20')
  call g:assert.equals(getline(5),   '',               'failed at #20')
  call g:assert.equals(getline(6),   '    ]',          'failed at #20')
  call g:assert.equals(getline(7),   '}',              'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #21')
  call g:assert.equals(getline(2),   '    [',       'failed at #21')
  call g:assert.equals(getline(3),   '',            'failed at #21')
  call g:assert.equals(getline(4),   '    foo',     'failed at #21')
  call g:assert.equals(getline(5),   '',            'failed at #21')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #21')
  call g:assert.equals(getline(7),   '}',           'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #21')
  call g:assert.equals(&l:autoindent,  0,           'failed at #21')
  call g:assert.equals(&l:smartindent, 0,           'failed at #21')
  call g:assert.equals(&l:cindent,     0,           'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #22')
  call g:assert.equals(getline(2),   '    [',       'failed at #22')
  call g:assert.equals(getline(3),   '',            'failed at #22')
  call g:assert.equals(getline(4),   '    foo',     'failed at #22')
  call g:assert.equals(getline(5),   '',            'failed at #22')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #22')
  call g:assert.equals(getline(7),   '}',           'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #22')
  call g:assert.equals(&l:autoindent,  1,           'failed at #22')
  call g:assert.equals(&l:smartindent, 0,           'failed at #22')
  call g:assert.equals(&l:cindent,     0,           'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #23')
  call g:assert.equals(getline(2),   '    [',       'failed at #23')
  call g:assert.equals(getline(3),   '',            'failed at #23')
  call g:assert.equals(getline(4),   '    foo',     'failed at #23')
  call g:assert.equals(getline(5),   '',            'failed at #23')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #23')
  call g:assert.equals(getline(7),   '}',           'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #23')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #23')
  call g:assert.equals(&l:autoindent,  1,           'failed at #23')
  call g:assert.equals(&l:smartindent, 1,           'failed at #23')
  call g:assert.equals(&l:cindent,     0,           'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #24')
  call g:assert.equals(getline(2),   '    [',       'failed at #24')
  call g:assert.equals(getline(3),   '',            'failed at #24')
  call g:assert.equals(getline(4),   '    foo',     'failed at #24')
  call g:assert.equals(getline(5),   '',            'failed at #24')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #24')
  call g:assert.equals(getline(7),   '}',           'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #24')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #24')
  call g:assert.equals(&l:autoindent,  1,           'failed at #24')
  call g:assert.equals(&l:smartindent, 1,           'failed at #24')
  call g:assert.equals(&l:cindent,     1,           'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '',               'failed at #25')
  call g:assert.equals(getline(4),   '    foo',        'failed at #25')
  call g:assert.equals(getline(5),   '',               'failed at #25')
  " call g:assert.equals(getline(6),   '        ]',      'failed at #25')
  call g:assert.equals(getline(7),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsr2j0
  call g:assert.equals(getline(1),   '{',          'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   '',           'failed at #26')
  call g:assert.equals(getline(4),   '    foo',    'failed at #26')
  call g:assert.equals(getline(5),   '',           'failed at #26')
  call g:assert.equals(getline(6),   ']',          'failed at #26')
  call g:assert.equals(getline(7),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')

  %delete

  """ 4
  setlocal indentexpr=TestIndent()
  let g:sandwich#recipes = [{'buns': ['bar', 'bar'], 'line': 1, 'autoindent': 4, 'input': ['a']}, {'buns': ['baz', 'baz'], 'line': 1, 'autoindent': 4, 'input': ['b']}]
  let g:operator#sandwich#recipes = []
  call append(0, ['        foo', '    bar', '    foo', '    bar'])
  normal 2GV2jsrb
  call g:assert.equals(getline(1), '        foo', 'failed at #27')
  call g:assert.equals(getline(2), '    baz', 'failed at #27')
  call g:assert.equals(getline(3), '    foo', 'failed at #27')
  call g:assert.equals(getline(4), '    baz', 'failed at #27')
endfunction
"}}}
function! s:suite.linewise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{", "}"], 'input': ['a']},
        \   {'buns': ["{", "}"], 'indentkeys': '0},0),:,0#,!^F,o,e', 'input': ['1']},
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ cinkeys
  setlocal autoindent
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '    foo',    'failed at #1')
  call g:assert.equals(getline(3),   '    }',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #2
  setlocal cinkeys=0},0),:,0#,!^F,o,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    }',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsr1
  call g:assert.equals(getline(1),   '    {',      'failed at #4')
  call g:assert.equals(getline(2),   '    foo',    'failed at #4')
  call g:assert.equals(getline(3),   '    }',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #5')
  call g:assert.equals(getline(2),   '    foo',       'failed at #5')
  call g:assert.equals(getline(3),   '            }', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0},0),:,0#,!^F,o,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',      'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,0{')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #7')
  call g:assert.equals(getline(2),   '    foo',       'failed at #7')
  call g:assert.equals(getline(3),   '            }', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsr1
  call g:assert.equals(getline(1),   '    {',         'failed at #8')
  call g:assert.equals(getline(2),   '    foo',       'failed at #8')
  call g:assert.equals(getline(3),   '            }', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #8')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #1')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #1')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #2')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #2')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #3')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #3')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #4')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #4')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #1')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #1')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  " #2
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #2')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #2')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #4')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #4')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #5')
  call g:assert.equals(getline(2),   'barbar',     'failed at #5')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #6')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #6')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #7')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #7')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #8')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #8')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #8')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #1')
  call g:assert.equals(getline(2),   '[b]',        'failed at #1')
  call g:assert.equals(getline(3),   '[c]',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #1')
  call g:assert.equals(getline(2),   '[]',         'failed at #1')
  call g:assert.equals(getline(3),   '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #1')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #1')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #2')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #2')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #3')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #3')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #4')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #4')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #5')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #5')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #5')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_external_textobj() abort "{{{
  set whichwrap=h,l

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #2')
  call g:assert.equals(getline(2), '"bar"', 'failed at #2')
  call g:assert.equals(getline(3), '"baz"', 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #3')
  call g:assert.equals(getline(2), '"bar"', 'failed at #3')
  call g:assert.equals(getline(3), '"baz"', 'failed at #3')

  %delete

  " #4
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  %delete

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  normal ggsr17l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #5')
  call g:assert.equals(getline(2), '(bar)', 'failed at #5')
  call g:assert.equals(getline(3), '(baz)', 'failed at #5')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #1
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(α)',          'failed at #1')
  call g:assert.equals(getline(2), '(β)',          'failed at #1')
  call g:assert.equals(getline(3), '(γ)',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #1')

  " #2
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(aα)',         'failed at #2')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #2')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #2')

  " #3
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(α)',          'failed at #3')
  call g:assert.equals(getline(2), '(β)',          'failed at #3')
  call g:assert.equals(getline(3), '(γ)',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #3')

  " #4
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(aα)',         'failed at #4')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #4')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'αaα',          'failed at #5')
  call g:assert.equals(getline(2), 'αbα',          'failed at #5')
  call g:assert.equals(getline(3), 'αcα',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #5')

  " #6
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'ααα',          'failed at #6')
  call g:assert.equals(getline(2), 'αβα',          'failed at #6')
  call g:assert.equals(getline(3), 'αγα',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #6')

  " #7
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #7')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #7')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #7')

  " #8
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'αaα',          'failed at #8')
  call g:assert.equals(getline(2), 'αbα',          'failed at #8')
  call g:assert.equals(getline(3), 'αcα',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #8')

  " #9
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'ααα',          'failed at #9')
  call g:assert.equals(getline(2), 'αβα',          'failed at #9')
  call g:assert.equals(getline(3), 'αγα',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #9')

  " #10
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #10')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #10')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #11')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #11')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #11')

  " #12
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #12')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #12')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #12')

  " #13
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #13')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #13')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #13')

  " #14
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #14')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #14')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #14')

  " #15
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #15')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #15')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #15')

  " #16
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #16')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #16')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(“)',          'failed at #17')
  call g:assert.equals(getline(2), '(“)',          'failed at #17')
  call g:assert.equals(getline(3), '(“)',          'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #17')

  " #18
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(a“)',         'failed at #18')
  call g:assert.equals(getline(2), '(b“)',         'failed at #18')
  call g:assert.equals(getline(3), '(c“)',         'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #18')

  " #19
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(“)',          'failed at #19')
  call g:assert.equals(getline(2), '(“)',          'failed at #19')
  call g:assert.equals(getline(3), '(“)',          'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #19')

  " #20
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(a“)',         'failed at #20')
  call g:assert.equals(getline(2), '(b“)',         'failed at #20')
  call g:assert.equals(getline(3), '(c“)',         'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“a“',          'failed at #21')
  call g:assert.equals(getline(2), '“b“',          'failed at #21')
  call g:assert.equals(getline(3), '“c“',          'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #21')

  " #22
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“““',          'failed at #22')
  call g:assert.equals(getline(2), '“““',          'failed at #22')
  call g:assert.equals(getline(3), '“““',          'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #22')

  " #23
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), '“a““',         'failed at #23')
  call g:assert.equals(getline(2), '“b““',         'failed at #23')
  call g:assert.equals(getline(3), '“c““',         'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #23')

  " #24
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“a“',          'failed at #24')
  call g:assert.equals(getline(2), '“b“',          'failed at #24')
  call g:assert.equals(getline(3), '“c“',          'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #24')

  " #25
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“““',          'failed at #25')
  call g:assert.equals(getline(2), '“““',          'failed at #25')
  call g:assert.equals(getline(3), '“““',          'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #25')

  " #26
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), '“a““',         'failed at #26')
  call g:assert.equals(getline(2), '“b““',         'failed at #26')
  call g:assert.equals(getline(3), '“c““',         'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #27')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #27')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #27')

  " #28
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #28')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #28')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #28')

  " #29
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #29')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #29')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #29')

  " #30
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #30')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #30')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #30')

  " #31
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #31')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #31')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #31')

  " #32
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #32')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #32')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ default
  " #1
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #1')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #1')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #1')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #1')

  " #2
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #2')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #2')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #2')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #2')

  %delete

  """ inner_head
  " #3
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #3')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #3')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #3')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #3')

  " #4
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #4')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #4')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #4')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #4')

  %delete

  """ keep
  " #5
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #5')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #5')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #5')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #5')

  " #6
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #6')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #6')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #6')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #6')

  %delete

  """ inner_tail
  " #7
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #7')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #7')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #7')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #7')

  " #8
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #8')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #8')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #8')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #8')

  %delete

  """ head
  " #9
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #9')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #9')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #9')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #9')

  " #10
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #10')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #10')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #10')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #10')

  %delete

  """ tail
  " #11
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #11')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #11')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #11')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #11')

  " #12
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #12')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #12')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #12')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #12')

  %delete

  """"" recipe option
  " #13
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  execute "normal ^sr\<C-v>5l1"
  call g:assert.equals(getline('.'), '(foo)',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #13')
endfunction
"}}}
function! s:suite.blockwise_n_option_noremap() abort  "{{{
  set whichwrap=h,l

  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')
  call g:assert.equals(getline(2), '(bar)', 'failed at #2')
  call g:assert.equals(getline(3), '(baz)', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #3')
  call g:assert.equals(getline(2), '{bar}', 'failed at #3')
  call g:assert.equals(getline(3), '{baz}', 'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  """ off
  %delete
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #5')
  call g:assert.equals(getline(2), '{bar}', 'failed at #5')
  call g:assert.equals(getline(3), '{baz}', 'failed at #5')

  %delete

  " #6
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #6')
  call g:assert.equals(getline(2), '"bar"', 'failed at #6')
  call g:assert.equals(getline(3), '"baz"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #7')
  call g:assert.equals(getline(2), '"bar"', 'failed at #7')
  call g:assert.equals(getline(3), '"baz"', 'failed at #7')

  %delete

  " #8
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #8')
  call g:assert.equals(getline(2), '(bar)', 'failed at #8')
  call g:assert.equals(getline(3), '(baz)', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_n_option_regex() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #2')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #2')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #3')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #3')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #3')

  %delete

  " #4
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  """ on
  %delete
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #5')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #5')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #5')

  %delete

  " #6
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #6')
  call g:assert.equals(getline(2), '"bar"', 'failed at #6')
  call g:assert.equals(getline(3), '"baz"', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #7')
  call g:assert.equals(getline(2), '"bar"', 'failed at #7')
  call g:assert.equals(getline(3), '"baz"', 'failed at #7')

  %delete

  " #8
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #8')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #8')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  set whichwrap=h,l

  """ 1
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')
  call g:assert.equals(getline(2), '(bar)', 'failed at #1')
  call g:assert.equals(getline(3), '(baz)', 'failed at #1')

  %delete

  " #2
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #2')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #2')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #2')

  %delete

  " #3
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #3')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #3')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #3')

  %delete

  " #4
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #4')
  call g:assert.equals(getline(2), '("bar")', 'failed at #4')
  call g:assert.equals(getline(3), '("baz")', 'failed at #4')

  %delete

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #5')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #5')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #5')

  %delete

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)

  " #6
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #6')
  call g:assert.equals(getline(2), '(bar)', 'failed at #6')
  call g:assert.equals(getline(3), '(baz)', 'failed at #6')

  %delete

  " #7
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #7')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #7')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #7')

  %delete

  " #8
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #8')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #8')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #8')

  %delete

  " #9
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sr\<C-v>23l("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #9')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #9')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #9')

  %delete

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #10')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #10')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #10')

  %delete

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)

  " #11
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #11')
  call g:assert.equals(getline(2), '(bar)', 'failed at #11')
  call g:assert.equals(getline(3), '(baz)', 'failed at #11')

  %delete

  " #12
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #12')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #12')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #12')

  %delete

  " #13
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #13')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #13')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #13')

  %delete

  " #14
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #14')
  call g:assert.equals(getline(2), '("bar")', 'failed at #14')
  call g:assert.equals(getline(3), '("baz")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #2')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #2')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #1
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #1')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #1')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #1')

  %delete

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #2')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #2')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #2')

  """ on
  %delete
  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)

  " #3
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #3')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #3')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #3')

  %delete

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #4')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #4')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l

  " #1
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '', 'failed at #1')
  call g:assert.equals(getline(2), '', 'failed at #1')
  call g:assert.equals(getline(3), '', 'failed at #1')

  " #2
  call operator#sandwich#set('replace', 'block', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '', 'failed at #2')
  call g:assert.equals(getline(2), '', 'failed at #2')
  call g:assert.equals(getline(3), '', 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #1')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #1')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #1')

  %delete

  " #2
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l1"
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #2')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #2')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #2')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'query_once', 1)

  " #3
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #3')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #3')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #3')

  " #4
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l0[{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #4')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #4')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '1+1foo1+2', 'failed at #1')
  call g:assert.equals(getline(2), '1+1bar1+2', 'failed at #1')
  call g:assert.equals(getline(3), '1+1baz1+2', 'failed at #1')

  %delete

  " #2
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l1"
  call g:assert.equals(getline(1), '2foo3', 'failed at #2')
  call g:assert.equals(getline(2), '2bar3', 'failed at #2')
  call g:assert.equals(getline(3), '2baz3', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '2foo3', 'failed at #3')
  call g:assert.equals(getline(2), '2bar3', 'failed at #3')
  call g:assert.equals(getline(3), '2baz3', 'failed at #3')

  %delete

  " #4
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #5')
  call g:assert.equals(getline(2), '"bar"', 'failed at #5')
  call g:assert.equals(getline(3), '"baz"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #6')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #6')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,     'failed at #6')

  %delete

  " #7
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #7')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #7')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,     'failed at #7')

  %delete

  " #8
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #8')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #8')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0,     'failed at #8')

  %delete

  " #9
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #9')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #9')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0,     'failed at #9')

  %delete

  " #10
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l0"
  call g:assert.equals(getline(1), '1+1foo1+2', 'failed at #10')
  call g:assert.equals(getline(2), '1+1bar1+2', 'failed at #10')
  call g:assert.equals(getline(3), '1+1baz1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal ggsr\<C-v>a\"a"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  execute "normal ggsr\<C-v>a\"1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'block', 'listexpr', 1)
  call setline('.', '"bar"')
  execute "normal ggsr\<C-v>a\"a"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  execute "normal ggsr\<C-v>a\"b"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal ggsr\<C-v>a\"0"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  execute "normal ggsr\<C-v>a\"1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    "foo"')
  " execute "normal ^sr\<C-v>2i\"a"
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"0"
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.blockwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"1"
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"1"
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #1')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #1')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #2')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #2')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #3')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #3')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #4')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #4')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #1
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #1')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #1')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  " #2
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #2')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #2')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #1
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #4')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #4')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #5')
  call g:assert.equals(getline(2),   'barbar',     'failed at #5')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #6')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #6')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #7')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #7')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #8')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #8')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #9')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #9')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #9')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #10
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #10')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #10')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #10')

  %delete

  " #11
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #11')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #11')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #12')
  call g:assert.equals(getline(2),   '',           'failed at #12')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #12')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #1
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #1')
  call g:assert.equals(getline(2),   '[b]',        'failed at #1')
  call g:assert.equals(getline(3),   '[c]',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #1
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #1')
  call g:assert.equals(getline(2),   '[]',         'failed at #1')
  call g:assert.equals(getline(3),   '[]',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #1
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #1')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #1')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #2')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #2')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #3')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #3')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #4')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #4')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #5')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #5')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #5')
endfunction
"}}}
function! s:suite.blockwise_x_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #2')
  call g:assert.equals(getline(2), '"bar"', 'failed at #2')
  call g:assert.equals(getline(3), '"baz"', 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #3')
  call g:assert.equals(getline(2), '"bar"', 'failed at #3')
  call g:assert.equals(getline(3), '"baz"', 'failed at #3')

  %delete

  " #4
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  %delete

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #5')
  call g:assert.equals(getline(2), '(bar)', 'failed at #5')
  call g:assert.equals(getline(3), '(baz)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #1
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(α)',          'failed at #1')
  call g:assert.equals(getline(2), '(β)',          'failed at #1')
  call g:assert.equals(getline(3), '(γ)',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #1')

  " #2
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(aα)',         'failed at #2')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #2')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #2')

  " #3
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(α)',          'failed at #3')
  call g:assert.equals(getline(2), '(β)',          'failed at #3')
  call g:assert.equals(getline(3), '(γ)',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #3')

  " #4
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(aα)',         'failed at #4')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #4')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #5
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'αaα',          'failed at #5')
  call g:assert.equals(getline(2), 'αbα',          'failed at #5')
  call g:assert.equals(getline(3), 'αcα',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #5')

  " #6
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'ααα',          'failed at #6')
  call g:assert.equals(getline(2), 'αβα',          'failed at #6')
  call g:assert.equals(getline(3), 'αγα',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #6')

  " #7
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #7')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #7')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #7')

  " #8
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'αaα',          'failed at #8')
  call g:assert.equals(getline(2), 'αbα',          'failed at #8')
  call g:assert.equals(getline(3), 'αcα',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #8')

  " #9
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'ααα',          'failed at #9')
  call g:assert.equals(getline(2), 'αβα',          'failed at #9')
  call g:assert.equals(getline(3), 'αγα',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #9')

  " #10
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #10')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #10')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #11')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #11')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #11')

  " #12
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #12')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #12')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #12')

  " #13
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #13')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #13')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #13')

  " #14
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #14')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #14')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #14')

  " #15
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #15')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #15')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #15')

  " #16
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #16')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #16')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #16')

  unlet g:operator#sandwich#recipes

  " #17
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(“)',          'failed at #17')
  call g:assert.equals(getline(2), '(“)',          'failed at #17')
  call g:assert.equals(getline(3), '(“)',          'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #17')

  " #18
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(a“)',         'failed at #18')
  call g:assert.equals(getline(2), '(b“)',         'failed at #18')
  call g:assert.equals(getline(3), '(c“)',         'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #18')

  " #19
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(“)',          'failed at #19')
  call g:assert.equals(getline(2), '(“)',          'failed at #19')
  call g:assert.equals(getline(3), '(“)',          'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #19')

  " #20
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(a“)',         'failed at #20')
  call g:assert.equals(getline(2), '(b“)',         'failed at #20')
  call g:assert.equals(getline(3), '(c“)',         'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #21
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“a“',          'failed at #21')
  call g:assert.equals(getline(2), '“b“',          'failed at #21')
  call g:assert.equals(getline(3), '“c“',          'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #21')

  " #22
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“““',          'failed at #22')
  call g:assert.equals(getline(2), '“““',          'failed at #22')
  call g:assert.equals(getline(3), '“““',          'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #22')

  " #23
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), '“a““',         'failed at #23')
  call g:assert.equals(getline(2), '“b““',         'failed at #23')
  call g:assert.equals(getline(3), '“c““',         'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #23')

  " #24
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“a“',          'failed at #24')
  call g:assert.equals(getline(2), '“b“',          'failed at #24')
  call g:assert.equals(getline(3), '“c“',          'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #24')

  " #25
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“““',          'failed at #25')
  call g:assert.equals(getline(2), '“““',          'failed at #25')
  call g:assert.equals(getline(3), '“““',          'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #25')

  " #26
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), '“a““',         'failed at #26')
  call g:assert.equals(getline(2), '“b““',         'failed at #26')
  call g:assert.equals(getline(3), '“c““',         'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #27
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #27')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #27')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #27')

  " #28
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #28')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #28')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #28')

  " #29
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #29')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #29')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #29')

  " #30
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #30')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #30')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #30')

  " #31
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #31')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #31')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #31')

  " #32
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #32')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #32')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #32')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #1')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #1')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #1')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #1')

  " #2
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #2')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #2')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #2')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #2')

  %delete

  """ inner_head
  " #3
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #3')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #3')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #3')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #3')

  " #4
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #4')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #4')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #4')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #4')

  %delete

  """ keep
  " #5
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #5')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #5')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #5')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #5')

  " #6
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #6')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #6')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #6')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #6')

  %delete

  """ inner_tail
  " #7
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #7')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #7')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #7')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #7')

  " #8
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #8')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #8')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #8')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #8')

  %delete

  """ head
  " #9
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #9')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #9')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #9')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #9')

  " #10
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #10')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #10')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #10')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #10')

  %delete

  """ tail
  " #11
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #11')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #11')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #11')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #11')

  " #12
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #12')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #12')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #12')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #12')

  %delete

  """"" recipe option
  " #13
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call setline('.', '[foo]')
  execute "normal ^\<C-v>4lsr1"
  call g:assert.equals(getline('.'), '(foo)',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #13')
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')
  call g:assert.equals(getline(2), '(bar)', 'failed at #2')
  call g:assert.equals(getline(3), '(baz)', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #3')
  call g:assert.equals(getline(2), '{bar}', 'failed at #3')
  call g:assert.equals(getline(3), '{baz}', 'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')


  """ off
  %delete
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #5')
  call g:assert.equals(getline(2), '{bar}', 'failed at #5')
  call g:assert.equals(getline(3), '{baz}', 'failed at #5')

  %delete

  " #6
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #6')
  call g:assert.equals(getline(2), '"bar"', 'failed at #6')
  call g:assert.equals(getline(3), '"baz"', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #7')
  call g:assert.equals(getline(2), '"bar"', 'failed at #7')
  call g:assert.equals(getline(3), '"baz"', 'failed at #7')

  %delete

  " #8
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #8')
  call g:assert.equals(getline(2), '(bar)', 'failed at #8')
  call g:assert.equals(getline(3), '(baz)', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #1')
  call g:assert.equals(getline(2), '"bar"', 'failed at #1')
  call g:assert.equals(getline(3), '"baz"', 'failed at #1')

  %delete

  " #2
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #2')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #2')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #3')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #3')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #3')

  %delete

  " #4
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  """ on
  %delete
  call operator#sandwich#set('replace', 'block', 'regex', 1)

  " #5
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #5')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #5')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #5')

  %delete

  " #6
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #6')
  call g:assert.equals(getline(2), '"bar"', 'failed at #6')
  call g:assert.equals(getline(3), '"baz"', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #7')
  call g:assert.equals(getline(2), '"bar"', 'failed at #7')
  call g:assert.equals(getline(3), '"baz"', 'failed at #7')

  %delete

  " #8
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #8')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #8')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  """ 1
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')
  call g:assert.equals(getline(2), '(bar)', 'failed at #1')
  call g:assert.equals(getline(3), '(baz)', 'failed at #1')

  %delete

  " #2
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #2')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #2')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #2')

  %delete

  " #3
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #3')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #3')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #3')

  %delete

  " #4
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #4')
  call g:assert.equals(getline(2), '("bar")', 'failed at #4')
  call g:assert.equals(getline(3), '("baz")', 'failed at #4')

  %delete

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #5')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #5')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #5')

  %delete

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)

  " #6
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #6')
  call g:assert.equals(getline(2), '(bar)', 'failed at #6')
  call g:assert.equals(getline(3), '(baz)', 'failed at #6')

  %delete

  " #7
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #7')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #7')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #7')

  %delete

  " #8
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #8')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #8')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #8')

  %delete

  " #9
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #9')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #9')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #9')

  %delete

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #10')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #10')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #10')

  %delete

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)

  " #11
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #11')
  call g:assert.equals(getline(2), '(bar)', 'failed at #11')
  call g:assert.equals(getline(3), '(baz)', 'failed at #11')

  %delete

  " #12
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #12')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #12')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #12')

  %delete

  " #13
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #13')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #13')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #13')

  %delete

  " #14
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #14')
  call g:assert.equals(getline(2), '("bar")', 'failed at #14')
  call g:assert.equals(getline(3), '("baz")', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}, {'buns': ['(', ')']}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #2')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #2')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #1
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #1')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #1')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #1')

  %delete

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #2')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #2')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #3
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #3')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #3')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #3')

  %delete

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #4')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #4')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '', 'failed at #1')
  call g:assert.equals(getline(2), '', 'failed at #1')
  call g:assert.equals(getline(3), '', 'failed at #1')

  " #2
  call operator#sandwich#set('replace', 'block', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '', 'failed at #2')
  call g:assert.equals(getline(2), '', 'failed at #2')
  call g:assert.equals(getline(3), '', 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #1')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #1')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #1')

  %delete

  " #2
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr1"
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #2')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #2')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #2')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'query_once', 1)

  " #3
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #3')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #3')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #3')

  %delete

  " #4
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr0[{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #4')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #4')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  %delete

  " #2
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr1"
  call g:assert.equals(getline(1), '2foo3', 'failed at #2')
  call g:assert.equals(getline(2), '2bar3', 'failed at #2')
  call g:assert.equals(getline(3), '2baz3', 'failed at #2')

  %delete

  """ 1
  " #3
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #3')

  %delete

  " #4
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #5')
  call g:assert.equals(getline(2), '"bar"', 'failed at #5')
  call g:assert.equals(getline(3), '"baz"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #6')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #6')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,     'failed at #6')

  %delete

  " #7
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #7')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #7')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,     'failed at #7')

  %delete

  " #8
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #8')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #8')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #8')
  call g:assert.equals(exists(s:object), 0,     'failed at #8')

  %delete

  " #9
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #9')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #9')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #9')
  call g:assert.equals(exists(s:object), 0,     'failed at #9')

  %delete

  " #10
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr0"
  call g:assert.equals(getline(1), '1+1foo1+2', 'failed at #10')
  call g:assert.equals(getline(2), '1+1bar1+2', 'failed at #10')
  call g:assert.equals(getline(3), '1+1baz1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal gg\<C-v>a\"sra"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', '"bar"')
  execute "normal gg\<C-v>a\"sr1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('replace', 'block', 'listexpr', 1)
  call setline('.', '"bar"')
  execute "normal gg\<C-v>a\"sra"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', '"bar"')
  execute "normal gg\<C-v>a\"srb"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', '"bar"')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal gg\<C-v>a\"sr0"
  call g:assert.equals(getline('.'), '"bar"', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', '"bar"')
  execute "normal gg\<C-v>a\"sr1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    "foo"')
  " execute "normal ^\<C-v>2i\"sra"
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"0"
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.blockwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"1"
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"1"
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #1
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sr$"
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #1')

  " #2
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sr$""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #2')

  " #3
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sr$"""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #3')
endfunction
"}}}

" When a assigned region is invalid
function! s:suite.invalid_region() abort  "{{{
  nmap sr' <Plug>(operator-sandwich-replace)i'

  " #1
  call setline('.', 'foo')
  normal 0lsr'"
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  nunmap sr'
endfunction
"}}}

" input_fallback
function! s:suite.input_fallback() abort "{{{
  let g:sandwich#recipes = [{'buns': ['a', 'a']}]
  let g:operator#sandwich#recipes = []

  let g:sandwich#input_fallback = 1
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob', 'failed at #1')

  let g:sandwich#input_fallback = 0
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'afooa', 'failed at #2')

  unlet! g:sandwich#input_fallback
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob', 'failed at #3')
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
