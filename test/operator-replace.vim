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
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #179
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #179')

  " #180
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #180')

  """ keep
  " #181
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #181')

  " #182
  normal lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #182')

  """ inner_tail
  " #183
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #183')

  " #184
  normal hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #184')

  """ head
  " #185
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #185')

  " #186
  normal 3lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #186')

  """ tail
  " #187
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #187')

  " #188
  normal 3hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #188')

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
  " #189
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #189')

  " #190
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #190')

  """ off
  " #191
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #191')

  " #192
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #192')

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
  " #193
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #193')

  " #194
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #194')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #195
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #195')

  " #196
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #196')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ 1
  " #197
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #197')

  " #198
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #198')

  " #199
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #199')

  " #200
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #200')

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
  " #201
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #201')

  " #202
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #202')

  " #203
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #203')

  " #204
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #204')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #205
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #205')

  " #206
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #206')

  " #207
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #207')

  " #208
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #208')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #209
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #209')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #210
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #210')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])

  " #211
  call setline('.', '[(foo)]')
  normal 0ffsra("
  call g:assert.equals(getline('.'), '[]', 'failed at #211')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #212
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #212')
  call g:assert.equals(getline(2),   'foo',        'failed at #212')
  call g:assert.equals(getline(3),   ']',          'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #212')

  %delete

  " #213
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #213')
  call g:assert.equals(getline(2),   'foo',        'failed at #213')
  call g:assert.equals(getline(3),   ']',          'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #213')

  %delete

  " #214
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #214')
  call g:assert.equals(getline(2),   'foo',        'failed at #214')
  call g:assert.equals(getline(3),   'aa]',        'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #214')

  %delete

  " #215
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #215')
  call g:assert.equals(getline(2),   'foo',        'failed at #215')
  call g:assert.equals(getline(3),   ']',          'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #215')

  %delete

  " #216
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #216')
  call g:assert.equals(getline(2),   'foo',        'failed at #216')
  call g:assert.equals(getline(3),   'aa]',        'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #216')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #217
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #217')
  call g:assert.equals(getline(2),   'foo',        'failed at #217')
  call g:assert.equals(getline(3),   ']',          'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #217')

  %delete

  " #218
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #218')
  call g:assert.equals(getline(2),   'foo',        'failed at #218')
  call g:assert.equals(getline(3),   ']',          'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #218')

  %delete

  " #219
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #219')
  call g:assert.equals(getline(2),   'foo',        'failed at #219')
  call g:assert.equals(getline(3),   ']',          'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #219')

  %delete

  " #220
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #220')
  call g:assert.equals(getline(2),   '[',          'failed at #220')
  call g:assert.equals(getline(3),   'bb',         'failed at #220')
  call g:assert.equals(getline(4),   '',           'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #220')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #221
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #221')

  %delete

  """ on
  " #222
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #222')

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
  " #223
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #223')

  """ 1
  " #224
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3', 'failed at #224')

  " #225
  call setline('.', '"foo"')
  normal 0sra"b
  call g:assert.equals(getline('.'), '"foo"', 'failed at #225')
  call g:assert.equals(exists(s:object), 0,   'failed at #225')

  " #226
  call setline('.', '"foo"')
  normal 0sra"c
  call g:assert.equals(getline('.'), '"foo"', 'failed at #226')
  call g:assert.equals(exists(s:object), 0,   'failed at #226')

  " #227
  call setline('.', '"''foo''"')
  normal 02sra"ab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #227')
  call g:assert.equals(exists(s:object), 0,       'failed at #227')

  " #228
  call setline('.', '"''foo''"')
  normal 02sra"ac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #228')
  call g:assert.equals(exists(s:object), 0,       'failed at #228')

  " #229
  call setline('.', '"''foo''"')
  normal 02sra"ba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #229')
  call g:assert.equals(exists(s:object), 0,       'failed at #229')

  " #230
  call setline('.', '"''foo''"')
  normal 02sra"ca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #230')
  call g:assert.equals(exists(s:object), 0,       'failed at #230')

  " #231
  call setline('.', '"foo"')
  normal 0sra"d
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #231')

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

  " #232
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #232')
  call g:assert.equals(getline(2),   '[',          'failed at #232')
  call g:assert.equals(getline(3),   'foo',        'failed at #232')
  call g:assert.equals(getline(4),   ']',          'failed at #232')
  call g:assert.equals(getline(5),   '}',          'failed at #232')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #232')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #232')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #232')
  call g:assert.equals(&l:autoindent,  0,          'failed at #232')
  call g:assert.equals(&l:smartindent, 0,          'failed at #232')
  call g:assert.equals(&l:cindent,     0,          'failed at #232')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #232')

  %delete

  " #233
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #233')
  call g:assert.equals(getline(2),   '    [',      'failed at #233')
  call g:assert.equals(getline(3),   '    foo',    'failed at #233')
  call g:assert.equals(getline(4),   '    ]',      'failed at #233')
  call g:assert.equals(getline(5),   '    }',      'failed at #233')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #233')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #233')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #233')
  call g:assert.equals(&l:autoindent,  1,          'failed at #233')
  call g:assert.equals(&l:smartindent, 0,          'failed at #233')
  call g:assert.equals(&l:cindent,     0,          'failed at #233')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #233')

  %delete

  " #234
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #234')
  call g:assert.equals(getline(2),   '        [',   'failed at #234')
  call g:assert.equals(getline(3),   '        foo', 'failed at #234')
  call g:assert.equals(getline(4),   '    ]',       'failed at #234')
  call g:assert.equals(getline(5),   '}',           'failed at #234')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #234')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #234')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #234')
  call g:assert.equals(&l:autoindent,  1,           'failed at #234')
  call g:assert.equals(&l:smartindent, 1,           'failed at #234')
  call g:assert.equals(&l:cindent,     0,           'failed at #234')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #234')

  %delete

  " #235
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #235')
  call g:assert.equals(getline(2),   '    [',       'failed at #235')
  call g:assert.equals(getline(3),   '        foo', 'failed at #235')
  call g:assert.equals(getline(4),   '    ]',       'failed at #235')
  call g:assert.equals(getline(5),   '    }',       'failed at #235')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #235')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #235')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #235')
  call g:assert.equals(&l:autoindent,  1,           'failed at #235')
  call g:assert.equals(&l:smartindent, 1,           'failed at #235')
  call g:assert.equals(&l:cindent,     1,           'failed at #235')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #235')

  %delete

  " #236
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',           'failed at #236')
  call g:assert.equals(getline(2),   '            [',       'failed at #236')
  call g:assert.equals(getline(3),   '                foo', 'failed at #236')
  call g:assert.equals(getline(4),   '        ]',           'failed at #236')
  call g:assert.equals(getline(5),   '                }',   'failed at #236')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #236')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #236')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #236')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #236')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #236')
  call g:assert.equals(&l:cindent,     1,                   'failed at #236')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #236')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #237
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #237')
  call g:assert.equals(getline(2),   '[',          'failed at #237')
  call g:assert.equals(getline(3),   'foo',        'failed at #237')
  call g:assert.equals(getline(4),   ']',          'failed at #237')
  call g:assert.equals(getline(5),   '}',          'failed at #237')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #237')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #237')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #237')
  call g:assert.equals(&l:autoindent,  0,          'failed at #237')
  call g:assert.equals(&l:smartindent, 0,          'failed at #237')
  call g:assert.equals(&l:cindent,     0,          'failed at #237')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #237')

  %delete

  " #238
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #238')
  call g:assert.equals(getline(2),   '[',          'failed at #238')
  call g:assert.equals(getline(3),   'foo',        'failed at #238')
  call g:assert.equals(getline(4),   ']',          'failed at #238')
  call g:assert.equals(getline(5),   '}',          'failed at #238')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #238')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #238')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #238')
  call g:assert.equals(&l:autoindent,  1,          'failed at #238')
  call g:assert.equals(&l:smartindent, 0,          'failed at #238')
  call g:assert.equals(&l:cindent,     0,          'failed at #238')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #238')

  %delete

  " #239
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #239')
  call g:assert.equals(getline(2),   '[',          'failed at #239')
  call g:assert.equals(getline(3),   'foo',        'failed at #239')
  call g:assert.equals(getline(4),   ']',          'failed at #239')
  call g:assert.equals(getline(5),   '}',          'failed at #239')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #239')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #239')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #239')
  call g:assert.equals(&l:autoindent,  1,          'failed at #239')
  call g:assert.equals(&l:smartindent, 1,          'failed at #239')
  call g:assert.equals(&l:cindent,     0,          'failed at #239')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #239')

  %delete

  " #240
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #240')
  call g:assert.equals(getline(2),   '[',          'failed at #240')
  call g:assert.equals(getline(3),   'foo',        'failed at #240')
  call g:assert.equals(getline(4),   ']',          'failed at #240')
  call g:assert.equals(getline(5),   '}',          'failed at #240')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #240')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #240')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #240')
  call g:assert.equals(&l:autoindent,  1,          'failed at #240')
  call g:assert.equals(&l:smartindent, 1,          'failed at #240')
  call g:assert.equals(&l:cindent,     1,          'failed at #240')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #240')

  %delete

  " #241
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #241')
  call g:assert.equals(getline(2),   '[',              'failed at #241')
  call g:assert.equals(getline(3),   'foo',            'failed at #241')
  call g:assert.equals(getline(4),   ']',              'failed at #241')
  call g:assert.equals(getline(5),   '}',              'failed at #241')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #241')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #241')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #241')
  call g:assert.equals(&l:autoindent,  1,              'failed at #241')
  call g:assert.equals(&l:smartindent, 1,              'failed at #241')
  call g:assert.equals(&l:cindent,     1,              'failed at #241')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #241')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #242
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #242')
  call g:assert.equals(getline(2),   '    [',      'failed at #242')
  call g:assert.equals(getline(3),   '    foo',    'failed at #242')
  call g:assert.equals(getline(4),   '    ]',      'failed at #242')
  call g:assert.equals(getline(5),   '    }',      'failed at #242')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #242')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #242')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #242')
  call g:assert.equals(&l:autoindent,  0,          'failed at #242')
  call g:assert.equals(&l:smartindent, 0,          'failed at #242')
  call g:assert.equals(&l:cindent,     0,          'failed at #242')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #242')

  %delete

  " #243
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #243')
  call g:assert.equals(getline(2),   '    [',      'failed at #243')
  call g:assert.equals(getline(3),   '    foo',    'failed at #243')
  call g:assert.equals(getline(4),   '    ]',      'failed at #243')
  call g:assert.equals(getline(5),   '    }',      'failed at #243')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #243')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #243')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #243')
  call g:assert.equals(&l:autoindent,  1,          'failed at #243')
  call g:assert.equals(&l:smartindent, 0,          'failed at #243')
  call g:assert.equals(&l:cindent,     0,          'failed at #243')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #243')

  %delete

  " #244
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #244')
  call g:assert.equals(getline(2),   '    [',      'failed at #244')
  call g:assert.equals(getline(3),   '    foo',    'failed at #244')
  call g:assert.equals(getline(4),   '    ]',      'failed at #244')
  call g:assert.equals(getline(5),   '    }',      'failed at #244')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #244')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #244')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #244')
  call g:assert.equals(&l:autoindent,  1,          'failed at #244')
  call g:assert.equals(&l:smartindent, 1,          'failed at #244')
  call g:assert.equals(&l:cindent,     0,          'failed at #244')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #244')

  %delete

  " #245
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #245')
  call g:assert.equals(getline(2),   '    [',      'failed at #245')
  call g:assert.equals(getline(3),   '    foo',    'failed at #245')
  call g:assert.equals(getline(4),   '    ]',      'failed at #245')
  call g:assert.equals(getline(5),   '    }',      'failed at #245')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #245')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #245')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #245')
  call g:assert.equals(&l:autoindent,  1,          'failed at #245')
  call g:assert.equals(&l:smartindent, 1,          'failed at #245')
  call g:assert.equals(&l:cindent,     1,          'failed at #245')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #245')

  %delete

  " #246
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #246')
  call g:assert.equals(getline(2),   '    [',          'failed at #246')
  call g:assert.equals(getline(3),   '    foo',        'failed at #246')
  call g:assert.equals(getline(4),   '    ]',          'failed at #246')
  call g:assert.equals(getline(5),   '    }',          'failed at #246')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #246')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #246')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #246')
  call g:assert.equals(&l:autoindent,  1,              'failed at #246')
  call g:assert.equals(&l:smartindent, 1,              'failed at #246')
  call g:assert.equals(&l:cindent,     1,              'failed at #246')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #246')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #247
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #247')
  call g:assert.equals(getline(2),   '        [',   'failed at #247')
  call g:assert.equals(getline(3),   '        foo', 'failed at #247')
  call g:assert.equals(getline(4),   '    ]',       'failed at #247')
  call g:assert.equals(getline(5),   '}',           'failed at #247')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #247')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #247')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #247')
  call g:assert.equals(&l:autoindent,  0,           'failed at #247')
  call g:assert.equals(&l:smartindent, 0,           'failed at #247')
  call g:assert.equals(&l:cindent,     0,           'failed at #247')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #247')

  %delete

  " #248
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #248')
  call g:assert.equals(getline(2),   '        [',   'failed at #248')
  call g:assert.equals(getline(3),   '        foo', 'failed at #248')
  call g:assert.equals(getline(4),   '    ]',       'failed at #248')
  call g:assert.equals(getline(5),   '}',           'failed at #248')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #248')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #248')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #248')
  call g:assert.equals(&l:autoindent,  1,           'failed at #248')
  call g:assert.equals(&l:smartindent, 0,           'failed at #248')
  call g:assert.equals(&l:cindent,     0,           'failed at #248')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #248')

  %delete

  " #249
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #249')
  call g:assert.equals(getline(2),   '        [',   'failed at #249')
  call g:assert.equals(getline(3),   '        foo', 'failed at #249')
  call g:assert.equals(getline(4),   '    ]',       'failed at #249')
  call g:assert.equals(getline(5),   '}',           'failed at #249')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #249')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #249')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #249')
  call g:assert.equals(&l:autoindent,  1,           'failed at #249')
  call g:assert.equals(&l:smartindent, 1,           'failed at #249')
  call g:assert.equals(&l:cindent,     0,           'failed at #249')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #249')

  %delete

  " #250
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #250')
  call g:assert.equals(getline(2),   '        [',   'failed at #250')
  call g:assert.equals(getline(3),   '        foo', 'failed at #250')
  call g:assert.equals(getline(4),   '    ]',       'failed at #250')
  call g:assert.equals(getline(5),   '}',           'failed at #250')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #250')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #250')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #250')
  call g:assert.equals(&l:autoindent,  1,           'failed at #250')
  call g:assert.equals(&l:smartindent, 1,           'failed at #250')
  call g:assert.equals(&l:cindent,     1,           'failed at #250')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #250')

  %delete

  " #251
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #251')
  call g:assert.equals(getline(2),   '        [',      'failed at #251')
  call g:assert.equals(getline(3),   '        foo',    'failed at #251')
  call g:assert.equals(getline(4),   '    ]',          'failed at #251')
  call g:assert.equals(getline(5),   '}',              'failed at #251')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #251')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #251')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #251')
  call g:assert.equals(&l:autoindent,  1,              'failed at #251')
  call g:assert.equals(&l:smartindent, 1,              'failed at #251')
  call g:assert.equals(&l:cindent,     1,              'failed at #251')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #251')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #252
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #252')
  call g:assert.equals(getline(2),   '    [',       'failed at #252')
  call g:assert.equals(getline(3),   '        foo', 'failed at #252')
  call g:assert.equals(getline(4),   '    ]',       'failed at #252')
  call g:assert.equals(getline(5),   '    }',       'failed at #252')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #252')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #252')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #252')
  call g:assert.equals(&l:autoindent,  0,           'failed at #252')
  call g:assert.equals(&l:smartindent, 0,           'failed at #252')
  call g:assert.equals(&l:cindent,     0,           'failed at #252')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #252')

  %delete

  " #253
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #253')
  call g:assert.equals(getline(2),   '    [',       'failed at #253')
  call g:assert.equals(getline(3),   '        foo', 'failed at #253')
  call g:assert.equals(getline(4),   '    ]',       'failed at #253')
  call g:assert.equals(getline(5),   '    }',       'failed at #253')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #253')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #253')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #253')
  call g:assert.equals(&l:autoindent,  1,           'failed at #253')
  call g:assert.equals(&l:smartindent, 0,           'failed at #253')
  call g:assert.equals(&l:cindent,     0,           'failed at #253')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #253')

  %delete

  " #254
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #254')
  call g:assert.equals(getline(2),   '    [',       'failed at #254')
  call g:assert.equals(getline(3),   '        foo', 'failed at #254')
  call g:assert.equals(getline(4),   '    ]',       'failed at #254')
  call g:assert.equals(getline(5),   '    }',       'failed at #254')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #254')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #254')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #254')
  call g:assert.equals(&l:autoindent,  1,           'failed at #254')
  call g:assert.equals(&l:smartindent, 1,           'failed at #254')
  call g:assert.equals(&l:cindent,     0,           'failed at #254')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #254')

  %delete

  " #255
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #255')
  call g:assert.equals(getline(2),   '    [',       'failed at #255')
  call g:assert.equals(getline(3),   '        foo', 'failed at #255')
  call g:assert.equals(getline(4),   '    ]',       'failed at #255')
  call g:assert.equals(getline(5),   '    }',       'failed at #255')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #255')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #255')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #255')
  call g:assert.equals(&l:autoindent,  1,           'failed at #255')
  call g:assert.equals(&l:smartindent, 1,           'failed at #255')
  call g:assert.equals(&l:cindent,     1,           'failed at #255')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #255')

  %delete

  " #256
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',              'failed at #256')
  call g:assert.equals(getline(2),   '    [',          'failed at #256')
  call g:assert.equals(getline(3),   '        foo',    'failed at #256')
  call g:assert.equals(getline(4),   '    ]',          'failed at #256')
  call g:assert.equals(getline(5),   '    }',          'failed at #256')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #256')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #256')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #256')
  call g:assert.equals(&l:autoindent,  1,              'failed at #256')
  call g:assert.equals(&l:smartindent, 1,              'failed at #256')
  call g:assert.equals(&l:cindent,     1,              'failed at #256')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #256')
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

  " #257
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #257')
  call g:assert.equals(getline(2),   'foo',        'failed at #257')
  call g:assert.equals(getline(3),   '    }',      'failed at #257')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #257')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #257')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #257')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #257')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #258
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #258')
  call g:assert.equals(getline(2),   '    foo',    'failed at #258')
  call g:assert.equals(getline(3),   '    }',      'failed at #258')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #258')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #258')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #258')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #258')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #259
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #259')
  call g:assert.equals(getline(2),   'foo',        'failed at #259')
  call g:assert.equals(getline(3),   '    }',      'failed at #259')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #259')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #259')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #259')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #259')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #260
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #260')
  call g:assert.equals(getline(2),   'foo',        'failed at #260')
  call g:assert.equals(getline(3),   '    }',      'failed at #260')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #260')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #260')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #260')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #260')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #260')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #261
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',     'failed at #261')
  call g:assert.equals(getline(2),   '    foo',       'failed at #261')
  call g:assert.equals(getline(3),   '            }', 'failed at #261')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #261')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #261')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #261')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #261')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #261')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #262
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #262')
  call g:assert.equals(getline(2),   'foo',        'failed at #262')
  call g:assert.equals(getline(3),   '    }',      'failed at #262')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #262')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #262')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #262')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #262')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #262')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #263
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #263')

  " #264
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #264')

  " #265
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #265')

  " #266
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #266')

  " #267
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #267')

  " #268
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #268')

  " #269
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #269')

  " #270
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #270')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #271
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #271')

  " #272
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #272')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #272')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #273
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #273')

  " #274
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #274')

  " #275
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #275')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #275')

  " #276
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #276')
  call g:assert.equals(getline(2),   'bar',        'failed at #276')
  call g:assert.equals(getline(3),   'baz]',       'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #276')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #277
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #277')

  %delete

  " #278
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #278')
  call g:assert.equals(getline(2),   'a',          'failed at #278')
  call g:assert.equals(getline(3),   ']',          'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #278')

  %delete

  " #279
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #279')
  call g:assert.equals(getline(2),   ']',          'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #279')

  %delete

  " #280
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #280')
  call g:assert.equals(getline(2),   'a]',         'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #280')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #281
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #281')

  " #282
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #283')
  call g:assert.equals(getline(2),   ']',          'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #283')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #284
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #284')

  " #285
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #285')

  " #286
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #286')

  " #287
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #287')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #287')

  " #288
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #288')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #288')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #289
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #289')

  %delete

  " #290
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #290')

  %delete

  " #291
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #291')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #291')
  call g:assert.equals(getline(3),   'aa',         'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #291')

  %delete

  " #292
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #292')
  call g:assert.equals(getline(2),   'bbb',        'failed at #292')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #292')
  call g:assert.equals(getline(4),   'bbb',        'failed at #292')
  call g:assert.equals(getline(5),   'bb',         'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #292')
endfunction
"}}}
function! s:suite.charwise_x_external_textobj() abort"{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #293
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #293')

  " #294
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #294')

  " #295
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #295')

  " #296
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #296')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #297
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #297')

  " #298
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')

  """ keep
  " #299
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #299')

  " #300
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #300')

  """ inner_tail
  " #301
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #301')

  " #302
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #302')

  """ head
  " #303
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #303')

  " #304
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #304')

  """ tail
  " #305
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #305')

  " #306
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #306')

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
  " #307
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #307')

  " #308
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #308')

  """ off
  " #309
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #309')

  " #310
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #310')

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
  " #311
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #311')

  " #312
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #312')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #313
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #313')

  " #314
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #314')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ 1
  " #315
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #315')

  " #316
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #316')

  " #317
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #317')

  " #318
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #318')

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
  " #319
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #319')

  " #320
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #320')

  " #321
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #321')

  " #322
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #322')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #323
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #323')

  " #324
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #324')

  " #325
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #325')

  " #326
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #326')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #327
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #327')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #328
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #328')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[d`]'])

  " #329
  call setline('.', '[(foo)]')
  normal 0ffva(sr"
  call g:assert.equals(getline('.'), '[]', 'failed at #329')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #330
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #330')
  call g:assert.equals(getline(2),   'foo',        'failed at #330')
  call g:assert.equals(getline(3),   ']',          'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #330')

  %delete

  " #331
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #331')
  call g:assert.equals(getline(2),   'foo',        'failed at #331')
  call g:assert.equals(getline(3),   ']',          'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #331')

  %delete

  " #332
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #332')
  call g:assert.equals(getline(2),   'foo',        'failed at #332')
  call g:assert.equals(getline(3),   'aa]',        'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #332')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #332')

  %delete

  " #333
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #333')
  call g:assert.equals(getline(2),   'foo',        'failed at #333')
  call g:assert.equals(getline(3),   ']',          'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #333')

  %delete

  " #334
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #334')
  call g:assert.equals(getline(2),   'foo',        'failed at #334')
  call g:assert.equals(getline(3),   'aa]',        'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #334')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #335
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #335')
  call g:assert.equals(getline(2),   'foo',        'failed at #335')
  call g:assert.equals(getline(3),   ']',          'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #335')

  %delete

  " #336
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #336')
  call g:assert.equals(getline(2),   'foo',        'failed at #336')
  call g:assert.equals(getline(3),   ']',          'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #336')

  %delete

  " #337
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #337')
  call g:assert.equals(getline(2),   'foo',        'failed at #337')
  call g:assert.equals(getline(3),   ']',          'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #337')

  %delete

  " #338
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #338')
  call g:assert.equals(getline(2),   '[',          'failed at #338')
  call g:assert.equals(getline(3),   'bb',         'failed at #338')
  call g:assert.equals(getline(4),   '',           'failed at #338')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #338')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #339
  call setline('.', '"""foo"""')
  normal 0v$3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #339')

  %delete

  """ on
  " #340
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 0v$3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #340')

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
  " #341
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #341')

  """ 1
  " #342
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0va"sra
  call g:assert.equals(getline('.'), '2foo3', 'failed at #342')

  " #343
  call setline('.', '"foo"')
  normal 0va"srb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #343')
  call g:assert.equals(exists(s:object), 0,   'failed at #343')

  " #344
  call setline('.', '"foo"')
  normal 0va"src
  call g:assert.equals(getline('.'), '"foo"', 'failed at #344')
  call g:assert.equals(exists(s:object), 0,   'failed at #344')

  " #345
  call setline('.', '"''foo''"')
  normal 0va"2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #345')
  call g:assert.equals(exists(s:object), 0,       'failed at #345')

  " #346
  call setline('.', '"''foo''"')
  normal 0va"2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #346')
  call g:assert.equals(exists(s:object), 0,       'failed at #346')

  " #347
  call setline('.', '"''foo''"')
  normal 0va"2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #347')
  call g:assert.equals(exists(s:object), 0,       'failed at #347')

  " #348
  call setline('.', '"''foo''"')
  normal 0va"2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #348')
  call g:assert.equals(exists(s:object), 0,       'failed at #348')

  " #349
  call setline('.', '"foo"')
  normal 0va"srd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #349')

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

  " #350
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #350')
  call g:assert.equals(getline(2),   '[',          'failed at #350')
  call g:assert.equals(getline(3),   'foo',        'failed at #350')
  call g:assert.equals(getline(4),   ']',          'failed at #350')
  call g:assert.equals(getline(5),   '}',          'failed at #350')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #350')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #350')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #350')
  call g:assert.equals(&l:autoindent,  0,          'failed at #350')
  call g:assert.equals(&l:smartindent, 0,          'failed at #350')
  call g:assert.equals(&l:cindent,     0,          'failed at #350')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #350')

  %delete

  " #351
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #351')
  call g:assert.equals(getline(2),   '    [',      'failed at #351')
  call g:assert.equals(getline(3),   '    foo',    'failed at #351')
  call g:assert.equals(getline(4),   '    ]',      'failed at #351')
  call g:assert.equals(getline(5),   '    }',      'failed at #351')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #351')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #351')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #351')
  call g:assert.equals(&l:autoindent,  1,          'failed at #351')
  call g:assert.equals(&l:smartindent, 0,          'failed at #351')
  call g:assert.equals(&l:cindent,     0,          'failed at #351')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #351')

  %delete

  " #352
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #352')
  call g:assert.equals(getline(2),   '        [',   'failed at #352')
  call g:assert.equals(getline(3),   '        foo', 'failed at #352')
  call g:assert.equals(getline(4),   '    ]',       'failed at #352')
  call g:assert.equals(getline(5),   '}',           'failed at #352')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #352')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #352')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #352')
  call g:assert.equals(&l:autoindent,  1,           'failed at #352')
  call g:assert.equals(&l:smartindent, 1,           'failed at #352')
  call g:assert.equals(&l:cindent,     0,           'failed at #352')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #352')

  %delete

  " #353
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #353')
  call g:assert.equals(getline(2),   '    [',       'failed at #353')
  call g:assert.equals(getline(3),   '        foo', 'failed at #353')
  call g:assert.equals(getline(4),   '    ]',       'failed at #353')
  call g:assert.equals(getline(5),   '    }',       'failed at #353')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #353')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #353')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #353')
  call g:assert.equals(&l:autoindent,  1,           'failed at #353')
  call g:assert.equals(&l:smartindent, 1,           'failed at #353')
  call g:assert.equals(&l:cindent,     1,           'failed at #353')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #353')

  %delete

  " #354
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',           'failed at #354')
  call g:assert.equals(getline(2),   '            [',       'failed at #354')
  call g:assert.equals(getline(3),   '                foo', 'failed at #354')
  call g:assert.equals(getline(4),   '        ]',           'failed at #354')
  call g:assert.equals(getline(5),   '                }',   'failed at #354')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #354')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #354')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #354')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #354')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #354')
  call g:assert.equals(&l:cindent,     1,                   'failed at #354')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #354')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #355
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #355')
  call g:assert.equals(getline(2),   '[',          'failed at #355')
  call g:assert.equals(getline(3),   'foo',        'failed at #355')
  call g:assert.equals(getline(4),   ']',          'failed at #355')
  call g:assert.equals(getline(5),   '}',          'failed at #355')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #355')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #355')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #355')
  call g:assert.equals(&l:autoindent,  0,          'failed at #355')
  call g:assert.equals(&l:smartindent, 0,          'failed at #355')
  call g:assert.equals(&l:cindent,     0,          'failed at #355')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #355')

  %delete

  " #356
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #356')
  call g:assert.equals(getline(2),   '[',          'failed at #356')
  call g:assert.equals(getline(3),   'foo',        'failed at #356')
  call g:assert.equals(getline(4),   ']',          'failed at #356')
  call g:assert.equals(getline(5),   '}',          'failed at #356')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #356')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #356')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #356')
  call g:assert.equals(&l:autoindent,  1,          'failed at #356')
  call g:assert.equals(&l:smartindent, 0,          'failed at #356')
  call g:assert.equals(&l:cindent,     0,          'failed at #356')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #356')

  %delete

  " #357
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #357')
  call g:assert.equals(getline(2),   '[',          'failed at #357')
  call g:assert.equals(getline(3),   'foo',        'failed at #357')
  call g:assert.equals(getline(4),   ']',          'failed at #357')
  call g:assert.equals(getline(5),   '}',          'failed at #357')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #357')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #357')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #357')
  call g:assert.equals(&l:autoindent,  1,          'failed at #357')
  call g:assert.equals(&l:smartindent, 1,          'failed at #357')
  call g:assert.equals(&l:cindent,     0,          'failed at #357')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #357')

  %delete

  " #358
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #358')
  call g:assert.equals(getline(2),   '[',          'failed at #358')
  call g:assert.equals(getline(3),   'foo',        'failed at #358')
  call g:assert.equals(getline(4),   ']',          'failed at #358')
  call g:assert.equals(getline(5),   '}',          'failed at #358')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #358')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #358')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #358')
  call g:assert.equals(&l:autoindent,  1,          'failed at #358')
  call g:assert.equals(&l:smartindent, 1,          'failed at #358')
  call g:assert.equals(&l:cindent,     1,          'failed at #358')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #358')

  %delete

  " #359
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #359')
  call g:assert.equals(getline(2),   '[',              'failed at #359')
  call g:assert.equals(getline(3),   'foo',            'failed at #359')
  call g:assert.equals(getline(4),   ']',              'failed at #359')
  call g:assert.equals(getline(5),   '}',              'failed at #359')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #359')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #359')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #359')
  call g:assert.equals(&l:autoindent,  1,              'failed at #359')
  call g:assert.equals(&l:smartindent, 1,              'failed at #359')
  call g:assert.equals(&l:cindent,     1,              'failed at #359')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #359')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #360
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #360')
  call g:assert.equals(getline(2),   '    [',      'failed at #360')
  call g:assert.equals(getline(3),   '    foo',    'failed at #360')
  call g:assert.equals(getline(4),   '    ]',      'failed at #360')
  call g:assert.equals(getline(5),   '    }',      'failed at #360')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #360')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #360')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #360')
  call g:assert.equals(&l:autoindent,  0,          'failed at #360')
  call g:assert.equals(&l:smartindent, 0,          'failed at #360')
  call g:assert.equals(&l:cindent,     0,          'failed at #360')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #360')

  %delete

  " #361
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #361')
  call g:assert.equals(getline(2),   '    [',      'failed at #361')
  call g:assert.equals(getline(3),   '    foo',    'failed at #361')
  call g:assert.equals(getline(4),   '    ]',      'failed at #361')
  call g:assert.equals(getline(5),   '    }',      'failed at #361')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #361')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #361')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #361')
  call g:assert.equals(&l:autoindent,  1,          'failed at #361')
  call g:assert.equals(&l:smartindent, 0,          'failed at #361')
  call g:assert.equals(&l:cindent,     0,          'failed at #361')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #361')

  %delete

  " #362
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #362')
  call g:assert.equals(getline(2),   '    [',      'failed at #362')
  call g:assert.equals(getline(3),   '    foo',    'failed at #362')
  call g:assert.equals(getline(4),   '    ]',      'failed at #362')
  call g:assert.equals(getline(5),   '    }',      'failed at #362')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #362')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #362')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #362')
  call g:assert.equals(&l:autoindent,  1,          'failed at #362')
  call g:assert.equals(&l:smartindent, 1,          'failed at #362')
  call g:assert.equals(&l:cindent,     0,          'failed at #362')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #362')

  %delete

  " #363
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #363')
  call g:assert.equals(getline(2),   '    [',      'failed at #363')
  call g:assert.equals(getline(3),   '    foo',    'failed at #363')
  call g:assert.equals(getline(4),   '    ]',      'failed at #363')
  call g:assert.equals(getline(5),   '    }',      'failed at #363')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #363')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #363')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #363')
  call g:assert.equals(&l:autoindent,  1,          'failed at #363')
  call g:assert.equals(&l:smartindent, 1,          'failed at #363')
  call g:assert.equals(&l:cindent,     1,          'failed at #363')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #363')

  %delete

  " #364
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #364')
  call g:assert.equals(getline(2),   '    [',          'failed at #364')
  call g:assert.equals(getline(3),   '    foo',        'failed at #364')
  call g:assert.equals(getline(4),   '    ]',          'failed at #364')
  call g:assert.equals(getline(5),   '    }',          'failed at #364')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #364')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #364')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #364')
  call g:assert.equals(&l:autoindent,  1,              'failed at #364')
  call g:assert.equals(&l:smartindent, 1,              'failed at #364')
  call g:assert.equals(&l:cindent,     1,              'failed at #364')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #364')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #365
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #365')
  call g:assert.equals(getline(2),   '        [',   'failed at #365')
  call g:assert.equals(getline(3),   '        foo', 'failed at #365')
  call g:assert.equals(getline(4),   '    ]',       'failed at #365')
  call g:assert.equals(getline(5),   '}',           'failed at #365')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #365')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #365')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #365')
  call g:assert.equals(&l:autoindent,  0,           'failed at #365')
  call g:assert.equals(&l:smartindent, 0,           'failed at #365')
  call g:assert.equals(&l:cindent,     0,           'failed at #365')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #365')

  %delete

  " #366
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #366')
  call g:assert.equals(getline(2),   '        [',   'failed at #366')
  call g:assert.equals(getline(3),   '        foo', 'failed at #366')
  call g:assert.equals(getline(4),   '    ]',       'failed at #366')
  call g:assert.equals(getline(5),   '}',           'failed at #366')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #366')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #366')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #366')
  call g:assert.equals(&l:autoindent,  1,           'failed at #366')
  call g:assert.equals(&l:smartindent, 0,           'failed at #366')
  call g:assert.equals(&l:cindent,     0,           'failed at #366')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #366')

  %delete

  " #367
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #367')
  call g:assert.equals(getline(2),   '        [',   'failed at #367')
  call g:assert.equals(getline(3),   '        foo', 'failed at #367')
  call g:assert.equals(getline(4),   '    ]',       'failed at #367')
  call g:assert.equals(getline(5),   '}',           'failed at #367')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #367')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #367')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #367')
  call g:assert.equals(&l:autoindent,  1,           'failed at #367')
  call g:assert.equals(&l:smartindent, 1,           'failed at #367')
  call g:assert.equals(&l:cindent,     0,           'failed at #367')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #367')

  %delete

  " #368
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #368')
  call g:assert.equals(getline(2),   '        [',   'failed at #368')
  call g:assert.equals(getline(3),   '        foo', 'failed at #368')
  call g:assert.equals(getline(4),   '    ]',       'failed at #368')
  call g:assert.equals(getline(5),   '}',           'failed at #368')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #368')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #368')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #368')
  call g:assert.equals(&l:autoindent,  1,           'failed at #368')
  call g:assert.equals(&l:smartindent, 1,           'failed at #368')
  call g:assert.equals(&l:cindent,     1,           'failed at #368')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #368')

  %delete

  " #369
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #369')
  call g:assert.equals(getline(2),   '        [',      'failed at #369')
  call g:assert.equals(getline(3),   '        foo',    'failed at #369')
  call g:assert.equals(getline(4),   '    ]',          'failed at #369')
  call g:assert.equals(getline(5),   '}',              'failed at #369')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #369')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #369')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #369')
  call g:assert.equals(&l:autoindent,  1,              'failed at #369')
  call g:assert.equals(&l:smartindent, 1,              'failed at #369')
  call g:assert.equals(&l:cindent,     1,              'failed at #369')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #369')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #370
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #370')
  call g:assert.equals(getline(2),   '    [',       'failed at #370')
  call g:assert.equals(getline(3),   '        foo', 'failed at #370')
  call g:assert.equals(getline(4),   '    ]',       'failed at #370')
  call g:assert.equals(getline(5),   '    }',       'failed at #370')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #370')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #370')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #370')
  call g:assert.equals(&l:autoindent,  0,           'failed at #370')
  call g:assert.equals(&l:smartindent, 0,           'failed at #370')
  call g:assert.equals(&l:cindent,     0,           'failed at #370')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #370')

  %delete

  " #371
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #371')
  call g:assert.equals(getline(2),   '    [',       'failed at #371')
  call g:assert.equals(getline(3),   '        foo', 'failed at #371')
  call g:assert.equals(getline(4),   '    ]',       'failed at #371')
  call g:assert.equals(getline(5),   '    }',       'failed at #371')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #371')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #371')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #371')
  call g:assert.equals(&l:autoindent,  1,           'failed at #371')
  call g:assert.equals(&l:smartindent, 0,           'failed at #371')
  call g:assert.equals(&l:cindent,     0,           'failed at #371')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #371')

  %delete

  " #372
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #372')
  call g:assert.equals(getline(2),   '    [',       'failed at #372')
  call g:assert.equals(getline(3),   '        foo', 'failed at #372')
  call g:assert.equals(getline(4),   '    ]',       'failed at #372')
  call g:assert.equals(getline(5),   '    }',       'failed at #372')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #372')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #372')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #372')
  call g:assert.equals(&l:autoindent,  1,           'failed at #372')
  call g:assert.equals(&l:smartindent, 1,           'failed at #372')
  call g:assert.equals(&l:cindent,     0,           'failed at #372')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #372')

  %delete

  " #373
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #373')
  call g:assert.equals(getline(2),   '    [',       'failed at #373')
  call g:assert.equals(getline(3),   '        foo', 'failed at #373')
  call g:assert.equals(getline(4),   '    ]',       'failed at #373')
  call g:assert.equals(getline(5),   '    }',       'failed at #373')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #373')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #373')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #373')
  call g:assert.equals(&l:autoindent,  1,           'failed at #373')
  call g:assert.equals(&l:smartindent, 1,           'failed at #373')
  call g:assert.equals(&l:cindent,     1,           'failed at #373')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #373')

  %delete

  " #374
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',              'failed at #374')
  call g:assert.equals(getline(2),   '    [',          'failed at #374')
  call g:assert.equals(getline(3),   '        foo',    'failed at #374')
  call g:assert.equals(getline(4),   '    ]',          'failed at #374')
  call g:assert.equals(getline(5),   '    }',          'failed at #374')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #374')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #374')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #374')
  call g:assert.equals(&l:autoindent,  1,              'failed at #374')
  call g:assert.equals(&l:smartindent, 1,              'failed at #374')
  call g:assert.equals(&l:cindent,     1,              'failed at #374')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #374')
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

  " #375
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #375')
  call g:assert.equals(getline(2),   'foo',        'failed at #375')
  call g:assert.equals(getline(3),   '    }',      'failed at #375')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #375')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #375')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #375')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #375')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #375')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #376
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #376')
  call g:assert.equals(getline(2),   '    foo',    'failed at #376')
  call g:assert.equals(getline(3),   '    }',      'failed at #376')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #376')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #376')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #376')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #376')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #376')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #377
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #377')
  call g:assert.equals(getline(2),   'foo',        'failed at #377')
  call g:assert.equals(getline(3),   '    }',      'failed at #377')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #377')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #377')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #377')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #377')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #378
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #378')
  call g:assert.equals(getline(2),   'foo',        'failed at #378')
  call g:assert.equals(getline(3),   '    }',      'failed at #378')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #378')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #378')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #378')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #378')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #378')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #379
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',     'failed at #379')
  call g:assert.equals(getline(2),   '    foo',       'failed at #379')
  call g:assert.equals(getline(3),   '            }', 'failed at #379')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #379')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #379')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #379')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #379')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #379')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #380
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #380')
  call g:assert.equals(getline(2),   'foo',        'failed at #380')
  call g:assert.equals(getline(3),   '    }',      'failed at #380')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #380')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #380')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #380')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #380')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #380')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #381
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #381')

  " #382
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #382')

  " #383
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #383')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #383')

  " #384
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #384')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #384')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #384')

  %delete

  " #385
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #385')
  call g:assert.equals(getline(2),   'foo',        'failed at #385')
  call g:assert.equals(getline(3),   ']',          'failed at #385')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #385')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #385')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #385')

  " #386
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #386')
  call g:assert.equals(getline(2),   'foo',        'failed at #386')
  call g:assert.equals(getline(3),   '}',          'failed at #386')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #386')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #386')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #386')

  " #387
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #387')
  call g:assert.equals(getline(2),   'foo',        'failed at #387')
  call g:assert.equals(getline(3),   '>',          'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #387')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #387')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #387')

  " #388
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #388')
  call g:assert.equals(getline(2),   'foo',        'failed at #388')
  call g:assert.equals(getline(3),   ')',          'failed at #388')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #388')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #388')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #388')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #389
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #389')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #389')

  " #390
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #390')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #390')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #390')

  %delete

  " #389
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #389')
  call g:assert.equals(getline(2),   'foo',        'failed at #389')
  call g:assert.equals(getline(3),   'b',          'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #389')

  %delete

  " #390
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #390')
  call g:assert.equals(getline(2),   'foo',        'failed at #390')
  call g:assert.equals(getline(3),   '*',          'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #390')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #390')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #390')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #391
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #391')
  call g:assert.equals(getline(2),   'foo',        'failed at #391')
  call g:assert.equals(getline(3),   'bar',        'failed at #391')
  call g:assert.equals(getline(4),   'baz',        'failed at #391')
  call g:assert.equals(getline(5),   ']',          'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #391')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #391')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #391')

  %delete

  " #392
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #392')
  call g:assert.equals(getline(2),   '[',          'failed at #392')
  call g:assert.equals(getline(3),   'bar',        'failed at #392')
  call g:assert.equals(getline(4),   ']',          'failed at #392')
  call g:assert.equals(getline(5),   'baz',        'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #392')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #392')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #392')

  %delete

  " #393
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #393')
  call g:assert.equals(getline(2),   'bar',        'failed at #393')
  call g:assert.equals(getline(3),   'baz]',       'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #393')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #393')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #393')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #394
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #394')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #394')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #394')

  %delete

  " #395
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #395')
  call g:assert.equals(getline(2),   ']',          'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #395')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #396
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #396')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #396')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #396')

  " #397
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #397')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #397')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #397')

  %delete

  " #398
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #398')
  call g:assert.equals(getline(2),   '(',          'failed at #398')
  call g:assert.equals(getline(3),   '{',          'failed at #398')
  call g:assert.equals(getline(4),   '[',          'failed at #398')
  call g:assert.equals(getline(5),   'bar',        'failed at #398')
  call g:assert.equals(getline(6),   ']',          'failed at #398')
  call g:assert.equals(getline(7),   '}',          'failed at #398')
  call g:assert.equals(getline(8),   ')',          'failed at #398')
  call g:assert.equals(getline(9),   'baz',        'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #398')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #399
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #399')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #399')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #399')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #399')

  %delete

  " #400
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #400')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #400')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #400')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #400')

  %delete

  " #401
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #401')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #401')
  call g:assert.equals(getline(3),   'aa',         'failed at #401')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #401')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #401')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #401')

  %delete

  " #402
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #402')
  call g:assert.equals(getline(2),   'bbb',        'failed at #402')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #402')
  call g:assert.equals(getline(4),   'bbb',        'failed at #402')
  call g:assert.equals(getline(5),   'bb',         'failed at #402')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #402')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #402')

  %delete

  " #403
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #403')
  call g:assert.equals(getline(2),   '(',          'failed at #403')
  call g:assert.equals(getline(3),   'foo',        'failed at #403')
  call g:assert.equals(getline(4),   ')',          'failed at #403')
  call g:assert.equals(getline(5),   ')',          'failed at #403')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #403')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #403')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #403')

  %delete

  " #404
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #404')
  call g:assert.equals(getline(2),   '(',          'failed at #404')
  call g:assert.equals(getline(3),   'foo',        'failed at #404')
  call g:assert.equals(getline(4),   ')',          'failed at #404')
  call g:assert.equals(getline(5),   ')',          'failed at #404')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #404')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #404')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #404')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_external_textobj() abort"{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #405
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #405')

  " #406
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #406')

  " #407
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #407')

  " #408
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #408')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #409
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #409')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #409')

  " #410
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #410')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #410')

  """ keep
  " #411
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #411')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #411')

  " #412
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #412')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #412')

  """ inner_tail
  " #413
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #413')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #413')

  " #414
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #414')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #414')

  """ head
  " #415
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #415')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #415')

  " #416
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #416')

  """ tail
  " #417
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #417')

  " #418
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #418')

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
  " #419
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #419')

  " #420
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #420')

  """ off
  " #421
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #421')

  " #422
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #422')

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
  " #423
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #423')

  " #424
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #424')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #425
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #425')

  " #426
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #426')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #427
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #427')

  " #428
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #428')

  " #429
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #429')

  " #430
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #430')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #431
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #431')

  " #432
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #432')

  " #433
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #433')

  " #434
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #434')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #435
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #435')

  " #436
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #436')

  " #437
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #437')

  " #438
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #438')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #439
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #439')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #440
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #440')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])

  " #441
  call append(0, ['[', '(foo)', ']'])
  normal ggjsrVl"
  call g:assert.equals(getline(1), '[', 'failed at #441')
  call g:assert.equals(getline(2), '',  'failed at #441')
  call g:assert.equals(getline(3), ']', 'failed at #441')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #442
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #442')
  call g:assert.equals(getline(2),   'foo',        'failed at #442')
  call g:assert.equals(getline(3),   ']',          'failed at #442')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #442')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #442')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #442')

  %delete

  " #443
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #443')
  call g:assert.equals(getline(2),   'foo',        'failed at #443')
  call g:assert.equals(getline(3),   '  ]',        'failed at #443')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #443')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #443')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #443')

  %delete

  " #444
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #444')
  call g:assert.equals(getline(2),   'foo',        'failed at #444')
  call g:assert.equals(getline(3),   'aa]',        'failed at #444')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #444')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #444')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #444')

  %delete

  " #445
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #445')
  call g:assert.equals(getline(2),   'foo',        'failed at #445')
  call g:assert.equals(getline(3),   ']',          'failed at #445')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #445')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #445')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #445')

  %delete

  " #446
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #446')
  call g:assert.equals(getline(2),   'foo',        'failed at #446')
  call g:assert.equals(getline(3),   'aa]',        'failed at #446')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #446')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #446')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #446')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #447
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #447')
  call g:assert.equals(getline(2),   'foo',        'failed at #447')
  call g:assert.equals(getline(3),   ']',          'failed at #447')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #447')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #447')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #447')

  %delete

  " #448
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #448')
  call g:assert.equals(getline(2),   'foo',        'failed at #448')
  call g:assert.equals(getline(3),   ']',          'failed at #448')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #448')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #448')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #448')

  %delete

  " #449
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #449')
  call g:assert.equals(getline(2),   'foo',        'failed at #449')
  call g:assert.equals(getline(3),   ']',          'failed at #449')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #449')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #449')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #449')

  %delete

  " #450
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #450')
  call g:assert.equals(getline(2),   '[',          'failed at #450')
  call g:assert.equals(getline(3),   'bb',         'failed at #450')
  call g:assert.equals(getline(4),   '',           'failed at #450')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #450')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #450')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #450')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #451
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #451')

  %delete

  """ on
  " #452
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #452')

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
  " #453
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #453')

  """ 1
  " #454
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3', 'failed at #454')

  " #455
  call setline('.', '"foo"')
  normal 0srVlb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #455')
  call g:assert.equals(exists(s:object), 0,   'failed at #455')

  " #456
  call setline('.', '"foo"')
  normal 0srVlc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #456')
  call g:assert.equals(exists(s:object), 0, 'failed at #456')

  " #457
  call setline('.', '"''foo''"')
  normal 02srVlab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #457')
  call g:assert.equals(exists(s:object), 0, 'failed at #457')

  " #458
  call setline('.', '"''foo''"')
  normal 02srVlac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #458')
  call g:assert.equals(exists(s:object), 0, 'failed at #458')

  " #459
  call setline('.', '"''foo''"')
  normal 02srVlba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #459')
  call g:assert.equals(exists(s:object), 0, 'failed at #459')

  " #460
  call setline('.', '"''foo''"')
  normal 02srVlca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #460')
  call g:assert.equals(exists(s:object), 0, 'failed at #460')

  " #461
  call setline('.', '"foo"')
  normal 0srVld
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #461')

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

  " #462
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #462')
  call g:assert.equals(getline(2),   '[',          'failed at #462')
  call g:assert.equals(getline(3),   '',           'failed at #462')
  call g:assert.equals(getline(4),   '    foo',    'failed at #462')
  call g:assert.equals(getline(5),   '',           'failed at #462')
  call g:assert.equals(getline(6),   ']',          'failed at #462')
  call g:assert.equals(getline(7),   '}',          'failed at #462')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #462')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #462')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #462')
  call g:assert.equals(&l:autoindent,  0,          'failed at #462')
  call g:assert.equals(&l:smartindent, 0,          'failed at #462')
  call g:assert.equals(&l:cindent,     0,          'failed at #462')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #462')

  %delete

  " #463
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #463')
  call g:assert.equals(getline(2),   '    [',      'failed at #463')
  call g:assert.equals(getline(3),   '',           'failed at #463')
  call g:assert.equals(getline(4),   '    foo',    'failed at #463')
  call g:assert.equals(getline(5),   '',           'failed at #463')
  call g:assert.equals(getline(6),   '    ]',      'failed at #463')
  call g:assert.equals(getline(7),   '    }',      'failed at #463')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #463')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #463')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #463')
  call g:assert.equals(&l:autoindent,  1,          'failed at #463')
  call g:assert.equals(&l:smartindent, 0,          'failed at #463')
  call g:assert.equals(&l:cindent,     0,          'failed at #463')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #463')

  %delete

  " #464
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #464')
  call g:assert.equals(getline(2),   '    [',       'failed at #464')
  call g:assert.equals(getline(3),   '',            'failed at #464')
  call g:assert.equals(getline(4),   '    foo',     'failed at #464')
  call g:assert.equals(getline(5),   '',            'failed at #464')
  call g:assert.equals(getline(6),   '    ]',       'failed at #464')
  call g:assert.equals(getline(7),   '}',           'failed at #464')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #464')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #464')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #464')
  call g:assert.equals(&l:autoindent,  1,           'failed at #464')
  call g:assert.equals(&l:smartindent, 1,           'failed at #464')
  call g:assert.equals(&l:cindent,     0,           'failed at #464')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #464')

  %delete

  " #465
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #465')
  call g:assert.equals(getline(2),   '    [',       'failed at #465')
  call g:assert.equals(getline(3),   '',            'failed at #465')
  call g:assert.equals(getline(4),   '    foo',     'failed at #465')
  call g:assert.equals(getline(5),   '',            'failed at #465')
  call g:assert.equals(getline(6),   '    ]',       'failed at #465')
  call g:assert.equals(getline(7),   '    }',       'failed at #465')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #465')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #465')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #465')
  call g:assert.equals(&l:autoindent,  1,           'failed at #465')
  call g:assert.equals(&l:smartindent, 1,           'failed at #465')
  call g:assert.equals(&l:cindent,     1,           'failed at #465')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #465')

  %delete

  " #466
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',            'failed at #466')
  call g:assert.equals(getline(2),   '           [',        'failed at #466')
  call g:assert.equals(getline(3),   '',                    'failed at #466')
  call g:assert.equals(getline(4),   '    foo',             'failed at #466')
  call g:assert.equals(getline(5),   '',                    'failed at #466')
  call g:assert.equals(getline(6),   '        ]',           'failed at #466')
  call g:assert.equals(getline(7),   '                }',   'failed at #466')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #466')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #466')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #466')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #466')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #466')
  call g:assert.equals(&l:cindent,     1,                   'failed at #466')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #466')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #467
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #467')
  call g:assert.equals(getline(2),   '[',          'failed at #467')
  call g:assert.equals(getline(3),   '',           'failed at #467')
  call g:assert.equals(getline(4),   '    foo',    'failed at #467')
  call g:assert.equals(getline(5),   '',           'failed at #467')
  call g:assert.equals(getline(6),   ']',          'failed at #467')
  call g:assert.equals(getline(7),   '}',          'failed at #467')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #467')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #467')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #467')
  call g:assert.equals(&l:autoindent,  0,          'failed at #467')
  call g:assert.equals(&l:smartindent, 0,          'failed at #467')
  call g:assert.equals(&l:cindent,     0,          'failed at #467')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #467')

  %delete

  " #468
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #468')
  call g:assert.equals(getline(2),   '[',          'failed at #468')
  call g:assert.equals(getline(3),   '',           'failed at #468')
  call g:assert.equals(getline(4),   '    foo',    'failed at #468')
  call g:assert.equals(getline(5),   '',           'failed at #468')
  call g:assert.equals(getline(6),   ']',          'failed at #468')
  call g:assert.equals(getline(7),   '}',          'failed at #468')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #468')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #468')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #468')
  call g:assert.equals(&l:autoindent,  1,          'failed at #468')
  call g:assert.equals(&l:smartindent, 0,          'failed at #468')
  call g:assert.equals(&l:cindent,     0,          'failed at #468')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #468')

  %delete

  " #469
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #469')
  call g:assert.equals(getline(2),   '[',          'failed at #469')
  call g:assert.equals(getline(3),   '',           'failed at #469')
  call g:assert.equals(getline(4),   '    foo',    'failed at #469')
  call g:assert.equals(getline(5),   '',           'failed at #469')
  call g:assert.equals(getline(6),   ']',          'failed at #469')
  call g:assert.equals(getline(7),   '}',          'failed at #469')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #469')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #469')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #469')
  call g:assert.equals(&l:autoindent,  1,          'failed at #469')
  call g:assert.equals(&l:smartindent, 1,          'failed at #469')
  call g:assert.equals(&l:cindent,     0,          'failed at #469')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #469')

  %delete

  " #470
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #470')
  call g:assert.equals(getline(2),   '[',          'failed at #470')
  call g:assert.equals(getline(3),   '',           'failed at #470')
  call g:assert.equals(getline(4),   '    foo',    'failed at #470')
  call g:assert.equals(getline(5),   '',           'failed at #470')
  call g:assert.equals(getline(6),   ']',          'failed at #470')
  call g:assert.equals(getline(7),   '}',          'failed at #470')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #470')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #470')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #470')
  call g:assert.equals(&l:autoindent,  1,          'failed at #470')
  call g:assert.equals(&l:smartindent, 1,          'failed at #470')
  call g:assert.equals(&l:cindent,     1,          'failed at #470')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #470')

  %delete

  " #471
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #471')
  call g:assert.equals(getline(2),   '[',              'failed at #471')
  call g:assert.equals(getline(3),   '',               'failed at #471')
  call g:assert.equals(getline(4),   '    foo',        'failed at #471')
  call g:assert.equals(getline(5),   '',               'failed at #471')
  call g:assert.equals(getline(6),   ']',              'failed at #471')
  call g:assert.equals(getline(7),   '}',              'failed at #471')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #471')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #471')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #471')
  call g:assert.equals(&l:autoindent,  1,              'failed at #471')
  call g:assert.equals(&l:smartindent, 1,              'failed at #471')
  call g:assert.equals(&l:cindent,     1,              'failed at #471')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #471')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #472
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #472')
  call g:assert.equals(getline(2),   '    [',      'failed at #472')
  call g:assert.equals(getline(3),   '',           'failed at #472')
  call g:assert.equals(getline(4),   '    foo',    'failed at #472')
  call g:assert.equals(getline(5),   '',           'failed at #472')
  call g:assert.equals(getline(6),   '    ]',      'failed at #472')
  call g:assert.equals(getline(7),   '    }',      'failed at #472')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #472')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #472')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #472')
  call g:assert.equals(&l:autoindent,  0,          'failed at #472')
  call g:assert.equals(&l:smartindent, 0,          'failed at #472')
  call g:assert.equals(&l:cindent,     0,          'failed at #472')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #472')

  %delete

  " #473
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #473')
  call g:assert.equals(getline(2),   '    [',      'failed at #473')
  call g:assert.equals(getline(3),   '',           'failed at #473')
  call g:assert.equals(getline(4),   '    foo',    'failed at #473')
  call g:assert.equals(getline(5),   '',           'failed at #473')
  call g:assert.equals(getline(6),   '    ]',      'failed at #473')
  call g:assert.equals(getline(7),   '    }',      'failed at #473')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #473')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #473')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #473')
  call g:assert.equals(&l:autoindent,  1,          'failed at #473')
  call g:assert.equals(&l:smartindent, 0,          'failed at #473')
  call g:assert.equals(&l:cindent,     0,          'failed at #473')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #473')

  %delete

  " #474
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #474')
  call g:assert.equals(getline(2),   '    [',      'failed at #474')
  call g:assert.equals(getline(3),   '',           'failed at #474')
  call g:assert.equals(getline(4),   '    foo',    'failed at #474')
  call g:assert.equals(getline(5),   '',           'failed at #474')
  call g:assert.equals(getline(6),   '    ]',      'failed at #474')
  call g:assert.equals(getline(7),   '    }',      'failed at #474')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #474')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #474')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #474')
  call g:assert.equals(&l:autoindent,  1,          'failed at #474')
  call g:assert.equals(&l:smartindent, 1,          'failed at #474')
  call g:assert.equals(&l:cindent,     0,          'failed at #474')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #474')

  %delete

  " #475
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #475')
  call g:assert.equals(getline(2),   '    [',      'failed at #475')
  call g:assert.equals(getline(3),   '',           'failed at #475')
  call g:assert.equals(getline(4),   '    foo',    'failed at #475')
  call g:assert.equals(getline(5),   '',           'failed at #475')
  call g:assert.equals(getline(6),   '    ]',      'failed at #475')
  call g:assert.equals(getline(7),   '    }',      'failed at #475')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #475')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #475')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #475')
  call g:assert.equals(&l:autoindent,  1,          'failed at #475')
  call g:assert.equals(&l:smartindent, 1,          'failed at #475')
  call g:assert.equals(&l:cindent,     1,          'failed at #475')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #475')

  %delete

  " #476
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',          'failed at #476')
  call g:assert.equals(getline(2),   '    [',          'failed at #476')
  call g:assert.equals(getline(3),   '',               'failed at #476')
  call g:assert.equals(getline(4),   '    foo',        'failed at #476')
  call g:assert.equals(getline(5),   '',               'failed at #476')
  call g:assert.equals(getline(6),   '    ]',          'failed at #476')
  call g:assert.equals(getline(7),   '    }',          'failed at #476')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #476')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #476')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #476')
  call g:assert.equals(&l:autoindent,  1,              'failed at #476')
  call g:assert.equals(&l:smartindent, 1,              'failed at #476')
  call g:assert.equals(&l:cindent,     1,              'failed at #476')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #476')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #477
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #477')
  call g:assert.equals(getline(2),   '    [',       'failed at #477')
  call g:assert.equals(getline(3),   '',            'failed at #477')
  call g:assert.equals(getline(4),   '    foo',     'failed at #477')
  call g:assert.equals(getline(5),   '',            'failed at #477')
  call g:assert.equals(getline(6),   '    ]',       'failed at #477')
  call g:assert.equals(getline(7),   '}',           'failed at #477')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #477')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #477')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #477')
  call g:assert.equals(&l:autoindent,  0,           'failed at #477')
  call g:assert.equals(&l:smartindent, 0,           'failed at #477')
  call g:assert.equals(&l:cindent,     0,           'failed at #477')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #477')

  %delete

  " #478
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #478')
  call g:assert.equals(getline(2),   '    [',       'failed at #478')
  call g:assert.equals(getline(3),   '',            'failed at #478')
  call g:assert.equals(getline(4),   '    foo',     'failed at #478')
  call g:assert.equals(getline(5),   '',            'failed at #478')
  call g:assert.equals(getline(6),   '    ]',       'failed at #478')
  call g:assert.equals(getline(7),   '}',           'failed at #478')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #478')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #478')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #478')
  call g:assert.equals(&l:autoindent,  1,           'failed at #478')
  call g:assert.equals(&l:smartindent, 0,           'failed at #478')
  call g:assert.equals(&l:cindent,     0,           'failed at #478')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #478')

  %delete

  " #479
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #479')
  call g:assert.equals(getline(2),   '    [',       'failed at #479')
  call g:assert.equals(getline(3),   '',            'failed at #479')
  call g:assert.equals(getline(4),   '    foo',     'failed at #479')
  call g:assert.equals(getline(5),   '',            'failed at #479')
  call g:assert.equals(getline(6),   '    ]',       'failed at #479')
  call g:assert.equals(getline(7),   '}',           'failed at #479')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #479')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #479')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #479')
  call g:assert.equals(&l:autoindent,  1,           'failed at #479')
  call g:assert.equals(&l:smartindent, 1,           'failed at #479')
  call g:assert.equals(&l:cindent,     0,           'failed at #479')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #479')

  %delete

  " #480
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #480')
  call g:assert.equals(getline(2),   '    [',       'failed at #480')
  call g:assert.equals(getline(3),   '',            'failed at #480')
  call g:assert.equals(getline(4),   '    foo',     'failed at #480')
  call g:assert.equals(getline(5),   '',            'failed at #480')
  call g:assert.equals(getline(6),   '    ]',       'failed at #480')
  call g:assert.equals(getline(7),   '}',           'failed at #480')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #480')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #480')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #480')
  call g:assert.equals(&l:autoindent,  1,           'failed at #480')
  call g:assert.equals(&l:smartindent, 1,           'failed at #480')
  call g:assert.equals(&l:cindent,     1,           'failed at #480')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #480')

  %delete

  " #481
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #481')
  call g:assert.equals(getline(2),   '    [',          'failed at #481')
  call g:assert.equals(getline(3),   '',               'failed at #481')
  call g:assert.equals(getline(4),   '    foo',        'failed at #481')
  call g:assert.equals(getline(5),   '',               'failed at #481')
  call g:assert.equals(getline(6),   '    ]',          'failed at #481')
  call g:assert.equals(getline(7),   '}',              'failed at #481')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #481')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #481')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #481')
  call g:assert.equals(&l:autoindent,  1,              'failed at #481')
  call g:assert.equals(&l:smartindent, 1,              'failed at #481')
  call g:assert.equals(&l:cindent,     1,              'failed at #481')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #481')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #482
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #482')
  call g:assert.equals(getline(2),   '    [',       'failed at #482')
  call g:assert.equals(getline(3),   '',            'failed at #482')
  call g:assert.equals(getline(4),   '    foo',     'failed at #482')
  call g:assert.equals(getline(5),   '',            'failed at #482')
  call g:assert.equals(getline(6),   '    ]',       'failed at #482')
  call g:assert.equals(getline(7),   '    }',       'failed at #482')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #482')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #482')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #482')
  call g:assert.equals(&l:autoindent,  0,           'failed at #482')
  call g:assert.equals(&l:smartindent, 0,           'failed at #482')
  call g:assert.equals(&l:cindent,     0,           'failed at #482')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #482')

  %delete

  " #483
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #483')
  call g:assert.equals(getline(2),   '    [',       'failed at #483')
  call g:assert.equals(getline(3),   '',            'failed at #483')
  call g:assert.equals(getline(4),   '    foo',     'failed at #483')
  call g:assert.equals(getline(5),   '',            'failed at #483')
  call g:assert.equals(getline(6),   '    ]',       'failed at #483')
  call g:assert.equals(getline(7),   '    }',       'failed at #483')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #483')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #483')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #483')
  call g:assert.equals(&l:autoindent,  1,           'failed at #483')
  call g:assert.equals(&l:smartindent, 0,           'failed at #483')
  call g:assert.equals(&l:cindent,     0,           'failed at #483')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #483')

  %delete

  " #484
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #484')
  call g:assert.equals(getline(2),   '    [',       'failed at #484')
  call g:assert.equals(getline(3),   '',            'failed at #484')
  call g:assert.equals(getline(4),   '    foo',     'failed at #484')
  call g:assert.equals(getline(5),   '',            'failed at #484')
  call g:assert.equals(getline(6),   '    ]',       'failed at #484')
  call g:assert.equals(getline(7),   '    }',       'failed at #484')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #484')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #484')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #484')
  call g:assert.equals(&l:autoindent,  1,           'failed at #484')
  call g:assert.equals(&l:smartindent, 1,           'failed at #484')
  call g:assert.equals(&l:cindent,     0,           'failed at #484')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #484')

  %delete

  " #485
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #485')
  call g:assert.equals(getline(2),   '    [',       'failed at #485')
  call g:assert.equals(getline(3),   '',            'failed at #485')
  call g:assert.equals(getline(4),   '    foo',     'failed at #485')
  call g:assert.equals(getline(5),   '',            'failed at #485')
  call g:assert.equals(getline(6),   '    ]',       'failed at #485')
  call g:assert.equals(getline(7),   '    }',       'failed at #485')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #485')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #485')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #485')
  call g:assert.equals(&l:autoindent,  1,           'failed at #485')
  call g:assert.equals(&l:smartindent, 1,           'failed at #485')
  call g:assert.equals(&l:cindent,     1,           'failed at #485')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #485')

  %delete

  " #486
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #486')
  call g:assert.equals(getline(2),   '    [',          'failed at #486')
  call g:assert.equals(getline(3),   '',               'failed at #486')
  call g:assert.equals(getline(4),   '    foo',        'failed at #486')
  call g:assert.equals(getline(5),   '',               'failed at #486')
  call g:assert.equals(getline(6),   '    ]',          'failed at #486')
  call g:assert.equals(getline(7),   '    }',          'failed at #486')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #486')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #486')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #486')
  call g:assert.equals(&l:autoindent,  1,              'failed at #486')
  call g:assert.equals(&l:smartindent, 1,              'failed at #486')
  call g:assert.equals(&l:cindent,     1,              'failed at #486')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #486')
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

  " #487
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #487')
  call g:assert.equals(getline(2),   '',           'failed at #487')
  call g:assert.equals(getline(3),   '    foo',    'failed at #487')
  call g:assert.equals(getline(4),   '',           'failed at #487')
  call g:assert.equals(getline(5),   '    }',      'failed at #487')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #487')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #487')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #487')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #487')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #487')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #488
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #488')
  call g:assert.equals(getline(2),   '',           'failed at #488')
  call g:assert.equals(getline(3),   '    foo',    'failed at #488')
  call g:assert.equals(getline(4),   '',           'failed at #488')
  call g:assert.equals(getline(5),   '    }',      'failed at #488')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #488')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #488')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #488')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #488')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #488')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #489
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #489')
  call g:assert.equals(getline(2),   '',           'failed at #489')
  call g:assert.equals(getline(3),   '    foo',    'failed at #489')
  call g:assert.equals(getline(4),   '',           'failed at #489')
  call g:assert.equals(getline(5),   '    }',      'failed at #489')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #489')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #489')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #489')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #489')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #489')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #490
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #490')
  call g:assert.equals(getline(2),   '',              'failed at #490')
  call g:assert.equals(getline(3),   '    foo',       'failed at #490')
  call g:assert.equals(getline(4),   '',              'failed at #490')
  call g:assert.equals(getline(5),   '    }',         'failed at #490')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #490')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #490')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #490')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #490')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #490')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #491
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',      'failed at #491')
  call g:assert.equals(getline(2),   '',              'failed at #491')
  call g:assert.equals(getline(3),   '    foo',       'failed at #491')
  call g:assert.equals(getline(4),   '',              'failed at #491')
  call g:assert.equals(getline(5),   '            }', 'failed at #491')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #491')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #491')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #491')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #491')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #491')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #492
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #492')
  call g:assert.equals(getline(2),   '',              'failed at #492')
  call g:assert.equals(getline(3),   '    foo',       'failed at #492')
  call g:assert.equals(getline(4),   '',              'failed at #492')
  call g:assert.equals(getline(5),   '    }',         'failed at #492')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #492')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #492')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #492')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #492')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #492')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #493
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #493')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #493')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #493')

  " #494
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #494')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #494')

  " #495
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #495')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #495')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #495')

  " #496
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #496')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #496')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #496')

  %delete

  " #497
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #497')
  call g:assert.equals(getline(2),   'foo',        'failed at #497')
  call g:assert.equals(getline(3),   ']',          'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #497')

  " #498
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #498')
  call g:assert.equals(getline(2),   'foo',        'failed at #498')
  call g:assert.equals(getline(3),   '}',          'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #498')

  " #499
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #499')
  call g:assert.equals(getline(2),   'foo',        'failed at #499')
  call g:assert.equals(getline(3),   '>',          'failed at #499')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #499')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #499')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #499')

  " #500
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #500')
  call g:assert.equals(getline(2),   'foo',        'failed at #500')
  call g:assert.equals(getline(3),   ')',          'failed at #500')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #500')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #501
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #501')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #501')

  " #502
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #502')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #502')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #502')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #502')

  %delete

  " #501
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #501')
  call g:assert.equals(getline(2),   'foo',        'failed at #501')
  call g:assert.equals(getline(3),   'b',          'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #501')

  %delete

  " #502
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #502')
  call g:assert.equals(getline(2),   'foo',        'failed at #502')
  call g:assert.equals(getline(3),   '*',          'failed at #502')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #502')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #502')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #502')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #503
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #503')
  call g:assert.equals(getline(2),   'foo',        'failed at #503')
  call g:assert.equals(getline(3),   'bar',        'failed at #503')
  call g:assert.equals(getline(4),   'baz',        'failed at #503')
  call g:assert.equals(getline(5),   ']',          'failed at #503')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #503')

  %delete

  " #504
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #504')
  call g:assert.equals(getline(2),   '[',          'failed at #504')
  call g:assert.equals(getline(3),   'bar',        'failed at #504')
  call g:assert.equals(getline(4),   ']',          'failed at #504')
  call g:assert.equals(getline(5),   'baz',        'failed at #504')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #504')

  %delete

  " #505
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #505')
  call g:assert.equals(getline(2),   'bar',        'failed at #505')
  call g:assert.equals(getline(3),   'baz]',       'failed at #505')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #505')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #505')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #505')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #506
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #506')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #506')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #506')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #506')

  %delete

  " #507
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #507')
  call g:assert.equals(getline(2),   ']',          'failed at #507')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #507')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #507')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #507')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #508
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #508')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #508')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #508')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #508')

  " #509
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #509')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #509')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #509')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #509')

  %delete

  " #510
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #510')
  call g:assert.equals(getline(2),   '(',          'failed at #510')
  call g:assert.equals(getline(3),   '{',          'failed at #510')
  call g:assert.equals(getline(4),   '[',          'failed at #510')
  call g:assert.equals(getline(5),   'bar',        'failed at #510')
  call g:assert.equals(getline(6),   ']',          'failed at #510')
  call g:assert.equals(getline(7),   '}',          'failed at #510')
  call g:assert.equals(getline(8),   ')',          'failed at #510')
  call g:assert.equals(getline(9),   'baz',        'failed at #510')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #510')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #510')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #510')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #511
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #511')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #511')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #511')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #511')

  %delete

  " #512
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #512')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #512')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #512')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #512')

  %delete

  " #513
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #513')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #513')
  call g:assert.equals(getline(3),   'aa',         'failed at #513')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #513')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #513')

  %delete

  " #514
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #514')
  call g:assert.equals(getline(2),   'bbb',        'failed at #514')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #514')
  call g:assert.equals(getline(4),   'bbb',        'failed at #514')
  call g:assert.equals(getline(5),   'bb',         'failed at #514')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #514')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #514')

  %delete

  " #515
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #515')
  call g:assert.equals(getline(2),   '(',          'failed at #515')
  call g:assert.equals(getline(3),   'foo',        'failed at #515')
  call g:assert.equals(getline(4),   ')',          'failed at #515')
  call g:assert.equals(getline(5),   ')',          'failed at #515')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #515')

  %delete

  " #516
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #516')
  call g:assert.equals(getline(2),   '(',          'failed at #516')
  call g:assert.equals(getline(3),   'foo',        'failed at #516')
  call g:assert.equals(getline(4),   ')',          'failed at #516')
  call g:assert.equals(getline(5),   ')',          'failed at #516')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #516')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_external_textobj() abort"{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #517
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #517')

  " #518
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #518')

  " #519
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #519')

  " #520
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #520')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #521
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #521')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #521')

  " #522
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #522')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #522')

  """ keep
  " #523
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #523')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #523')

  " #524
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #524')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #524')

  """ inner_tail
  " #525
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #525')

  " #526
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #526')

  """ head
  " #527
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #527')

  " #528
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #528')

  """ tail
  " #529
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #529')

  " #530
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #530')

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
  " #531
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #531')

  " #532
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #532')

  """ off
  " #533
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #533')

  " #534
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #534')

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
  " #535
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #535')

  " #536
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #536')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #537
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #537')

  " #538
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #538')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #539
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #539')

  " #540
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #540')

  " #541
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #541')

  " #542
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #542')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #543
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #543')

  " #544
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #544')

  " #545
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #545')

  " #546
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #546')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #547
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #547')

  " #548
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #548')

  " #549
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #549')

  " #550
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #550')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #551
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #551')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #552
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #552')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[d`]'])

  " #553
  call append(0, ['[', '(foo)', ']'])
  normal ggjVsr"
  call g:assert.equals(getline(1), '[', 'failed at #553')
  call g:assert.equals(getline(2), '',  'failed at #553')
  call g:assert.equals(getline(3), ']', 'failed at #553')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #554
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #554')
  call g:assert.equals(getline(2),   'foo',        'failed at #554')
  call g:assert.equals(getline(3),   ']',          'failed at #554')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #554')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #554')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #554')

  %delete

  " #555
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #555')
  call g:assert.equals(getline(2),   'foo',        'failed at #555')
  call g:assert.equals(getline(3),   '  ]',        'failed at #555')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #555')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #555')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #555')

  %delete

  " #556
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #556')
  call g:assert.equals(getline(2),   'foo',        'failed at #556')
  call g:assert.equals(getline(3),   'aa]',        'failed at #556')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #556')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #556')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #556')

  %delete

  " #557
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #557')
  call g:assert.equals(getline(2),   'foo',        'failed at #557')
  call g:assert.equals(getline(3),   ']',          'failed at #557')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #557')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #557')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #557')

  %delete

  " #558
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #558')
  call g:assert.equals(getline(2),   'foo',        'failed at #558')
  call g:assert.equals(getline(3),   'aa]',        'failed at #558')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #558')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #558')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #558')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #559
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #559')
  call g:assert.equals(getline(2),   'foo',        'failed at #559')
  call g:assert.equals(getline(3),   ']',          'failed at #559')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #559')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #559')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #559')

  %delete

  " #560
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #560')
  call g:assert.equals(getline(2),   'foo',        'failed at #560')
  call g:assert.equals(getline(3),   ']',          'failed at #560')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #560')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #560')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #560')

  %delete

  " #561
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #561')
  call g:assert.equals(getline(2),   'foo',        'failed at #561')
  call g:assert.equals(getline(3),   ']',          'failed at #561')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #561')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #561')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #561')

  %delete

  " #562
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #562')
  call g:assert.equals(getline(2),   '[',          'failed at #562')
  call g:assert.equals(getline(3),   'bb',         'failed at #562')
  call g:assert.equals(getline(4),   '',           'failed at #562')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #562')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #562')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #562')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #563
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #563')

  %delete

  """ on
  " #564
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #564')

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
  " #565
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #565')

  """ 1
  " #566
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #566')

  " #567
  call setline('.', '"foo"')
  normal 0Vsrb
  call g:assert.equals(getline('.'), '"foo"', 'failed at #567')
  call g:assert.equals(exists(s:object), 0,   'failed at #567')

  " #568
  call setline('.', '"foo"')
  normal 0Vsrc
  call g:assert.equals(getline('.'), '"foo"', 'failed at #568')
  call g:assert.equals(exists(s:object), 0,   'failed at #568')

  " #569
  call setline('.', '"''foo''"')
  normal 0V2srab
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #569')
  call g:assert.equals(exists(s:object), 0,       'failed at #569')

  " #570
  call setline('.', '"''foo''"')
  normal 0V2srac
  call g:assert.equals(getline('.'), '2''foo''3', 'failed at #570')
  call g:assert.equals(exists(s:object), 0,       'failed at #570')


  " #571
  call setline('.', '"''foo''"')
  normal 0V2srba
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #571')
  call g:assert.equals(exists(s:object), 0,       'failed at #571')

  " #572
  call setline('.', '"''foo''"')
  normal 0V2srca
  call g:assert.equals(getline('.'), '"''foo''"', 'failed at #572')
  call g:assert.equals(exists(s:object), 0,       'failed at #572')

  " #573
  call setline('.', '"foo"')
  normal 0Vsrd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #573')

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

  " #574
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #574')
  call g:assert.equals(getline(2),   '[',          'failed at #574')
  call g:assert.equals(getline(3),   '',           'failed at #574')
  call g:assert.equals(getline(4),   '    foo',    'failed at #574')
  call g:assert.equals(getline(5),   '',           'failed at #574')
  call g:assert.equals(getline(6),   ']',          'failed at #574')
  call g:assert.equals(getline(7),   '}',          'failed at #574')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #574')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #574')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #574')
  call g:assert.equals(&l:autoindent,  0,          'failed at #574')
  call g:assert.equals(&l:smartindent, 0,          'failed at #574')
  call g:assert.equals(&l:cindent,     0,          'failed at #574')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #574')

  %delete

  " #575
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #575')
  call g:assert.equals(getline(2),   '    [',      'failed at #575')
  call g:assert.equals(getline(3),   '',           'failed at #575')
  call g:assert.equals(getline(4),   '    foo',    'failed at #575')
  call g:assert.equals(getline(5),   '',           'failed at #575')
  call g:assert.equals(getline(6),   '    ]',      'failed at #575')
  call g:assert.equals(getline(7),   '    }',      'failed at #575')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #575')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #575')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #575')
  call g:assert.equals(&l:autoindent,  1,          'failed at #575')
  call g:assert.equals(&l:smartindent, 0,          'failed at #575')
  call g:assert.equals(&l:cindent,     0,          'failed at #575')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #575')

  %delete

  " #576
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #576')
  call g:assert.equals(getline(2),   '    [',       'failed at #576')
  call g:assert.equals(getline(3),   '',            'failed at #576')
  call g:assert.equals(getline(4),   '    foo',     'failed at #576')
  call g:assert.equals(getline(5),   '',            'failed at #576')
  call g:assert.equals(getline(6),   '    ]',       'failed at #576')
  call g:assert.equals(getline(7),   '}',           'failed at #576')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #576')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #576')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #576')
  call g:assert.equals(&l:autoindent,  1,           'failed at #576')
  call g:assert.equals(&l:smartindent, 1,           'failed at #576')
  call g:assert.equals(&l:cindent,     0,           'failed at #576')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #576')

  %delete

  " #577
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #577')
  call g:assert.equals(getline(2),   '    [',       'failed at #577')
  call g:assert.equals(getline(3),   '',            'failed at #577')
  call g:assert.equals(getline(4),   '    foo',     'failed at #577')
  call g:assert.equals(getline(5),   '',            'failed at #577')
  call g:assert.equals(getline(6),   '    ]',       'failed at #577')
  call g:assert.equals(getline(7),   '    }',       'failed at #577')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #577')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #577')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #577')
  call g:assert.equals(&l:autoindent,  1,           'failed at #577')
  call g:assert.equals(&l:smartindent, 1,           'failed at #577')
  call g:assert.equals(&l:cindent,     1,           'failed at #577')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #577')

  %delete

  " #578
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',            'failed at #578')
  call g:assert.equals(getline(2),   '           [',        'failed at #578')
  call g:assert.equals(getline(3),   '',                    'failed at #578')
  call g:assert.equals(getline(4),   '    foo',             'failed at #578')
  call g:assert.equals(getline(5),   '',                    'failed at #578')
  call g:assert.equals(getline(6),   '        ]',           'failed at #578')
  call g:assert.equals(getline(7),   '                }',   'failed at #578')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #578')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #578')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #578')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #578')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #578')
  call g:assert.equals(&l:cindent,     1,                   'failed at #578')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #578')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #579
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #579')
  call g:assert.equals(getline(2),   '[',          'failed at #579')
  call g:assert.equals(getline(3),   '',           'failed at #579')
  call g:assert.equals(getline(4),   '    foo',    'failed at #579')
  call g:assert.equals(getline(5),   '',           'failed at #579')
  call g:assert.equals(getline(6),   ']',          'failed at #579')
  call g:assert.equals(getline(7),   '}',          'failed at #579')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #579')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #579')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #579')
  call g:assert.equals(&l:autoindent,  0,          'failed at #579')
  call g:assert.equals(&l:smartindent, 0,          'failed at #579')
  call g:assert.equals(&l:cindent,     0,          'failed at #579')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #579')

  %delete

  " #580
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #580')
  call g:assert.equals(getline(2),   '[',          'failed at #580')
  call g:assert.equals(getline(3),   '',           'failed at #580')
  call g:assert.equals(getline(4),   '    foo',    'failed at #580')
  call g:assert.equals(getline(5),   '',           'failed at #580')
  call g:assert.equals(getline(6),   ']',          'failed at #580')
  call g:assert.equals(getline(7),   '}',          'failed at #580')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #580')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #580')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #580')
  call g:assert.equals(&l:autoindent,  1,          'failed at #580')
  call g:assert.equals(&l:smartindent, 0,          'failed at #580')
  call g:assert.equals(&l:cindent,     0,          'failed at #580')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #580')

  %delete

  " #581
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #581')
  call g:assert.equals(getline(2),   '[',          'failed at #581')
  call g:assert.equals(getline(3),   '',           'failed at #581')
  call g:assert.equals(getline(4),   '    foo',    'failed at #581')
  call g:assert.equals(getline(5),   '',           'failed at #581')
  call g:assert.equals(getline(6),   ']',          'failed at #581')
  call g:assert.equals(getline(7),   '}',          'failed at #581')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #581')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #581')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #581')
  call g:assert.equals(&l:autoindent,  1,          'failed at #581')
  call g:assert.equals(&l:smartindent, 1,          'failed at #581')
  call g:assert.equals(&l:cindent,     0,          'failed at #581')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #581')

  %delete

  " #582
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #582')
  call g:assert.equals(getline(2),   '[',          'failed at #582')
  call g:assert.equals(getline(3),   '',           'failed at #582')
  call g:assert.equals(getline(4),   '    foo',    'failed at #582')
  call g:assert.equals(getline(5),   '',           'failed at #582')
  call g:assert.equals(getline(6),   ']',          'failed at #582')
  call g:assert.equals(getline(7),   '}',          'failed at #582')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #582')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #582')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #582')
  call g:assert.equals(&l:autoindent,  1,          'failed at #582')
  call g:assert.equals(&l:smartindent, 1,          'failed at #582')
  call g:assert.equals(&l:cindent,     1,          'failed at #582')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #582')

  %delete

  " #583
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #583')
  call g:assert.equals(getline(2),   '[',              'failed at #583')
  call g:assert.equals(getline(3),   '',               'failed at #583')
  call g:assert.equals(getline(4),   '    foo',        'failed at #583')
  call g:assert.equals(getline(5),   '',               'failed at #583')
  call g:assert.equals(getline(6),   ']',              'failed at #583')
  call g:assert.equals(getline(7),   '}',              'failed at #583')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #583')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #583')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #583')
  call g:assert.equals(&l:autoindent,  1,              'failed at #583')
  call g:assert.equals(&l:smartindent, 1,              'failed at #583')
  call g:assert.equals(&l:cindent,     1,              'failed at #583')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #583')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #584
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #584')
  call g:assert.equals(getline(2),   '    [',      'failed at #584')
  call g:assert.equals(getline(3),   '',           'failed at #584')
  call g:assert.equals(getline(4),   '    foo',    'failed at #584')
  call g:assert.equals(getline(5),   '',           'failed at #584')
  call g:assert.equals(getline(6),   '    ]',      'failed at #584')
  call g:assert.equals(getline(7),   '    }',      'failed at #584')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #584')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #584')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #584')
  call g:assert.equals(&l:autoindent,  0,          'failed at #584')
  call g:assert.equals(&l:smartindent, 0,          'failed at #584')
  call g:assert.equals(&l:cindent,     0,          'failed at #584')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #584')

  %delete

  " #585
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #585')
  call g:assert.equals(getline(2),   '    [',      'failed at #585')
  call g:assert.equals(getline(3),   '',           'failed at #585')
  call g:assert.equals(getline(4),   '    foo',    'failed at #585')
  call g:assert.equals(getline(5),   '',           'failed at #585')
  call g:assert.equals(getline(6),   '    ]',      'failed at #585')
  call g:assert.equals(getline(7),   '    }',      'failed at #585')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #585')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #585')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #585')
  call g:assert.equals(&l:autoindent,  1,          'failed at #585')
  call g:assert.equals(&l:smartindent, 0,          'failed at #585')
  call g:assert.equals(&l:cindent,     0,          'failed at #585')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #585')

  %delete

  " #586
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #586')
  call g:assert.equals(getline(2),   '    [',      'failed at #586')
  call g:assert.equals(getline(3),   '',           'failed at #586')
  call g:assert.equals(getline(4),   '    foo',    'failed at #586')
  call g:assert.equals(getline(5),   '',           'failed at #586')
  call g:assert.equals(getline(6),   '    ]',      'failed at #586')
  call g:assert.equals(getline(7),   '    }',      'failed at #586')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #586')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #586')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #586')
  call g:assert.equals(&l:autoindent,  1,          'failed at #586')
  call g:assert.equals(&l:smartindent, 1,          'failed at #586')
  call g:assert.equals(&l:cindent,     0,          'failed at #586')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #586')

  %delete

  " #587
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #587')
  call g:assert.equals(getline(2),   '    [',      'failed at #587')
  call g:assert.equals(getline(3),   '',           'failed at #587')
  call g:assert.equals(getline(4),   '    foo',    'failed at #587')
  call g:assert.equals(getline(5),   '',           'failed at #587')
  call g:assert.equals(getline(6),   '    ]',      'failed at #587')
  call g:assert.equals(getline(7),   '    }',      'failed at #587')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #587')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #587')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #587')
  call g:assert.equals(&l:autoindent,  1,          'failed at #587')
  call g:assert.equals(&l:smartindent, 1,          'failed at #587')
  call g:assert.equals(&l:cindent,     1,          'failed at #587')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #587')

  %delete

  " #588
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',          'failed at #588')
  call g:assert.equals(getline(2),   '    [',          'failed at #588')
  call g:assert.equals(getline(3),   '',               'failed at #588')
  call g:assert.equals(getline(4),   '    foo',        'failed at #588')
  call g:assert.equals(getline(5),   '',               'failed at #588')
  call g:assert.equals(getline(6),   '    ]',          'failed at #588')
  call g:assert.equals(getline(7),   '    }',          'failed at #588')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #588')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #588')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #588')
  call g:assert.equals(&l:autoindent,  1,              'failed at #588')
  call g:assert.equals(&l:smartindent, 1,              'failed at #588')
  call g:assert.equals(&l:cindent,     1,              'failed at #588')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #588')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #589
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #589')
  call g:assert.equals(getline(2),   '    [',       'failed at #589')
  call g:assert.equals(getline(3),   '',            'failed at #589')
  call g:assert.equals(getline(4),   '    foo',     'failed at #589')
  call g:assert.equals(getline(5),   '',            'failed at #589')
  call g:assert.equals(getline(6),   '    ]',       'failed at #589')
  call g:assert.equals(getline(7),   '}',           'failed at #589')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #589')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #589')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #589')
  call g:assert.equals(&l:autoindent,  0,           'failed at #589')
  call g:assert.equals(&l:smartindent, 0,           'failed at #589')
  call g:assert.equals(&l:cindent,     0,           'failed at #589')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #589')

  %delete

  " #590
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #590')
  call g:assert.equals(getline(2),   '    [',       'failed at #590')
  call g:assert.equals(getline(3),   '',            'failed at #590')
  call g:assert.equals(getline(4),   '    foo',     'failed at #590')
  call g:assert.equals(getline(5),   '',            'failed at #590')
  call g:assert.equals(getline(6),   '    ]',       'failed at #590')
  call g:assert.equals(getline(7),   '}',           'failed at #590')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #590')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #590')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #590')
  call g:assert.equals(&l:autoindent,  1,           'failed at #590')
  call g:assert.equals(&l:smartindent, 0,           'failed at #590')
  call g:assert.equals(&l:cindent,     0,           'failed at #590')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #590')

  %delete

  " #591
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #591')
  call g:assert.equals(getline(2),   '    [',       'failed at #591')
  call g:assert.equals(getline(3),   '',            'failed at #591')
  call g:assert.equals(getline(4),   '    foo',     'failed at #591')
  call g:assert.equals(getline(5),   '',            'failed at #591')
  call g:assert.equals(getline(6),   '    ]',       'failed at #591')
  call g:assert.equals(getline(7),   '}',           'failed at #591')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #591')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #591')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #591')
  call g:assert.equals(&l:autoindent,  1,           'failed at #591')
  call g:assert.equals(&l:smartindent, 1,           'failed at #591')
  call g:assert.equals(&l:cindent,     0,           'failed at #591')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #591')

  %delete

  " #592
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #592')
  call g:assert.equals(getline(2),   '    [',       'failed at #592')
  call g:assert.equals(getline(3),   '',            'failed at #592')
  call g:assert.equals(getline(4),   '    foo',     'failed at #592')
  call g:assert.equals(getline(5),   '',            'failed at #592')
  call g:assert.equals(getline(6),   '    ]',       'failed at #592')
  call g:assert.equals(getline(7),   '}',           'failed at #592')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #592')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #592')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #592')
  call g:assert.equals(&l:autoindent,  1,           'failed at #592')
  call g:assert.equals(&l:smartindent, 1,           'failed at #592')
  call g:assert.equals(&l:cindent,     1,           'failed at #592')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #592')

  %delete

  " #593
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #593')
  call g:assert.equals(getline(2),   '    [',          'failed at #593')
  call g:assert.equals(getline(3),   '',               'failed at #593')
  call g:assert.equals(getline(4),   '    foo',        'failed at #593')
  call g:assert.equals(getline(5),   '',               'failed at #593')
  call g:assert.equals(getline(6),   '    ]',          'failed at #593')
  call g:assert.equals(getline(7),   '}',              'failed at #593')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #593')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #593')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #593')
  call g:assert.equals(&l:autoindent,  1,              'failed at #593')
  call g:assert.equals(&l:smartindent, 1,              'failed at #593')
  call g:assert.equals(&l:cindent,     1,              'failed at #593')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #593')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #594
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #594')
  call g:assert.equals(getline(2),   '    [',       'failed at #594')
  call g:assert.equals(getline(3),   '',            'failed at #594')
  call g:assert.equals(getline(4),   '    foo',     'failed at #594')
  call g:assert.equals(getline(5),   '',            'failed at #594')
  call g:assert.equals(getline(6),   '    ]',       'failed at #594')
  call g:assert.equals(getline(7),   '    }',       'failed at #594')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #594')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #594')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #594')
  call g:assert.equals(&l:autoindent,  0,           'failed at #594')
  call g:assert.equals(&l:smartindent, 0,           'failed at #594')
  call g:assert.equals(&l:cindent,     0,           'failed at #594')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #594')

  %delete

  " #595
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #595')
  call g:assert.equals(getline(2),   '    [',       'failed at #595')
  call g:assert.equals(getline(3),   '',            'failed at #595')
  call g:assert.equals(getline(4),   '    foo',     'failed at #595')
  call g:assert.equals(getline(5),   '',            'failed at #595')
  call g:assert.equals(getline(6),   '    ]',       'failed at #595')
  call g:assert.equals(getline(7),   '    }',       'failed at #595')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #595')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #595')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #595')
  call g:assert.equals(&l:autoindent,  1,           'failed at #595')
  call g:assert.equals(&l:smartindent, 0,           'failed at #595')
  call g:assert.equals(&l:cindent,     0,           'failed at #595')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #595')

  %delete

  " #596
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #596')
  call g:assert.equals(getline(2),   '    [',       'failed at #596')
  call g:assert.equals(getline(3),   '',            'failed at #596')
  call g:assert.equals(getline(4),   '    foo',     'failed at #596')
  call g:assert.equals(getline(5),   '',            'failed at #596')
  call g:assert.equals(getline(6),   '    ]',       'failed at #596')
  call g:assert.equals(getline(7),   '    }',       'failed at #596')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #596')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #596')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #596')
  call g:assert.equals(&l:autoindent,  1,           'failed at #596')
  call g:assert.equals(&l:smartindent, 1,           'failed at #596')
  call g:assert.equals(&l:cindent,     0,           'failed at #596')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #596')

  %delete

  " #597
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #597')
  call g:assert.equals(getline(2),   '    [',       'failed at #597')
  call g:assert.equals(getline(3),   '',            'failed at #597')
  call g:assert.equals(getline(4),   '    foo',     'failed at #597')
  call g:assert.equals(getline(5),   '',            'failed at #597')
  call g:assert.equals(getline(6),   '    ]',       'failed at #597')
  call g:assert.equals(getline(7),   '    }',       'failed at #597')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #597')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #597')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #597')
  call g:assert.equals(&l:autoindent,  1,           'failed at #597')
  call g:assert.equals(&l:smartindent, 1,           'failed at #597')
  call g:assert.equals(&l:cindent,     1,           'failed at #597')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #597')

  %delete

  " #598
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #598')
  call g:assert.equals(getline(2),   '    [',          'failed at #598')
  call g:assert.equals(getline(3),   '',               'failed at #598')
  call g:assert.equals(getline(4),   '    foo',        'failed at #598')
  call g:assert.equals(getline(5),   '',               'failed at #598')
  call g:assert.equals(getline(6),   '    ]',          'failed at #598')
  call g:assert.equals(getline(7),   '    }',          'failed at #598')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #598')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #598')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #598')
  call g:assert.equals(&l:autoindent,  1,              'failed at #598')
  call g:assert.equals(&l:smartindent, 1,              'failed at #598')
  call g:assert.equals(&l:cindent,     1,              'failed at #598')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #598')
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

  " #599
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #599')
  call g:assert.equals(getline(2),   '',           'failed at #599')
  call g:assert.equals(getline(3),   '    foo',    'failed at #599')
  call g:assert.equals(getline(4),   '',           'failed at #599')
  call g:assert.equals(getline(5),   '    }',      'failed at #599')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #599')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #599')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #599')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #599')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #599')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #600
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #600')
  call g:assert.equals(getline(2),   '',           'failed at #600')
  call g:assert.equals(getline(3),   '    foo',    'failed at #600')
  call g:assert.equals(getline(4),   '',           'failed at #600')
  call g:assert.equals(getline(5),   '    }',      'failed at #600')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #600')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #600')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #600')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #600')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #600')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #601
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #601')
  call g:assert.equals(getline(2),   '',           'failed at #601')
  call g:assert.equals(getline(3),   '    foo',    'failed at #601')
  call g:assert.equals(getline(4),   '',           'failed at #601')
  call g:assert.equals(getline(5),   '    }',      'failed at #601')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #601')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #601')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #601')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #601')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #601')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #602
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #602')
  call g:assert.equals(getline(2),   '',              'failed at #602')
  call g:assert.equals(getline(3),   '    foo',       'failed at #602')
  call g:assert.equals(getline(4),   '',              'failed at #602')
  call g:assert.equals(getline(5),   '    }',         'failed at #602')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #602')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #602')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #602')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #602')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #602')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #603
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',      'failed at #603')
  call g:assert.equals(getline(2),   '',              'failed at #603')
  call g:assert.equals(getline(3),   '    foo',       'failed at #603')
  call g:assert.equals(getline(4),   '',              'failed at #603')
  call g:assert.equals(getline(5),   '            }', 'failed at #603')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #603')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #603')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #603')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #603')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #603')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #604
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #604')
  call g:assert.equals(getline(2),   '',              'failed at #604')
  call g:assert.equals(getline(3),   '    foo',       'failed at #604')
  call g:assert.equals(getline(4),   '',              'failed at #604')
  call g:assert.equals(getline(5),   '    }',         'failed at #604')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #604')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #604')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #604')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #604')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #604')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #605
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #605')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #605')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #605')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #605')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #605')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #605')

  %delete

  " #606
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #606')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #606')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #606')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #606')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #606')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #606')

  %delete

  " #607
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #607')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #607')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #607')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #607')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #607')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #607')

  %delete

  " #608
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #608')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #608')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #608')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #608')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #608')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #608')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #609
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #609')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #609')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #609')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #609')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #609')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #609')

  " #610
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #610')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #610')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #610')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #610')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #610')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #610')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #611
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #611')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #611')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #611')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #611')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #611')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #611')

  %delete

  " #612
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #612')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #612')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #612')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #612')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #612')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #612')

  %delete

  " #613
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #613')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #613')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #613')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #613')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #613')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #613')

  %delete

  " #614
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #614')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #614')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #614')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #614')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #614')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #614')

  %delete

  " #615
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #615')
  call g:assert.equals(getline(2),   'barbar',     'failed at #615')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #615')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #615')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #615')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #615')

  %delete

  " #616
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #616')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #616')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #616')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #616')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #616')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #616')

  %delete

  " #617
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #617')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #617')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #617')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #617')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #617')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #617')

  %delete

  " #618
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #618')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #618')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #618')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #618')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #618')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #618')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #619
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #619')
  call g:assert.equals(getline(2),   '[b]',        'failed at #619')
  call g:assert.equals(getline(3),   '[c]',        'failed at #619')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #619')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #619')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #619')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #620
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #620')
  call g:assert.equals(getline(2),   '[]',         'failed at #620')
  call g:assert.equals(getline(3),   '[]',         'failed at #620')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #620')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #620')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #620')

  %delete

  " #621
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #621')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #621')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #621')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #621')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #621')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #621')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #622
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #622')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #622')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #622')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #622')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #622')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #622')

  %delete

  " #623
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #623')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #623')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #623')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #623')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #623')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #623')

  %delete

  " #624
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #624')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #624')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #624')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #624')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #624')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #624')

  %delete

  " #625
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #625')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #625')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #625')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #625')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #625')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #625')

  %delete

  " #626
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #626')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #626')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #626')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #626')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #626')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #626')

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

  " #627
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #627')
  call g:assert.equals(getline(2), '"bar"', 'failed at #627')
  call g:assert.equals(getline(3), '"baz"', 'failed at #627')

  %delete

  " #628
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #628')
  call g:assert.equals(getline(2), '"bar"', 'failed at #628')
  call g:assert.equals(getline(3), '"baz"', 'failed at #628')

  %delete

  " #629
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #629')
  call g:assert.equals(getline(2), '"bar"', 'failed at #629')
  call g:assert.equals(getline(3), '"baz"', 'failed at #629')

  %delete

  " #630
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #630')
  call g:assert.equals(getline(2), '"bar"', 'failed at #630')
  call g:assert.equals(getline(3), '"baz"', 'failed at #630')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #631
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #631')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #631')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #631')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #631')

  " #632
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #632')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #632')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #632')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #632')

  %delete

  """ keep
  " #633
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #633')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #633')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #633')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #633')

  " #634
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #634')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #634')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #634')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #634')

  %delete

  """ inner_tail
  " #635
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #635')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #635')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #635')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #635')

  " #636
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #636')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #636')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #636')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #636')

  %delete

  """ head
  " #637
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #637')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #637')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #637')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #637')

  " #638
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #638')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #638')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #638')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #638')

  %delete

  """ tail
  " #639
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #639')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #639')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #639')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #639')

  " #640
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #640')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #640')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #640')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #640')

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
  " #641
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #641')
  call g:assert.equals(getline(2), '"bar"', 'failed at #641')
  call g:assert.equals(getline(3), '"baz"', 'failed at #641')

  %delete

  " #642
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #642')
  call g:assert.equals(getline(2), '(bar)', 'failed at #642')
  call g:assert.equals(getline(3), '(baz)', 'failed at #642')

  %delete

  """ off
  " #643
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #643')
  call g:assert.equals(getline(2), '{bar}', 'failed at #643')
  call g:assert.equals(getline(3), '{baz}', 'failed at #643')

  %delete

  " #644
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #644')
  call g:assert.equals(getline(2), '"bar"', 'failed at #644')
  call g:assert.equals(getline(3), '"baz"', 'failed at #644')

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
  " #645
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #645')
  call g:assert.equals(getline(2), '"bar"', 'failed at #645')
  call g:assert.equals(getline(3), '"baz"', 'failed at #645')

  %delete

  " #646
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #646')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #646')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #646')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #647
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #647')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #647')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #647')

  %delete

  " #648
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #648')
  call g:assert.equals(getline(2), '"bar"', 'failed at #648')
  call g:assert.equals(getline(3), '"baz"', 'failed at #648')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ 1
  " #649
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #649')
  call g:assert.equals(getline(2), '(bar)', 'failed at #649')
  call g:assert.equals(getline(3), '(baz)', 'failed at #649')

  %delete

  " #650
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #650')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #650')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #650')

  %delete

  " #651
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #651')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #651')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #651')

  %delete

  " #652
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #652')
  call g:assert.equals(getline(2), '("bar")', 'failed at #652')
  call g:assert.equals(getline(3), '("baz")', 'failed at #652')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #653
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #653')
  call g:assert.equals(getline(2), '(bar)', 'failed at #653')
  call g:assert.equals(getline(3), '(baz)', 'failed at #653')

  %delete

  " #654
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #654')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #654')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #654')

  %delete

  " #655
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #655')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #655')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #655')

  %delete

  " #656
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #656')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #656')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #656')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #657
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #657')
  call g:assert.equals(getline(2), '(bar)', 'failed at #657')
  call g:assert.equals(getline(3), '(baz)', 'failed at #657')

  %delete

  " #658
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #658')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #658')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #658')

  %delete

  " #659
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #659')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #659')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #659')

  %delete

  " #660
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #660')
  call g:assert.equals(getline(2), '("bar")', 'failed at #660')
  call g:assert.equals(getline(3), '("baz")', 'failed at #660')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #661
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #661')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #661')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #661')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #662
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #662')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #662')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #662')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #663
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '', 'failed at #663')
  call g:assert.equals(getline(2), '', 'failed at #663')
  call g:assert.equals(getline(3), '', 'failed at #663')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #663
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #663')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #663')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #663')

  %delete

  """ on
  " #664
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #664')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #664')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #664')

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
  " #665
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '1+1foo1+2', 'failed at #665')
  call g:assert.equals(getline(2), '1+1bar1+2', 'failed at #665')
  call g:assert.equals(getline(3), '1+1baz1+2', 'failed at #665')

  %delete

  """ 1
  " #666
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline(1), '2foo3', 'failed at #666')
  call g:assert.equals(getline(2), '2bar3', 'failed at #666')
  call g:assert.equals(getline(3), '2baz3', 'failed at #666')

  %delete

  " #667
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #667')
  call g:assert.equals(getline(2), '"bar"', 'failed at #667')
  call g:assert.equals(getline(3), '"baz"', 'failed at #667')
  call g:assert.equals(exists(s:object), 0, 'failed at #667')

  %delete

  " #668
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17lc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #668')
  call g:assert.equals(getline(2), '"bar"', 'failed at #668')
  call g:assert.equals(getline(3), '"baz"', 'failed at #668')
  call g:assert.equals(exists(s:object), 0, 'failed at #668')

  %delete

  " #669
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #669')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #669')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #669')
  call g:assert.equals(exists(s:object), 0,     'failed at #669')

  %delete

  " #670
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #670')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #670')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #670')
  call g:assert.equals(exists(s:object), 0,     'failed at #670')

  %delete

  " #671
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #671')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #671')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #671')
  call g:assert.equals(exists(s:object), 0,     'failed at #671')

  %delete

  " #672
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg2sr\<C-v>23lca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #672')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #672')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #672')
  call g:assert.equals(exists(s:object), 0,     'failed at #672')

  %delete

  " #673
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17ld"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #673')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #673')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #673')

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

  " #674
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #674')
  call g:assert.equals(getline(2),   '[',          'failed at #674')
  call g:assert.equals(getline(3),   'foo',        'failed at #674')
  call g:assert.equals(getline(4),   ']',          'failed at #674')
  call g:assert.equals(getline(5),   '}',          'failed at #674')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #674')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #674')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #674')
  call g:assert.equals(&l:autoindent,  0,          'failed at #674')
  call g:assert.equals(&l:smartindent, 0,          'failed at #674')
  call g:assert.equals(&l:cindent,     0,          'failed at #674')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #674')

  %delete

  " #675
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #675')
  call g:assert.equals(getline(2),   '    [',      'failed at #675')
  call g:assert.equals(getline(3),   '    foo',    'failed at #675')
  call g:assert.equals(getline(4),   '    ]',      'failed at #675')
  call g:assert.equals(getline(5),   '    }',      'failed at #675')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #675')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #675')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #675')
  call g:assert.equals(&l:autoindent,  1,          'failed at #675')
  call g:assert.equals(&l:smartindent, 0,          'failed at #675')
  call g:assert.equals(&l:cindent,     0,          'failed at #675')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #675')

  %delete

  " #676
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #676')
  call g:assert.equals(getline(2),   '        [',   'failed at #676')
  call g:assert.equals(getline(3),   '        foo', 'failed at #676')
  call g:assert.equals(getline(4),   '    ]',       'failed at #676')
  call g:assert.equals(getline(5),   '}',           'failed at #676')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #676')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #676')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #676')
  call g:assert.equals(&l:autoindent,  1,           'failed at #676')
  call g:assert.equals(&l:smartindent, 1,           'failed at #676')
  call g:assert.equals(&l:cindent,     0,           'failed at #676')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #676')

  %delete

  " #677
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #677')
  call g:assert.equals(getline(2),   '    [',       'failed at #677')
  call g:assert.equals(getline(3),   '        foo', 'failed at #677')
  call g:assert.equals(getline(4),   '    ]',       'failed at #677')
  call g:assert.equals(getline(5),   '    }',       'failed at #677')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #677')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #677')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #677')
  call g:assert.equals(&l:autoindent,  1,           'failed at #677')
  call g:assert.equals(&l:smartindent, 1,           'failed at #677')
  call g:assert.equals(&l:cindent,     1,           'failed at #677')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #677')

  %delete

  " #678
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',           'failed at #678')
  call g:assert.equals(getline(2),   '            [',       'failed at #678')
  call g:assert.equals(getline(3),   '                foo', 'failed at #678')
  call g:assert.equals(getline(4),   '        ]',           'failed at #678')
  call g:assert.equals(getline(5),   '                }',   'failed at #678')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #678')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #678')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #678')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #678')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #678')
  call g:assert.equals(&l:cindent,     1,                   'failed at #678')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #678')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #679
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #679')
  call g:assert.equals(getline(2),   '[',          'failed at #679')
  call g:assert.equals(getline(3),   'foo',        'failed at #679')
  call g:assert.equals(getline(4),   ']',          'failed at #679')
  call g:assert.equals(getline(5),   '}',          'failed at #679')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #679')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #679')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #679')
  call g:assert.equals(&l:autoindent,  0,          'failed at #679')
  call g:assert.equals(&l:smartindent, 0,          'failed at #679')
  call g:assert.equals(&l:cindent,     0,          'failed at #679')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #679')

  %delete

  " #680
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #680')
  call g:assert.equals(getline(2),   '[',          'failed at #680')
  call g:assert.equals(getline(3),   'foo',        'failed at #680')
  call g:assert.equals(getline(4),   ']',          'failed at #680')
  call g:assert.equals(getline(5),   '}',          'failed at #680')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #680')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #680')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #680')
  call g:assert.equals(&l:autoindent,  1,          'failed at #680')
  call g:assert.equals(&l:smartindent, 0,          'failed at #680')
  call g:assert.equals(&l:cindent,     0,          'failed at #680')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #680')

  %delete

  " #681
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #681')
  call g:assert.equals(getline(2),   '[',          'failed at #681')
  call g:assert.equals(getline(3),   'foo',        'failed at #681')
  call g:assert.equals(getline(4),   ']',          'failed at #681')
  call g:assert.equals(getline(5),   '}',          'failed at #681')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #681')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #681')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #681')
  call g:assert.equals(&l:autoindent,  1,          'failed at #681')
  call g:assert.equals(&l:smartindent, 1,          'failed at #681')
  call g:assert.equals(&l:cindent,     0,          'failed at #681')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #681')

  %delete

  " #682
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #682')
  call g:assert.equals(getline(2),   '[',          'failed at #682')
  call g:assert.equals(getline(3),   'foo',        'failed at #682')
  call g:assert.equals(getline(4),   ']',          'failed at #682')
  call g:assert.equals(getline(5),   '}',          'failed at #682')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #682')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #682')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #682')
  call g:assert.equals(&l:autoindent,  1,          'failed at #682')
  call g:assert.equals(&l:smartindent, 1,          'failed at #682')
  call g:assert.equals(&l:cindent,     1,          'failed at #682')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #682')

  %delete

  " #683
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #683')
  call g:assert.equals(getline(2),   '[',              'failed at #683')
  call g:assert.equals(getline(3),   'foo',            'failed at #683')
  call g:assert.equals(getline(4),   ']',              'failed at #683')
  call g:assert.equals(getline(5),   '}',              'failed at #683')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #683')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #683')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #683')
  call g:assert.equals(&l:autoindent,  1,              'failed at #683')
  call g:assert.equals(&l:smartindent, 1,              'failed at #683')
  call g:assert.equals(&l:cindent,     1,              'failed at #683')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #683')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #684
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #684')
  call g:assert.equals(getline(2),   '    [',      'failed at #684')
  call g:assert.equals(getline(3),   '    foo',    'failed at #684')
  call g:assert.equals(getline(4),   '    ]',      'failed at #684')
  call g:assert.equals(getline(5),   '    }',      'failed at #684')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #684')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #684')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #684')
  call g:assert.equals(&l:autoindent,  0,          'failed at #684')
  call g:assert.equals(&l:smartindent, 0,          'failed at #684')
  call g:assert.equals(&l:cindent,     0,          'failed at #684')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #684')

  %delete

  " #685
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #685')
  call g:assert.equals(getline(2),   '    [',      'failed at #685')
  call g:assert.equals(getline(3),   '    foo',    'failed at #685')
  call g:assert.equals(getline(4),   '    ]',      'failed at #685')
  call g:assert.equals(getline(5),   '    }',      'failed at #685')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #685')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #685')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #685')
  call g:assert.equals(&l:autoindent,  1,          'failed at #685')
  call g:assert.equals(&l:smartindent, 0,          'failed at #685')
  call g:assert.equals(&l:cindent,     0,          'failed at #685')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #685')

  %delete

  " #686
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #686')
  call g:assert.equals(getline(2),   '    [',      'failed at #686')
  call g:assert.equals(getline(3),   '    foo',    'failed at #686')
  call g:assert.equals(getline(4),   '    ]',      'failed at #686')
  call g:assert.equals(getline(5),   '    }',      'failed at #686')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #686')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #686')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #686')
  call g:assert.equals(&l:autoindent,  1,          'failed at #686')
  call g:assert.equals(&l:smartindent, 1,          'failed at #686')
  call g:assert.equals(&l:cindent,     0,          'failed at #686')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #686')

  %delete

  " #687
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #687')
  call g:assert.equals(getline(2),   '    [',      'failed at #687')
  call g:assert.equals(getline(3),   '    foo',    'failed at #687')
  call g:assert.equals(getline(4),   '    ]',      'failed at #687')
  call g:assert.equals(getline(5),   '    }',      'failed at #687')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #687')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #687')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #687')
  call g:assert.equals(&l:autoindent,  1,          'failed at #687')
  call g:assert.equals(&l:smartindent, 1,          'failed at #687')
  call g:assert.equals(&l:cindent,     1,          'failed at #687')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #687')

  %delete

  " #688
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #688')
  call g:assert.equals(getline(2),   '    [',          'failed at #688')
  call g:assert.equals(getline(3),   '    foo',        'failed at #688')
  call g:assert.equals(getline(4),   '    ]',          'failed at #688')
  call g:assert.equals(getline(5),   '    }',          'failed at #688')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #688')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #688')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #688')
  call g:assert.equals(&l:autoindent,  1,              'failed at #688')
  call g:assert.equals(&l:smartindent, 1,              'failed at #688')
  call g:assert.equals(&l:cindent,     1,              'failed at #688')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #688')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #689
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #689')
  call g:assert.equals(getline(2),   '        [',   'failed at #689')
  call g:assert.equals(getline(3),   '        foo', 'failed at #689')
  call g:assert.equals(getline(4),   '    ]',       'failed at #689')
  call g:assert.equals(getline(5),   '}',           'failed at #689')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #689')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #689')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #689')
  call g:assert.equals(&l:autoindent,  0,           'failed at #689')
  call g:assert.equals(&l:smartindent, 0,           'failed at #689')
  call g:assert.equals(&l:cindent,     0,           'failed at #689')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #689')

  %delete

  " #690
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #690')
  call g:assert.equals(getline(2),   '        [',   'failed at #690')
  call g:assert.equals(getline(3),   '        foo', 'failed at #690')
  call g:assert.equals(getline(4),   '    ]',       'failed at #690')
  call g:assert.equals(getline(5),   '}',           'failed at #690')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #690')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #690')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #690')
  call g:assert.equals(&l:autoindent,  1,           'failed at #690')
  call g:assert.equals(&l:smartindent, 0,           'failed at #690')
  call g:assert.equals(&l:cindent,     0,           'failed at #690')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #690')

  %delete

  " #691
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #691')
  call g:assert.equals(getline(2),   '        [',   'failed at #691')
  call g:assert.equals(getline(3),   '        foo', 'failed at #691')
  call g:assert.equals(getline(4),   '    ]',       'failed at #691')
  call g:assert.equals(getline(5),   '}',           'failed at #691')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #691')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #691')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #691')
  call g:assert.equals(&l:autoindent,  1,           'failed at #691')
  call g:assert.equals(&l:smartindent, 1,           'failed at #691')
  call g:assert.equals(&l:cindent,     0,           'failed at #691')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #691')

  %delete

  " #692
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #692')
  call g:assert.equals(getline(2),   '        [',   'failed at #692')
  call g:assert.equals(getline(3),   '        foo', 'failed at #692')
  call g:assert.equals(getline(4),   '    ]',       'failed at #692')
  call g:assert.equals(getline(5),   '}',           'failed at #692')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #692')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #692')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #692')
  call g:assert.equals(&l:autoindent,  1,           'failed at #692')
  call g:assert.equals(&l:smartindent, 1,           'failed at #692')
  call g:assert.equals(&l:cindent,     1,           'failed at #692')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #692')

  %delete

  " #693
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #693')
  call g:assert.equals(getline(2),   '        [',      'failed at #693')
  call g:assert.equals(getline(3),   '        foo',    'failed at #693')
  call g:assert.equals(getline(4),   '    ]',          'failed at #693')
  call g:assert.equals(getline(5),   '}',              'failed at #693')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #693')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #693')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #693')
  call g:assert.equals(&l:autoindent,  1,              'failed at #693')
  call g:assert.equals(&l:smartindent, 1,              'failed at #693')
  call g:assert.equals(&l:cindent,     1,              'failed at #693')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #693')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #694
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #694')
  call g:assert.equals(getline(2),   '    [',       'failed at #694')
  call g:assert.equals(getline(3),   '        foo', 'failed at #694')
  call g:assert.equals(getline(4),   '    ]',       'failed at #694')
  call g:assert.equals(getline(5),   '    }',       'failed at #694')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #694')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #694')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #694')
  call g:assert.equals(&l:autoindent,  0,           'failed at #694')
  call g:assert.equals(&l:smartindent, 0,           'failed at #694')
  call g:assert.equals(&l:cindent,     0,           'failed at #694')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #694')

  %delete

  " #695
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #695')
  call g:assert.equals(getline(2),   '    [',       'failed at #695')
  call g:assert.equals(getline(3),   '        foo', 'failed at #695')
  call g:assert.equals(getline(4),   '    ]',       'failed at #695')
  call g:assert.equals(getline(5),   '    }',       'failed at #695')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #695')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #695')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #695')
  call g:assert.equals(&l:autoindent,  1,           'failed at #695')
  call g:assert.equals(&l:smartindent, 0,           'failed at #695')
  call g:assert.equals(&l:cindent,     0,           'failed at #695')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #695')

  %delete

  " #696
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #696')
  call g:assert.equals(getline(2),   '    [',       'failed at #696')
  call g:assert.equals(getline(3),   '        foo', 'failed at #696')
  call g:assert.equals(getline(4),   '    ]',       'failed at #696')
  call g:assert.equals(getline(5),   '    }',       'failed at #696')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #696')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #696')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #696')
  call g:assert.equals(&l:autoindent,  1,           'failed at #696')
  call g:assert.equals(&l:smartindent, 1,           'failed at #696')
  call g:assert.equals(&l:cindent,     0,           'failed at #696')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #696')

  %delete

  " #697
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #697')
  call g:assert.equals(getline(2),   '    [',       'failed at #697')
  call g:assert.equals(getline(3),   '        foo', 'failed at #697')
  call g:assert.equals(getline(4),   '    ]',       'failed at #697')
  call g:assert.equals(getline(5),   '    }',       'failed at #697')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #697')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #697')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #697')
  call g:assert.equals(&l:autoindent,  1,           'failed at #697')
  call g:assert.equals(&l:smartindent, 1,           'failed at #697')
  call g:assert.equals(&l:cindent,     1,           'failed at #697')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #697')

  %delete

  " #698
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',              'failed at #698')
  call g:assert.equals(getline(2),   '    [',          'failed at #698')
  call g:assert.equals(getline(3),   '        foo',    'failed at #698')
  call g:assert.equals(getline(4),   '    ]',          'failed at #698')
  call g:assert.equals(getline(5),   '    }',          'failed at #698')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #698')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #698')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #698')
  call g:assert.equals(&l:autoindent,  1,              'failed at #698')
  call g:assert.equals(&l:smartindent, 1,              'failed at #698')
  call g:assert.equals(&l:cindent,     1,              'failed at #698')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #698')
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

  " #699
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #699')
  call g:assert.equals(getline(2),   'foo',        'failed at #699')
  call g:assert.equals(getline(3),   '    }',      'failed at #699')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #699')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #699')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #699')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #699')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #699')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #700
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #700')
  call g:assert.equals(getline(2),   '    foo',    'failed at #700')
  call g:assert.equals(getline(3),   '    }',      'failed at #700')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #700')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #700')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #700')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #700')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #700')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #701
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #701')
  call g:assert.equals(getline(2),   'foo',        'failed at #701')
  call g:assert.equals(getline(3),   '    }',      'failed at #701')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #701')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #701')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #701')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #701')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #701')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #702
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #702')
  call g:assert.equals(getline(2),   'foo',        'failed at #702')
  call g:assert.equals(getline(3),   '    }',      'failed at #702')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #702')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #702')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #702')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #702')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #702')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #703
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',     'failed at #703')
  call g:assert.equals(getline(2),   '    foo',       'failed at #703')
  call g:assert.equals(getline(3),   '            }', 'failed at #703')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #703')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #703')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #703')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #703')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #703')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #704
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #704')
  call g:assert.equals(getline(2),   'foo',        'failed at #704')
  call g:assert.equals(getline(3),   '    }',      'failed at #704')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #704')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #704')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #704')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #704')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #704')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #705
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #705')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #705')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #705')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #705')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #705')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #705')

  %delete

  " #706
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #706')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #706')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #706')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #706')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #706')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #706')

  %delete

  " #707
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #707')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #707')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #707')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #707')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #707')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #707')

  %delete

  " #708
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #708')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #708')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #708')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #708')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #708')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #708')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #709
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #709')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #709')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #709')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #709')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #709')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #709')

  " #710
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #710')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #710')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #710')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #710')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #710')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #710')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #711
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #711')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #711')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #711')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #711')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #711')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #711')

  %delete

  " #712
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #712')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #712')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #712')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #712')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #712')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #712')

  %delete

  " #713
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #713')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #713')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #713')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #713')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #713')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #713')

  %delete

  " #714
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #714')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #714')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #714')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #714')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #714')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #714')

  %delete

  " #715
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #715')
  call g:assert.equals(getline(2),   'barbar',     'failed at #715')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #715')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #715')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #715')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #715')

  %delete

  " #716
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #716')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #716')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #716')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #716')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #716')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #716')

  %delete

  " #717
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #717')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #717')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #717')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #717')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #717')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #717')

  %delete

  " #718
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #718')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #718')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #718')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #718')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #718')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #718')

  %delete

  " #719
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #719')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #719')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #719')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #719')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #719')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #719')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #720
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #720')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #720')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #720')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #720')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #720')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #720')

  %delete

  " #721
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #721')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #721')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #721')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #721')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #721')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #721')

  %delete

  " #722
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #722')
  call g:assert.equals(getline(2),   '',           'failed at #722')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #722')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #722')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #722')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #722')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #723
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #723')
  call g:assert.equals(getline(2),   '[b]',        'failed at #723')
  call g:assert.equals(getline(3),   '[c]',        'failed at #723')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #723')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #723')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #723')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #724
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #724')
  call g:assert.equals(getline(2),   '[]',         'failed at #724')
  call g:assert.equals(getline(3),   '[]',         'failed at #724')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #724')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #724')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #724')

  %delete

  " #725
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #725')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #725')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #725')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #725')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #725')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #725')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #726
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #726')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #726')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #726')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #726')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #726')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #726')

  %delete

  " #727
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #727')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #727')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #727')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #727')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #727')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #727')

  %delete

  " #728
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #728')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #728')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #728')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #728')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #728')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #728')

  %delete

  " #729
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #729')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #729')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #729')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #729')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #729')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #729')

  %delete

  " #730
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #730')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #730')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #730')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #730')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #730')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #730')
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

  " #731
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #731')
  call g:assert.equals(getline(2), '"bar"', 'failed at #731')
  call g:assert.equals(getline(3), '"baz"', 'failed at #731')

  %delete

  " #732
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #732')
  call g:assert.equals(getline(2), '"bar"', 'failed at #732')
  call g:assert.equals(getline(3), '"baz"', 'failed at #732')

  %delete

  " #733
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #733')
  call g:assert.equals(getline(2), '"bar"', 'failed at #733')
  call g:assert.equals(getline(3), '"baz"', 'failed at #733')

  %delete

  " #734
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #734')
  call g:assert.equals(getline(2), '"bar"', 'failed at #734')
  call g:assert.equals(getline(3), '"baz"', 'failed at #734')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #735
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #735')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #735')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #735')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #735')

  " #736
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #736')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #736')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #736')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #736')

  %delete

  """ keep
  " #737
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #737')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #737')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #737')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #737')

  " #738
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #738')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #738')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #738')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #738')

  %delete

  """ inner_tail
  " #739
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #739')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #739')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #739')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #739')

  " #740
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #740')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #740')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #740')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #740')

  %delete

  """ head
  " #741
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #741')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #741')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #741')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #741')

  " #742
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #742')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #742')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #742')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #742')

  %delete

  """ tail
  " #743
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #743')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #743')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #743')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #743')

  " #744
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #744')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #744')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #744')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #744')

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
  " #745
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #745')
  call g:assert.equals(getline(2), '"bar"', 'failed at #745')
  call g:assert.equals(getline(3), '"baz"', 'failed at #745')

  %delete

  " #746
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #746')
  call g:assert.equals(getline(2), '(bar)', 'failed at #746')
  call g:assert.equals(getline(3), '(baz)', 'failed at #746')

  %delete

  """ off
  " #747
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #747')
  call g:assert.equals(getline(2), '{bar}', 'failed at #747')
  call g:assert.equals(getline(3), '{baz}', 'failed at #747')

  %delete

  " #748
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #748')
  call g:assert.equals(getline(2), '"bar"', 'failed at #748')
  call g:assert.equals(getline(3), '"baz"', 'failed at #748')

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
  " #749
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #749')
  call g:assert.equals(getline(2), '"bar"', 'failed at #749')
  call g:assert.equals(getline(3), '"baz"', 'failed at #749')

  %delete

  " #750
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #750')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #750')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #750')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #751
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #751')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #751')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #751')

  %delete

  " #752
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #752')
  call g:assert.equals(getline(2), '"bar"', 'failed at #752')
  call g:assert.equals(getline(3), '"baz"', 'failed at #752')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ 1
  " #753
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #753')
  call g:assert.equals(getline(2), '(bar)', 'failed at #753')
  call g:assert.equals(getline(3), '(baz)', 'failed at #753')

  %delete

  " #754
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #754')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #754')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #754')

  %delete

  " #755
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #755')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #755')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #755')

  %delete

  " #756
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #756')
  call g:assert.equals(getline(2), '("bar")', 'failed at #756')
  call g:assert.equals(getline(3), '("baz")', 'failed at #756')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #757
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #757')
  call g:assert.equals(getline(2), '(bar)', 'failed at #757')
  call g:assert.equals(getline(3), '(baz)', 'failed at #757')

  %delete

  " #758
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #758')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #758')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #758')

  %delete

  " #759
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #759')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #759')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #759')

  %delete

  " #760
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #760')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #760')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #760')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #761
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #761')
  call g:assert.equals(getline(2), '(bar)', 'failed at #761')
  call g:assert.equals(getline(3), '(baz)', 'failed at #761')

  %delete

  " #762
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #762')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #762')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #762')

  %delete

  " #763
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #763')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #763')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #763')

  %delete

  " #764
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #764')
  call g:assert.equals(getline(2), '("bar")', 'failed at #764')
  call g:assert.equals(getline(3), '("baz")', 'failed at #764')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #765
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #765')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #765')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #765')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #766
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #766')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #766')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #766')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #767
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '', 'failed at #767')
  call g:assert.equals(getline(2), '', 'failed at #767')
  call g:assert.equals(getline(3), '', 'failed at #767')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #767
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #767')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #767')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #767')

  %delete

  """ on
  " #768
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #768')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #768')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #768')

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
  " #769
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #769')

  %delete

  """ 1
  " #770
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #770')

  %delete

  " #771
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1), '"foo"', 'failed at #771')
  call g:assert.equals(getline(2), '"bar"', 'failed at #771')
  call g:assert.equals(getline(3), '"baz"', 'failed at #771')
  call g:assert.equals(exists(s:object), 0, 'failed at #771')

  %delete

  " #772
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrc"
  call g:assert.equals(getline(1), '"foo"', 'failed at #772')
  call g:assert.equals(getline(2), '"bar"', 'failed at #772')
  call g:assert.equals(getline(3), '"baz"', 'failed at #772')
  call g:assert.equals(exists(s:object), 0, 'failed at #772')

  %delete

  " #773
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srab"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #773')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #773')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #773')
  call g:assert.equals(exists(s:object), 0,     'failed at #773')

  %delete

  " #774
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srac"
  call g:assert.equals(getline(1), '2''foo''3', 'failed at #774')
  call g:assert.equals(getline(2), '2''bar''3', 'failed at #774')
  call g:assert.equals(getline(3), '2''baz''3', 'failed at #774')
  call g:assert.equals(exists(s:object), 0,     'failed at #774')

  %delete

  " #775
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srba"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #775')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #775')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #775')
  call g:assert.equals(exists(s:object), 0,     'failed at #775')

  %delete

  " #776
  call append(0, ['"''foo''"', '"''bar''"', '"''baz''"'])
  execute "normal gg\<C-v>2j7l2srca"
  call g:assert.equals(getline(1), '"''foo''"', 'failed at #776')
  call g:assert.equals(getline(2), '"''bar''"', 'failed at #776')
  call g:assert.equals(getline(3), '"''baz''"', 'failed at #776')
  call g:assert.equals(exists(s:object), 0,     'failed at #776')

  %delete

  " #777
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsrd"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #777')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #777')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #777')

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

  " #772
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #772')
  call g:assert.equals(getline(2),   '[',          'failed at #772')
  call g:assert.equals(getline(3),   'foo',        'failed at #772')
  call g:assert.equals(getline(4),   ']',          'failed at #772')
  call g:assert.equals(getline(5),   '}',          'failed at #772')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #772')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #772')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #772')
  call g:assert.equals(&l:autoindent,  0,          'failed at #772')
  call g:assert.equals(&l:smartindent, 0,          'failed at #772')
  call g:assert.equals(&l:cindent,     0,          'failed at #772')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #772')

  %delete

  " #773
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #773')
  call g:assert.equals(getline(2),   '    [',      'failed at #773')
  call g:assert.equals(getline(3),   '    foo',    'failed at #773')
  call g:assert.equals(getline(4),   '    ]',      'failed at #773')
  call g:assert.equals(getline(5),   '    }',      'failed at #773')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #773')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #773')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #773')
  call g:assert.equals(&l:autoindent,  1,          'failed at #773')
  call g:assert.equals(&l:smartindent, 0,          'failed at #773')
  call g:assert.equals(&l:cindent,     0,          'failed at #773')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #773')

  %delete

  " #774
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #774')
  call g:assert.equals(getline(2),   '        [',   'failed at #774')
  call g:assert.equals(getline(3),   '        foo', 'failed at #774')
  call g:assert.equals(getline(4),   '    ]',       'failed at #774')
  call g:assert.equals(getline(5),   '}',           'failed at #774')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #774')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #774')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #774')
  call g:assert.equals(&l:autoindent,  1,           'failed at #774')
  call g:assert.equals(&l:smartindent, 1,           'failed at #774')
  call g:assert.equals(&l:cindent,     0,           'failed at #774')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #774')

  %delete

  " #775
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #775')
  call g:assert.equals(getline(2),   '    [',       'failed at #775')
  call g:assert.equals(getline(3),   '        foo', 'failed at #775')
  call g:assert.equals(getline(4),   '    ]',       'failed at #775')
  call g:assert.equals(getline(5),   '    }',       'failed at #775')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #775')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #775')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #775')
  call g:assert.equals(&l:autoindent,  1,           'failed at #775')
  call g:assert.equals(&l:smartindent, 1,           'failed at #775')
  call g:assert.equals(&l:cindent,     1,           'failed at #775')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #775')

  %delete

  " #776
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',           'failed at #776')
  call g:assert.equals(getline(2),   '            [',       'failed at #776')
  call g:assert.equals(getline(3),   '                foo', 'failed at #776')
  call g:assert.equals(getline(4),   '        ]',           'failed at #776')
  call g:assert.equals(getline(5),   '                }',   'failed at #776')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #776')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #776')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #776')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #776')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #776')
  call g:assert.equals(&l:cindent,     1,                   'failed at #776')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #776')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #777
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #777')
  call g:assert.equals(getline(2),   '[',          'failed at #777')
  call g:assert.equals(getline(3),   'foo',        'failed at #777')
  call g:assert.equals(getline(4),   ']',          'failed at #777')
  call g:assert.equals(getline(5),   '}',          'failed at #777')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #777')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #777')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #777')
  call g:assert.equals(&l:autoindent,  0,          'failed at #777')
  call g:assert.equals(&l:smartindent, 0,          'failed at #777')
  call g:assert.equals(&l:cindent,     0,          'failed at #777')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #777')

  %delete

  " #778
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #778')
  call g:assert.equals(getline(2),   '[',          'failed at #778')
  call g:assert.equals(getline(3),   'foo',        'failed at #778')
  call g:assert.equals(getline(4),   ']',          'failed at #778')
  call g:assert.equals(getline(5),   '}',          'failed at #778')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #778')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #778')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #778')
  call g:assert.equals(&l:autoindent,  1,          'failed at #778')
  call g:assert.equals(&l:smartindent, 0,          'failed at #778')
  call g:assert.equals(&l:cindent,     0,          'failed at #778')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #778')

  %delete

  " #779
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #779')
  call g:assert.equals(getline(2),   '[',          'failed at #779')
  call g:assert.equals(getline(3),   'foo',        'failed at #779')
  call g:assert.equals(getline(4),   ']',          'failed at #779')
  call g:assert.equals(getline(5),   '}',          'failed at #779')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #779')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #779')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #779')
  call g:assert.equals(&l:autoindent,  1,          'failed at #779')
  call g:assert.equals(&l:smartindent, 1,          'failed at #779')
  call g:assert.equals(&l:cindent,     0,          'failed at #779')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #779')

  %delete

  " #780
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #780')
  call g:assert.equals(getline(2),   '[',          'failed at #780')
  call g:assert.equals(getline(3),   'foo',        'failed at #780')
  call g:assert.equals(getline(4),   ']',          'failed at #780')
  call g:assert.equals(getline(5),   '}',          'failed at #780')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #780')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #780')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #780')
  call g:assert.equals(&l:autoindent,  1,          'failed at #780')
  call g:assert.equals(&l:smartindent, 1,          'failed at #780')
  call g:assert.equals(&l:cindent,     1,          'failed at #780')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #780')

  %delete

  " #781
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #781')
  call g:assert.equals(getline(2),   '[',              'failed at #781')
  call g:assert.equals(getline(3),   'foo',            'failed at #781')
  call g:assert.equals(getline(4),   ']',              'failed at #781')
  call g:assert.equals(getline(5),   '}',              'failed at #781')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #781')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #781')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #781')
  call g:assert.equals(&l:autoindent,  1,              'failed at #781')
  call g:assert.equals(&l:smartindent, 1,              'failed at #781')
  call g:assert.equals(&l:cindent,     1,              'failed at #781')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #781')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #782
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #782')
  call g:assert.equals(getline(2),   '    [',      'failed at #782')
  call g:assert.equals(getline(3),   '    foo',    'failed at #782')
  call g:assert.equals(getline(4),   '    ]',      'failed at #782')
  call g:assert.equals(getline(5),   '    }',      'failed at #782')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #782')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #782')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #782')
  call g:assert.equals(&l:autoindent,  0,          'failed at #782')
  call g:assert.equals(&l:smartindent, 0,          'failed at #782')
  call g:assert.equals(&l:cindent,     0,          'failed at #782')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #782')

  %delete

  " #783
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #783')
  call g:assert.equals(getline(2),   '    [',      'failed at #783')
  call g:assert.equals(getline(3),   '    foo',    'failed at #783')
  call g:assert.equals(getline(4),   '    ]',      'failed at #783')
  call g:assert.equals(getline(5),   '    }',      'failed at #783')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #783')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #783')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #783')
  call g:assert.equals(&l:autoindent,  1,          'failed at #783')
  call g:assert.equals(&l:smartindent, 0,          'failed at #783')
  call g:assert.equals(&l:cindent,     0,          'failed at #783')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #783')

  %delete

  " #784
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #784')
  call g:assert.equals(getline(2),   '    [',      'failed at #784')
  call g:assert.equals(getline(3),   '    foo',    'failed at #784')
  call g:assert.equals(getline(4),   '    ]',      'failed at #784')
  call g:assert.equals(getline(5),   '    }',      'failed at #784')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #784')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #784')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #784')
  call g:assert.equals(&l:autoindent,  1,          'failed at #784')
  call g:assert.equals(&l:smartindent, 1,          'failed at #784')
  call g:assert.equals(&l:cindent,     0,          'failed at #784')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #784')

  %delete

  " #785
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #785')
  call g:assert.equals(getline(2),   '    [',      'failed at #785')
  call g:assert.equals(getline(3),   '    foo',    'failed at #785')
  call g:assert.equals(getline(4),   '    ]',      'failed at #785')
  call g:assert.equals(getline(5),   '    }',      'failed at #785')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #785')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #785')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #785')
  call g:assert.equals(&l:autoindent,  1,          'failed at #785')
  call g:assert.equals(&l:smartindent, 1,          'failed at #785')
  call g:assert.equals(&l:cindent,     1,          'failed at #785')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #785')

  %delete

  " #786
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #786')
  call g:assert.equals(getline(2),   '    [',          'failed at #786')
  call g:assert.equals(getline(3),   '    foo',        'failed at #786')
  call g:assert.equals(getline(4),   '    ]',          'failed at #786')
  call g:assert.equals(getline(5),   '    }',          'failed at #786')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #786')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #786')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #786')
  call g:assert.equals(&l:autoindent,  1,              'failed at #786')
  call g:assert.equals(&l:smartindent, 1,              'failed at #786')
  call g:assert.equals(&l:cindent,     1,              'failed at #786')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #786')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #787
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #787')
  call g:assert.equals(getline(2),   '        [',   'failed at #787')
  call g:assert.equals(getline(3),   '        foo', 'failed at #787')
  call g:assert.equals(getline(4),   '    ]',       'failed at #787')
  call g:assert.equals(getline(5),   '}',           'failed at #787')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #787')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #787')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #787')
  call g:assert.equals(&l:autoindent,  0,           'failed at #787')
  call g:assert.equals(&l:smartindent, 0,           'failed at #787')
  call g:assert.equals(&l:cindent,     0,           'failed at #787')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #787')

  %delete

  " #788
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #788')
  call g:assert.equals(getline(2),   '        [',   'failed at #788')
  call g:assert.equals(getline(3),   '        foo', 'failed at #788')
  call g:assert.equals(getline(4),   '    ]',       'failed at #788')
  call g:assert.equals(getline(5),   '}',           'failed at #788')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #788')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #788')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #788')
  call g:assert.equals(&l:autoindent,  1,           'failed at #788')
  call g:assert.equals(&l:smartindent, 0,           'failed at #788')
  call g:assert.equals(&l:cindent,     0,           'failed at #788')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #788')

  %delete

  " #789
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #789')
  call g:assert.equals(getline(2),   '        [',   'failed at #789')
  call g:assert.equals(getline(3),   '        foo', 'failed at #789')
  call g:assert.equals(getline(4),   '    ]',       'failed at #789')
  call g:assert.equals(getline(5),   '}',           'failed at #789')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #789')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #789')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #789')
  call g:assert.equals(&l:autoindent,  1,           'failed at #789')
  call g:assert.equals(&l:smartindent, 1,           'failed at #789')
  call g:assert.equals(&l:cindent,     0,           'failed at #789')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #789')

  %delete

  " #790
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #790')
  call g:assert.equals(getline(2),   '        [',   'failed at #790')
  call g:assert.equals(getline(3),   '        foo', 'failed at #790')
  call g:assert.equals(getline(4),   '    ]',       'failed at #790')
  call g:assert.equals(getline(5),   '}',           'failed at #790')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #790')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #790')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #790')
  call g:assert.equals(&l:autoindent,  1,           'failed at #790')
  call g:assert.equals(&l:smartindent, 1,           'failed at #790')
  call g:assert.equals(&l:cindent,     1,           'failed at #790')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #790')

  %delete

  " #791
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #791')
  call g:assert.equals(getline(2),   '        [',      'failed at #791')
  call g:assert.equals(getline(3),   '        foo',    'failed at #791')
  call g:assert.equals(getline(4),   '    ]',          'failed at #791')
  call g:assert.equals(getline(5),   '}',              'failed at #791')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #791')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #791')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #791')
  call g:assert.equals(&l:autoindent,  1,              'failed at #791')
  call g:assert.equals(&l:smartindent, 1,              'failed at #791')
  call g:assert.equals(&l:cindent,     1,              'failed at #791')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #791')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #792
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #792')
  call g:assert.equals(getline(2),   '    [',       'failed at #792')
  call g:assert.equals(getline(3),   '        foo', 'failed at #792')
  call g:assert.equals(getline(4),   '    ]',       'failed at #792')
  call g:assert.equals(getline(5),   '    }',       'failed at #792')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #792')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #792')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #792')
  call g:assert.equals(&l:autoindent,  0,           'failed at #792')
  call g:assert.equals(&l:smartindent, 0,           'failed at #792')
  call g:assert.equals(&l:cindent,     0,           'failed at #792')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #792')

  %delete

  " #793
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #793')
  call g:assert.equals(getline(2),   '    [',       'failed at #793')
  call g:assert.equals(getline(3),   '        foo', 'failed at #793')
  call g:assert.equals(getline(4),   '    ]',       'failed at #793')
  call g:assert.equals(getline(5),   '    }',       'failed at #793')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #793')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #793')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #793')
  call g:assert.equals(&l:autoindent,  1,           'failed at #793')
  call g:assert.equals(&l:smartindent, 0,           'failed at #793')
  call g:assert.equals(&l:cindent,     0,           'failed at #793')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #793')

  %delete

  " #794
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #794')
  call g:assert.equals(getline(2),   '    [',       'failed at #794')
  call g:assert.equals(getline(3),   '        foo', 'failed at #794')
  call g:assert.equals(getline(4),   '    ]',       'failed at #794')
  call g:assert.equals(getline(5),   '    }',       'failed at #794')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #794')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #794')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #794')
  call g:assert.equals(&l:autoindent,  1,           'failed at #794')
  call g:assert.equals(&l:smartindent, 1,           'failed at #794')
  call g:assert.equals(&l:cindent,     0,           'failed at #794')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #794')

  %delete

  " #795
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #795')
  call g:assert.equals(getline(2),   '    [',       'failed at #795')
  call g:assert.equals(getline(3),   '        foo', 'failed at #795')
  call g:assert.equals(getline(4),   '    ]',       'failed at #795')
  call g:assert.equals(getline(5),   '    }',       'failed at #795')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #795')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #795')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #795')
  call g:assert.equals(&l:autoindent,  1,           'failed at #795')
  call g:assert.equals(&l:smartindent, 1,           'failed at #795')
  call g:assert.equals(&l:cindent,     1,           'failed at #795')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #795')

  %delete

  " #796
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',              'failed at #796')
  call g:assert.equals(getline(2),   '    [',          'failed at #796')
  call g:assert.equals(getline(3),   '        foo',    'failed at #796')
  call g:assert.equals(getline(4),   '    ]',          'failed at #796')
  call g:assert.equals(getline(5),   '    }',          'failed at #796')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #796')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #796')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #796')
  call g:assert.equals(&l:autoindent,  1,              'failed at #796')
  call g:assert.equals(&l:smartindent, 1,              'failed at #796')
  call g:assert.equals(&l:cindent,     1,              'failed at #796')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #796')
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

  " #797
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #797')
  call g:assert.equals(getline(2),   'foo',        'failed at #797')
  call g:assert.equals(getline(3),   '    }',      'failed at #797')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #797')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #797')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #797')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #797')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #797')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #798
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #798')
  call g:assert.equals(getline(2),   '    foo',    'failed at #798')
  call g:assert.equals(getline(3),   '    }',      'failed at #798')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #798')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #798')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #798')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #798')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #798')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #799
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #799')
  call g:assert.equals(getline(2),   'foo',        'failed at #799')
  call g:assert.equals(getline(3),   '    }',      'failed at #799')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #799')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #799')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #799')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #799')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #799')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #800
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #800')
  call g:assert.equals(getline(2),   'foo',        'failed at #800')
  call g:assert.equals(getline(3),   '    }',      'failed at #800')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #800')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #800')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #800')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #800')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #800')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #801
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',     'failed at #801')
  call g:assert.equals(getline(2),   '    foo',       'failed at #801')
  call g:assert.equals(getline(3),   '            }', 'failed at #801')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #801')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #801')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #801')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #801')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #801')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #802
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #802')
  call g:assert.equals(getline(2),   'foo',        'failed at #802')
  call g:assert.equals(getline(3),   '    }',      'failed at #802')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #802')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #802')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #802')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #802')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #802')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #803
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #803')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #803')

  " #804
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #804')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #804')

  " #805
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #805')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #805')

  " #806
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #806')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #806')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #807
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sr$"
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #807')

  " #808
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sr$""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #808')

  " #809
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sr$"""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #809')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
