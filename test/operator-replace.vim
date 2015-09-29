scriptencoding utf-8

let s:suite = themis#suite('operator-sandwich: replace:')
let s:object = 'g:operator#sandwich#object'

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
  set virtualedit&
  silent! mapc!
  silent! ounmap ii
  silent! ounmap ssr
  silent! xunmap i{
  silent! xunmap a{
  call operator#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
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
  normal 0sr2i'`
  call g:assert.equals(getline('.'), '`foo`', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #6')

  " #7
  call setline('.', "'foo'")
  normal 0sr2i'``
  call g:assert.equals(getline('.'), '``foo``', 'failed at #7')

  " #8
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '``foo``', 'failed at #8')

  " #9
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #9')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #10
  call setline('.', "'foo'")
  normal 0sr2i'`
  call g:assert.equals(getline('.'), '`foo`', 'failed at #10')

  " #11
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #11')

  " #12
  call setline('.', "'foo'")
  normal 0sr2i'``
  call g:assert.equals(getline('.'), '`foo`', 'failed at #12')

  " #13
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #13')

  " #14
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #14')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #15
  call setline('.', "'foo'")
  normal 0sr2i'`
  call g:assert.equals(getline('.'), '"foo"', 'failed at #15')

  " #16
  call setline('.', "'foo'")
  normal 0sr2i'`h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #16')

  " #17
  call setline('.', "'foo'")
  normal 0sr2i'``
  call g:assert.equals(getline('.'), '"foo"', 'failed at #17')

  " #18
  call setline('.', "'foo'")
  normal 0sr2i'``h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #18')

  " #19
  call setline('.', "'foo'")
  normal 0sr2i'```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #19')
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

  " #20
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #20')

  " #21
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #21')

  " #22
  call setline('.', '(foo)')
  normal 0sra(<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #22')

  " #23
  call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #23')

  set filetype=vim

  " #24
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #24')

  " #25
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #25')

  " #26
  call setline('.', '(foo)')
  normal 0sra(<
  call g:assert.equals(getline('.'), '<foo<', 'failed at #26')

  " #27
  call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '<foo>', 'failed at #27')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \   {'buns': ['(', ')']},
        \ ]

  " #28
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #28')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['add']},
        \ ]

  " #29
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #29')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['delete']},
        \ ]

  " #30
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #30')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['replace']},
        \ ]

  " #31
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #31')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['operator']},
        \ ]

  " #32
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #32')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #33
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #33')
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

  " #34
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #34')

  " #35
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #35')

  " #36
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #36')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['{']},
        \ ]

  " #37
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #37')

  " #38
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #38')

  " #39
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #39')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['{']},
        \ ]

  " #40
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #40')

  " #41
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #41')

  " #42
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #42')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['{']},
        \ ]

  " #43
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #43')

  " #44
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #44')

  " #45
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #45')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['{']},
        \ ]

  " #46
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #46')

  " #47
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #47')

  " #48
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #48')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #49
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #49')

  " #50
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #50')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['{']},
        \ ]

  " #51
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #51')

  " #52
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #52')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['{']},
        \ ]

  " #53
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #53')

  " #54
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #54')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #55
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #55')

  " #56
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #56')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['{']},
        \ ]

  " #57
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #57')

  " #58
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #58')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['{']},
        \ ]

  " #59
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #59')

  " #60
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #60')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['{']},
        \ ]

  " #61
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #61')

  " #62
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #62')
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

  " #63
  call setline('.', '"foo"')
  normal 0sr2i"(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #63')

  " #64
  call setline('.', '"foo"')
  normal 0sr2i"[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #64')

  " #65
  call setline('.', '"foo"')
  normal 0sr2i"{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #65')

  " #66
  call setline('.', '(foo)')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #66')

  " #67
  call setline('.', '[foo]')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #67')

  " #68
  call setline('.', '{foo}')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #68')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #69
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #69')

  " #70
  call setline('.', '[foo]')
  normal 0sra[{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #70')

  " #71
  call setline('.', '{foo}')
  normal 0sra{<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #71')

  " #72
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
  " #77
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #77')

  " #78
  call setline('.', '+foo+')
  normal 0sr$*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #78')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #79
  call setline('.', '(foo)bar')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #79')

  " #80
  call setline('.', 'foo(bar)')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #80')

  " #81
  call setline('.', 'foo(bar)baz')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #81')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))'], 'input': ['(']}, {'buns': ['[', ']']}]

  " #82
  call setline('.', 'foo((bar))baz')
  normal 0srii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #82')

  " #83
  call setline('.', 'foo((bar))baz')
  normal 02lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #83')

  " #84
  call setline('.', 'foo((bar))baz')
  normal 03lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #84')

  " #85
  call setline('.', 'foo((bar))baz')
  normal 04lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #85')

  " #86
  call setline('.', 'foo((bar))baz')
  normal 05lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #86')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #86')

  " #87
  call setline('.', 'foo((bar))baz')
  normal 07lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #87')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #87')

  " #88
  call setline('.', 'foo((bar))baz')
  normal 08lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #88')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #88')

  " #89
  call setline('.', 'foo((bar))baz')
  normal 09lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #89')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #89')

  " #90
  call setline('.', 'foo((bar))baz')
  normal 010lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #90')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #90')

  " #91
  call setline('.', 'foo((bar))baz')
  normal 012lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #91')

  " #92
  call setline('.', 'foo[[bar]]baz')
  normal 03lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0],     'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #92')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #92')

  " #93
  call setline('.', 'foo[[bar]]baz')
  normal 09lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0],     'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #93')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #93')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #94
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsr13l[
  call g:assert.equals(getline(1),   '[foo',       'failed at #94')
  call g:assert.equals(getline(2),   'bar',        'failed at #94')
  call g:assert.equals(getline(3),   'baz]',       'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #94')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #95
  call setline('.', '(a)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[a]',        'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #95')

  %delete

  " #96
  call append(0, ['(', 'a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #96')
  call g:assert.equals(getline(2),   'a',          'failed at #96')
  call g:assert.equals(getline(3),   ']',          'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #96')

  %delete

  " #97
  call append(0, ['(a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[a',         'failed at #97')
  call g:assert.equals(getline(2),   ']',          'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #97')

  %delete

  " #98
  call append(0, ['(', 'a)'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #98')
  call g:assert.equals(getline(2),   'a]',         'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #98')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #99
  call setline('.', '()')
  normal 0sra([
  call g:assert.equals(getline('.'), '[]',         'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #99')

  " #100
  call setline('.', 'foo()bar')
  normal 03lsra([
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #100')

  %delete

  " #101
  call append(0, ['(', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #101')
  call g:assert.equals(getline(2),   ']',          'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #101')
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #102
  call setline('.', '([foo])')
  normal 02sr%[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #102')

  " #103
  call setline('.', '[({foo})]')
  normal 03sr%{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #103')

  " #104
  call setline('.', '[foo ]bar')
  normal 0sr6l(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #104')

  " #105
  call setline('.', '[foo bar]')
  normal 0sr9l(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #105')

  " #106
  call setline('.', '{[foo bar]}')
  normal 02sr11l[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #106')

  " #107
  call setline('.', 'foo{[bar]}baz')
  normal 03l2sr7l[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #107')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #107')

  " #108
  call setline('.', 'foo({[bar]})baz')
  normal 03l3sr9l{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #108')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #108')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #109
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #109')

  %delete

  " #110
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #110')

  %delete

  " #111
  call setline('.', '(foo)')
  normal 0sr5la
  call g:assert.equals(getline(1),   'aa',         'failed at #111')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #111')
  call g:assert.equals(getline(3),   'aa',         'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #111')

  %delete

  " #112
  call setline('.', '(foo)')
  normal 0sr5lb
  call g:assert.equals(getline(1),   'bb',         'failed at #112')
  call g:assert.equals(getline(2),   'bbb',        'failed at #112')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #112')
  call g:assert.equals(getline(4),   'bbb',        'failed at #112')
  call g:assert.equals(getline(5),   'bb',         'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #112')

  %delete

  " #113
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15lb
  call g:assert.equals(getline(1),   'bb',         'failed at #113')
  call g:assert.equals(getline(2),   'bbb',        'failed at #113')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #113')
  call g:assert.equals(getline(4),   'bbb',        'failed at #113')
  call g:assert.equals(getline(5),   'bb',         'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #113')

  %delete

  " #114
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21la
  call g:assert.equals(getline(1),   'aa',         'failed at #114')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #114')
  call g:assert.equals(getline(3),   'aa',         'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #114')

  %delete

  " #115
  call append(0, ['aa', 'aaaaa', 'aaafooaaa', 'aaaaa', 'aa'])
  normal gg2sr27lbb
  call g:assert.equals(getline(1),   'bb',         'failed at #115')
  call g:assert.equals(getline(2),   'bbb',        'failed at #115')
  call g:assert.equals(getline(3),   'bbbb',       'failed at #115')
  call g:assert.equals(getline(4),   'bbb',        'failed at #115')
  call g:assert.equals(getline(5),   'bbfoobb',    'failed at #115')
  call g:assert.equals(getline(6),   'bbb',        'failed at #115')
  call g:assert.equals(getline(7),   'bbbb',       'failed at #115')
  call g:assert.equals(getline(8),   'bbb',        'failed at #115')
  call g:assert.equals(getline(9),   'bb',         'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #115')

  %delete

  " #116
  call append(0, ['bb', 'bbb', 'bbbb', 'bbb', 'bbfoobb', 'bbb', 'bbbb', 'bbb', 'bb'])
  normal gg2sr39laa
  call g:assert.equals(getline(1),   'aa',         'failed at #116')
  call g:assert.equals(getline(2),   'aaaaa',      'failed at #116')
  call g:assert.equals(getline(3),   'aaafooaaa',  'failed at #116')
  call g:assert.equals(getline(4),   'aaaaa',      'failed at #116')
  call g:assert.equals(getline(5),   'aa',         'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #116')

  %delete
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 8)<CR>

  " #117
  call setline('.', ['foo(bar)baz'])
  normal 0sriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #117')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #117')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #117')

  %delete

  " #118
  call setline('.', ['foo(bar)baz'])
  normal 02lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #118')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #118')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #118')

  %delete

  " #119
  call setline('.', ['foo(bar)baz'])
  normal 03lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #119')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #119')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #119')

  %delete

  " #120
  call setline('.', ['foo(bar)baz'])
  normal 04lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #120')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #120')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #120')

  %delete

  " #121
  call setline('.', ['foo(bar)baz'])
  normal 06lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #121')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #121')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #121')

  %delete

  " #122
  call setline('.', ['foo(bar)baz'])
  normal 07lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #122')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #122')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #122')

  %delete

  " #123
  call setline('.', ['foo(bar)baz'])
  normal 08lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #123')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #123')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #123')

  %delete

  " #124
  call setline('.', ['foo(bar)baz'])
  normal 010lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #124')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #124')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #124')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>

  " #125
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #125')

  %delete

  " #126
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #126')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #126')

  %delete

  " #127
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #127')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #127')

  %delete

  " #128
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #128')

  %delete

  " #129
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #129')

  %delete

  " #130
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #130')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #130')

  %delete

  " #131
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #131')

  %delete

  " #132
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #132')

  %delete

  " #133
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #133')

  %delete

  " #134
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #134')

  %delete

  " #135
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #135')

  %delete

  " #136
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #136')

  %delete

  " #137
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #137')

  %delete

  " #138
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #138')

  %delete

  " #139
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #139')
  call g:assert.equals(getline(2),   'bbb',        'failed at #139')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #139')
  call g:assert.equals(getline(4),   'bbb',        'failed at #139')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #139')

  %delete

  " #140
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #140')
  call g:assert.equals(getline(2),   'bbb',        'failed at #140')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #140')
  call g:assert.equals(getline(4),   'bbb',        'failed at #140')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #141')
  call g:assert.equals(getline(2),   'bbb',        'failed at #141')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #141')
  call g:assert.equals(getline(4),   'bbb',        'failed at #141')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #141')

  %delete

  " #142
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #142')
  call g:assert.equals(getline(2),   'bbb',        'failed at #142')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #142')
  call g:assert.equals(getline(4),   'bbb',        'failed at #142')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #142')

  %delete

  " #143
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #143')
  call g:assert.equals(getline(2),   'bbb',        'failed at #143')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #143')
  call g:assert.equals(getline(4),   'bbb',        'failed at #143')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #144')
  call g:assert.equals(getline(2),   'bbb',        'failed at #144')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #144')
  call g:assert.equals(getline(4),   'bbb',        'failed at #144')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #144')

  %delete

  " #145
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #145')
  call g:assert.equals(getline(2),   'bbb',        'failed at #145')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #145')
  call g:assert.equals(getline(4),   'bbb',        'failed at #145')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #145')

  %delete

  " #146
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #146')
  call g:assert.equals(getline(2),   'bbb',        'failed at #146')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #146')
  call g:assert.equals(getline(4),   'bbb',        'failed at #146')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #146')

  %delete

  " #147
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #147')
  call g:assert.equals(getline(2),   'bbb',        'failed at #147')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #147')
  call g:assert.equals(getline(4),   'bbb',        'failed at #147')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #147')

  %delete

  " #148
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #148')
  call g:assert.equals(getline(2),   'bbb',        'failed at #148')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #148')
  call g:assert.equals(getline(4),   'bbb',        'failed at #148')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 3, 6, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #148')

  %delete

  " #149
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj7lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #149')
  call g:assert.equals(getline(2),   'bbb',        'failed at #149')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #149')
  call g:assert.equals(getline(4),   'bbb',        'failed at #149')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #149')

  %delete

  " #150
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #150')
  call g:assert.equals(getline(2),   'bbb',        'failed at #150')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #150')
  call g:assert.equals(getline(4),   'bbb',        'failed at #150')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #150')

  %delete

  " #151
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #151')
  call g:assert.equals(getline(2),   'bbb',        'failed at #151')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #151')
  call g:assert.equals(getline(4),   'bbb',        'failed at #151')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #151')

  %delete

  " #152
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #152')
  call g:assert.equals(getline(2),   'bbb',        'failed at #152')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #152')
  call g:assert.equals(getline(4),   'bbb',        'failed at #152')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #152')

  %delete

  " #153
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #153')
  call g:assert.equals(getline(2),   'bbb',        'failed at #153')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #153')
  call g:assert.equals(getline(4),   'bbb',        'failed at #153')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #154')
  call g:assert.equals(getline(2),   'bbb',        'failed at #154')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #154')
  call g:assert.equals(getline(4),   'bbb',        'failed at #154')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 5, 5, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #154')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 5, 2)<CR>

  " #155
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #155')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #155')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #155')

  %delete

  " #156
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #156')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #156')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #156')

  %delete

  " #157
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #157')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #157')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #157')

  %delete

  " #158
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #158')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #158')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #158')

  %delete

  " #159
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #159')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #159')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #159')

  %delete

  " #160
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #160')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #160')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #160')

  %delete

  " #161
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggj2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #161')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #161')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #161')

  %delete

  " #162
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #162')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #162')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #162')

  %delete

  " #163
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #163')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #163')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #163')

  %delete

  " #164
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #164')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #164')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #164')

  %delete

  " #165
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #165')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #165')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #165')

  %delete

  " #166
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j5lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #166')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #166')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #166')

  %delete

  " #167
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j6lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #167')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #167')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #167')

  %delete

  " #168
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #168')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #168')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #168')

  %delete

  " #169
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #169')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #169')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #169')

  %delete

  " #170
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #170')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #170')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #170')

  %delete

  " #171
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #171')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #171')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #171')

  %delete

  " #172
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #172')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #172')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #172')

  %delete

  " #173
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #173')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #173')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #173')

  %delete

  " #174
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #174')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #174')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #174')

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

  " #175
  call setline('.', '{[(foo)]}')
  normal 02lsr5l"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #175')

  " #176
  call setline('.', '{[(foo)]}')
  normal 0lsr7l"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #176')

  " #177
  call setline('.', '{[(foo)]}')
  normal 0sr9l"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #177')

  " #178
  call setline('.', '<title>foo</title>')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #178')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #179
  call setline('.', 'aαa')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(α)',        'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #179')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #179')

  " #180
  call setline('.', 'aaαa')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #180')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #180')

  " #181
  call setline('.', 'βαβ')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(α)',        'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #181')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #181')

  " #182
  call setline('.', 'βaαβ')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #182')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #183
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'αaα',       'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #183')

  " #184
  call setline('.', 'aαa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'ααα',       'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #184')

  " #185
  call setline('.', 'aaαa')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #185')

  " #186
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'αaα',        'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #186')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #186')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #186')

  " #187
  call setline('.', 'βαβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'ααα',        'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #187')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #187')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #187')

  " #188
  call setline('.', 'βaαβ')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #188')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #188')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #189
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #189')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #189')

  " #190
  call setline('.', 'aαa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #190')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #190')

  " #191
  call setline('.', 'aaαa')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #191')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #191')

  " #192
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #192')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #192')

  " #193
  call setline('.', 'βαβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #193')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #193')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #193')

  " #194
  call setline('.', 'βaαβ')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #194')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #194')

  unlet g:operator#sandwich#recipes

  " #195
  call setline('.', 'a“a')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(“)',        'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #195')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #195')

  " #196
  call setline('.', 'aa“a')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #196')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #196')

  " #197
  call setline('.', 'β“β')
  normal 0sr3l(
  call g:assert.equals(getline('.'), '(“)',        'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #197')

  " #198
  call setline('.', 'βa“β')
  normal 0sr4l(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #198')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #199
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“a“',        'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #199')

  " #200
  call setline('.', 'a“a')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“““',        'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #200')

  " #201
  call setline('.', 'aa“a')
  normal 0sr4la
  call g:assert.equals(getline('.'), '“a““',       'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #201')

  " #202
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“a“',        'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #202')

  " #203
  call setline('.', 'β“β')
  normal 0sr3la
  call g:assert.equals(getline('.'), '“““',        'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #203')

  " #204
  call setline('.', 'βa“β')
  normal 0sr4la
  call g:assert.equals(getline('.'), '“a““',       'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #204')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #205
  call setline('.', 'aaa')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #205')

  " #206
  call setline('.', 'a“a')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #206')

  " #207
  call setline('.', 'aa“a')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #207')

  " #208
  call setline('.', 'βaβ')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #208')

  " #209
  call setline('.', 'β“β')
  normal 0sr3la
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #209')

  " #210
  call setline('.', 'βa“β')
  normal 0sr4la
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #210')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #211
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #211')

  " #212
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #212')

  """ keep
  " #213
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #213')

  " #214
  normal lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #214')

  """ inner_tail
  " #215
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #215')

  " #216
  normal hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #216')

  """ head
  " #217
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #217')

  " #218
  normal 3lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #218')

  """ tail
  " #219
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #219')

  " #220
  normal 3hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #220')

  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #221
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #221')

  " #222
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #222')

  """ off
  " #223
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #223')

  " #224
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #224')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #225
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #225')

  " #226
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #226')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #227
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #227')

  " #228
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #228')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ 1
  " #229
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #229')

  " #230
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #230')

  " #231
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #231')

  " #232
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #232')

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
  " #233
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #233')

  " #234
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #234')

  " #235
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #235')

  " #236
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #236')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #237
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #237')

  " #238
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #238')

  " #239
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #239')

  " #240
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #240')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #241
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #241')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #242
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #242')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])

  " #243
  call setline('.', '[(foo)]')
  normal 0ffsra("
  call g:assert.equals(getline('.'), '[]', 'failed at #243')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #244
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #244')
  call g:assert.equals(getline(2),   'foo',        'failed at #244')
  call g:assert.equals(getline(3),   ']',          'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #244')

  %delete

  " #245
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #245')
  call g:assert.equals(getline(2),   'foo',        'failed at #245')
  call g:assert.equals(getline(3),   ']',          'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #246')
  call g:assert.equals(getline(2),   'foo',        'failed at #246')
  call g:assert.equals(getline(3),   'aa]',        'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #247')
  call g:assert.equals(getline(2),   'foo',        'failed at #247')
  call g:assert.equals(getline(3),   ']',          'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #247')

  %delete

  " #248
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #248')
  call g:assert.equals(getline(2),   'foo',        'failed at #248')
  call g:assert.equals(getline(3),   'aa]',        'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #248')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #249
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #249')
  call g:assert.equals(getline(2),   'foo',        'failed at #249')
  call g:assert.equals(getline(3),   ']',          'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #249')

  %delete

  " #250
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #250')
  call g:assert.equals(getline(2),   'foo',        'failed at #250')
  call g:assert.equals(getline(3),   ']',          'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #250')

  %delete

  " #251
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #251')
  call g:assert.equals(getline(2),   'foo',        'failed at #251')
  call g:assert.equals(getline(3),   ']',          'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #251')

  %delete

  " #252
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #252')
  call g:assert.equals(getline(2),   '[',          'failed at #252')
  call g:assert.equals(getline(3),   'bb',         'failed at #252')
  call g:assert.equals(getline(4),   '',           'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #252')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #253
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #253')

  %delete

  """ on
  " #254
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #254')

  call operator#sandwich#set('replace', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #255
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #255')

  """ 1
  " #256
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3', 'failed at #256')

  " #257
  call setline('.', '"foo"')
  normal 0sra"b
  call g:assert.equals(getline('.'), '"foo"', 'failed at #257')
  call g:assert.equals(exists(s:object), 0,   'failed at #257')

  " #258
  call setline('.', '"foo"')
  normal 0sra"c
  call g:assert.equals(getline('.'), '"foo"', 'failed at #258')
  call g:assert.equals(exists(s:object), 0,   'failed at #258')

  " #259
  call setline('.', '"''foo''"')
  normal 02sra"ab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #259')
  call g:assert.equals(exists(s:object), 0,       'failed at #259')

  " #260
  call setline('.', '"''foo''"')
  normal 02sra"ac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #260')
  call g:assert.equals(exists(s:object), 0,       'failed at #260')

  " #261
  call setline('.', '"''foo''"')
  normal 02sra"ba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #261')
  call g:assert.equals(exists(s:object), 0,       'failed at #261')

  " #262
  call setline('.', '"''foo''"')
  normal 02sra"ca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #262')
  call g:assert.equals(exists(s:object), 0,       'failed at #262')

  " #263
  call setline('.', '"foo"')
  normal 0sra"d
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #263')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'char', 'expr', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #264
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #264')
  call g:assert.equals(getline(2),   '[',          'failed at #264')
  call g:assert.equals(getline(3),   'foo',        'failed at #264')
  call g:assert.equals(getline(4),   ']',          'failed at #264')
  call g:assert.equals(getline(5),   '}',          'failed at #264')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #264')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #264')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #264')
  call g:assert.equals(&l:autoindent,  0,          'failed at #264')
  call g:assert.equals(&l:smartindent, 0,          'failed at #264')
  call g:assert.equals(&l:cindent,     0,          'failed at #264')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #264')

  %delete

  " #265
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #265')
  call g:assert.equals(getline(2),   '    [',      'failed at #265')
  call g:assert.equals(getline(3),   '    foo',    'failed at #265')
  call g:assert.equals(getline(4),   '    ]',      'failed at #265')
  call g:assert.equals(getline(5),   '    }',      'failed at #265')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #265')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #265')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #265')
  call g:assert.equals(&l:autoindent,  1,          'failed at #265')
  call g:assert.equals(&l:smartindent, 0,          'failed at #265')
  call g:assert.equals(&l:cindent,     0,          'failed at #265')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #265')

  %delete

  " #266
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #266')
  call g:assert.equals(getline(2),   '        [',   'failed at #266')
  call g:assert.equals(getline(3),   '        foo', 'failed at #266')
  call g:assert.equals(getline(4),   '    ]',       'failed at #266')
  call g:assert.equals(getline(5),   '}',           'failed at #266')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #266')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #266')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #266')
  call g:assert.equals(&l:autoindent,  1,           'failed at #266')
  call g:assert.equals(&l:smartindent, 1,           'failed at #266')
  call g:assert.equals(&l:cindent,     0,           'failed at #266')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #266')

  %delete

  " #267
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #267')
  call g:assert.equals(getline(2),   '    [',       'failed at #267')
  call g:assert.equals(getline(3),   '        foo', 'failed at #267')
  call g:assert.equals(getline(4),   '    ]',       'failed at #267')
  call g:assert.equals(getline(5),   '    }',       'failed at #267')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #267')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #267')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #267')
  call g:assert.equals(&l:autoindent,  1,           'failed at #267')
  call g:assert.equals(&l:smartindent, 1,           'failed at #267')
  call g:assert.equals(&l:cindent,     1,           'failed at #267')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #267')

  %delete

  " #268
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',           'failed at #268')
  call g:assert.equals(getline(2),   '            [',       'failed at #268')
  call g:assert.equals(getline(3),   '                foo', 'failed at #268')
  call g:assert.equals(getline(4),   '        ]',           'failed at #268')
  call g:assert.equals(getline(5),   '                }',   'failed at #268')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #268')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #268')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #268')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #268')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #268')
  call g:assert.equals(&l:cindent,     1,                   'failed at #268')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #268')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #269
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #269')
  call g:assert.equals(getline(2),   '[',          'failed at #269')
  call g:assert.equals(getline(3),   'foo',        'failed at #269')
  call g:assert.equals(getline(4),   ']',          'failed at #269')
  call g:assert.equals(getline(5),   '}',          'failed at #269')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #269')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #269')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #269')
  call g:assert.equals(&l:autoindent,  0,          'failed at #269')
  call g:assert.equals(&l:smartindent, 0,          'failed at #269')
  call g:assert.equals(&l:cindent,     0,          'failed at #269')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #269')

  %delete

  " #270
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #270')
  call g:assert.equals(getline(2),   '[',          'failed at #270')
  call g:assert.equals(getline(3),   'foo',        'failed at #270')
  call g:assert.equals(getline(4),   ']',          'failed at #270')
  call g:assert.equals(getline(5),   '}',          'failed at #270')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #270')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #270')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #270')
  call g:assert.equals(&l:autoindent,  1,          'failed at #270')
  call g:assert.equals(&l:smartindent, 0,          'failed at #270')
  call g:assert.equals(&l:cindent,     0,          'failed at #270')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #270')

  %delete

  " #271
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #271')
  call g:assert.equals(getline(2),   '[',          'failed at #271')
  call g:assert.equals(getline(3),   'foo',        'failed at #271')
  call g:assert.equals(getline(4),   ']',          'failed at #271')
  call g:assert.equals(getline(5),   '}',          'failed at #271')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #271')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #271')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #271')
  call g:assert.equals(&l:autoindent,  1,          'failed at #271')
  call g:assert.equals(&l:smartindent, 1,          'failed at #271')
  call g:assert.equals(&l:cindent,     0,          'failed at #271')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #271')

  %delete

  " #272
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #272')
  call g:assert.equals(getline(2),   '[',          'failed at #272')
  call g:assert.equals(getline(3),   'foo',        'failed at #272')
  call g:assert.equals(getline(4),   ']',          'failed at #272')
  call g:assert.equals(getline(5),   '}',          'failed at #272')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #272')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #272')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #272')
  call g:assert.equals(&l:autoindent,  1,          'failed at #272')
  call g:assert.equals(&l:smartindent, 1,          'failed at #272')
  call g:assert.equals(&l:cindent,     1,          'failed at #272')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #272')

  %delete

  " #273
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #273')
  call g:assert.equals(getline(2),   '[',              'failed at #273')
  call g:assert.equals(getline(3),   'foo',            'failed at #273')
  call g:assert.equals(getline(4),   ']',              'failed at #273')
  call g:assert.equals(getline(5),   '}',              'failed at #273')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #273')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #273')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #273')
  call g:assert.equals(&l:autoindent,  1,              'failed at #273')
  call g:assert.equals(&l:smartindent, 1,              'failed at #273')
  call g:assert.equals(&l:cindent,     1,              'failed at #273')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #273')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #274
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #274')
  call g:assert.equals(getline(2),   '    [',      'failed at #274')
  call g:assert.equals(getline(3),   '    foo',    'failed at #274')
  call g:assert.equals(getline(4),   '    ]',      'failed at #274')
  call g:assert.equals(getline(5),   '    }',      'failed at #274')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #274')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #274')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #274')
  call g:assert.equals(&l:autoindent,  0,          'failed at #274')
  call g:assert.equals(&l:smartindent, 0,          'failed at #274')
  call g:assert.equals(&l:cindent,     0,          'failed at #274')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #274')

  %delete

  " #275
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #275')
  call g:assert.equals(getline(2),   '    [',      'failed at #275')
  call g:assert.equals(getline(3),   '    foo',    'failed at #275')
  call g:assert.equals(getline(4),   '    ]',      'failed at #275')
  call g:assert.equals(getline(5),   '    }',      'failed at #275')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #275')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #275')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #275')
  call g:assert.equals(&l:autoindent,  1,          'failed at #275')
  call g:assert.equals(&l:smartindent, 0,          'failed at #275')
  call g:assert.equals(&l:cindent,     0,          'failed at #275')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #275')

  %delete

  " #276
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #276')
  call g:assert.equals(getline(2),   '    [',      'failed at #276')
  call g:assert.equals(getline(3),   '    foo',    'failed at #276')
  call g:assert.equals(getline(4),   '    ]',      'failed at #276')
  call g:assert.equals(getline(5),   '    }',      'failed at #276')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #276')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #276')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #276')
  call g:assert.equals(&l:autoindent,  1,          'failed at #276')
  call g:assert.equals(&l:smartindent, 1,          'failed at #276')
  call g:assert.equals(&l:cindent,     0,          'failed at #276')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #276')

  %delete

  " #277
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #277')
  call g:assert.equals(getline(2),   '    [',      'failed at #277')
  call g:assert.equals(getline(3),   '    foo',    'failed at #277')
  call g:assert.equals(getline(4),   '    ]',      'failed at #277')
  call g:assert.equals(getline(5),   '    }',      'failed at #277')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #277')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #277')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #277')
  call g:assert.equals(&l:autoindent,  1,          'failed at #277')
  call g:assert.equals(&l:smartindent, 1,          'failed at #277')
  call g:assert.equals(&l:cindent,     1,          'failed at #277')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #277')

  %delete

  " #278
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #278')
  call g:assert.equals(getline(2),   '    [',          'failed at #278')
  call g:assert.equals(getline(3),   '    foo',        'failed at #278')
  call g:assert.equals(getline(4),   '    ]',          'failed at #278')
  call g:assert.equals(getline(5),   '    }',          'failed at #278')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #278')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #278')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #278')
  call g:assert.equals(&l:autoindent,  1,              'failed at #278')
  call g:assert.equals(&l:smartindent, 1,              'failed at #278')
  call g:assert.equals(&l:cindent,     1,              'failed at #278')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #278')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #279
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #279')
  call g:assert.equals(getline(2),   '        [',   'failed at #279')
  call g:assert.equals(getline(3),   '        foo', 'failed at #279')
  call g:assert.equals(getline(4),   '    ]',       'failed at #279')
  call g:assert.equals(getline(5),   '}',           'failed at #279')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #279')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #279')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #279')
  call g:assert.equals(&l:autoindent,  0,           'failed at #279')
  call g:assert.equals(&l:smartindent, 0,           'failed at #279')
  call g:assert.equals(&l:cindent,     0,           'failed at #279')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #279')

  %delete

  " #280
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #280')
  call g:assert.equals(getline(2),   '        [',   'failed at #280')
  call g:assert.equals(getline(3),   '        foo', 'failed at #280')
  call g:assert.equals(getline(4),   '    ]',       'failed at #280')
  call g:assert.equals(getline(5),   '}',           'failed at #280')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #280')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #280')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #280')
  call g:assert.equals(&l:autoindent,  1,           'failed at #280')
  call g:assert.equals(&l:smartindent, 0,           'failed at #280')
  call g:assert.equals(&l:cindent,     0,           'failed at #280')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #280')

  %delete

  " #281
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #281')
  call g:assert.equals(getline(2),   '        [',   'failed at #281')
  call g:assert.equals(getline(3),   '        foo', 'failed at #281')
  call g:assert.equals(getline(4),   '    ]',       'failed at #281')
  call g:assert.equals(getline(5),   '}',           'failed at #281')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #281')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #281')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #281')
  call g:assert.equals(&l:autoindent,  1,           'failed at #281')
  call g:assert.equals(&l:smartindent, 1,           'failed at #281')
  call g:assert.equals(&l:cindent,     0,           'failed at #281')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #281')

  %delete

  " #282
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #282')
  call g:assert.equals(getline(2),   '        [',   'failed at #282')
  call g:assert.equals(getline(3),   '        foo', 'failed at #282')
  call g:assert.equals(getline(4),   '    ]',       'failed at #282')
  call g:assert.equals(getline(5),   '}',           'failed at #282')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #282')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #282')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #282')
  call g:assert.equals(&l:autoindent,  1,           'failed at #282')
  call g:assert.equals(&l:smartindent, 1,           'failed at #282')
  call g:assert.equals(&l:cindent,     1,           'failed at #282')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #282')

  %delete

  " #283
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #283')
  call g:assert.equals(getline(2),   '        [',      'failed at #283')
  call g:assert.equals(getline(3),   '        foo',    'failed at #283')
  call g:assert.equals(getline(4),   '    ]',          'failed at #283')
  call g:assert.equals(getline(5),   '}',              'failed at #283')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #283')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #283')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #283')
  call g:assert.equals(&l:autoindent,  1,              'failed at #283')
  call g:assert.equals(&l:smartindent, 1,              'failed at #283')
  call g:assert.equals(&l:cindent,     1,              'failed at #283')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #283')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #284
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #284')
  call g:assert.equals(getline(2),   '    [',       'failed at #284')
  call g:assert.equals(getline(3),   '        foo', 'failed at #284')
  call g:assert.equals(getline(4),   '    ]',       'failed at #284')
  call g:assert.equals(getline(5),   '    }',       'failed at #284')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #284')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #284')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #284')
  call g:assert.equals(&l:autoindent,  0,           'failed at #284')
  call g:assert.equals(&l:smartindent, 0,           'failed at #284')
  call g:assert.equals(&l:cindent,     0,           'failed at #284')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #284')

  %delete

  " #285
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #285')
  call g:assert.equals(getline(2),   '    [',       'failed at #285')
  call g:assert.equals(getline(3),   '        foo', 'failed at #285')
  call g:assert.equals(getline(4),   '    ]',       'failed at #285')
  call g:assert.equals(getline(5),   '    }',       'failed at #285')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #285')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #285')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #285')
  call g:assert.equals(&l:autoindent,  1,           'failed at #285')
  call g:assert.equals(&l:smartindent, 0,           'failed at #285')
  call g:assert.equals(&l:cindent,     0,           'failed at #285')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #285')

  %delete

  " #286
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #286')
  call g:assert.equals(getline(2),   '    [',       'failed at #286')
  call g:assert.equals(getline(3),   '        foo', 'failed at #286')
  call g:assert.equals(getline(4),   '    ]',       'failed at #286')
  call g:assert.equals(getline(5),   '    }',       'failed at #286')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #286')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #286')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #286')
  call g:assert.equals(&l:autoindent,  1,           'failed at #286')
  call g:assert.equals(&l:smartindent, 1,           'failed at #286')
  call g:assert.equals(&l:cindent,     0,           'failed at #286')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #286')

  %delete

  " #287
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #287')
  call g:assert.equals(getline(2),   '    [',       'failed at #287')
  call g:assert.equals(getline(3),   '        foo', 'failed at #287')
  call g:assert.equals(getline(4),   '    ]',       'failed at #287')
  call g:assert.equals(getline(5),   '    }',       'failed at #287')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #287')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #287')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #287')
  call g:assert.equals(&l:autoindent,  1,           'failed at #287')
  call g:assert.equals(&l:smartindent, 1,           'failed at #287')
  call g:assert.equals(&l:cindent,     1,           'failed at #287')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #287')

  %delete

  " #288
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',              'failed at #288')
  call g:assert.equals(getline(2),   '    [',          'failed at #288')
  call g:assert.equals(getline(3),   '        foo',    'failed at #288')
  call g:assert.equals(getline(4),   '    ]',          'failed at #288')
  call g:assert.equals(getline(5),   '    }',          'failed at #288')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #288')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #288')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #288')
  call g:assert.equals(&l:autoindent,  1,              'failed at #288')
  call g:assert.equals(&l:smartindent, 1,              'failed at #288')
  call g:assert.equals(&l:cindent,     1,              'failed at #288')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #288')
endfunction
"}}}
function! s:suite.charwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #289
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #289')
  call g:assert.equals(getline(2),   'foo',        'failed at #289')
  call g:assert.equals(getline(3),   '    }',      'failed at #289')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #289')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #289')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #289')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #289')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #290
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #290')
  call g:assert.equals(getline(2),   '    foo',    'failed at #290')
  call g:assert.equals(getline(3),   '    }',      'failed at #290')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #290')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #290')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #290')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #290')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #291
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #291')
  call g:assert.equals(getline(2),   'foo',        'failed at #291')
  call g:assert.equals(getline(3),   '    }',      'failed at #291')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #291')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #291')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #291')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #291')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #292
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #292')
  call g:assert.equals(getline(2),   'foo',        'failed at #292')
  call g:assert.equals(getline(3),   '    }',      'failed at #292')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #292')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #292')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #292')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #292')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #292')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #293
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',     'failed at #293')
  call g:assert.equals(getline(2),   '    foo',       'failed at #293')
  call g:assert.equals(getline(3),   '            }', 'failed at #293')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #293')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #293')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #293')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #293')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #293')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #294
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #294')
  call g:assert.equals(getline(2),   'foo',        'failed at #294')
  call g:assert.equals(getline(3),   '    }',      'failed at #294')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #294')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #294')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #294')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #294')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #294')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #295
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #295')

  " #296
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #296')

  " #297
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #297')

  " #298
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #298')

  " #299
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #299')

  " #300
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #300')

  " #301
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #301')

  " #302
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #302')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #303
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #303')

  " #304
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #304')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #305
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #305')

  " #306
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #306')

  " #307
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #307')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #307')

  " #308
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #308')
  call g:assert.equals(getline(2),   'bar',        'failed at #308')
  call g:assert.equals(getline(3),   'baz]',       'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #308')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #309
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #309')

  %delete

  " #310
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #310')
  call g:assert.equals(getline(2),   'a',          'failed at #310')
  call g:assert.equals(getline(3),   ']',          'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #310')

  %delete

  " #311
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #311')
  call g:assert.equals(getline(2),   ']',          'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #312')
  call g:assert.equals(getline(2),   'a]',         'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #312')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #313
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #313')

  " #314
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #314')

  %delete

  " #315
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #315')
  call g:assert.equals(getline(2),   ']',          'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #315')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #316
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #316')

  " #317
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #317')

  " #318
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #318')

  " #319
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #319')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #319')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #319')

  " #320
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #320')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #320')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #320')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #321
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #321')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #321')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #321')

  %delete

  " #322
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #322')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #322')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #322')

  %delete

  " #323
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #323')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #323')
  call g:assert.equals(getline(3),   'aa',         'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #323')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #323')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #323')

  %delete

  " #324
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #324')
  call g:assert.equals(getline(2),   'bbb',        'failed at #324')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #324')
  call g:assert.equals(getline(4),   'bbb',        'failed at #324')
  call g:assert.equals(getline(5),   'bb',         'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #324')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #324')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #324')
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

  " #325
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #325')

  " #326
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #326')

  " #327
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #327')

  " #328
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #328')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #329
  call setline('.', 'aαa')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(α)',        'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #329')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #329')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #329')

  " #330
  call setline('.', 'aaαa')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #330')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #330')

  " #331
  call setline('.', 'βαβ')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(α)',        'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #331')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #331')

  " #332
  call setline('.', 'βaαβ')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(aα)',       'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #332')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #332')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #333
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'αaα',       'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #333')

  " #334
  call setline('.', 'aαa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'ααα',       'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #334')

  " #335
  call setline('.', 'aaαa')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #335')

  " #336
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'αaα',        'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #336')

  " #337
  call setline('.', 'βαβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'ααα',        'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #337')

  " #338
  call setline('.', 'βaαβ')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'αaαα',       'failed at #338')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #338')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #338')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #339
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #339')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #339')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #339')

  " #340
  call setline('.', 'aαa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #340')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #340')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #340')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #340')

  " #341
  call setline('.', 'aaαa')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #341')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #341')

  " #342
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aαaaα',      'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #342')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #342')

  " #343
  call setline('.', 'βαβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'aααaα',      'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #343')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #343')

  " #344
  call setline('.', 'βaαβ')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'aαaαaα',     'failed at #344')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #344')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #344')

  unlet g:operator#sandwich#recipes

  " #345
  call setline('.', 'a“a')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(“)',        'failed at #345')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #345')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #345')

  " #346
  call setline('.', 'aa“a')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #346')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #346')

  " #347
  call setline('.', 'β“β')
  normal 0v2lsr(
  call g:assert.equals(getline('.'), '(“)',        'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #347')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #347')

  " #348
  call setline('.', 'βa“β')
  normal 0v3lsr(
  call g:assert.equals(getline('.'), '(a“)',       'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #348')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #348')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #349
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“a“',        'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #349')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #349')

  " #350
  call setline('.', 'a“a')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“““',        'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #350')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #350')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #350')

  " #351
  call setline('.', 'aa“a')
  normal 0v3lsra
  call g:assert.equals(getline('.'), '“a““',       'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #351')

  " #352
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“a“',        'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #352')

  " #353
  call setline('.', 'β“β')
  normal 0v2lsra
  call g:assert.equals(getline('.'), '“““',        'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #353')

  " #354
  call setline('.', 'βa“β')
  normal 0v3lsra
  call g:assert.equals(getline('.'), '“a““',       'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #354')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #355
  call setline('.', 'aaa')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #355')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #355')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #355')

  " #356
  call setline('.', 'a“a')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #356')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #356')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #356')

  " #357
  call setline('.', 'aa“a')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #357')

  " #358
  call setline('.', 'βaβ')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a“aa“',      'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #358')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #358')

  " #359
  call setline('.', 'β“β')
  normal 0v2lsra
  call g:assert.equals(getline('.'), 'a““a“',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #359')

  " #360
  call setline('.', 'βa“β')
  normal 0v3lsra
  call g:assert.equals(getline('.'), 'a“a“a“',     'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #360')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #361
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #361')

  " #362
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #362')

  """ keep
  " #363
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #363')

  " #364
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #364')

  """ inner_tail
  " #365
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #365')

  " #366
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #366')

  """ head
  " #367
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #367')

  " #368
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #368')

  """ tail
  " #369
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #369')

  " #370
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #370')

  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #371
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #371')

  " #372
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #372')

  """ off
  " #373
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #373')

  " #374
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #374')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #375
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #375')

  " #376
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #376')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #377
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #377')

  " #378
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #378')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ 1
  " #379
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #379')

  " #380
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #380')

  " #381
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #381')

  " #382
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #382')

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
  " #383
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #383')

  " #384
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #384')

  " #385
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #385')

  " #386
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #386')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #387
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #387')

  " #388
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #388')

  " #389
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #389')

  " #390
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #390')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #391
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #391')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #392
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #392')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])

  " #393
  call setline('.', '[(foo)]')
  normal 0ffva(sr"
  call g:assert.equals(getline('.'), '[]', 'failed at #393')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #394
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #394')
  call g:assert.equals(getline(2),   'foo',        'failed at #394')
  call g:assert.equals(getline(3),   ']',          'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #394')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #394')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #394')

  %delete

  " #395
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #395')
  call g:assert.equals(getline(2),   'foo',        'failed at #395')
  call g:assert.equals(getline(3),   ']',          'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #395')

  %delete

  " #396
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #396')
  call g:assert.equals(getline(2),   'foo',        'failed at #396')
  call g:assert.equals(getline(3),   'aa]',        'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #396')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #396')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #396')

  %delete

  " #397
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #397')
  call g:assert.equals(getline(2),   'foo',        'failed at #397')
  call g:assert.equals(getline(3),   ']',          'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #397')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #397')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #397')

  %delete

  " #398
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #398')
  call g:assert.equals(getline(2),   'foo',        'failed at #398')
  call g:assert.equals(getline(3),   'aa]',        'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #398')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #399
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #399')
  call g:assert.equals(getline(2),   'foo',        'failed at #399')
  call g:assert.equals(getline(3),   ']',          'failed at #399')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #399')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #399')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #399')

  %delete

  " #400
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #400')
  call g:assert.equals(getline(2),   'foo',        'failed at #400')
  call g:assert.equals(getline(3),   ']',          'failed at #400')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #400')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #400')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #400')

  %delete

  " #401
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #401')
  call g:assert.equals(getline(2),   'foo',        'failed at #401')
  call g:assert.equals(getline(3),   ']',          'failed at #401')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #401')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #401')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #401')

  %delete

  " #402
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #402')
  call g:assert.equals(getline(2),   '[',          'failed at #402')
  call g:assert.equals(getline(3),   'bb',         'failed at #402')
  call g:assert.equals(getline(4),   '',           'failed at #402')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #402')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #403
  call setline('.', '"""foo"""')
  normal 0v$3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #403')

  %delete

  """ on
  " #404
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 0v$3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #404')

  call operator#sandwich#set('replace', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #405
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #405')

  """ 1
  " #406
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '2foo3', 'failed at #406')

  " #407
  call setline('.', '"foo"')
  normal 0va"srb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #407')
  call g:assert.equals(exists(s:object), 0,   'failed at #407')

  " #408
  call setline('.', '"foo"')
  normal 0va"src
  call g:assert.equals(getline('.'), '"foo"', 'failed at #408')
  call g:assert.equals(exists(s:object), 0,   'failed at #408')

  " #409
  call setline('.', '"''foo''"')
  normal 0va"2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #409')
  call g:assert.equals(exists(s:object), 0,       'failed at #409')

  " #410
  call setline('.', '"''foo''"')
  normal 0va"2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #410')
  call g:assert.equals(exists(s:object), 0,       'failed at #410')

  " #411
  call setline('.', '"''foo''"')
  normal 0va"2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #411')
  call g:assert.equals(exists(s:object), 0,       'failed at #411')

  " #412
  call setline('.', '"''foo''"')
  normal 0va"2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #412')
  call g:assert.equals(exists(s:object), 0,       'failed at #412')

  " #413
  call setline('.', '"foo"')
  normal 0va"srd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #413')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'char', 'expr', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #414
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #414')
  call g:assert.equals(getline(2),   '[',          'failed at #414')
  call g:assert.equals(getline(3),   'foo',        'failed at #414')
  call g:assert.equals(getline(4),   ']',          'failed at #414')
  call g:assert.equals(getline(5),   '}',          'failed at #414')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #414')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #414')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #414')
  call g:assert.equals(&l:autoindent,  0,          'failed at #414')
  call g:assert.equals(&l:smartindent, 0,          'failed at #414')
  call g:assert.equals(&l:cindent,     0,          'failed at #414')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #414')

  %delete

  " #415
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #415')
  call g:assert.equals(getline(2),   '    [',      'failed at #415')
  call g:assert.equals(getline(3),   '    foo',    'failed at #415')
  call g:assert.equals(getline(4),   '    ]',      'failed at #415')
  call g:assert.equals(getline(5),   '    }',      'failed at #415')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #415')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #415')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #415')
  call g:assert.equals(&l:autoindent,  1,          'failed at #415')
  call g:assert.equals(&l:smartindent, 0,          'failed at #415')
  call g:assert.equals(&l:cindent,     0,          'failed at #415')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #415')

  %delete

  " #416
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #416')
  call g:assert.equals(getline(2),   '        [',   'failed at #416')
  call g:assert.equals(getline(3),   '        foo', 'failed at #416')
  call g:assert.equals(getline(4),   '    ]',       'failed at #416')
  call g:assert.equals(getline(5),   '}',           'failed at #416')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #416')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #416')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #416')
  call g:assert.equals(&l:autoindent,  1,           'failed at #416')
  call g:assert.equals(&l:smartindent, 1,           'failed at #416')
  call g:assert.equals(&l:cindent,     0,           'failed at #416')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #416')

  %delete

  " #417
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #417')
  call g:assert.equals(getline(2),   '    [',       'failed at #417')
  call g:assert.equals(getline(3),   '        foo', 'failed at #417')
  call g:assert.equals(getline(4),   '    ]',       'failed at #417')
  call g:assert.equals(getline(5),   '    }',       'failed at #417')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #417')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #417')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #417')
  call g:assert.equals(&l:autoindent,  1,           'failed at #417')
  call g:assert.equals(&l:smartindent, 1,           'failed at #417')
  call g:assert.equals(&l:cindent,     1,           'failed at #417')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #417')

  %delete

  " #418
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',           'failed at #418')
  call g:assert.equals(getline(2),   '            [',       'failed at #418')
  call g:assert.equals(getline(3),   '                foo', 'failed at #418')
  call g:assert.equals(getline(4),   '        ]',           'failed at #418')
  call g:assert.equals(getline(5),   '                }',   'failed at #418')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #418')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #418')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #418')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #418')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #418')
  call g:assert.equals(&l:cindent,     1,                   'failed at #418')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #418')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #419
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #419')
  call g:assert.equals(getline(2),   '[',          'failed at #419')
  call g:assert.equals(getline(3),   'foo',        'failed at #419')
  call g:assert.equals(getline(4),   ']',          'failed at #419')
  call g:assert.equals(getline(5),   '}',          'failed at #419')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #419')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #419')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #419')
  call g:assert.equals(&l:autoindent,  0,          'failed at #419')
  call g:assert.equals(&l:smartindent, 0,          'failed at #419')
  call g:assert.equals(&l:cindent,     0,          'failed at #419')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #419')

  %delete

  " #420
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #420')
  call g:assert.equals(getline(2),   '[',          'failed at #420')
  call g:assert.equals(getline(3),   'foo',        'failed at #420')
  call g:assert.equals(getline(4),   ']',          'failed at #420')
  call g:assert.equals(getline(5),   '}',          'failed at #420')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #420')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #420')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #420')
  call g:assert.equals(&l:autoindent,  1,          'failed at #420')
  call g:assert.equals(&l:smartindent, 0,          'failed at #420')
  call g:assert.equals(&l:cindent,     0,          'failed at #420')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #420')

  %delete

  " #421
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #421')
  call g:assert.equals(getline(2),   '[',          'failed at #421')
  call g:assert.equals(getline(3),   'foo',        'failed at #421')
  call g:assert.equals(getline(4),   ']',          'failed at #421')
  call g:assert.equals(getline(5),   '}',          'failed at #421')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #421')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #421')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #421')
  call g:assert.equals(&l:autoindent,  1,          'failed at #421')
  call g:assert.equals(&l:smartindent, 1,          'failed at #421')
  call g:assert.equals(&l:cindent,     0,          'failed at #421')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #421')

  %delete

  " #422
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #422')
  call g:assert.equals(getline(2),   '[',          'failed at #422')
  call g:assert.equals(getline(3),   'foo',        'failed at #422')
  call g:assert.equals(getline(4),   ']',          'failed at #422')
  call g:assert.equals(getline(5),   '}',          'failed at #422')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #422')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #422')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #422')
  call g:assert.equals(&l:autoindent,  1,          'failed at #422')
  call g:assert.equals(&l:smartindent, 1,          'failed at #422')
  call g:assert.equals(&l:cindent,     1,          'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #422')

  %delete

  " #423
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #423')
  call g:assert.equals(getline(2),   '[',              'failed at #423')
  call g:assert.equals(getline(3),   'foo',            'failed at #423')
  call g:assert.equals(getline(4),   ']',              'failed at #423')
  call g:assert.equals(getline(5),   '}',              'failed at #423')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #423')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #423')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #423')
  call g:assert.equals(&l:autoindent,  1,              'failed at #423')
  call g:assert.equals(&l:smartindent, 1,              'failed at #423')
  call g:assert.equals(&l:cindent,     1,              'failed at #423')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #423')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #424
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #424')
  call g:assert.equals(getline(2),   '    [',      'failed at #424')
  call g:assert.equals(getline(3),   '    foo',    'failed at #424')
  call g:assert.equals(getline(4),   '    ]',      'failed at #424')
  call g:assert.equals(getline(5),   '    }',      'failed at #424')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #424')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #424')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #424')
  call g:assert.equals(&l:autoindent,  0,          'failed at #424')
  call g:assert.equals(&l:smartindent, 0,          'failed at #424')
  call g:assert.equals(&l:cindent,     0,          'failed at #424')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #424')

  %delete

  " #425
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #425')
  call g:assert.equals(getline(2),   '    [',      'failed at #425')
  call g:assert.equals(getline(3),   '    foo',    'failed at #425')
  call g:assert.equals(getline(4),   '    ]',      'failed at #425')
  call g:assert.equals(getline(5),   '    }',      'failed at #425')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #425')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #425')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #425')
  call g:assert.equals(&l:autoindent,  1,          'failed at #425')
  call g:assert.equals(&l:smartindent, 0,          'failed at #425')
  call g:assert.equals(&l:cindent,     0,          'failed at #425')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #425')

  %delete

  " #426
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #426')
  call g:assert.equals(getline(2),   '    [',      'failed at #426')
  call g:assert.equals(getline(3),   '    foo',    'failed at #426')
  call g:assert.equals(getline(4),   '    ]',      'failed at #426')
  call g:assert.equals(getline(5),   '    }',      'failed at #426')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #426')
  call g:assert.equals(&l:autoindent,  1,          'failed at #426')
  call g:assert.equals(&l:smartindent, 1,          'failed at #426')
  call g:assert.equals(&l:cindent,     0,          'failed at #426')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #426')

  %delete

  " #427
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #427')
  call g:assert.equals(getline(2),   '    [',      'failed at #427')
  call g:assert.equals(getline(3),   '    foo',    'failed at #427')
  call g:assert.equals(getline(4),   '    ]',      'failed at #427')
  call g:assert.equals(getline(5),   '    }',      'failed at #427')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #427')
  call g:assert.equals(&l:autoindent,  1,          'failed at #427')
  call g:assert.equals(&l:smartindent, 1,          'failed at #427')
  call g:assert.equals(&l:cindent,     1,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #428')
  call g:assert.equals(getline(2),   '    [',          'failed at #428')
  call g:assert.equals(getline(3),   '    foo',        'failed at #428')
  call g:assert.equals(getline(4),   '    ]',          'failed at #428')
  call g:assert.equals(getline(5),   '    }',          'failed at #428')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #428')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #428')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #428')
  call g:assert.equals(&l:autoindent,  1,              'failed at #428')
  call g:assert.equals(&l:smartindent, 1,              'failed at #428')
  call g:assert.equals(&l:cindent,     1,              'failed at #428')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #428')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #429
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #429')
  call g:assert.equals(getline(2),   '        [',   'failed at #429')
  call g:assert.equals(getline(3),   '        foo', 'failed at #429')
  call g:assert.equals(getline(4),   '    ]',       'failed at #429')
  call g:assert.equals(getline(5),   '}',           'failed at #429')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #429')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #429')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #429')
  call g:assert.equals(&l:autoindent,  0,           'failed at #429')
  call g:assert.equals(&l:smartindent, 0,           'failed at #429')
  call g:assert.equals(&l:cindent,     0,           'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #429')

  %delete

  " #430
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #430')
  call g:assert.equals(getline(2),   '        [',   'failed at #430')
  call g:assert.equals(getline(3),   '        foo', 'failed at #430')
  call g:assert.equals(getline(4),   '    ]',       'failed at #430')
  call g:assert.equals(getline(5),   '}',           'failed at #430')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #430')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #430')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #430')
  call g:assert.equals(&l:autoindent,  1,           'failed at #430')
  call g:assert.equals(&l:smartindent, 0,           'failed at #430')
  call g:assert.equals(&l:cindent,     0,           'failed at #430')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #430')

  %delete

  " #431
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #431')
  call g:assert.equals(getline(2),   '        [',   'failed at #431')
  call g:assert.equals(getline(3),   '        foo', 'failed at #431')
  call g:assert.equals(getline(4),   '    ]',       'failed at #431')
  call g:assert.equals(getline(5),   '}',           'failed at #431')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #431')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #431')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #431')
  call g:assert.equals(&l:autoindent,  1,           'failed at #431')
  call g:assert.equals(&l:smartindent, 1,           'failed at #431')
  call g:assert.equals(&l:cindent,     0,           'failed at #431')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #431')

  %delete

  " #432
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #432')
  call g:assert.equals(getline(2),   '        [',   'failed at #432')
  call g:assert.equals(getline(3),   '        foo', 'failed at #432')
  call g:assert.equals(getline(4),   '    ]',       'failed at #432')
  call g:assert.equals(getline(5),   '}',           'failed at #432')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #432')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #432')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #432')
  call g:assert.equals(&l:autoindent,  1,           'failed at #432')
  call g:assert.equals(&l:smartindent, 1,           'failed at #432')
  call g:assert.equals(&l:cindent,     1,           'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #432')

  %delete

  " #433
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #433')
  call g:assert.equals(getline(2),   '        [',      'failed at #433')
  call g:assert.equals(getline(3),   '        foo',    'failed at #433')
  call g:assert.equals(getline(4),   '    ]',          'failed at #433')
  call g:assert.equals(getline(5),   '}',              'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #433')
  call g:assert.equals(&l:autoindent,  1,              'failed at #433')
  call g:assert.equals(&l:smartindent, 1,              'failed at #433')
  call g:assert.equals(&l:cindent,     1,              'failed at #433')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #433')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #434
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #434')
  call g:assert.equals(getline(2),   '    [',       'failed at #434')
  call g:assert.equals(getline(3),   '        foo', 'failed at #434')
  call g:assert.equals(getline(4),   '    ]',       'failed at #434')
  call g:assert.equals(getline(5),   '    }',       'failed at #434')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #434')
  call g:assert.equals(&l:autoindent,  0,           'failed at #434')
  call g:assert.equals(&l:smartindent, 0,           'failed at #434')
  call g:assert.equals(&l:cindent,     0,           'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #434')

  %delete

  " #435
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #435')
  call g:assert.equals(getline(2),   '    [',       'failed at #435')
  call g:assert.equals(getline(3),   '        foo', 'failed at #435')
  call g:assert.equals(getline(4),   '    ]',       'failed at #435')
  call g:assert.equals(getline(5),   '    }',       'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #435')
  call g:assert.equals(&l:autoindent,  1,           'failed at #435')
  call g:assert.equals(&l:smartindent, 0,           'failed at #435')
  call g:assert.equals(&l:cindent,     0,           'failed at #435')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #435')

  %delete

  " #436
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '        foo', 'failed at #436')
  call g:assert.equals(getline(4),   '    ]',       'failed at #436')
  call g:assert.equals(getline(5),   '    }',       'failed at #436')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #436')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #436')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #436')
  call g:assert.equals(&l:autoindent,  1,           'failed at #436')
  call g:assert.equals(&l:smartindent, 1,           'failed at #436')
  call g:assert.equals(&l:cindent,     0,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #437')
  call g:assert.equals(getline(2),   '    [',       'failed at #437')
  call g:assert.equals(getline(3),   '        foo', 'failed at #437')
  call g:assert.equals(getline(4),   '    ]',       'failed at #437')
  call g:assert.equals(getline(5),   '    }',       'failed at #437')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #437')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #437')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #437')
  call g:assert.equals(&l:autoindent,  1,           'failed at #437')
  call g:assert.equals(&l:smartindent, 1,           'failed at #437')
  call g:assert.equals(&l:cindent,     1,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',              'failed at #438')
  call g:assert.equals(getline(2),   '    [',          'failed at #438')
  call g:assert.equals(getline(3),   '        foo',    'failed at #438')
  call g:assert.equals(getline(4),   '    ]',          'failed at #438')
  call g:assert.equals(getline(5),   '    }',          'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #438')
  call g:assert.equals(&l:autoindent,  1,              'failed at #438')
  call g:assert.equals(&l:smartindent, 1,              'failed at #438')
  call g:assert.equals(&l:cindent,     1,              'failed at #438')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #438')
endfunction
"}}}
function! s:suite.charwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #439
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #439')
  call g:assert.equals(getline(2),   'foo',        'failed at #439')
  call g:assert.equals(getline(3),   '    }',      'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #439')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #439')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #439')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #440
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #440')
  call g:assert.equals(getline(2),   '    foo',    'failed at #440')
  call g:assert.equals(getline(3),   '    }',      'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #440')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #440')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #440')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #441
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #441')
  call g:assert.equals(getline(2),   'foo',        'failed at #441')
  call g:assert.equals(getline(3),   '    }',      'failed at #441')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #441')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #441')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #441')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #441')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #441')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #442
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #442')
  call g:assert.equals(getline(2),   'foo',        'failed at #442')
  call g:assert.equals(getline(3),   '    }',      'failed at #442')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #442')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #442')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #442')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #442')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #442')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #443
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',     'failed at #443')
  call g:assert.equals(getline(2),   '    foo',       'failed at #443')
  call g:assert.equals(getline(3),   '            }', 'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #443')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #443')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #443')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #444
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #444')
  call g:assert.equals(getline(2),   'foo',        'failed at #444')
  call g:assert.equals(getline(3),   '    }',      'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #444')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #444')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #444')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #445
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #445')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #445')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #445')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #445')

  " #446
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #446')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #446')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #446')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #446')

  " #447
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #447')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #447')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #447')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #447')

  " #448
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #448')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #448')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #448')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #448')

  %delete

  " #449
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #449')
  call g:assert.equals(getline(2),   'foo',        'failed at #449')
  call g:assert.equals(getline(3),   ']',          'failed at #449')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #449')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #449')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #449')

  " #450
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #450')
  call g:assert.equals(getline(2),   'foo',        'failed at #450')
  call g:assert.equals(getline(3),   '}',          'failed at #450')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #450')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #450')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #450')

  " #451
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #451')
  call g:assert.equals(getline(2),   'foo',        'failed at #451')
  call g:assert.equals(getline(3),   '>',          'failed at #451')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #451')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #451')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #451')

  " #452
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #452')
  call g:assert.equals(getline(2),   'foo',        'failed at #452')
  call g:assert.equals(getline(3),   ')',          'failed at #452')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #452')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #452')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #452')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #453
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #453')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #453')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #453')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #453')

  " #454
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #454')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #454')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #454')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #454')

  %delete

  " #453
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #453')
  call g:assert.equals(getline(2),   'foo',        'failed at #453')
  call g:assert.equals(getline(3),   'b',          'failed at #453')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #453')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #453')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #453')

  %delete

  " #454
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #454')
  call g:assert.equals(getline(2),   'foo',        'failed at #454')
  call g:assert.equals(getline(3),   '*',          'failed at #454')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #454')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #454')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #454')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #455
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #455')
  call g:assert.equals(getline(2),   'foo',        'failed at #455')
  call g:assert.equals(getline(3),   'bar',        'failed at #455')
  call g:assert.equals(getline(4),   'baz',        'failed at #455')
  call g:assert.equals(getline(5),   ']',          'failed at #455')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #455')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #455')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #455')

  %delete

  " #456
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #456')
  call g:assert.equals(getline(2),   '[',          'failed at #456')
  call g:assert.equals(getline(3),   'bar',        'failed at #456')
  call g:assert.equals(getline(4),   ']',          'failed at #456')
  call g:assert.equals(getline(5),   'baz',        'failed at #456')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #456')

  %delete

  " #457
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #457')
  call g:assert.equals(getline(2),   'bar',        'failed at #457')
  call g:assert.equals(getline(3),   'baz]',       'failed at #457')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #457')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #457')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #458
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #458')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #458')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #458')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #458')

  %delete

  " #459
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #459')
  call g:assert.equals(getline(2),   ']',          'failed at #459')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #459')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #460
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #460')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #460')

  " #461
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #461')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #461')

  %delete

  " #462
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #462')
  call g:assert.equals(getline(2),   '(',          'failed at #462')
  call g:assert.equals(getline(3),   '{',          'failed at #462')
  call g:assert.equals(getline(4),   '[',          'failed at #462')
  call g:assert.equals(getline(5),   'bar',        'failed at #462')
  call g:assert.equals(getline(6),   ']',          'failed at #462')
  call g:assert.equals(getline(7),   '}',          'failed at #462')
  call g:assert.equals(getline(8),   ')',          'failed at #462')
  call g:assert.equals(getline(9),   'baz',        'failed at #462')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #462')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #463
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #463')

  %delete

  " #464
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #464')

  %delete

  " #465
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #465')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #465')
  call g:assert.equals(getline(3),   'aa',         'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #465')

  %delete

  " #466
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #466')
  call g:assert.equals(getline(2),   'bbb',        'failed at #466')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #466')
  call g:assert.equals(getline(4),   'bbb',        'failed at #466')
  call g:assert.equals(getline(5),   'bb',         'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #466')

  %delete

  " #467
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #467')
  call g:assert.equals(getline(2),   '(',          'failed at #467')
  call g:assert.equals(getline(3),   'foo',        'failed at #467')
  call g:assert.equals(getline(4),   ')',          'failed at #467')
  call g:assert.equals(getline(5),   ')',          'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #467')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #467')

  %delete

  " #468
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #468')
  call g:assert.equals(getline(2),   '(',          'failed at #468')
  call g:assert.equals(getline(3),   'foo',        'failed at #468')
  call g:assert.equals(getline(4),   ')',          'failed at #468')
  call g:assert.equals(getline(5),   ')',          'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #468')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #468')

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

  " #469
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #469')

  " #470
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #470')

  " #471
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #471')

  " #472
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #472')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #473
  call append(0, ['a', 'α', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #473')
  call g:assert.equals(getline(2), 'α', 'failed at #473')
  call g:assert.equals(getline(3), ')', 'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #473')

  " #474
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #474')
  call g:assert.equals(getline(2), 'aα', 'failed at #474')
  call g:assert.equals(getline(3), ')',  'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #474')

  " #475
  call append(0, ['β', 'α', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #475')
  call g:assert.equals(getline(2), 'α', 'failed at #475')
  call g:assert.equals(getline(3), ')', 'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #475')

  " #476
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #476')
  call g:assert.equals(getline(2), 'aα', 'failed at #476')
  call g:assert.equals(getline(3), ')',  'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #476')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #476')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #477
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #477')
  call g:assert.equals(getline(2), 'a', 'failed at #477')
  call g:assert.equals(getline(3), 'α', 'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #477')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #477')

  " #478
  call append(0, ['a', 'α', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #478')
  call g:assert.equals(getline(2), 'α', 'failed at #478')
  call g:assert.equals(getline(3), 'α', 'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #478')

  " #479
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α',  'failed at #479')
  call g:assert.equals(getline(2), 'aα', 'failed at #479')
  call g:assert.equals(getline(3), 'α',  'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #479')

  " #480
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #480')
  call g:assert.equals(getline(2), 'a', 'failed at #480')
  call g:assert.equals(getline(3), 'α', 'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #480')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #480')

  " #481
  call append(0, ['β', 'α', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α', 'failed at #481')
  call g:assert.equals(getline(2), 'α', 'failed at #481')
  call g:assert.equals(getline(3), 'α', 'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #481')

  " #482
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'α',  'failed at #482')
  call g:assert.equals(getline(2), 'aα', 'failed at #482')
  call g:assert.equals(getline(3), 'α',  'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #482')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #483
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #483')
  call g:assert.equals(getline(2), 'a',  'failed at #483')
  call g:assert.equals(getline(3), 'aα', 'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #483')

  " #484
  call append(0, ['a', 'α', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #484')
  call g:assert.equals(getline(2), 'α',  'failed at #484')
  call g:assert.equals(getline(3), 'aα', 'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #484')

  " #485
  call append(0, ['a', 'aα', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #485')
  call g:assert.equals(getline(2), 'aα', 'failed at #485')
  call g:assert.equals(getline(3), 'aα', 'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #485')

  " #486
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #486')
  call g:assert.equals(getline(2), 'a',  'failed at #486')
  call g:assert.equals(getline(3), 'aα', 'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #486')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #486')

  " #487
  call append(0, ['β', 'α', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #487')
  call g:assert.equals(getline(2), 'α',  'failed at #487')
  call g:assert.equals(getline(3), 'aα', 'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #487')

  " #488
  call append(0, ['β', 'aα', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'aα', 'failed at #488')
  call g:assert.equals(getline(2), 'aα', 'failed at #488')
  call g:assert.equals(getline(3), 'aα', 'failed at #488')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #488')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #488')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #488')

  unlet g:operator#sandwich#recipes

  " #489
  call append(0, ['a', '“', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #489')
  call g:assert.equals(getline(2), '“', 'failed at #489')
  call g:assert.equals(getline(3), ')', 'failed at #489')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #489')

  " #490
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #490')
  call g:assert.equals(getline(2), 'a“', 'failed at #490')
  call g:assert.equals(getline(3), ')',  'failed at #490')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #490')

  " #491
  call append(0, ['β', '“', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(', 'failed at #491')
  call g:assert.equals(getline(2), '“', 'failed at #491')
  call g:assert.equals(getline(3), ')', 'failed at #491')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #491')

  " #492
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2j(
  call g:assert.equals(getline(1), '(',  'failed at #492')
  call g:assert.equals(getline(2), 'a“', 'failed at #492')
  call g:assert.equals(getline(3), ')',  'failed at #492')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #492')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #493
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #493')
  call g:assert.equals(getline(2), 'a', 'failed at #493')
  call g:assert.equals(getline(3), '“', 'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #493')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #493')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #493')

  " #494
  call append(0, ['a', '“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #494')
  call g:assert.equals(getline(2), '“', 'failed at #494')
  call g:assert.equals(getline(3), '“', 'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #494')

  " #495
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“',  'failed at #495')
  call g:assert.equals(getline(2), 'a“', 'failed at #495')
  call g:assert.equals(getline(3), '“',  'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #495')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #495')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #495')

  " #496
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #496')
  call g:assert.equals(getline(2), 'a', 'failed at #496')
  call g:assert.equals(getline(3), '“', 'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #496')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #496')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #496')

  " #497
  call append(0, ['β', '“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“', 'failed at #497')
  call g:assert.equals(getline(2), '“', 'failed at #497')
  call g:assert.equals(getline(3), '“', 'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #497')

  " #498
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), '“',  'failed at #498')
  call g:assert.equals(getline(2), 'a“', 'failed at #498')
  call g:assert.equals(getline(3), '“',  'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #498')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #499
  call append(0, ['a', 'a', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #499')
  call g:assert.equals(getline(2), 'a',  'failed at #499')
  call g:assert.equals(getline(3), 'a“', 'failed at #499')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #499')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #499')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #499')

  " #500
  call append(0, ['a', '“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #500')
  call g:assert.equals(getline(2), '“',  'failed at #500')
  call g:assert.equals(getline(3), 'a“', 'failed at #500')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #500')

  " #501
  call append(0, ['a', 'a“', 'a'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #501')
  call g:assert.equals(getline(2), 'a“', 'failed at #501')
  call g:assert.equals(getline(3), 'a“', 'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #501')

  " #502
  call append(0, ['β', 'a', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #502')
  call g:assert.equals(getline(2), 'a',  'failed at #502')
  call g:assert.equals(getline(3), 'a“', 'failed at #502')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #502')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #502')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #502')

  " #503
  call append(0, ['β', '“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #503')
  call g:assert.equals(getline(2), '“',  'failed at #503')
  call g:assert.equals(getline(3), 'a“', 'failed at #503')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #503')

  " #504
  call append(0, ['β', 'a“', 'β'])
  normal ggsr2ja
  call g:assert.equals(getline(1), 'a“', 'failed at #504')
  call g:assert.equals(getline(2), 'a“', 'failed at #504')
  call g:assert.equals(getline(3), 'a“', 'failed at #504')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #504')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #505
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #505')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #505')

  " #506
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #506')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #506')

  """ keep
  " #507
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #507')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #507')

  " #508
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #508')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #508')

  """ inner_tail
  " #509
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #509')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #509')

  " #510
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #510')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #510')

  """ head
  " #511
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #511')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #511')

  " #512
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #512')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #512')

  """ tail
  " #513
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #513')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #513')

  " #514
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #514')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #514')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
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
  " #515
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #515')

  " #516
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #516')

  """ off
  " #517
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #517')

  " #518
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #518')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #519
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #519')

  " #520
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #520')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #521
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #521')

  " #522
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #522')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #523
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #523')

  " #524
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #524')

  " #525
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #525')

  " #526
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #526')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #527
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #527')

  " #528
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #528')

  " #529
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #529')

  " #530
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #530')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #531
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #531')

  " #532
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #532')

  " #533
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #533')

  " #534
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #534')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #535
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #535')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #536
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #536')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])

  " #537
  call append(0, ['[', '(foo)', ']'])
  normal ggjsrVl"
  call g:assert.equals(getline(1), '[', 'failed at #537')
  call g:assert.equals(getline(2), '',  'failed at #537')
  call g:assert.equals(getline(3), ']', 'failed at #537')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #538
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #538')
  call g:assert.equals(getline(2),   'foo',        'failed at #538')
  call g:assert.equals(getline(3),   ']',          'failed at #538')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #538')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #538')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #538')

  %delete

  " #539
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #539')
  call g:assert.equals(getline(2),   'foo',        'failed at #539')
  call g:assert.equals(getline(3),   '  ]',        'failed at #539')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #539')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #539')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #539')

  %delete

  " #540
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #540')
  call g:assert.equals(getline(2),   'foo',        'failed at #540')
  call g:assert.equals(getline(3),   'aa]',        'failed at #540')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #540')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #540')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #540')

  %delete

  " #541
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #541')
  call g:assert.equals(getline(2),   'foo',        'failed at #541')
  call g:assert.equals(getline(3),   ']',          'failed at #541')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #541')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #541')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #541')

  %delete

  " #542
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #542')
  call g:assert.equals(getline(2),   'foo',        'failed at #542')
  call g:assert.equals(getline(3),   'aa]',        'failed at #542')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #542')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #542')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #542')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #543
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #543')
  call g:assert.equals(getline(2),   'foo',        'failed at #543')
  call g:assert.equals(getline(3),   ']',          'failed at #543')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #543')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #543')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #543')

  %delete

  " #544
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #544')
  call g:assert.equals(getline(2),   'foo',        'failed at #544')
  call g:assert.equals(getline(3),   ']',          'failed at #544')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #544')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #544')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #544')

  %delete

  " #545
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #545')
  call g:assert.equals(getline(2),   'foo',        'failed at #545')
  call g:assert.equals(getline(3),   ']',          'failed at #545')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #545')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #545')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #545')

  %delete

  " #546
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #546')
  call g:assert.equals(getline(2),   '[',          'failed at #546')
  call g:assert.equals(getline(3),   'bb',         'failed at #546')
  call g:assert.equals(getline(4),   '',           'failed at #546')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #546')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #546')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #546')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #547
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #547')

  %delete

  """ on
  " #548
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #548')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #549
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #549')

  """ 1
  " #550
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3', 'failed at #550')

  " #551
  call setline('.', '"foo"')
  normal 0srVlb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #551')
  call g:assert.equals(exists(s:object), 0,   'failed at #551')

  " #552
  call setline('.', '"foo"')
  normal 0srVlc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #552')
  call g:assert.equals(exists(s:object), 0, 'failed at #552')

  " #553
  call setline('.', '"''foo''"')
  normal 02srVlab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #553')
  call g:assert.equals(exists(s:object), 0, 'failed at #553')

  " #554
  call setline('.', '"''foo''"')
  normal 02srVlac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #554')
  call g:assert.equals(exists(s:object), 0, 'failed at #554')

  " #555
  call setline('.', '"''foo''"')
  normal 02srVlba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #555')
  call g:assert.equals(exists(s:object), 0, 'failed at #555')

  " #556
  call setline('.', '"''foo''"')
  normal 02srVlca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #556')
  call g:assert.equals(exists(s:object), 0, 'failed at #556')

  " #557
  call setline('.', '"foo"')
  normal 0srVld
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #557')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'expr', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_autoindent() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ -1
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #558
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #558')
  call g:assert.equals(getline(2),   '[',          'failed at #558')
  call g:assert.equals(getline(3),   '',           'failed at #558')
  call g:assert.equals(getline(4),   '    foo',    'failed at #558')
  call g:assert.equals(getline(5),   '',           'failed at #558')
  call g:assert.equals(getline(6),   ']',          'failed at #558')
  call g:assert.equals(getline(7),   '}',          'failed at #558')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #558')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #558')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #558')
  call g:assert.equals(&l:autoindent,  0,          'failed at #558')
  call g:assert.equals(&l:smartindent, 0,          'failed at #558')
  call g:assert.equals(&l:cindent,     0,          'failed at #558')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #558')

  %delete

  " #559
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #559')
  call g:assert.equals(getline(2),   '    [',      'failed at #559')
  call g:assert.equals(getline(3),   '',           'failed at #559')
  call g:assert.equals(getline(4),   '    foo',    'failed at #559')
  call g:assert.equals(getline(5),   '',           'failed at #559')
  call g:assert.equals(getline(6),   '    ]',      'failed at #559')
  call g:assert.equals(getline(7),   '    }',      'failed at #559')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #559')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #559')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #559')
  call g:assert.equals(&l:autoindent,  1,          'failed at #559')
  call g:assert.equals(&l:smartindent, 0,          'failed at #559')
  call g:assert.equals(&l:cindent,     0,          'failed at #559')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #559')

  %delete

  " #560
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #560')
  call g:assert.equals(getline(2),   '    [',       'failed at #560')
  call g:assert.equals(getline(3),   '',            'failed at #560')
  call g:assert.equals(getline(4),   '    foo',     'failed at #560')
  call g:assert.equals(getline(5),   '',            'failed at #560')
  call g:assert.equals(getline(6),   '    ]',       'failed at #560')
  call g:assert.equals(getline(7),   '}',           'failed at #560')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #560')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #560')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #560')
  call g:assert.equals(&l:autoindent,  1,           'failed at #560')
  call g:assert.equals(&l:smartindent, 1,           'failed at #560')
  call g:assert.equals(&l:cindent,     0,           'failed at #560')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #560')

  %delete

  " #561
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #561')
  call g:assert.equals(getline(2),   '    [',       'failed at #561')
  call g:assert.equals(getline(3),   '',            'failed at #561')
  call g:assert.equals(getline(4),   '    foo',     'failed at #561')
  call g:assert.equals(getline(5),   '',            'failed at #561')
  call g:assert.equals(getline(6),   '    ]',       'failed at #561')
  call g:assert.equals(getline(7),   '    }',       'failed at #561')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #561')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #561')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #561')
  call g:assert.equals(&l:autoindent,  1,           'failed at #561')
  call g:assert.equals(&l:smartindent, 1,           'failed at #561')
  call g:assert.equals(&l:cindent,     1,           'failed at #561')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #561')

  %delete

  " #562
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',            'failed at #562')
  call g:assert.equals(getline(2),   '           [',        'failed at #562')
  call g:assert.equals(getline(3),   '',                    'failed at #562')
  call g:assert.equals(getline(4),   '    foo',             'failed at #562')
  call g:assert.equals(getline(5),   '',                    'failed at #562')
  call g:assert.equals(getline(6),   '        ]',           'failed at #562')
  call g:assert.equals(getline(7),   '                }',   'failed at #562')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #562')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #562')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #562')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #562')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #562')
  call g:assert.equals(&l:cindent,     1,                   'failed at #562')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #562')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #563
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #563')
  call g:assert.equals(getline(2),   '[',          'failed at #563')
  call g:assert.equals(getline(3),   '',           'failed at #563')
  call g:assert.equals(getline(4),   '    foo',    'failed at #563')
  call g:assert.equals(getline(5),   '',           'failed at #563')
  call g:assert.equals(getline(6),   ']',          'failed at #563')
  call g:assert.equals(getline(7),   '}',          'failed at #563')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #563')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #563')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #563')
  call g:assert.equals(&l:autoindent,  0,          'failed at #563')
  call g:assert.equals(&l:smartindent, 0,          'failed at #563')
  call g:assert.equals(&l:cindent,     0,          'failed at #563')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #563')

  %delete

  " #564
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #564')
  call g:assert.equals(getline(2),   '[',          'failed at #564')
  call g:assert.equals(getline(3),   '',           'failed at #564')
  call g:assert.equals(getline(4),   '    foo',    'failed at #564')
  call g:assert.equals(getline(5),   '',           'failed at #564')
  call g:assert.equals(getline(6),   ']',          'failed at #564')
  call g:assert.equals(getline(7),   '}',          'failed at #564')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #564')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #564')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #564')
  call g:assert.equals(&l:autoindent,  1,          'failed at #564')
  call g:assert.equals(&l:smartindent, 0,          'failed at #564')
  call g:assert.equals(&l:cindent,     0,          'failed at #564')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #564')

  %delete

  " #565
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #565')
  call g:assert.equals(getline(2),   '[',          'failed at #565')
  call g:assert.equals(getline(3),   '',           'failed at #565')
  call g:assert.equals(getline(4),   '    foo',    'failed at #565')
  call g:assert.equals(getline(5),   '',           'failed at #565')
  call g:assert.equals(getline(6),   ']',          'failed at #565')
  call g:assert.equals(getline(7),   '}',          'failed at #565')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #565')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #565')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #565')
  call g:assert.equals(&l:autoindent,  1,          'failed at #565')
  call g:assert.equals(&l:smartindent, 1,          'failed at #565')
  call g:assert.equals(&l:cindent,     0,          'failed at #565')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #565')

  %delete

  " #566
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #566')
  call g:assert.equals(getline(2),   '[',          'failed at #566')
  call g:assert.equals(getline(3),   '',           'failed at #566')
  call g:assert.equals(getline(4),   '    foo',    'failed at #566')
  call g:assert.equals(getline(5),   '',           'failed at #566')
  call g:assert.equals(getline(6),   ']',          'failed at #566')
  call g:assert.equals(getline(7),   '}',          'failed at #566')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #566')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #566')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #566')
  call g:assert.equals(&l:autoindent,  1,          'failed at #566')
  call g:assert.equals(&l:smartindent, 1,          'failed at #566')
  call g:assert.equals(&l:cindent,     1,          'failed at #566')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #566')

  %delete

  " #567
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #567')
  call g:assert.equals(getline(2),   '[',              'failed at #567')
  call g:assert.equals(getline(3),   '',               'failed at #567')
  call g:assert.equals(getline(4),   '    foo',        'failed at #567')
  call g:assert.equals(getline(5),   '',               'failed at #567')
  call g:assert.equals(getline(6),   ']',              'failed at #567')
  call g:assert.equals(getline(7),   '}',              'failed at #567')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #567')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #567')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #567')
  call g:assert.equals(&l:autoindent,  1,              'failed at #567')
  call g:assert.equals(&l:smartindent, 1,              'failed at #567')
  call g:assert.equals(&l:cindent,     1,              'failed at #567')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #567')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #568
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #568')
  call g:assert.equals(getline(2),   '    [',      'failed at #568')
  call g:assert.equals(getline(3),   '',           'failed at #568')
  call g:assert.equals(getline(4),   '    foo',    'failed at #568')
  call g:assert.equals(getline(5),   '',           'failed at #568')
  call g:assert.equals(getline(6),   '    ]',      'failed at #568')
  call g:assert.equals(getline(7),   '    }',      'failed at #568')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #568')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #568')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #568')
  call g:assert.equals(&l:autoindent,  0,          'failed at #568')
  call g:assert.equals(&l:smartindent, 0,          'failed at #568')
  call g:assert.equals(&l:cindent,     0,          'failed at #568')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #568')

  %delete

  " #569
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #569')
  call g:assert.equals(getline(2),   '    [',      'failed at #569')
  call g:assert.equals(getline(3),   '',           'failed at #569')
  call g:assert.equals(getline(4),   '    foo',    'failed at #569')
  call g:assert.equals(getline(5),   '',           'failed at #569')
  call g:assert.equals(getline(6),   '    ]',      'failed at #569')
  call g:assert.equals(getline(7),   '    }',      'failed at #569')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #569')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #569')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #569')
  call g:assert.equals(&l:autoindent,  1,          'failed at #569')
  call g:assert.equals(&l:smartindent, 0,          'failed at #569')
  call g:assert.equals(&l:cindent,     0,          'failed at #569')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #569')

  %delete

  " #570
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #570')
  call g:assert.equals(getline(2),   '    [',      'failed at #570')
  call g:assert.equals(getline(3),   '',           'failed at #570')
  call g:assert.equals(getline(4),   '    foo',    'failed at #570')
  call g:assert.equals(getline(5),   '',           'failed at #570')
  call g:assert.equals(getline(6),   '    ]',      'failed at #570')
  call g:assert.equals(getline(7),   '    }',      'failed at #570')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #570')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #570')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #570')
  call g:assert.equals(&l:autoindent,  1,          'failed at #570')
  call g:assert.equals(&l:smartindent, 1,          'failed at #570')
  call g:assert.equals(&l:cindent,     0,          'failed at #570')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #570')

  %delete

  " #571
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #571')
  call g:assert.equals(getline(2),   '    [',      'failed at #571')
  call g:assert.equals(getline(3),   '',           'failed at #571')
  call g:assert.equals(getline(4),   '    foo',    'failed at #571')
  call g:assert.equals(getline(5),   '',           'failed at #571')
  call g:assert.equals(getline(6),   '    ]',      'failed at #571')
  call g:assert.equals(getline(7),   '    }',      'failed at #571')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #571')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #571')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #571')
  call g:assert.equals(&l:autoindent,  1,          'failed at #571')
  call g:assert.equals(&l:smartindent, 1,          'failed at #571')
  call g:assert.equals(&l:cindent,     1,          'failed at #571')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #571')

  %delete

  " #572
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',          'failed at #572')
  call g:assert.equals(getline(2),   '    [',          'failed at #572')
  call g:assert.equals(getline(3),   '',               'failed at #572')
  call g:assert.equals(getline(4),   '    foo',        'failed at #572')
  call g:assert.equals(getline(5),   '',               'failed at #572')
  call g:assert.equals(getline(6),   '    ]',          'failed at #572')
  call g:assert.equals(getline(7),   '    }',          'failed at #572')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #572')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #572')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #572')
  call g:assert.equals(&l:autoindent,  1,              'failed at #572')
  call g:assert.equals(&l:smartindent, 1,              'failed at #572')
  call g:assert.equals(&l:cindent,     1,              'failed at #572')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #572')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #573
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #573')
  call g:assert.equals(getline(2),   '    [',       'failed at #573')
  call g:assert.equals(getline(3),   '',            'failed at #573')
  call g:assert.equals(getline(4),   '    foo',     'failed at #573')
  call g:assert.equals(getline(5),   '',            'failed at #573')
  call g:assert.equals(getline(6),   '    ]',       'failed at #573')
  call g:assert.equals(getline(7),   '}',           'failed at #573')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #573')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #573')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #573')
  call g:assert.equals(&l:autoindent,  0,           'failed at #573')
  call g:assert.equals(&l:smartindent, 0,           'failed at #573')
  call g:assert.equals(&l:cindent,     0,           'failed at #573')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #573')

  %delete

  " #574
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #574')
  call g:assert.equals(getline(2),   '    [',       'failed at #574')
  call g:assert.equals(getline(3),   '',            'failed at #574')
  call g:assert.equals(getline(4),   '    foo',     'failed at #574')
  call g:assert.equals(getline(5),   '',            'failed at #574')
  call g:assert.equals(getline(6),   '    ]',       'failed at #574')
  call g:assert.equals(getline(7),   '}',           'failed at #574')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #574')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #574')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #574')
  call g:assert.equals(&l:autoindent,  1,           'failed at #574')
  call g:assert.equals(&l:smartindent, 0,           'failed at #574')
  call g:assert.equals(&l:cindent,     0,           'failed at #574')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #574')

  %delete

  " #575
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #575')
  call g:assert.equals(getline(2),   '    [',       'failed at #575')
  call g:assert.equals(getline(3),   '',            'failed at #575')
  call g:assert.equals(getline(4),   '    foo',     'failed at #575')
  call g:assert.equals(getline(5),   '',            'failed at #575')
  call g:assert.equals(getline(6),   '    ]',       'failed at #575')
  call g:assert.equals(getline(7),   '}',           'failed at #575')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #575')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #575')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #575')
  call g:assert.equals(&l:autoindent,  1,           'failed at #575')
  call g:assert.equals(&l:smartindent, 1,           'failed at #575')
  call g:assert.equals(&l:cindent,     0,           'failed at #575')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #575')

  %delete

  " #576
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #576')
  call g:assert.equals(getline(2),   '    [',       'failed at #576')
  call g:assert.equals(getline(3),   '',            'failed at #576')
  call g:assert.equals(getline(4),   '    foo',     'failed at #576')
  call g:assert.equals(getline(5),   '',            'failed at #576')
  call g:assert.equals(getline(6),   '    ]',       'failed at #576')
  call g:assert.equals(getline(7),   '}',           'failed at #576')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #576')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #576')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #576')
  call g:assert.equals(&l:autoindent,  1,           'failed at #576')
  call g:assert.equals(&l:smartindent, 1,           'failed at #576')
  call g:assert.equals(&l:cindent,     1,           'failed at #576')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #576')

  %delete

  " #577
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #577')
  call g:assert.equals(getline(2),   '    [',          'failed at #577')
  call g:assert.equals(getline(3),   '',               'failed at #577')
  call g:assert.equals(getline(4),   '    foo',        'failed at #577')
  call g:assert.equals(getline(5),   '',               'failed at #577')
  call g:assert.equals(getline(6),   '    ]',          'failed at #577')
  call g:assert.equals(getline(7),   '}',              'failed at #577')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #577')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #577')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #577')
  call g:assert.equals(&l:autoindent,  1,              'failed at #577')
  call g:assert.equals(&l:smartindent, 1,              'failed at #577')
  call g:assert.equals(&l:cindent,     1,              'failed at #577')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #577')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #578
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #578')
  call g:assert.equals(getline(2),   '    [',       'failed at #578')
  call g:assert.equals(getline(3),   '',            'failed at #578')
  call g:assert.equals(getline(4),   '    foo',     'failed at #578')
  call g:assert.equals(getline(5),   '',            'failed at #578')
  call g:assert.equals(getline(6),   '    ]',       'failed at #578')
  call g:assert.equals(getline(7),   '    }',       'failed at #578')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #578')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #578')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #578')
  call g:assert.equals(&l:autoindent,  0,           'failed at #578')
  call g:assert.equals(&l:smartindent, 0,           'failed at #578')
  call g:assert.equals(&l:cindent,     0,           'failed at #578')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #578')

  %delete

  " #579
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #579')
  call g:assert.equals(getline(2),   '    [',       'failed at #579')
  call g:assert.equals(getline(3),   '',            'failed at #579')
  call g:assert.equals(getline(4),   '    foo',     'failed at #579')
  call g:assert.equals(getline(5),   '',            'failed at #579')
  call g:assert.equals(getline(6),   '    ]',       'failed at #579')
  call g:assert.equals(getline(7),   '    }',       'failed at #579')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #579')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #579')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #579')
  call g:assert.equals(&l:autoindent,  1,           'failed at #579')
  call g:assert.equals(&l:smartindent, 0,           'failed at #579')
  call g:assert.equals(&l:cindent,     0,           'failed at #579')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #579')

  %delete

  " #580
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #580')
  call g:assert.equals(getline(2),   '    [',       'failed at #580')
  call g:assert.equals(getline(3),   '',            'failed at #580')
  call g:assert.equals(getline(4),   '    foo',     'failed at #580')
  call g:assert.equals(getline(5),   '',            'failed at #580')
  call g:assert.equals(getline(6),   '    ]',       'failed at #580')
  call g:assert.equals(getline(7),   '    }',       'failed at #580')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #580')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #580')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #580')
  call g:assert.equals(&l:autoindent,  1,           'failed at #580')
  call g:assert.equals(&l:smartindent, 1,           'failed at #580')
  call g:assert.equals(&l:cindent,     0,           'failed at #580')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #580')

  %delete

  " #581
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #581')
  call g:assert.equals(getline(2),   '    [',       'failed at #581')
  call g:assert.equals(getline(3),   '',            'failed at #581')
  call g:assert.equals(getline(4),   '    foo',     'failed at #581')
  call g:assert.equals(getline(5),   '',            'failed at #581')
  call g:assert.equals(getline(6),   '    ]',       'failed at #581')
  call g:assert.equals(getline(7),   '    }',       'failed at #581')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #581')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #581')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #581')
  call g:assert.equals(&l:autoindent,  1,           'failed at #581')
  call g:assert.equals(&l:smartindent, 1,           'failed at #581')
  call g:assert.equals(&l:cindent,     1,           'failed at #581')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #581')

  %delete

  " #582
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #582')
  call g:assert.equals(getline(2),   '    [',          'failed at #582')
  call g:assert.equals(getline(3),   '',               'failed at #582')
  call g:assert.equals(getline(4),   '    foo',        'failed at #582')
  call g:assert.equals(getline(5),   '',               'failed at #582')
  call g:assert.equals(getline(6),   '    ]',          'failed at #582')
  call g:assert.equals(getline(7),   '    }',          'failed at #582')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #582')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #582')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #582')
  call g:assert.equals(&l:autoindent,  1,              'failed at #582')
  call g:assert.equals(&l:smartindent, 1,              'failed at #582')
  call g:assert.equals(&l:cindent,     1,              'failed at #582')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #582')
endfunction
"}}}
function! s:suite.linewise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ cinkeys
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #583
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #583')
  call g:assert.equals(getline(2),   '',           'failed at #583')
  call g:assert.equals(getline(3),   '    foo',    'failed at #583')
  call g:assert.equals(getline(4),   '',           'failed at #583')
  call g:assert.equals(getline(5),   '    }',      'failed at #583')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #583')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #583')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #583')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #583')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #583')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #584
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #584')
  call g:assert.equals(getline(2),   '',           'failed at #584')
  call g:assert.equals(getline(3),   '    foo',    'failed at #584')
  call g:assert.equals(getline(4),   '',           'failed at #584')
  call g:assert.equals(getline(5),   '    }',      'failed at #584')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #584')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #584')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #584')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #584')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #584')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #585
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #585')
  call g:assert.equals(getline(2),   '',           'failed at #585')
  call g:assert.equals(getline(3),   '    foo',    'failed at #585')
  call g:assert.equals(getline(4),   '',           'failed at #585')
  call g:assert.equals(getline(5),   '    }',      'failed at #585')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #585')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #585')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #585')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #585')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #585')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #586
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #586')
  call g:assert.equals(getline(2),   '',              'failed at #586')
  call g:assert.equals(getline(3),   '    foo',       'failed at #586')
  call g:assert.equals(getline(4),   '',              'failed at #586')
  call g:assert.equals(getline(5),   '    }',         'failed at #586')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #586')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #586')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #586')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #586')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #586')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #587
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',      'failed at #587')
  call g:assert.equals(getline(2),   '',              'failed at #587')
  call g:assert.equals(getline(3),   '    foo',       'failed at #587')
  call g:assert.equals(getline(4),   '',              'failed at #587')
  call g:assert.equals(getline(5),   '            }', 'failed at #587')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #587')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #587')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #587')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #587')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #587')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #588
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #588')
  call g:assert.equals(getline(2),   '',              'failed at #588')
  call g:assert.equals(getline(3),   '    foo',       'failed at #588')
  call g:assert.equals(getline(4),   '',              'failed at #588')
  call g:assert.equals(getline(5),   '    }',         'failed at #588')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #588')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #588')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #588')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #588')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #588')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #589
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #589')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #589')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #589')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #589')

  " #590
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #590')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #590')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #590')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #590')

  " #591
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #591')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #591')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #591')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #591')

  " #592
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #592')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #592')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #592')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #592')

  %delete

  " #593
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #593')
  call g:assert.equals(getline(2),   'foo',        'failed at #593')
  call g:assert.equals(getline(3),   ']',          'failed at #593')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #593')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #593')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #593')

  " #594
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #594')
  call g:assert.equals(getline(2),   'foo',        'failed at #594')
  call g:assert.equals(getline(3),   '}',          'failed at #594')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #594')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #594')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #594')

  " #595
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #595')
  call g:assert.equals(getline(2),   'foo',        'failed at #595')
  call g:assert.equals(getline(3),   '>',          'failed at #595')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #595')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #595')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #595')

  " #596
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #596')
  call g:assert.equals(getline(2),   'foo',        'failed at #596')
  call g:assert.equals(getline(3),   ')',          'failed at #596')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #596')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #596')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #596')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #597
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #597')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #597')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #597')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #597')

  " #598
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #598')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #598')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #598')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #598')

  %delete

  " #597
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #597')
  call g:assert.equals(getline(2),   'foo',        'failed at #597')
  call g:assert.equals(getline(3),   'b',          'failed at #597')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #597')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #597')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #597')

  %delete

  " #598
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #598')
  call g:assert.equals(getline(2),   'foo',        'failed at #598')
  call g:assert.equals(getline(3),   '*',          'failed at #598')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #598')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #598')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #598')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #599
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #599')
  call g:assert.equals(getline(2),   'foo',        'failed at #599')
  call g:assert.equals(getline(3),   'bar',        'failed at #599')
  call g:assert.equals(getline(4),   'baz',        'failed at #599')
  call g:assert.equals(getline(5),   ']',          'failed at #599')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #599')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #599')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #599')

  %delete

  " #600
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #600')
  call g:assert.equals(getline(2),   '[',          'failed at #600')
  call g:assert.equals(getline(3),   'bar',        'failed at #600')
  call g:assert.equals(getline(4),   ']',          'failed at #600')
  call g:assert.equals(getline(5),   'baz',        'failed at #600')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #600')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #600')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #600')

  %delete

  " #601
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #601')
  call g:assert.equals(getline(2),   'bar',        'failed at #601')
  call g:assert.equals(getline(3),   'baz]',       'failed at #601')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #601')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #601')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #601')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #602
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #602')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #602')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #602')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #602')

  %delete

  " #603
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #603')
  call g:assert.equals(getline(2),   ']',          'failed at #603')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #603')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #603')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #603')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #604
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #604')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #604')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #604')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #604')

  " #605
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #605')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #605')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #605')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #605')

  %delete

  " #606
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #606')
  call g:assert.equals(getline(2),   '(',          'failed at #606')
  call g:assert.equals(getline(3),   '{',          'failed at #606')
  call g:assert.equals(getline(4),   '[',          'failed at #606')
  call g:assert.equals(getline(5),   'bar',        'failed at #606')
  call g:assert.equals(getline(6),   ']',          'failed at #606')
  call g:assert.equals(getline(7),   '}',          'failed at #606')
  call g:assert.equals(getline(8),   ')',          'failed at #606')
  call g:assert.equals(getline(9),   'baz',        'failed at #606')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #606')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #606')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #606')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #607
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #607')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #607')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #607')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #607')

  %delete

  " #608
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #608')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #608')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #608')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #608')

  %delete

  " #609
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #609')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #609')
  call g:assert.equals(getline(3),   'aa',         'failed at #609')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #609')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #609')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #609')

  %delete

  " #610
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #610')
  call g:assert.equals(getline(2),   'bbb',        'failed at #610')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #610')
  call g:assert.equals(getline(4),   'bbb',        'failed at #610')
  call g:assert.equals(getline(5),   'bb',         'failed at #610')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #610')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #610')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #610')

  %delete

  " #611
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #611')
  call g:assert.equals(getline(2),   '(',          'failed at #611')
  call g:assert.equals(getline(3),   'foo',        'failed at #611')
  call g:assert.equals(getline(4),   ')',          'failed at #611')
  call g:assert.equals(getline(5),   ')',          'failed at #611')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #611')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #611')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #611')

  %delete

  " #612
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #612')
  call g:assert.equals(getline(2),   '(',          'failed at #612')
  call g:assert.equals(getline(3),   'foo',        'failed at #612')
  call g:assert.equals(getline(4),   ')',          'failed at #612')
  call g:assert.equals(getline(5),   ')',          'failed at #612')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #612')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #612')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #612')

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

  " #613
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #613')

  " #614
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #614')

  " #615
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #615')

  " #616
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #616')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #617
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #617')
  call g:assert.equals(getline(2), 'α', 'failed at #617')
  call g:assert.equals(getline(3), ')', 'failed at #617')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #617')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #617')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #617')

  " #618
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #618')
  call g:assert.equals(getline(2), 'aα', 'failed at #618')
  call g:assert.equals(getline(3), ')',  'failed at #618')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #618')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #618')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #618')

  " #619
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #619')
  call g:assert.equals(getline(2), 'α', 'failed at #619')
  call g:assert.equals(getline(3), ')', 'failed at #619')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #619')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #619')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #619')

  " #620
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #620')
  call g:assert.equals(getline(2), 'aα', 'failed at #620')
  call g:assert.equals(getline(3), ')',  'failed at #620')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #620')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #620')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #620')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #621
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #621')
  call g:assert.equals(getline(2), 'a', 'failed at #621')
  call g:assert.equals(getline(3), 'α', 'failed at #621')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #621')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #621')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #621')

  " #622
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #622')
  call g:assert.equals(getline(2), 'α', 'failed at #622')
  call g:assert.equals(getline(3), 'α', 'failed at #622')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #622')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #622')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #622')

  " #623
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α',  'failed at #623')
  call g:assert.equals(getline(2), 'aα', 'failed at #623')
  call g:assert.equals(getline(3), 'α',  'failed at #623')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #623')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #623')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #623')

  " #624
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #624')
  call g:assert.equals(getline(2), 'a', 'failed at #624')
  call g:assert.equals(getline(3), 'α', 'failed at #624')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #624')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #624')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #624')

  " #625
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α', 'failed at #625')
  call g:assert.equals(getline(2), 'α', 'failed at #625')
  call g:assert.equals(getline(3), 'α', 'failed at #625')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #625')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #625')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #625')

  " #626
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'α',  'failed at #626')
  call g:assert.equals(getline(2), 'aα', 'failed at #626')
  call g:assert.equals(getline(3), 'α',  'failed at #626')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #626')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #626')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #626')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #627
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #627')
  call g:assert.equals(getline(2), 'a',  'failed at #627')
  call g:assert.equals(getline(3), 'aα', 'failed at #627')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #627')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #627')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #627')

  " #628
  call append(0, ['a', 'α', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #628')
  call g:assert.equals(getline(2), 'α',  'failed at #628')
  call g:assert.equals(getline(3), 'aα', 'failed at #628')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #628')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #628')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #628')

  " #629
  call append(0, ['a', 'aα', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #629')
  call g:assert.equals(getline(2), 'aα', 'failed at #629')
  call g:assert.equals(getline(3), 'aα', 'failed at #629')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #629')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #629')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #629')

  " #630
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #630')
  call g:assert.equals(getline(2), 'a',  'failed at #630')
  call g:assert.equals(getline(3), 'aα', 'failed at #630')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #630')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #630')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #630')

  " #631
  call append(0, ['β', 'α', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #631')
  call g:assert.equals(getline(2), 'α',  'failed at #631')
  call g:assert.equals(getline(3), 'aα', 'failed at #631')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #631')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #631')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #631')

  " #632
  call append(0, ['β', 'aα', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'aα', 'failed at #632')
  call g:assert.equals(getline(2), 'aα', 'failed at #632')
  call g:assert.equals(getline(3), 'aα', 'failed at #632')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #632')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #632')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #632')

  unlet g:operator#sandwich#recipes

  " #633
  call append(0, ['a', '“', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #633')
  call g:assert.equals(getline(2), '“', 'failed at #633')
  call g:assert.equals(getline(3), ')', 'failed at #633')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #633')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #633')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #633')

  " #634
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #634')
  call g:assert.equals(getline(2), 'a“', 'failed at #634')
  call g:assert.equals(getline(3), ')',  'failed at #634')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #634')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #634')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #634')

  " #635
  call append(0, ['β', '“', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(', 'failed at #635')
  call g:assert.equals(getline(2), '“', 'failed at #635')
  call g:assert.equals(getline(3), ')', 'failed at #635')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #635')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #635')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #635')

  " #636
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsr(
  call g:assert.equals(getline(1), '(',  'failed at #636')
  call g:assert.equals(getline(2), 'a“', 'failed at #636')
  call g:assert.equals(getline(3), ')',  'failed at #636')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #636')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #636')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #636')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #637
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #637')
  call g:assert.equals(getline(2), 'a', 'failed at #637')
  call g:assert.equals(getline(3), '“', 'failed at #637')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #637')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #637')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #637')

  " #638
  call append(0, ['a', '“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #638')
  call g:assert.equals(getline(2), '“', 'failed at #638')
  call g:assert.equals(getline(3), '“', 'failed at #638')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #638')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #638')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #638')

  " #639
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“',  'failed at #639')
  call g:assert.equals(getline(2), 'a“', 'failed at #639')
  call g:assert.equals(getline(3), '“',  'failed at #639')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #639')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #639')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #639')

  " #640
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #640')
  call g:assert.equals(getline(2), 'a', 'failed at #640')
  call g:assert.equals(getline(3), '“', 'failed at #640')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #640')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #640')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #640')

  " #641
  call append(0, ['β', '“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“', 'failed at #641')
  call g:assert.equals(getline(2), '“', 'failed at #641')
  call g:assert.equals(getline(3), '“', 'failed at #641')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #641')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #641')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #641')

  " #642
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), '“',  'failed at #642')
  call g:assert.equals(getline(2), 'a“', 'failed at #642')
  call g:assert.equals(getline(3), '“',  'failed at #642')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #642')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #642')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #642')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #643
  call append(0, ['a', 'a', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #643')
  call g:assert.equals(getline(2), 'a',  'failed at #643')
  call g:assert.equals(getline(3), 'a“', 'failed at #643')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #643')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #643')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #643')

  " #644
  call append(0, ['a', '“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #644')
  call g:assert.equals(getline(2), '“',  'failed at #644')
  call g:assert.equals(getline(3), 'a“', 'failed at #644')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #644')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #644')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #644')

  " #645
  call append(0, ['a', 'a“', 'a'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #645')
  call g:assert.equals(getline(2), 'a“', 'failed at #645')
  call g:assert.equals(getline(3), 'a“', 'failed at #645')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #645')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #645')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #645')

  " #646
  call append(0, ['β', 'a', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #646')
  call g:assert.equals(getline(2), 'a',  'failed at #646')
  call g:assert.equals(getline(3), 'a“', 'failed at #646')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #646')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #646')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #646')

  " #647
  call append(0, ['β', '“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #647')
  call g:assert.equals(getline(2), '“',  'failed at #647')
  call g:assert.equals(getline(3), 'a“', 'failed at #647')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #647')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #647')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #647')

  " #648
  call append(0, ['β', 'a“', 'β'])
  normal ggV2jsra
  call g:assert.equals(getline(1), 'a“', 'failed at #648')
  call g:assert.equals(getline(2), 'a“', 'failed at #648')
  call g:assert.equals(getline(3), 'a“', 'failed at #648')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #648')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #648')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #648')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #649
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #649')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #649')

  " #650
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #650')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #650')

  """ keep
  " #651
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #651')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #651')

  " #652
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #652')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #652')

  """ inner_tail
  " #653
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #653')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #653')

  " #654
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #654')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #654')

  """ head
  " #655
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #655')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #655')

  " #656
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #656')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #656')

  """ tail
  " #657
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #657')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #657')

  " #658
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #658')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #658')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
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
  " #659
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #659')

  " #660
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #660')

  """ off
  " #661
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #661')

  " #662
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #662')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #663
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #663')

  " #664
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #664')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #665
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #665')

  " #666
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #666')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #667
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #667')

  " #668
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #668')

  " #669
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #669')

  " #670
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #670')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #671
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #671')

  " #672
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #672')

  " #673
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #673')

  " #674
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #674')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #675
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #675')

  " #676
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #676')

  " #677
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #677')

  " #678
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #678')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #679
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #679')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #680
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #680')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])

  " #681
  call append(0, ['[', '(foo)', ']'])
  normal ggjVsr"
  call g:assert.equals(getline(1), '[', 'failed at #681')
  call g:assert.equals(getline(2), '',  'failed at #681')
  call g:assert.equals(getline(3), ']', 'failed at #681')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #682
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #682')
  call g:assert.equals(getline(2),   'foo',        'failed at #682')
  call g:assert.equals(getline(3),   ']',          'failed at #682')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #682')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #682')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #682')

  %delete

  " #683
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #683')
  call g:assert.equals(getline(2),   'foo',        'failed at #683')
  call g:assert.equals(getline(3),   '  ]',        'failed at #683')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #683')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #683')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #683')

  %delete

  " #684
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #684')
  call g:assert.equals(getline(2),   'foo',        'failed at #684')
  call g:assert.equals(getline(3),   'aa]',        'failed at #684')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #684')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #684')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #684')

  %delete

  " #685
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #685')
  call g:assert.equals(getline(2),   'foo',        'failed at #685')
  call g:assert.equals(getline(3),   ']',          'failed at #685')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #685')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #685')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #685')

  %delete

  " #686
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #686')
  call g:assert.equals(getline(2),   'foo',        'failed at #686')
  call g:assert.equals(getline(3),   'aa]',        'failed at #686')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #686')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #686')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #686')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #687
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #687')
  call g:assert.equals(getline(2),   'foo',        'failed at #687')
  call g:assert.equals(getline(3),   ']',          'failed at #687')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #687')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #687')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #687')

  %delete

  " #688
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #688')
  call g:assert.equals(getline(2),   'foo',        'failed at #688')
  call g:assert.equals(getline(3),   ']',          'failed at #688')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #688')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #688')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #688')

  %delete

  " #689
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #689')
  call g:assert.equals(getline(2),   'foo',        'failed at #689')
  call g:assert.equals(getline(3),   ']',          'failed at #689')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #689')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #689')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #689')

  %delete

  " #690
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #690')
  call g:assert.equals(getline(2),   '[',          'failed at #690')
  call g:assert.equals(getline(3),   'bb',         'failed at #690')
  call g:assert.equals(getline(4),   '',           'failed at #690')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #690')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #690')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #690')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #691
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #691')

  %delete

  """ on
  " #692
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #692')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #693
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #693')

  """ 1
  " #694
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #694')

  " #695
  call setline('.', '"foo"')
  normal 0Vsrb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #695')
  call g:assert.equals(exists(s:object), 0,   'failed at #695')

  " #696
  call setline('.', '"foo"')
  normal 0Vsrc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #696')
  call g:assert.equals(exists(s:object), 0,   'failed at #696')

  " #697
  call setline('.', '"''foo''"')
  normal 0V2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #697')
  call g:assert.equals(exists(s:object), 0,       'failed at #697')

  " #698
  call setline('.', '"''foo''"')
  normal 0V2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #698')
  call g:assert.equals(exists(s:object), 0,       'failed at #698')


  " #699
  call setline('.', '"''foo''"')
  normal 0V2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #699')
  call g:assert.equals(exists(s:object), 0,       'failed at #699')

  " #700
  call setline('.', '"''foo''"')
  normal 0V2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #700')
  call g:assert.equals(exists(s:object), 0,       'failed at #700')

  " #701
  call setline('.', '"foo"')
  normal 0Vsrd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #701')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'expr', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_autoindent() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ -1
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #702
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #702')
  call g:assert.equals(getline(2),   '[',          'failed at #702')
  call g:assert.equals(getline(3),   '',           'failed at #702')
  call g:assert.equals(getline(4),   '    foo',    'failed at #702')
  call g:assert.equals(getline(5),   '',           'failed at #702')
  call g:assert.equals(getline(6),   ']',          'failed at #702')
  call g:assert.equals(getline(7),   '}',          'failed at #702')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #702')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #702')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #702')
  call g:assert.equals(&l:autoindent,  0,          'failed at #702')
  call g:assert.equals(&l:smartindent, 0,          'failed at #702')
  call g:assert.equals(&l:cindent,     0,          'failed at #702')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #702')

  %delete

  " #703
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #703')
  call g:assert.equals(getline(2),   '    [',      'failed at #703')
  call g:assert.equals(getline(3),   '',           'failed at #703')
  call g:assert.equals(getline(4),   '    foo',    'failed at #703')
  call g:assert.equals(getline(5),   '',           'failed at #703')
  call g:assert.equals(getline(6),   '    ]',      'failed at #703')
  call g:assert.equals(getline(7),   '    }',      'failed at #703')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #703')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #703')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #703')
  call g:assert.equals(&l:autoindent,  1,          'failed at #703')
  call g:assert.equals(&l:smartindent, 0,          'failed at #703')
  call g:assert.equals(&l:cindent,     0,          'failed at #703')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #703')

  %delete

  " #704
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #704')
  call g:assert.equals(getline(2),   '    [',       'failed at #704')
  call g:assert.equals(getline(3),   '',            'failed at #704')
  call g:assert.equals(getline(4),   '    foo',     'failed at #704')
  call g:assert.equals(getline(5),   '',            'failed at #704')
  call g:assert.equals(getline(6),   '    ]',       'failed at #704')
  call g:assert.equals(getline(7),   '}',           'failed at #704')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #704')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #704')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #704')
  call g:assert.equals(&l:autoindent,  1,           'failed at #704')
  call g:assert.equals(&l:smartindent, 1,           'failed at #704')
  call g:assert.equals(&l:cindent,     0,           'failed at #704')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #704')

  %delete

  " #705
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #705')
  call g:assert.equals(getline(2),   '    [',       'failed at #705')
  call g:assert.equals(getline(3),   '',            'failed at #705')
  call g:assert.equals(getline(4),   '    foo',     'failed at #705')
  call g:assert.equals(getline(5),   '',            'failed at #705')
  call g:assert.equals(getline(6),   '    ]',       'failed at #705')
  call g:assert.equals(getline(7),   '    }',       'failed at #705')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #705')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #705')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #705')
  call g:assert.equals(&l:autoindent,  1,           'failed at #705')
  call g:assert.equals(&l:smartindent, 1,           'failed at #705')
  call g:assert.equals(&l:cindent,     1,           'failed at #705')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #705')

  %delete

  " #706
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',            'failed at #706')
  call g:assert.equals(getline(2),   '           [',        'failed at #706')
  call g:assert.equals(getline(3),   '',                    'failed at #706')
  call g:assert.equals(getline(4),   '    foo',             'failed at #706')
  call g:assert.equals(getline(5),   '',                    'failed at #706')
  call g:assert.equals(getline(6),   '        ]',           'failed at #706')
  call g:assert.equals(getline(7),   '                }',   'failed at #706')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #706')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #706')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #706')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #706')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #706')
  call g:assert.equals(&l:cindent,     1,                   'failed at #706')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #706')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #707
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #707')
  call g:assert.equals(getline(2),   '[',          'failed at #707')
  call g:assert.equals(getline(3),   '',           'failed at #707')
  call g:assert.equals(getline(4),   '    foo',    'failed at #707')
  call g:assert.equals(getline(5),   '',           'failed at #707')
  call g:assert.equals(getline(6),   ']',          'failed at #707')
  call g:assert.equals(getline(7),   '}',          'failed at #707')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #707')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #707')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #707')
  call g:assert.equals(&l:autoindent,  0,          'failed at #707')
  call g:assert.equals(&l:smartindent, 0,          'failed at #707')
  call g:assert.equals(&l:cindent,     0,          'failed at #707')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #707')

  %delete

  " #708
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #708')
  call g:assert.equals(getline(2),   '[',          'failed at #708')
  call g:assert.equals(getline(3),   '',           'failed at #708')
  call g:assert.equals(getline(4),   '    foo',    'failed at #708')
  call g:assert.equals(getline(5),   '',           'failed at #708')
  call g:assert.equals(getline(6),   ']',          'failed at #708')
  call g:assert.equals(getline(7),   '}',          'failed at #708')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #708')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #708')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #708')
  call g:assert.equals(&l:autoindent,  1,          'failed at #708')
  call g:assert.equals(&l:smartindent, 0,          'failed at #708')
  call g:assert.equals(&l:cindent,     0,          'failed at #708')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #708')

  %delete

  " #709
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #709')
  call g:assert.equals(getline(2),   '[',          'failed at #709')
  call g:assert.equals(getline(3),   '',           'failed at #709')
  call g:assert.equals(getline(4),   '    foo',    'failed at #709')
  call g:assert.equals(getline(5),   '',           'failed at #709')
  call g:assert.equals(getline(6),   ']',          'failed at #709')
  call g:assert.equals(getline(7),   '}',          'failed at #709')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #709')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #709')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #709')
  call g:assert.equals(&l:autoindent,  1,          'failed at #709')
  call g:assert.equals(&l:smartindent, 1,          'failed at #709')
  call g:assert.equals(&l:cindent,     0,          'failed at #709')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #709')

  %delete

  " #710
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #710')
  call g:assert.equals(getline(2),   '[',          'failed at #710')
  call g:assert.equals(getline(3),   '',           'failed at #710')
  call g:assert.equals(getline(4),   '    foo',    'failed at #710')
  call g:assert.equals(getline(5),   '',           'failed at #710')
  call g:assert.equals(getline(6),   ']',          'failed at #710')
  call g:assert.equals(getline(7),   '}',          'failed at #710')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #710')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #710')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #710')
  call g:assert.equals(&l:autoindent,  1,          'failed at #710')
  call g:assert.equals(&l:smartindent, 1,          'failed at #710')
  call g:assert.equals(&l:cindent,     1,          'failed at #710')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #710')

  %delete

  " #711
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #711')
  call g:assert.equals(getline(2),   '[',              'failed at #711')
  call g:assert.equals(getline(3),   '',               'failed at #711')
  call g:assert.equals(getline(4),   '    foo',        'failed at #711')
  call g:assert.equals(getline(5),   '',               'failed at #711')
  call g:assert.equals(getline(6),   ']',              'failed at #711')
  call g:assert.equals(getline(7),   '}',              'failed at #711')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #711')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #711')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #711')
  call g:assert.equals(&l:autoindent,  1,              'failed at #711')
  call g:assert.equals(&l:smartindent, 1,              'failed at #711')
  call g:assert.equals(&l:cindent,     1,              'failed at #711')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #711')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #712
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #712')
  call g:assert.equals(getline(2),   '    [',      'failed at #712')
  call g:assert.equals(getline(3),   '',           'failed at #712')
  call g:assert.equals(getline(4),   '    foo',    'failed at #712')
  call g:assert.equals(getline(5),   '',           'failed at #712')
  call g:assert.equals(getline(6),   '    ]',      'failed at #712')
  call g:assert.equals(getline(7),   '    }',      'failed at #712')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #712')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #712')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #712')
  call g:assert.equals(&l:autoindent,  0,          'failed at #712')
  call g:assert.equals(&l:smartindent, 0,          'failed at #712')
  call g:assert.equals(&l:cindent,     0,          'failed at #712')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #712')

  %delete

  " #713
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #713')
  call g:assert.equals(getline(2),   '    [',      'failed at #713')
  call g:assert.equals(getline(3),   '',           'failed at #713')
  call g:assert.equals(getline(4),   '    foo',    'failed at #713')
  call g:assert.equals(getline(5),   '',           'failed at #713')
  call g:assert.equals(getline(6),   '    ]',      'failed at #713')
  call g:assert.equals(getline(7),   '    }',      'failed at #713')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #713')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #713')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #713')
  call g:assert.equals(&l:autoindent,  1,          'failed at #713')
  call g:assert.equals(&l:smartindent, 0,          'failed at #713')
  call g:assert.equals(&l:cindent,     0,          'failed at #713')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #713')

  %delete

  " #714
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #714')
  call g:assert.equals(getline(2),   '    [',      'failed at #714')
  call g:assert.equals(getline(3),   '',           'failed at #714')
  call g:assert.equals(getline(4),   '    foo',    'failed at #714')
  call g:assert.equals(getline(5),   '',           'failed at #714')
  call g:assert.equals(getline(6),   '    ]',      'failed at #714')
  call g:assert.equals(getline(7),   '    }',      'failed at #714')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #714')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #714')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #714')
  call g:assert.equals(&l:autoindent,  1,          'failed at #714')
  call g:assert.equals(&l:smartindent, 1,          'failed at #714')
  call g:assert.equals(&l:cindent,     0,          'failed at #714')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #714')

  %delete

  " #715
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #715')
  call g:assert.equals(getline(2),   '    [',      'failed at #715')
  call g:assert.equals(getline(3),   '',           'failed at #715')
  call g:assert.equals(getline(4),   '    foo',    'failed at #715')
  call g:assert.equals(getline(5),   '',           'failed at #715')
  call g:assert.equals(getline(6),   '    ]',      'failed at #715')
  call g:assert.equals(getline(7),   '    }',      'failed at #715')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #715')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #715')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #715')
  call g:assert.equals(&l:autoindent,  1,          'failed at #715')
  call g:assert.equals(&l:smartindent, 1,          'failed at #715')
  call g:assert.equals(&l:cindent,     1,          'failed at #715')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #715')

  %delete

  " #716
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',          'failed at #716')
  call g:assert.equals(getline(2),   '    [',          'failed at #716')
  call g:assert.equals(getline(3),   '',               'failed at #716')
  call g:assert.equals(getline(4),   '    foo',        'failed at #716')
  call g:assert.equals(getline(5),   '',               'failed at #716')
  call g:assert.equals(getline(6),   '    ]',          'failed at #716')
  call g:assert.equals(getline(7),   '    }',          'failed at #716')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #716')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #716')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #716')
  call g:assert.equals(&l:autoindent,  1,              'failed at #716')
  call g:assert.equals(&l:smartindent, 1,              'failed at #716')
  call g:assert.equals(&l:cindent,     1,              'failed at #716')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #716')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #717
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #717')
  call g:assert.equals(getline(2),   '    [',       'failed at #717')
  call g:assert.equals(getline(3),   '',            'failed at #717')
  call g:assert.equals(getline(4),   '    foo',     'failed at #717')
  call g:assert.equals(getline(5),   '',            'failed at #717')
  call g:assert.equals(getline(6),   '    ]',       'failed at #717')
  call g:assert.equals(getline(7),   '}',           'failed at #717')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #717')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #717')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #717')
  call g:assert.equals(&l:autoindent,  0,           'failed at #717')
  call g:assert.equals(&l:smartindent, 0,           'failed at #717')
  call g:assert.equals(&l:cindent,     0,           'failed at #717')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #717')

  %delete

  " #718
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #718')
  call g:assert.equals(getline(2),   '    [',       'failed at #718')
  call g:assert.equals(getline(3),   '',            'failed at #718')
  call g:assert.equals(getline(4),   '    foo',     'failed at #718')
  call g:assert.equals(getline(5),   '',            'failed at #718')
  call g:assert.equals(getline(6),   '    ]',       'failed at #718')
  call g:assert.equals(getline(7),   '}',           'failed at #718')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #718')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #718')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #718')
  call g:assert.equals(&l:autoindent,  1,           'failed at #718')
  call g:assert.equals(&l:smartindent, 0,           'failed at #718')
  call g:assert.equals(&l:cindent,     0,           'failed at #718')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #718')

  %delete

  " #719
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #719')
  call g:assert.equals(getline(2),   '    [',       'failed at #719')
  call g:assert.equals(getline(3),   '',            'failed at #719')
  call g:assert.equals(getline(4),   '    foo',     'failed at #719')
  call g:assert.equals(getline(5),   '',            'failed at #719')
  call g:assert.equals(getline(6),   '    ]',       'failed at #719')
  call g:assert.equals(getline(7),   '}',           'failed at #719')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #719')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #719')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #719')
  call g:assert.equals(&l:autoindent,  1,           'failed at #719')
  call g:assert.equals(&l:smartindent, 1,           'failed at #719')
  call g:assert.equals(&l:cindent,     0,           'failed at #719')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #719')

  %delete

  " #720
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #720')
  call g:assert.equals(getline(2),   '    [',       'failed at #720')
  call g:assert.equals(getline(3),   '',            'failed at #720')
  call g:assert.equals(getline(4),   '    foo',     'failed at #720')
  call g:assert.equals(getline(5),   '',            'failed at #720')
  call g:assert.equals(getline(6),   '    ]',       'failed at #720')
  call g:assert.equals(getline(7),   '}',           'failed at #720')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #720')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #720')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #720')
  call g:assert.equals(&l:autoindent,  1,           'failed at #720')
  call g:assert.equals(&l:smartindent, 1,           'failed at #720')
  call g:assert.equals(&l:cindent,     1,           'failed at #720')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #720')

  %delete

  " #721
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #721')
  call g:assert.equals(getline(2),   '    [',          'failed at #721')
  call g:assert.equals(getline(3),   '',               'failed at #721')
  call g:assert.equals(getline(4),   '    foo',        'failed at #721')
  call g:assert.equals(getline(5),   '',               'failed at #721')
  call g:assert.equals(getline(6),   '    ]',          'failed at #721')
  call g:assert.equals(getline(7),   '}',              'failed at #721')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #721')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #721')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #721')
  call g:assert.equals(&l:autoindent,  1,              'failed at #721')
  call g:assert.equals(&l:smartindent, 1,              'failed at #721')
  call g:assert.equals(&l:cindent,     1,              'failed at #721')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #721')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #722
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #722')
  call g:assert.equals(getline(2),   '    [',       'failed at #722')
  call g:assert.equals(getline(3),   '',            'failed at #722')
  call g:assert.equals(getline(4),   '    foo',     'failed at #722')
  call g:assert.equals(getline(5),   '',            'failed at #722')
  call g:assert.equals(getline(6),   '    ]',       'failed at #722')
  call g:assert.equals(getline(7),   '    }',       'failed at #722')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #722')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #722')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #722')
  call g:assert.equals(&l:autoindent,  0,           'failed at #722')
  call g:assert.equals(&l:smartindent, 0,           'failed at #722')
  call g:assert.equals(&l:cindent,     0,           'failed at #722')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #722')

  %delete

  " #723
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #723')
  call g:assert.equals(getline(2),   '    [',       'failed at #723')
  call g:assert.equals(getline(3),   '',            'failed at #723')
  call g:assert.equals(getline(4),   '    foo',     'failed at #723')
  call g:assert.equals(getline(5),   '',            'failed at #723')
  call g:assert.equals(getline(6),   '    ]',       'failed at #723')
  call g:assert.equals(getline(7),   '    }',       'failed at #723')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #723')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #723')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #723')
  call g:assert.equals(&l:autoindent,  1,           'failed at #723')
  call g:assert.equals(&l:smartindent, 0,           'failed at #723')
  call g:assert.equals(&l:cindent,     0,           'failed at #723')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #723')

  %delete

  " #724
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #724')
  call g:assert.equals(getline(2),   '    [',       'failed at #724')
  call g:assert.equals(getline(3),   '',            'failed at #724')
  call g:assert.equals(getline(4),   '    foo',     'failed at #724')
  call g:assert.equals(getline(5),   '',            'failed at #724')
  call g:assert.equals(getline(6),   '    ]',       'failed at #724')
  call g:assert.equals(getline(7),   '    }',       'failed at #724')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #724')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #724')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #724')
  call g:assert.equals(&l:autoindent,  1,           'failed at #724')
  call g:assert.equals(&l:smartindent, 1,           'failed at #724')
  call g:assert.equals(&l:cindent,     0,           'failed at #724')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #724')

  %delete

  " #725
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #725')
  call g:assert.equals(getline(2),   '    [',       'failed at #725')
  call g:assert.equals(getline(3),   '',            'failed at #725')
  call g:assert.equals(getline(4),   '    foo',     'failed at #725')
  call g:assert.equals(getline(5),   '',            'failed at #725')
  call g:assert.equals(getline(6),   '    ]',       'failed at #725')
  call g:assert.equals(getline(7),   '    }',       'failed at #725')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #725')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #725')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #725')
  call g:assert.equals(&l:autoindent,  1,           'failed at #725')
  call g:assert.equals(&l:smartindent, 1,           'failed at #725')
  call g:assert.equals(&l:cindent,     1,           'failed at #725')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #725')

  %delete

  " #726
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #726')
  call g:assert.equals(getline(2),   '    [',          'failed at #726')
  call g:assert.equals(getline(3),   '',               'failed at #726')
  call g:assert.equals(getline(4),   '    foo',        'failed at #726')
  call g:assert.equals(getline(5),   '',               'failed at #726')
  call g:assert.equals(getline(6),   '    ]',          'failed at #726')
  call g:assert.equals(getline(7),   '    }',          'failed at #726')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #726')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #726')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #726')
  call g:assert.equals(&l:autoindent,  1,              'failed at #726')
  call g:assert.equals(&l:smartindent, 1,              'failed at #726')
  call g:assert.equals(&l:cindent,     1,              'failed at #726')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #726')
endfunction
"}}}
function! s:suite.linewise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]
  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ cinkeys
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #727
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #727')
  call g:assert.equals(getline(2),   '',           'failed at #727')
  call g:assert.equals(getline(3),   '    foo',    'failed at #727')
  call g:assert.equals(getline(4),   '',           'failed at #727')
  call g:assert.equals(getline(5),   '    }',      'failed at #727')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #727')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #727')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #727')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #727')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #727')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #728
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #728')
  call g:assert.equals(getline(2),   '',           'failed at #728')
  call g:assert.equals(getline(3),   '    foo',    'failed at #728')
  call g:assert.equals(getline(4),   '',           'failed at #728')
  call g:assert.equals(getline(5),   '    }',      'failed at #728')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #728')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #728')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #728')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #728')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #728')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #729
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #729')
  call g:assert.equals(getline(2),   '',           'failed at #729')
  call g:assert.equals(getline(3),   '    foo',    'failed at #729')
  call g:assert.equals(getline(4),   '',           'failed at #729')
  call g:assert.equals(getline(5),   '    }',      'failed at #729')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #729')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #729')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #729')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #729')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #729')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #730
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #730')
  call g:assert.equals(getline(2),   '',              'failed at #730')
  call g:assert.equals(getline(3),   '    foo',       'failed at #730')
  call g:assert.equals(getline(4),   '',              'failed at #730')
  call g:assert.equals(getline(5),   '    }',         'failed at #730')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #730')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #730')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #730')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #730')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #730')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #731
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',      'failed at #731')
  call g:assert.equals(getline(2),   '',              'failed at #731')
  call g:assert.equals(getline(3),   '    foo',       'failed at #731')
  call g:assert.equals(getline(4),   '',              'failed at #731')
  call g:assert.equals(getline(5),   '            }', 'failed at #731')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #731')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #731')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #731')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #731')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #731')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #732
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #732')
  call g:assert.equals(getline(2),   '',              'failed at #732')
  call g:assert.equals(getline(3),   '    foo',       'failed at #732')
  call g:assert.equals(getline(4),   '',              'failed at #732')
  call g:assert.equals(getline(5),   '    }',         'failed at #732')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #732')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #732')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #732')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #732')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #732')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #733
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #733')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #733')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #733')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #733')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #733')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #733')

  %delete

  " #734
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #734')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #734')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #734')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #734')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #734')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #734')

  %delete

  " #735
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #735')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #735')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #735')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #735')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #735')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #735')

  %delete

  " #736
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #736')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #736')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #736')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #736')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #736')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #736')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #737
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #737')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #737')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #737')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #737')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #737')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #737')

  " #738
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #738')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #738')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #738')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #738')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #738')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #738')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #739
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #739')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #739')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #739')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #739')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #739')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #739')

  %delete

  " #740
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #740')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #740')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #740')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #740')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #740')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #740')

  %delete

  " #741
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #741')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #741')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #741')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #741')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #741')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #741')

  %delete

  " #742
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #742')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #742')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #742')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #742')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #742')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #742')

  %delete

  " #743
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #743')
  call g:assert.equals(getline(2),   'barbar',     'failed at #743')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #743')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #743')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #743')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #743')

  %delete

  " #744
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #744')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #744')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #744')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #744')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #744')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #744')

  %delete

  " #745
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #745')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #745')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #745')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #745')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #745')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #745')

  %delete

  " #746
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #746')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #746')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #746')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #746')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #746')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #746')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #747
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #747')
  call g:assert.equals(getline(2),   '[b]',        'failed at #747')
  call g:assert.equals(getline(3),   '[c]',        'failed at #747')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #747')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #747')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #747')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #748
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #748')
  call g:assert.equals(getline(2),   '[]',         'failed at #748')
  call g:assert.equals(getline(3),   '[]',         'failed at #748')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #748')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #748')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #748')

  %delete

  " #749
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #749')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #749')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #749')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #749')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #749')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #749')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #750
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #750')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #750')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #750')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #750')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #750')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #750')

  %delete

  " #751
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #751')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #751')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #751')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #751')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #751')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #751')

  %delete

  " #752
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #752')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #752')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #752')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #752')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #752')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #752')

  %delete

  " #753
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #753')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #753')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #753')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #753')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #753')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #753')

  %delete

  " #754
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #754')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #754')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #754')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #754')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #754')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #754')

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

  " #755
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #755')
  call g:assert.equals(getline(2), '"bar"', 'failed at #755')
  call g:assert.equals(getline(3), '"baz"', 'failed at #755')

  %delete

  " #756
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #756')
  call g:assert.equals(getline(2), '"bar"', 'failed at #756')
  call g:assert.equals(getline(3), '"baz"', 'failed at #756')

  %delete

  " #757
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #757')
  call g:assert.equals(getline(2), '"bar"', 'failed at #757')
  call g:assert.equals(getline(3), '"baz"', 'failed at #757')

  %delete

  " #758
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #758')
  call g:assert.equals(getline(2), '"bar"', 'failed at #758')
  call g:assert.equals(getline(3), '"baz"', 'failed at #758')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #759
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(α)',          'failed at #759')
  call g:assert.equals(getline(2), '(β)',          'failed at #759')
  call g:assert.equals(getline(3), '(γ)',          'failed at #759')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #759')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #759')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #759')

  " #760
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(aα)',         'failed at #760')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #760')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #760')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #760')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #760')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #760')

  " #761
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(α)',          'failed at #761')
  call g:assert.equals(getline(2), '(β)',          'failed at #761')
  call g:assert.equals(getline(3), '(γ)',          'failed at #761')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #761')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #761')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #761')

  " #762
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(aα)',         'failed at #762')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #762')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #762')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #762')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #762')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #762')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #763
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'αaα',          'failed at #763')
  call g:assert.equals(getline(2), 'αbα',          'failed at #763')
  call g:assert.equals(getline(3), 'αcα',          'failed at #763')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #763')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #763')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #763')

  " #764
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'ααα',          'failed at #764')
  call g:assert.equals(getline(2), 'αβα',          'failed at #764')
  call g:assert.equals(getline(3), 'αγα',          'failed at #764')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #764')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #764')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #764')

  " #765
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #765')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #765')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #765')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #765')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #765')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #765')

  " #766
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'αaα',          'failed at #766')
  call g:assert.equals(getline(2), 'αbα',          'failed at #766')
  call g:assert.equals(getline(3), 'αcα',          'failed at #766')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #766')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #766')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #766')

  " #767
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'ααα',          'failed at #767')
  call g:assert.equals(getline(2), 'αβα',          'failed at #767')
  call g:assert.equals(getline(3), 'αγα',          'failed at #767')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #767')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #767')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #767')

  " #768
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #768')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #768')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #768')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #768')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #768')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #768')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #769
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #769')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #769')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #769')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #769')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #769')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #769')

  " #770
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #770')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #770')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #770')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #770')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #770')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #770')

  " #771
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #771')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #771')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #771')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #771')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #771')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #771')

  " #772
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #772')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #772')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #772')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #772')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #772')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #772')

  " #773
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #773')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #773')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #773')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #773')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #773')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #773')

  " #774
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #774')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #774')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #774')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #774')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #774')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #774')

  unlet g:operator#sandwich#recipes

  " #775
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(“)',          'failed at #775')
  call g:assert.equals(getline(2), '(“)',          'failed at #775')
  call g:assert.equals(getline(3), '(“)',          'failed at #775')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #775')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #775')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #775')

  " #776
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(a“)',         'failed at #776')
  call g:assert.equals(getline(2), '(b“)',         'failed at #776')
  call g:assert.equals(getline(3), '(c“)',         'failed at #776')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #776')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #776')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #776')

  " #777
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11l("
  call g:assert.equals(getline(1), '(“)',          'failed at #777')
  call g:assert.equals(getline(2), '(“)',          'failed at #777')
  call g:assert.equals(getline(3), '(“)',          'failed at #777')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #777')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #777')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #777')

  " #778
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14l("
  call g:assert.equals(getline(1), '(a“)',         'failed at #778')
  call g:assert.equals(getline(2), '(b“)',         'failed at #778')
  call g:assert.equals(getline(3), '(c“)',         'failed at #778')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #778')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #778')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #778')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #779
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“a“',          'failed at #779')
  call g:assert.equals(getline(2), '“b“',          'failed at #779')
  call g:assert.equals(getline(3), '“c“',          'failed at #779')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #779')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #779')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #779')

  " #780
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“““',          'failed at #780')
  call g:assert.equals(getline(2), '“““',          'failed at #780')
  call g:assert.equals(getline(3), '“““',          'failed at #780')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #780')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #780')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #780')

  " #781
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), '“a““',         'failed at #781')
  call g:assert.equals(getline(2), '“b““',         'failed at #781')
  call g:assert.equals(getline(3), '“c““',         'failed at #781')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #781')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #781')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #781')

  " #782
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“a“',          'failed at #782')
  call g:assert.equals(getline(2), '“b“',          'failed at #782')
  call g:assert.equals(getline(3), '“c“',          'failed at #782')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #782')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #782')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #782')

  " #783
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), '“““',          'failed at #783')
  call g:assert.equals(getline(2), '“““',          'failed at #783')
  call g:assert.equals(getline(3), '“““',          'failed at #783')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #783')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #783')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #783')

  " #784
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), '“a““',         'failed at #784')
  call g:assert.equals(getline(2), '“b““',         'failed at #784')
  call g:assert.equals(getline(3), '“c““',         'failed at #784')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #784')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #784')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #784')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #785
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #785')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #785')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #785')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #785')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #785')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #785')

  " #786
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #786')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #786')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #786')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #786')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #786')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #786')

  " #787
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #787')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #787')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #787')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #787')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #787')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #787')

  " #788
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #788')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #788')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #788')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #788')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #788')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #788')

  " #789
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal ggsr\<C-v>11la"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #789')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #789')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #789')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #789')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #789')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #789')

  " #790
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal ggsr\<C-v>14la"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #790')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #790')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #790')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #790')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #790')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #790')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #791
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #791')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #791')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #791')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #791')

  " #792
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #792')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #792')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #792')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #792')

  %delete

  """ keep
  " #793
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #793')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #793')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #793')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #793')

  " #794
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #794')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #794')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #794')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #794')

  %delete

  """ inner_tail
  " #795
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #795')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #795')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #795')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #795')

  " #796
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #796')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #796')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #796')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #796')

  %delete

  """ head
  " #797
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #797')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #797')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #797')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #797')

  " #798
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #798')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #798')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #798')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #798')

  %delete

  """ tail
  " #799
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #799')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #799')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #799')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #799')

  " #800
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #800')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #800')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #800')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #800')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
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
  " #801
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #801')
  call g:assert.equals(getline(2), '"bar"', 'failed at #801')
  call g:assert.equals(getline(3), '"baz"', 'failed at #801')

  %delete

  " #802
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #802')
  call g:assert.equals(getline(2), '(bar)', 'failed at #802')
  call g:assert.equals(getline(3), '(baz)', 'failed at #802')

  %delete

  """ off
  " #803
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #803')
  call g:assert.equals(getline(2), '{bar}', 'failed at #803')
  call g:assert.equals(getline(3), '{baz}', 'failed at #803')

  %delete

  " #804
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #804')
  call g:assert.equals(getline(2), '"bar"', 'failed at #804')
  call g:assert.equals(getline(3), '"baz"', 'failed at #804')

  set whichwrap&
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_regex() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #805
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #805')
  call g:assert.equals(getline(2), '"bar"', 'failed at #805')
  call g:assert.equals(getline(3), '"baz"', 'failed at #805')

  %delete

  " #806
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #806')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #806')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #806')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #807
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #807')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #807')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #807')

  %delete

  " #808
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #808')
  call g:assert.equals(getline(2), '"bar"', 'failed at #808')
  call g:assert.equals(getline(3), '"baz"', 'failed at #808')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ 1
  " #809
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #809')
  call g:assert.equals(getline(2), '(bar)', 'failed at #809')
  call g:assert.equals(getline(3), '(baz)', 'failed at #809')

  %delete

  " #810
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #810')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #810')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #810')

  %delete

  " #811
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #811')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #811')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #811')

  %delete

  " #812
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #812')
  call g:assert.equals(getline(2), '("bar")', 'failed at #812')
  call g:assert.equals(getline(3), '("baz")', 'failed at #812')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #813
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #813')
  call g:assert.equals(getline(2), '(bar)', 'failed at #813')
  call g:assert.equals(getline(3), '(baz)', 'failed at #813')

  %delete

  " #814
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #814')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #814')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #814')

  %delete

  " #815
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #815')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #815')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #815')

  %delete

  " #816
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #816')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #816')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #816')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #817
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #817')
  call g:assert.equals(getline(2), '(bar)', 'failed at #817')
  call g:assert.equals(getline(3), '(baz)', 'failed at #817')

  %delete

  " #818
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #818')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #818')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #818')

  %delete

  " #819
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #819')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #819')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #819')

  %delete

  " #820
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #820')
  call g:assert.equals(getline(2), '("bar")', 'failed at #820')
  call g:assert.equals(getline(3), '("baz")', 'failed at #820')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #821
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #821')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #821')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #821')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #822
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #822')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #822')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #822')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #823
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '', 'failed at #823')
  call g:assert.equals(getline(2), '', 'failed at #823')
  call g:assert.equals(getline(3), '', 'failed at #823')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #823
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #823')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #823')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #823')

  %delete

  """ on
  " #824
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #824')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #824')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #824')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #825
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '1+1foo1+2', 'failed at #825')
  call g:assert.equals(getline(2), '1+1bar1+2', 'failed at #825')
  call g:assert.equals(getline(3), '1+1baz1+2', 'failed at #825')

  %delete

  """ 1
  " #826
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '2foo3', 'failed at #826')
  call g:assert.equals(getline(2), '2bar3', 'failed at #826')
  call g:assert.equals(getline(3), '2baz3', 'failed at #826')

  %delete

  " #827
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #827')
  call g:assert.equals(getline(2), '"bar"', 'failed at #827')
  call g:assert.equals(getline(3), '"baz"', 'failed at #827')
  call g:assert.equals(exists(s:object), 0, 'failed at #827')

  %delete

  " #828
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #828')
  call g:assert.equals(getline(2), '"bar"', 'failed at #828')
  call g:assert.equals(getline(3), '"baz"', 'failed at #828')
  call g:assert.equals(exists(s:object), 0, 'failed at #828')

  %delete

  " #829
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #829')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #829')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #829')
  call g:assert.equals(exists(s:object), 0,     'failed at #829')

  %delete

  " #830
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #830')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #830')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #830')
  call g:assert.equals(exists(s:object), 0,     'failed at #830')

  %delete

  " #831
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #831')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #831')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #831')
  call g:assert.equals(exists(s:object), 0,     'failed at #831')

  %delete

  " #832
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #832')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #832')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #832')
  call g:assert.equals(exists(s:object), 0,     'failed at #832')

  %delete

  " #833
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17ld"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #833')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #833')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #833')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  set whichwrap&
  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'expr', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #834
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #834')
  call g:assert.equals(getline(2),   '[',          'failed at #834')
  call g:assert.equals(getline(3),   'foo',        'failed at #834')
  call g:assert.equals(getline(4),   ']',          'failed at #834')
  call g:assert.equals(getline(5),   '}',          'failed at #834')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #834')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #834')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #834')
  call g:assert.equals(&l:autoindent,  0,          'failed at #834')
  call g:assert.equals(&l:smartindent, 0,          'failed at #834')
  call g:assert.equals(&l:cindent,     0,          'failed at #834')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #834')

  %delete

  " #835
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #835')
  call g:assert.equals(getline(2),   '    [',      'failed at #835')
  call g:assert.equals(getline(3),   '    foo',    'failed at #835')
  call g:assert.equals(getline(4),   '    ]',      'failed at #835')
  call g:assert.equals(getline(5),   '    }',      'failed at #835')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #835')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #835')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #835')
  call g:assert.equals(&l:autoindent,  1,          'failed at #835')
  call g:assert.equals(&l:smartindent, 0,          'failed at #835')
  call g:assert.equals(&l:cindent,     0,          'failed at #835')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #835')

  %delete

  " #836
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #836')
  call g:assert.equals(getline(2),   '        [',   'failed at #836')
  call g:assert.equals(getline(3),   '        foo', 'failed at #836')
  call g:assert.equals(getline(4),   '    ]',       'failed at #836')
  call g:assert.equals(getline(5),   '}',           'failed at #836')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #836')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #836')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #836')
  call g:assert.equals(&l:autoindent,  1,           'failed at #836')
  call g:assert.equals(&l:smartindent, 1,           'failed at #836')
  call g:assert.equals(&l:cindent,     0,           'failed at #836')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #836')

  %delete

  " #837
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #837')
  call g:assert.equals(getline(2),   '    [',       'failed at #837')
  call g:assert.equals(getline(3),   '        foo', 'failed at #837')
  call g:assert.equals(getline(4),   '    ]',       'failed at #837')
  call g:assert.equals(getline(5),   '    }',       'failed at #837')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #837')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #837')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #837')
  call g:assert.equals(&l:autoindent,  1,           'failed at #837')
  call g:assert.equals(&l:smartindent, 1,           'failed at #837')
  call g:assert.equals(&l:cindent,     1,           'failed at #837')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #837')

  %delete

  " #838
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',           'failed at #838')
  call g:assert.equals(getline(2),   '            [',       'failed at #838')
  call g:assert.equals(getline(3),   '                foo', 'failed at #838')
  call g:assert.equals(getline(4),   '        ]',           'failed at #838')
  call g:assert.equals(getline(5),   '                }',   'failed at #838')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #838')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #838')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #838')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #838')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #838')
  call g:assert.equals(&l:cindent,     1,                   'failed at #838')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #838')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #839
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #839')
  call g:assert.equals(getline(2),   '[',          'failed at #839')
  call g:assert.equals(getline(3),   'foo',        'failed at #839')
  call g:assert.equals(getline(4),   ']',          'failed at #839')
  call g:assert.equals(getline(5),   '}',          'failed at #839')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #839')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #839')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #839')
  call g:assert.equals(&l:autoindent,  0,          'failed at #839')
  call g:assert.equals(&l:smartindent, 0,          'failed at #839')
  call g:assert.equals(&l:cindent,     0,          'failed at #839')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #839')

  %delete

  " #840
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #840')
  call g:assert.equals(getline(2),   '[',          'failed at #840')
  call g:assert.equals(getline(3),   'foo',        'failed at #840')
  call g:assert.equals(getline(4),   ']',          'failed at #840')
  call g:assert.equals(getline(5),   '}',          'failed at #840')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #840')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #840')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #840')
  call g:assert.equals(&l:autoindent,  1,          'failed at #840')
  call g:assert.equals(&l:smartindent, 0,          'failed at #840')
  call g:assert.equals(&l:cindent,     0,          'failed at #840')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #840')

  %delete

  " #841
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #841')
  call g:assert.equals(getline(2),   '[',          'failed at #841')
  call g:assert.equals(getline(3),   'foo',        'failed at #841')
  call g:assert.equals(getline(4),   ']',          'failed at #841')
  call g:assert.equals(getline(5),   '}',          'failed at #841')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #841')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #841')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #841')
  call g:assert.equals(&l:autoindent,  1,          'failed at #841')
  call g:assert.equals(&l:smartindent, 1,          'failed at #841')
  call g:assert.equals(&l:cindent,     0,          'failed at #841')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #841')

  %delete

  " #842
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #842')
  call g:assert.equals(getline(2),   '[',          'failed at #842')
  call g:assert.equals(getline(3),   'foo',        'failed at #842')
  call g:assert.equals(getline(4),   ']',          'failed at #842')
  call g:assert.equals(getline(5),   '}',          'failed at #842')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #842')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #842')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #842')
  call g:assert.equals(&l:autoindent,  1,          'failed at #842')
  call g:assert.equals(&l:smartindent, 1,          'failed at #842')
  call g:assert.equals(&l:cindent,     1,          'failed at #842')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #842')

  %delete

  " #843
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #843')
  call g:assert.equals(getline(2),   '[',              'failed at #843')
  call g:assert.equals(getline(3),   'foo',            'failed at #843')
  call g:assert.equals(getline(4),   ']',              'failed at #843')
  call g:assert.equals(getline(5),   '}',              'failed at #843')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #843')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #843')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #843')
  call g:assert.equals(&l:autoindent,  1,              'failed at #843')
  call g:assert.equals(&l:smartindent, 1,              'failed at #843')
  call g:assert.equals(&l:cindent,     1,              'failed at #843')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #843')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #844
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #844')
  call g:assert.equals(getline(2),   '    [',      'failed at #844')
  call g:assert.equals(getline(3),   '    foo',    'failed at #844')
  call g:assert.equals(getline(4),   '    ]',      'failed at #844')
  call g:assert.equals(getline(5),   '    }',      'failed at #844')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #844')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #844')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #844')
  call g:assert.equals(&l:autoindent,  0,          'failed at #844')
  call g:assert.equals(&l:smartindent, 0,          'failed at #844')
  call g:assert.equals(&l:cindent,     0,          'failed at #844')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #844')

  %delete

  " #845
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #845')
  call g:assert.equals(getline(2),   '    [',      'failed at #845')
  call g:assert.equals(getline(3),   '    foo',    'failed at #845')
  call g:assert.equals(getline(4),   '    ]',      'failed at #845')
  call g:assert.equals(getline(5),   '    }',      'failed at #845')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #845')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #845')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #845')
  call g:assert.equals(&l:autoindent,  1,          'failed at #845')
  call g:assert.equals(&l:smartindent, 0,          'failed at #845')
  call g:assert.equals(&l:cindent,     0,          'failed at #845')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #845')

  %delete

  " #846
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #846')
  call g:assert.equals(getline(2),   '    [',      'failed at #846')
  call g:assert.equals(getline(3),   '    foo',    'failed at #846')
  call g:assert.equals(getline(4),   '    ]',      'failed at #846')
  call g:assert.equals(getline(5),   '    }',      'failed at #846')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #846')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #846')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #846')
  call g:assert.equals(&l:autoindent,  1,          'failed at #846')
  call g:assert.equals(&l:smartindent, 1,          'failed at #846')
  call g:assert.equals(&l:cindent,     0,          'failed at #846')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #846')

  %delete

  " #847
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #847')
  call g:assert.equals(getline(2),   '    [',      'failed at #847')
  call g:assert.equals(getline(3),   '    foo',    'failed at #847')
  call g:assert.equals(getline(4),   '    ]',      'failed at #847')
  call g:assert.equals(getline(5),   '    }',      'failed at #847')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #847')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #847')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #847')
  call g:assert.equals(&l:autoindent,  1,          'failed at #847')
  call g:assert.equals(&l:smartindent, 1,          'failed at #847')
  call g:assert.equals(&l:cindent,     1,          'failed at #847')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #847')

  %delete

  " #848
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #848')
  call g:assert.equals(getline(2),   '    [',          'failed at #848')
  call g:assert.equals(getline(3),   '    foo',        'failed at #848')
  call g:assert.equals(getline(4),   '    ]',          'failed at #848')
  call g:assert.equals(getline(5),   '    }',          'failed at #848')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #848')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #848')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #848')
  call g:assert.equals(&l:autoindent,  1,              'failed at #848')
  call g:assert.equals(&l:smartindent, 1,              'failed at #848')
  call g:assert.equals(&l:cindent,     1,              'failed at #848')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #848')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #849
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #849')
  call g:assert.equals(getline(2),   '        [',   'failed at #849')
  call g:assert.equals(getline(3),   '        foo', 'failed at #849')
  call g:assert.equals(getline(4),   '    ]',       'failed at #849')
  call g:assert.equals(getline(5),   '}',           'failed at #849')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #849')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #849')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #849')
  call g:assert.equals(&l:autoindent,  0,           'failed at #849')
  call g:assert.equals(&l:smartindent, 0,           'failed at #849')
  call g:assert.equals(&l:cindent,     0,           'failed at #849')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #849')

  %delete

  " #850
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #850')
  call g:assert.equals(getline(2),   '        [',   'failed at #850')
  call g:assert.equals(getline(3),   '        foo', 'failed at #850')
  call g:assert.equals(getline(4),   '    ]',       'failed at #850')
  call g:assert.equals(getline(5),   '}',           'failed at #850')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #850')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #850')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #850')
  call g:assert.equals(&l:autoindent,  1,           'failed at #850')
  call g:assert.equals(&l:smartindent, 0,           'failed at #850')
  call g:assert.equals(&l:cindent,     0,           'failed at #850')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #850')

  %delete

  " #851
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #851')
  call g:assert.equals(getline(2),   '        [',   'failed at #851')
  call g:assert.equals(getline(3),   '        foo', 'failed at #851')
  call g:assert.equals(getline(4),   '    ]',       'failed at #851')
  call g:assert.equals(getline(5),   '}',           'failed at #851')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #851')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #851')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #851')
  call g:assert.equals(&l:autoindent,  1,           'failed at #851')
  call g:assert.equals(&l:smartindent, 1,           'failed at #851')
  call g:assert.equals(&l:cindent,     0,           'failed at #851')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #851')

  %delete

  " #852
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #852')
  call g:assert.equals(getline(2),   '        [',   'failed at #852')
  call g:assert.equals(getline(3),   '        foo', 'failed at #852')
  call g:assert.equals(getline(4),   '    ]',       'failed at #852')
  call g:assert.equals(getline(5),   '}',           'failed at #852')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #852')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #852')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #852')
  call g:assert.equals(&l:autoindent,  1,           'failed at #852')
  call g:assert.equals(&l:smartindent, 1,           'failed at #852')
  call g:assert.equals(&l:cindent,     1,           'failed at #852')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #852')

  %delete

  " #853
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #853')
  call g:assert.equals(getline(2),   '        [',      'failed at #853')
  call g:assert.equals(getline(3),   '        foo',    'failed at #853')
  call g:assert.equals(getline(4),   '    ]',          'failed at #853')
  call g:assert.equals(getline(5),   '}',              'failed at #853')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #853')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #853')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #853')
  call g:assert.equals(&l:autoindent,  1,              'failed at #853')
  call g:assert.equals(&l:smartindent, 1,              'failed at #853')
  call g:assert.equals(&l:cindent,     1,              'failed at #853')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #853')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #854
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #854')
  call g:assert.equals(getline(2),   '    [',       'failed at #854')
  call g:assert.equals(getline(3),   '        foo', 'failed at #854')
  call g:assert.equals(getline(4),   '    ]',       'failed at #854')
  call g:assert.equals(getline(5),   '    }',       'failed at #854')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #854')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #854')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #854')
  call g:assert.equals(&l:autoindent,  0,           'failed at #854')
  call g:assert.equals(&l:smartindent, 0,           'failed at #854')
  call g:assert.equals(&l:cindent,     0,           'failed at #854')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #854')

  %delete

  " #855
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #855')
  call g:assert.equals(getline(2),   '    [',       'failed at #855')
  call g:assert.equals(getline(3),   '        foo', 'failed at #855')
  call g:assert.equals(getline(4),   '    ]',       'failed at #855')
  call g:assert.equals(getline(5),   '    }',       'failed at #855')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #855')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #855')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #855')
  call g:assert.equals(&l:autoindent,  1,           'failed at #855')
  call g:assert.equals(&l:smartindent, 0,           'failed at #855')
  call g:assert.equals(&l:cindent,     0,           'failed at #855')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #855')

  %delete

  " #856
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #856')
  call g:assert.equals(getline(2),   '    [',       'failed at #856')
  call g:assert.equals(getline(3),   '        foo', 'failed at #856')
  call g:assert.equals(getline(4),   '    ]',       'failed at #856')
  call g:assert.equals(getline(5),   '    }',       'failed at #856')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #856')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #856')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #856')
  call g:assert.equals(&l:autoindent,  1,           'failed at #856')
  call g:assert.equals(&l:smartindent, 1,           'failed at #856')
  call g:assert.equals(&l:cindent,     0,           'failed at #856')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #856')

  %delete

  " #857
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #857')
  call g:assert.equals(getline(2),   '    [',       'failed at #857')
  call g:assert.equals(getline(3),   '        foo', 'failed at #857')
  call g:assert.equals(getline(4),   '    ]',       'failed at #857')
  call g:assert.equals(getline(5),   '    }',       'failed at #857')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #857')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #857')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #857')
  call g:assert.equals(&l:autoindent,  1,           'failed at #857')
  call g:assert.equals(&l:smartindent, 1,           'failed at #857')
  call g:assert.equals(&l:cindent,     1,           'failed at #857')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #857')

  %delete

  " #858
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',              'failed at #858')
  call g:assert.equals(getline(2),   '    [',          'failed at #858')
  call g:assert.equals(getline(3),   '        foo',    'failed at #858')
  call g:assert.equals(getline(4),   '    ]',          'failed at #858')
  call g:assert.equals(getline(5),   '    }',          'failed at #858')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #858')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #858')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #858')
  call g:assert.equals(&l:autoindent,  1,              'failed at #858')
  call g:assert.equals(&l:smartindent, 1,              'failed at #858')
  call g:assert.equals(&l:cindent,     1,              'failed at #858')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #858')
endfunction
"}}}
function! s:suite.blockwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #859
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #859')
  call g:assert.equals(getline(2),   'foo',        'failed at #859')
  call g:assert.equals(getline(3),   '    }',      'failed at #859')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #859')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #859')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #859')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #859')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #859')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #860
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #860')
  call g:assert.equals(getline(2),   '    foo',    'failed at #860')
  call g:assert.equals(getline(3),   '    }',      'failed at #860')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #860')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #860')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #860')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #860')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #860')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #861
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #861')
  call g:assert.equals(getline(2),   'foo',        'failed at #861')
  call g:assert.equals(getline(3),   '    }',      'failed at #861')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #861')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #861')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #861')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #861')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #861')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #862
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #862')
  call g:assert.equals(getline(2),   'foo',        'failed at #862')
  call g:assert.equals(getline(3),   '    }',      'failed at #862')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #862')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #862')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #862')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #862')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #862')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #863
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',     'failed at #863')
  call g:assert.equals(getline(2),   '    foo',       'failed at #863')
  call g:assert.equals(getline(3),   '            }', 'failed at #863')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #863')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #863')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #863')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #863')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #863')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #864
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #864')
  call g:assert.equals(getline(2),   'foo',        'failed at #864')
  call g:assert.equals(getline(3),   '    }',      'failed at #864')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #864')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #864')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #864')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #864')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #864')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #865
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #865')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #865')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #865')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #865')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #865')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #865')

  %delete

  " #866
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #866')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #866')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #866')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #866')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #866')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #866')

  %delete

  " #867
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #867')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #867')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #867')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #867')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #867')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #867')

  %delete

  " #868
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #868')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #868')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #868')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #868')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #868')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #868')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #869
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #869')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #869')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #869')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #869')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #869')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #869')

  " #870
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #870')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #870')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #870')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #870')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #870')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #870')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #871
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #871')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #871')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #871')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #871')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #871')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #871')

  %delete

  " #872
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #872')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #872')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #872')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #872')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #872')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #872')

  %delete

  " #873
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #873')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #873')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #873')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #873')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #873')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #873')

  %delete

  " #874
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #874')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #874')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #874')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #874')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #874')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #874')

  %delete

  " #875
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #875')
  call g:assert.equals(getline(2),   'barbar',     'failed at #875')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #875')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #875')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #875')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #875')

  %delete

  " #876
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #876')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #876')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #876')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #876')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #876')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #876')

  %delete

  " #877
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #877')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #877')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #877')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #877')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #877')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #877')

  %delete

  " #878
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #878')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #878')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #878')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #878')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #878')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #878')

  %delete

  " #879
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #879')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #879')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #879')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #879')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #879')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #879')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #880
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #880')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #880')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #880')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #880')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #880')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #880')

  %delete

  " #881
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #881')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #881')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #881')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #881')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #881')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #881')

  %delete

  " #882
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #882')
  call g:assert.equals(getline(2),   '',           'failed at #882')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #882')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #882')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #882')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #882')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #883
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #883')
  call g:assert.equals(getline(2),   '[b]',        'failed at #883')
  call g:assert.equals(getline(3),   '[c]',        'failed at #883')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #883')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #883')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #883')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #884
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #884')
  call g:assert.equals(getline(2),   '[]',         'failed at #884')
  call g:assert.equals(getline(3),   '[]',         'failed at #884')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #884')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #884')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #884')

  %delete

  " #885
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #885')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #885')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #885')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #885')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #885')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #885')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #886
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #886')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #886')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #886')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #886')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #886')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #886')

  %delete

  " #887
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #887')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #887')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #887')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #887')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #887')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #887')

  %delete

  " #888
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #888')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #888')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #888')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #888')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #888')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #888')

  %delete

  " #889
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #889')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #889')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #889')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #889')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #889')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #889')

  %delete

  " #890
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #890')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #890')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #890')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #890')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #890')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #890')
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

  " #891
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #891')
  call g:assert.equals(getline(2), '"bar"', 'failed at #891')
  call g:assert.equals(getline(3), '"baz"', 'failed at #891')

  %delete

  " #892
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #892')
  call g:assert.equals(getline(2), '"bar"', 'failed at #892')
  call g:assert.equals(getline(3), '"baz"', 'failed at #892')

  %delete

  " #893
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #893')
  call g:assert.equals(getline(2), '"bar"', 'failed at #893')
  call g:assert.equals(getline(3), '"baz"', 'failed at #893')

  %delete

  " #894
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #894')
  call g:assert.equals(getline(2), '"bar"', 'failed at #894')
  call g:assert.equals(getline(3), '"baz"', 'failed at #894')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #895
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(α)',          'failed at #895')
  call g:assert.equals(getline(2), '(β)',          'failed at #895')
  call g:assert.equals(getline(3), '(γ)',          'failed at #895')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #895')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #895')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #895')

  " #896
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(aα)',         'failed at #896')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #896')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #896')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #896')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #896')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #896')

  " #897
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(α)',          'failed at #897')
  call g:assert.equals(getline(2), '(β)',          'failed at #897')
  call g:assert.equals(getline(3), '(γ)',          'failed at #897')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #897')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #897')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #897')

  " #898
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(aα)',         'failed at #898')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #898')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #898')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #898')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #898')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #898')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #899
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'αaα',          'failed at #899')
  call g:assert.equals(getline(2), 'αbα',          'failed at #899')
  call g:assert.equals(getline(3), 'αcα',          'failed at #899')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #899')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #899')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #899')

  " #900
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'ααα',          'failed at #900')
  call g:assert.equals(getline(2), 'αβα',          'failed at #900')
  call g:assert.equals(getline(3), 'αγα',          'failed at #900')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #900')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #900')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #900')

  " #901
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #901')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #901')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #901')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #901')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #901')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #901')

  " #902
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'αaα',          'failed at #902')
  call g:assert.equals(getline(2), 'αbα',          'failed at #902')
  call g:assert.equals(getline(3), 'αcα',          'failed at #902')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #902')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #902')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #902')

  " #903
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'ααα',          'failed at #903')
  call g:assert.equals(getline(2), 'αβα',          'failed at #903')
  call g:assert.equals(getline(3), 'αγα',          'failed at #903')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #903')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #903')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #903')

  " #904
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'αaαα',         'failed at #904')
  call g:assert.equals(getline(2), 'αbβα',         'failed at #904')
  call g:assert.equals(getline(3), 'αcγα',         'failed at #904')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #904')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #904')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #904')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #905
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #905')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #905')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #905')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #905')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #905')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #905')

  " #906
  call append(0, ['aαa', 'bβb', 'cγc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #906')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #906')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #906')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #906')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #906')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #906')

  " #907
  call append(0, ['aaαa', 'bbβb', 'ccγc'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #907')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #907')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #907')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #907')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #907')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #907')

  " #908
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aαaaα',        'failed at #908')
  call g:assert.equals(getline(2), 'aαbaα',        'failed at #908')
  call g:assert.equals(getline(3), 'aαcaα',        'failed at #908')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #908')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #908')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #908')

  " #909
  call append(0, ['ααα', 'βββ', 'γγγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'aααaα',        'failed at #909')
  call g:assert.equals(getline(2), 'aαβaα',        'failed at #909')
  call g:assert.equals(getline(3), 'aαγaα',        'failed at #909')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #909')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #909')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #909')

  " #910
  call append(0, ['αaαα', 'βbββ', 'γcγγ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'aαaαaα',       'failed at #910')
  call g:assert.equals(getline(2), 'aαbβaα',       'failed at #910')
  call g:assert.equals(getline(3), 'aαcγaα',       'failed at #910')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #910')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #910')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #910')

  unlet g:operator#sandwich#recipes

  " #911
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(“)',          'failed at #911')
  call g:assert.equals(getline(2), '(“)',          'failed at #911')
  call g:assert.equals(getline(3), '(“)',          'failed at #911')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #911')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #911')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #911')

  " #912
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(a“)',         'failed at #912')
  call g:assert.equals(getline(2), '(b“)',         'failed at #912')
  call g:assert.equals(getline(3), '(c“)',         'failed at #912')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #912')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #912')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #912')

  " #913
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsr("
  call g:assert.equals(getline(1), '(“)',          'failed at #913')
  call g:assert.equals(getline(2), '(“)',          'failed at #913')
  call g:assert.equals(getline(3), '(“)',          'failed at #913')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #913')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #913')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #913')

  " #914
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsr("
  call g:assert.equals(getline(1), '(a“)',         'failed at #914')
  call g:assert.equals(getline(2), '(b“)',         'failed at #914')
  call g:assert.equals(getline(3), '(c“)',         'failed at #914')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #914')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #914')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #914')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #915
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“a“',          'failed at #915')
  call g:assert.equals(getline(2), '“b“',          'failed at #915')
  call g:assert.equals(getline(3), '“c“',          'failed at #915')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #915')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #915')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #915')

  " #916
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“““',          'failed at #916')
  call g:assert.equals(getline(2), '“““',          'failed at #916')
  call g:assert.equals(getline(3), '“““',          'failed at #916')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #916')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #916')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #916')

  " #917
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), '“a““',         'failed at #917')
  call g:assert.equals(getline(2), '“b““',         'failed at #917')
  call g:assert.equals(getline(3), '“c““',         'failed at #917')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #917')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #917')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #917')

  " #918
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“a“',          'failed at #918')
  call g:assert.equals(getline(2), '“b“',          'failed at #918')
  call g:assert.equals(getline(3), '“c“',          'failed at #918')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #918')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #918')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #918')

  " #919
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), '“““',          'failed at #919')
  call g:assert.equals(getline(2), '“““',          'failed at #919')
  call g:assert.equals(getline(3), '“““',          'failed at #919')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #919')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #919')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #919')

  " #920
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), '“a““',         'failed at #920')
  call g:assert.equals(getline(2), '“b““',         'failed at #920')
  call g:assert.equals(getline(3), '“c““',         'failed at #920')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #920')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #920')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #920')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #921
  call append(0, ['aaa', 'bbb', 'ccc'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #921')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #921')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #921')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #921')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #921')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #921')

  " #922
  call append(0, ['a“a', 'b“b', 'c“c'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #922')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #922')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #922')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #922')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #922')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #922')

  " #923
  call append(0, ['aa“a', 'bb“b', 'cc“c'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #923')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #923')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #923')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #923')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #923')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #923')

  " #924
  call append(0, ['αaα', 'βbβ', 'γcγ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a“aa“',        'failed at #924')
  call g:assert.equals(getline(2), 'a“ba“',        'failed at #924')
  call g:assert.equals(getline(3), 'a“ca“',        'failed at #924')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #924')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #924')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #924')

  " #925
  call append(0, ['α“α', 'β“β', 'γ“γ'])
  execute "normal gg\<C-v>2l2jsra"
  call g:assert.equals(getline(1), 'a““a“',        'failed at #925')
  call g:assert.equals(getline(2), 'a““a“',        'failed at #925')
  call g:assert.equals(getline(3), 'a““a“',        'failed at #925')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #925')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #925')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #925')

  " #926
  call append(0, ['αa“α', 'βb“β', 'γc“γ'])
  execute "normal gg\<C-v>3l2jsra"
  call g:assert.equals(getline(1), 'a“a“a“',       'failed at #926')
  call g:assert.equals(getline(2), 'a“b“a“',       'failed at #926')
  call g:assert.equals(getline(3), 'a“c“a“',       'failed at #926')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #926')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #926')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #926')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #927
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #927')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #927')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #927')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #927')

  " #928
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #928')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #928')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #928')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #928')

  %delete

  """ keep
  " #929
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #929')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #929')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #929')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #929')

  " #930
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #930')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #930')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #930')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #930')

  %delete

  """ inner_tail
  " #931
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #931')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #931')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #931')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #931')

  " #932
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #932')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #932')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #932')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #932')

  %delete

  """ head
  " #933
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #933')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #933')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #933')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #933')

  " #934
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #934')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #934')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #934')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #934')

  %delete

  """ tail
  " #935
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #935')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #935')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #935')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #935')

  " #936
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #936')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #936')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #936')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #936')

  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #937
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #937')
  call g:assert.equals(getline(2), '"bar"', 'failed at #937')
  call g:assert.equals(getline(3), '"baz"', 'failed at #937')

  %delete

  " #938
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #938')
  call g:assert.equals(getline(2), '(bar)', 'failed at #938')
  call g:assert.equals(getline(3), '(baz)', 'failed at #938')

  %delete

  """ off
  " #939
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #939')
  call g:assert.equals(getline(2), '{bar}', 'failed at #939')
  call g:assert.equals(getline(3), '{baz}', 'failed at #939')

  %delete

  " #940
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #940')
  call g:assert.equals(getline(2), '"bar"', 'failed at #940')
  call g:assert.equals(getline(3), '"baz"', 'failed at #940')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #941
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #941')
  call g:assert.equals(getline(2), '"bar"', 'failed at #941')
  call g:assert.equals(getline(3), '"baz"', 'failed at #941')

  %delete

  " #942
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #942')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #942')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #942')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #943
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #943')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #943')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #943')

  %delete

  " #944
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #944')
  call g:assert.equals(getline(2), '"bar"', 'failed at #944')
  call g:assert.equals(getline(3), '"baz"', 'failed at #944')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ 1
  " #945
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #945')
  call g:assert.equals(getline(2), '(bar)', 'failed at #945')
  call g:assert.equals(getline(3), '(baz)', 'failed at #945')

  %delete

  " #946
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #946')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #946')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #946')

  %delete

  " #947
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #947')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #947')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #947')

  %delete

  " #948
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #948')
  call g:assert.equals(getline(2), '("bar")', 'failed at #948')
  call g:assert.equals(getline(3), '("baz")', 'failed at #948')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #949
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #949')
  call g:assert.equals(getline(2), '(bar)', 'failed at #949')
  call g:assert.equals(getline(3), '(baz)', 'failed at #949')

  %delete

  " #950
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #950')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #950')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #950')

  %delete

  " #951
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #951')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #951')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #951')

  %delete

  " #952
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #952')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #952')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #952')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #953
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #953')
  call g:assert.equals(getline(2), '(bar)', 'failed at #953')
  call g:assert.equals(getline(3), '(baz)', 'failed at #953')

  %delete

  " #954
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #954')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #954')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #954')

  %delete

  " #955
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #955')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #955')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #955')

  %delete

  " #956
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #956')
  call g:assert.equals(getline(2), '("bar")', 'failed at #956')
  call g:assert.equals(getline(3), '("baz")', 'failed at #956')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #957
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #957')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #957')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #957')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #958
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #958')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #958')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #958')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #959
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '', 'failed at #959')
  call g:assert.equals(getline(2), '', 'failed at #959')
  call g:assert.equals(getline(3), '', 'failed at #959')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #959
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #959')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #959')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #959')

  %delete

  """ on
  " #960
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #960')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #960')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #960')

  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ 0
  " #961
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #961')

  %delete

  """ 1
  " #962
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #962')

  %delete

  " #963
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #963')
  call g:assert.equals(getline(2), '"bar"', 'failed at #963')
  call g:assert.equals(getline(3), '"baz"', 'failed at #963')
  call g:assert.equals(exists(s:object), 0, 'failed at #963')

  %delete

  " #964
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #964')
  call g:assert.equals(getline(2), '"bar"', 'failed at #964')
  call g:assert.equals(getline(3), '"baz"', 'failed at #964')
  call g:assert.equals(exists(s:object), 0, 'failed at #964')

  %delete

  " #965
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #965')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #965')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #965')
  call g:assert.equals(exists(s:object), 0,     'failed at #965')

  %delete

  " #966
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #966')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #966')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #966')
  call g:assert.equals(exists(s:object), 0,     'failed at #966')

  %delete

  " #967
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #967')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #967')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #967')
  call g:assert.equals(exists(s:object), 0,     'failed at #967')

  %delete

  " #968
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #968')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #968')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #968')
  call g:assert.equals(exists(s:object), 0,     'failed at #968')

  %delete

  " #969
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrd"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #969')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #969')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #969')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'expr', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #964
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #964')
  call g:assert.equals(getline(2),   '[',          'failed at #964')
  call g:assert.equals(getline(3),   'foo',        'failed at #964')
  call g:assert.equals(getline(4),   ']',          'failed at #964')
  call g:assert.equals(getline(5),   '}',          'failed at #964')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #964')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #964')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #964')
  call g:assert.equals(&l:autoindent,  0,          'failed at #964')
  call g:assert.equals(&l:smartindent, 0,          'failed at #964')
  call g:assert.equals(&l:cindent,     0,          'failed at #964')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #964')

  %delete

  " #965
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #965')
  call g:assert.equals(getline(2),   '    [',      'failed at #965')
  call g:assert.equals(getline(3),   '    foo',    'failed at #965')
  call g:assert.equals(getline(4),   '    ]',      'failed at #965')
  call g:assert.equals(getline(5),   '    }',      'failed at #965')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #965')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #965')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #965')
  call g:assert.equals(&l:autoindent,  1,          'failed at #965')
  call g:assert.equals(&l:smartindent, 0,          'failed at #965')
  call g:assert.equals(&l:cindent,     0,          'failed at #965')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #965')

  %delete

  " #966
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #966')
  call g:assert.equals(getline(2),   '        [',   'failed at #966')
  call g:assert.equals(getline(3),   '        foo', 'failed at #966')
  call g:assert.equals(getline(4),   '    ]',       'failed at #966')
  call g:assert.equals(getline(5),   '}',           'failed at #966')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #966')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #966')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #966')
  call g:assert.equals(&l:autoindent,  1,           'failed at #966')
  call g:assert.equals(&l:smartindent, 1,           'failed at #966')
  call g:assert.equals(&l:cindent,     0,           'failed at #966')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #966')

  %delete

  " #967
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #967')
  call g:assert.equals(getline(2),   '    [',       'failed at #967')
  call g:assert.equals(getline(3),   '        foo', 'failed at #967')
  call g:assert.equals(getline(4),   '    ]',       'failed at #967')
  call g:assert.equals(getline(5),   '    }',       'failed at #967')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #967')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #967')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #967')
  call g:assert.equals(&l:autoindent,  1,           'failed at #967')
  call g:assert.equals(&l:smartindent, 1,           'failed at #967')
  call g:assert.equals(&l:cindent,     1,           'failed at #967')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #967')

  %delete

  " #968
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',           'failed at #968')
  call g:assert.equals(getline(2),   '            [',       'failed at #968')
  call g:assert.equals(getline(3),   '                foo', 'failed at #968')
  call g:assert.equals(getline(4),   '        ]',           'failed at #968')
  call g:assert.equals(getline(5),   '                }',   'failed at #968')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #968')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #968')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #968')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #968')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #968')
  call g:assert.equals(&l:cindent,     1,                   'failed at #968')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #968')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #969
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #969')
  call g:assert.equals(getline(2),   '[',          'failed at #969')
  call g:assert.equals(getline(3),   'foo',        'failed at #969')
  call g:assert.equals(getline(4),   ']',          'failed at #969')
  call g:assert.equals(getline(5),   '}',          'failed at #969')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #969')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #969')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #969')
  call g:assert.equals(&l:autoindent,  0,          'failed at #969')
  call g:assert.equals(&l:smartindent, 0,          'failed at #969')
  call g:assert.equals(&l:cindent,     0,          'failed at #969')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #969')

  %delete

  " #970
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #970')
  call g:assert.equals(getline(2),   '[',          'failed at #970')
  call g:assert.equals(getline(3),   'foo',        'failed at #970')
  call g:assert.equals(getline(4),   ']',          'failed at #970')
  call g:assert.equals(getline(5),   '}',          'failed at #970')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #970')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #970')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #970')
  call g:assert.equals(&l:autoindent,  1,          'failed at #970')
  call g:assert.equals(&l:smartindent, 0,          'failed at #970')
  call g:assert.equals(&l:cindent,     0,          'failed at #970')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #970')

  %delete

  " #971
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #971')
  call g:assert.equals(getline(2),   '[',          'failed at #971')
  call g:assert.equals(getline(3),   'foo',        'failed at #971')
  call g:assert.equals(getline(4),   ']',          'failed at #971')
  call g:assert.equals(getline(5),   '}',          'failed at #971')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #971')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #971')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #971')
  call g:assert.equals(&l:autoindent,  1,          'failed at #971')
  call g:assert.equals(&l:smartindent, 1,          'failed at #971')
  call g:assert.equals(&l:cindent,     0,          'failed at #971')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #971')

  %delete

  " #972
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #972')
  call g:assert.equals(getline(2),   '[',          'failed at #972')
  call g:assert.equals(getline(3),   'foo',        'failed at #972')
  call g:assert.equals(getline(4),   ']',          'failed at #972')
  call g:assert.equals(getline(5),   '}',          'failed at #972')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #972')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #972')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #972')
  call g:assert.equals(&l:autoindent,  1,          'failed at #972')
  call g:assert.equals(&l:smartindent, 1,          'failed at #972')
  call g:assert.equals(&l:cindent,     1,          'failed at #972')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #972')

  %delete

  " #973
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #973')
  call g:assert.equals(getline(2),   '[',              'failed at #973')
  call g:assert.equals(getline(3),   'foo',            'failed at #973')
  call g:assert.equals(getline(4),   ']',              'failed at #973')
  call g:assert.equals(getline(5),   '}',              'failed at #973')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #973')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #973')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #973')
  call g:assert.equals(&l:autoindent,  1,              'failed at #973')
  call g:assert.equals(&l:smartindent, 1,              'failed at #973')
  call g:assert.equals(&l:cindent,     1,              'failed at #973')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #973')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #974
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #974')
  call g:assert.equals(getline(2),   '    [',      'failed at #974')
  call g:assert.equals(getline(3),   '    foo',    'failed at #974')
  call g:assert.equals(getline(4),   '    ]',      'failed at #974')
  call g:assert.equals(getline(5),   '    }',      'failed at #974')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #974')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #974')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #974')
  call g:assert.equals(&l:autoindent,  0,          'failed at #974')
  call g:assert.equals(&l:smartindent, 0,          'failed at #974')
  call g:assert.equals(&l:cindent,     0,          'failed at #974')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #974')

  %delete

  " #975
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #975')
  call g:assert.equals(getline(2),   '    [',      'failed at #975')
  call g:assert.equals(getline(3),   '    foo',    'failed at #975')
  call g:assert.equals(getline(4),   '    ]',      'failed at #975')
  call g:assert.equals(getline(5),   '    }',      'failed at #975')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #975')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #975')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #975')
  call g:assert.equals(&l:autoindent,  1,          'failed at #975')
  call g:assert.equals(&l:smartindent, 0,          'failed at #975')
  call g:assert.equals(&l:cindent,     0,          'failed at #975')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #975')

  %delete

  " #976
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #976')
  call g:assert.equals(getline(2),   '    [',      'failed at #976')
  call g:assert.equals(getline(3),   '    foo',    'failed at #976')
  call g:assert.equals(getline(4),   '    ]',      'failed at #976')
  call g:assert.equals(getline(5),   '    }',      'failed at #976')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #976')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #976')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #976')
  call g:assert.equals(&l:autoindent,  1,          'failed at #976')
  call g:assert.equals(&l:smartindent, 1,          'failed at #976')
  call g:assert.equals(&l:cindent,     0,          'failed at #976')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #976')

  %delete

  " #977
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #977')
  call g:assert.equals(getline(2),   '    [',      'failed at #977')
  call g:assert.equals(getline(3),   '    foo',    'failed at #977')
  call g:assert.equals(getline(4),   '    ]',      'failed at #977')
  call g:assert.equals(getline(5),   '    }',      'failed at #977')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #977')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #977')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #977')
  call g:assert.equals(&l:autoindent,  1,          'failed at #977')
  call g:assert.equals(&l:smartindent, 1,          'failed at #977')
  call g:assert.equals(&l:cindent,     1,          'failed at #977')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #977')

  %delete

  " #978
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #978')
  call g:assert.equals(getline(2),   '    [',          'failed at #978')
  call g:assert.equals(getline(3),   '    foo',        'failed at #978')
  call g:assert.equals(getline(4),   '    ]',          'failed at #978')
  call g:assert.equals(getline(5),   '    }',          'failed at #978')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #978')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #978')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #978')
  call g:assert.equals(&l:autoindent,  1,              'failed at #978')
  call g:assert.equals(&l:smartindent, 1,              'failed at #978')
  call g:assert.equals(&l:cindent,     1,              'failed at #978')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #978')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #979
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #979')
  call g:assert.equals(getline(2),   '        [',   'failed at #979')
  call g:assert.equals(getline(3),   '        foo', 'failed at #979')
  call g:assert.equals(getline(4),   '    ]',       'failed at #979')
  call g:assert.equals(getline(5),   '}',           'failed at #979')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #979')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #979')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #979')
  call g:assert.equals(&l:autoindent,  0,           'failed at #979')
  call g:assert.equals(&l:smartindent, 0,           'failed at #979')
  call g:assert.equals(&l:cindent,     0,           'failed at #979')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #979')

  %delete

  " #980
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #980')
  call g:assert.equals(getline(2),   '        [',   'failed at #980')
  call g:assert.equals(getline(3),   '        foo', 'failed at #980')
  call g:assert.equals(getline(4),   '    ]',       'failed at #980')
  call g:assert.equals(getline(5),   '}',           'failed at #980')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #980')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #980')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #980')
  call g:assert.equals(&l:autoindent,  1,           'failed at #980')
  call g:assert.equals(&l:smartindent, 0,           'failed at #980')
  call g:assert.equals(&l:cindent,     0,           'failed at #980')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #980')

  %delete

  " #981
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #981')
  call g:assert.equals(getline(2),   '        [',   'failed at #981')
  call g:assert.equals(getline(3),   '        foo', 'failed at #981')
  call g:assert.equals(getline(4),   '    ]',       'failed at #981')
  call g:assert.equals(getline(5),   '}',           'failed at #981')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #981')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #981')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #981')
  call g:assert.equals(&l:autoindent,  1,           'failed at #981')
  call g:assert.equals(&l:smartindent, 1,           'failed at #981')
  call g:assert.equals(&l:cindent,     0,           'failed at #981')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #981')

  %delete

  " #982
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #982')
  call g:assert.equals(getline(2),   '        [',   'failed at #982')
  call g:assert.equals(getline(3),   '        foo', 'failed at #982')
  call g:assert.equals(getline(4),   '    ]',       'failed at #982')
  call g:assert.equals(getline(5),   '}',           'failed at #982')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #982')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #982')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #982')
  call g:assert.equals(&l:autoindent,  1,           'failed at #982')
  call g:assert.equals(&l:smartindent, 1,           'failed at #982')
  call g:assert.equals(&l:cindent,     1,           'failed at #982')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #982')

  %delete

  " #983
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #983')
  call g:assert.equals(getline(2),   '        [',      'failed at #983')
  call g:assert.equals(getline(3),   '        foo',    'failed at #983')
  call g:assert.equals(getline(4),   '    ]',          'failed at #983')
  call g:assert.equals(getline(5),   '}',              'failed at #983')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #983')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #983')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #983')
  call g:assert.equals(&l:autoindent,  1,              'failed at #983')
  call g:assert.equals(&l:smartindent, 1,              'failed at #983')
  call g:assert.equals(&l:cindent,     1,              'failed at #983')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #983')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #984
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #984')
  call g:assert.equals(getline(2),   '    [',       'failed at #984')
  call g:assert.equals(getline(3),   '        foo', 'failed at #984')
  call g:assert.equals(getline(4),   '    ]',       'failed at #984')
  call g:assert.equals(getline(5),   '    }',       'failed at #984')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #984')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #984')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #984')
  call g:assert.equals(&l:autoindent,  0,           'failed at #984')
  call g:assert.equals(&l:smartindent, 0,           'failed at #984')
  call g:assert.equals(&l:cindent,     0,           'failed at #984')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #984')

  %delete

  " #985
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #985')
  call g:assert.equals(getline(2),   '    [',       'failed at #985')
  call g:assert.equals(getline(3),   '        foo', 'failed at #985')
  call g:assert.equals(getline(4),   '    ]',       'failed at #985')
  call g:assert.equals(getline(5),   '    }',       'failed at #985')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #985')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #985')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #985')
  call g:assert.equals(&l:autoindent,  1,           'failed at #985')
  call g:assert.equals(&l:smartindent, 0,           'failed at #985')
  call g:assert.equals(&l:cindent,     0,           'failed at #985')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #985')

  %delete

  " #986
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #986')
  call g:assert.equals(getline(2),   '    [',       'failed at #986')
  call g:assert.equals(getline(3),   '        foo', 'failed at #986')
  call g:assert.equals(getline(4),   '    ]',       'failed at #986')
  call g:assert.equals(getline(5),   '    }',       'failed at #986')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #986')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #986')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #986')
  call g:assert.equals(&l:autoindent,  1,           'failed at #986')
  call g:assert.equals(&l:smartindent, 1,           'failed at #986')
  call g:assert.equals(&l:cindent,     0,           'failed at #986')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #986')

  %delete

  " #987
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #987')
  call g:assert.equals(getline(2),   '    [',       'failed at #987')
  call g:assert.equals(getline(3),   '        foo', 'failed at #987')
  call g:assert.equals(getline(4),   '    ]',       'failed at #987')
  call g:assert.equals(getline(5),   '    }',       'failed at #987')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #987')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #987')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #987')
  call g:assert.equals(&l:autoindent,  1,           'failed at #987')
  call g:assert.equals(&l:smartindent, 1,           'failed at #987')
  call g:assert.equals(&l:cindent,     1,           'failed at #987')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #987')

  %delete

  " #988
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',              'failed at #988')
  call g:assert.equals(getline(2),   '    [',          'failed at #988')
  call g:assert.equals(getline(3),   '        foo',    'failed at #988')
  call g:assert.equals(getline(4),   '    ]',          'failed at #988')
  call g:assert.equals(getline(5),   '    }',          'failed at #988')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #988')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #988')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #988')
  call g:assert.equals(&l:autoindent,  1,              'failed at #988')
  call g:assert.equals(&l:smartindent, 1,              'failed at #988')
  call g:assert.equals(&l:cindent,     1,              'failed at #988')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #988')
endfunction
"}}}
function! s:suite.blockwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']}
        \ ]

  """ cinkeys
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #989
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #989')
  call g:assert.equals(getline(2),   'foo',        'failed at #989')
  call g:assert.equals(getline(3),   '    }',      'failed at #989')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #989')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #989')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #989')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #989')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #989')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #990
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #990')
  call g:assert.equals(getline(2),   '    foo',    'failed at #990')
  call g:assert.equals(getline(3),   '    }',      'failed at #990')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #990')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #990')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #990')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #990')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #990')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #991
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #991')
  call g:assert.equals(getline(2),   'foo',        'failed at #991')
  call g:assert.equals(getline(3),   '    }',      'failed at #991')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #991')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #991')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #991')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #991')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #991')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #992
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #992')
  call g:assert.equals(getline(2),   'foo',        'failed at #992')
  call g:assert.equals(getline(3),   '    }',      'failed at #992')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #992')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #992')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #992')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #992')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #992')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #993
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',     'failed at #993')
  call g:assert.equals(getline(2),   '    foo',       'failed at #993')
  call g:assert.equals(getline(3),   '            }', 'failed at #993')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #993')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #993')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #993')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #993')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #993')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #994
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #994')
  call g:assert.equals(getline(2),   'foo',        'failed at #994')
  call g:assert.equals(getline(3),   '    }',      'failed at #994')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #994')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #994')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #994')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #994')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #994')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #995
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #995')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #995')

  " #996
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #996')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #996')

  " #997
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #997')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #997')

  " #998
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #998')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #998')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #999
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sr$"
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #999')

  " #1000
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sr$""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #1000')

  " #1001
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sr$"""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #1001')
endfunction
"}}}

" When a assigned region is invalid
function! s:suite.invalid_region() abort  "{{{
  nmap sr' <Plug>(operator-sandwich-replace)i'

  " #1002
  call setline('.', 'foo')
  normal 0lsr'"
  call g:assert.equals(getline('.'), 'foo',        'failed at #1002')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1002')

  nunmap sr'
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
