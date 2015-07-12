let s:suite = themis#suite('operator-sandwich: replace:')

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
        \ ]

  " #20
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #20')

  " #21
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #21')

  set filetype=vim

  " #22
  call setline('.', '{foo}')
  normal 0sra{(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #22')

  " #23
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #23')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \   {'buns': ['(', ')']},
        \ ]

  " #24
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #24')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['add']},
        \ ]

  " #25
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #25')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['delete']},
        \ ]

  " #26
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '{foo}', 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['replace']},
        \ ]

  " #27
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #27')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['operator']},
        \ ]

  " #28
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #28')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}'], 'input': ['[']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #29
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]', 'failed at #29')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #30
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #30')

  " #31
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #31')

  " #32
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #32')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['{']},
        \ ]

  " #33
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #33')

  " #34
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #34')

  " #35
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #35')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['{']},
        \ ]

  " #36
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #36')

  " #37
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #37')

  " #38
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #38')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['{']},
        \ ]

  " #39
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #39')

  " #40
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #40')

  " #41
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #41')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['{']},
        \ ]

  " #42
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #42')

  " #43
  call setline('.', '(foo)')
  normal 0srVl{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #43')

  " #44
  call setline('.', '(foo)')
  execute "normal 0sr\<C-v>a({"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #44')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #45
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #45')

  " #46
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #46')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['{']},
        \ ]

  " #47
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #47')

  " #48
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #48')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['{']},
        \ ]

  " #49
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #49')

  " #50
  call setline('.', '(foo)')
  normal 0va(sr{
  call g:assert.equals(getline('.'), '[foo]', 'failed at #50')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'input': ['{']},
        \ ]

  " #51
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #51')

  " #52
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #52')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['{']},
        \ ]

  " #53
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #53')

  " #54
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #54')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['{']},
        \ ]

  " #55
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '[foo]', 'failed at #55')

  " #56
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #56')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['{', '}']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['{']},
        \ ]

  " #57
  call setline('.', '(foo)')
  normal 0sra({
  call g:assert.equals(getline('.'), '{foo}', 'failed at #57')

  " #58
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #58')
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

  " #59
  call setline('.', '"foo"')
  normal 0sr2i"(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #59')

  " #60
  call setline('.', '"foo"')
  normal 0sr2i"[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #60')

  " #61
  call setline('.', '"foo"')
  normal 0sr2i"{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #61')

  " #62
  call setline('.', '(foo)')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #62')

  " #63
  call setline('.', '[foo]')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #63')

  " #64
  call setline('.', '{foo}')
  normal 0sr5l"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #64')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #65
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]',      'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #65')

  " #66
  call setline('.', '[foo]')
  normal 0sra[{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #66')

  " #67
  call setline('.', '{foo}')
  normal 0sra{<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #67')

  " #68
call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #68')

  " #69
  call setline('.', '(foo)')
  normal 0sra(]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #69')

  " #70
  call setline('.', '[foo]')
  normal 0sra[}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #70')

  " #71
  call setline('.', '{foo}')
  normal 0sra{>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #71')

  " #72
  call setline('.', '<foo>')
  normal 0sra<)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #72')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #73
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #73')

  " #74
  call setline('.', '+foo+')
  normal 0sr$*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #74')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #75
  call setline('.', '(foo)bar')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #75')

  " #76
  call setline('.', 'foo(bar)')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #76')

  " #77
  call setline('.', 'foo(bar)baz')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #77')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))'], 'input': ['(']}, {'buns': ['[', ']']}]

  " #78
  call setline('.', 'foo((bar))baz')
  normal 0srii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #78')

  " #79
  call setline('.', 'foo((bar))baz')
  normal 02lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #79')

  " #80
  call setline('.', 'foo((bar))baz')
  normal 03lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #80')

  " #81
  call setline('.', 'foo((bar))baz')
  normal 04lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #81')

  " #82
  call setline('.', 'foo((bar))baz')
  normal 05lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #82')

  " #83
  call setline('.', 'foo((bar))baz')
  normal 07lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #83')

  " #84
  call setline('.', 'foo((bar))baz')
  normal 08lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #84')

  " #85
  call setline('.', 'foo((bar))baz')
  normal 09lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #85')

  " #86
  call setline('.', 'foo((bar))baz')
  normal 010lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #86')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #86')

  " #87
  call setline('.', 'foo((bar))baz')
  normal 012lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #87')

  " #88
  call setline('.', 'foo[[bar]]baz')
  normal 03lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0],     'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #88')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #88')

  " #89
  call setline('.', 'foo[[bar]]baz')
  normal 09lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0],     'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #89')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #89')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #90
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsr13l[
  call g:assert.equals(getline(1),   '[foo',       'failed at #90')
  call g:assert.equals(getline(2),   'bar',        'failed at #90')
  call g:assert.equals(getline(3),   'baz]',       'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #90')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #91
  call setline('.', '(a)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[a]',        'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #91')

  %delete

  " #92
  call append(0, ['(', 'a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #92')
  call g:assert.equals(getline(2),   'a',          'failed at #92')
  call g:assert.equals(getline(3),   ']',          'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #92')

  %delete

  " #93
  call append(0, ['(a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[a',         'failed at #93')
  call g:assert.equals(getline(2),   ']',          'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #93')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #93')

  %delete

  " #94
  call append(0, ['(', 'a)'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #94')
  call g:assert.equals(getline(2),   'a]',         'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #94')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #95
  call setline('.', '()')
  normal 0sra([
  call g:assert.equals(getline('.'), '[]',         'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #95')

  " #96
  call setline('.', 'foo()bar')
  normal 03lsra([
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #96')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #96')

  %delete

  " #97
  call append(0, ['(', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #97')
  call g:assert.equals(getline(2),   ']',          'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #97')
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #98
  call setline('.', '([foo])')
  normal 02sr%[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #98')

  " #99
  call setline('.', '[({foo})]')
  normal 03sr%{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #99')

  " #100
  call setline('.', '[foo ]bar')
  normal 0sr6l(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #100')

  " #101
  call setline('.', '[foo bar]')
  normal 0sr9l(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #101')

  " #102
  call setline('.', '{[foo bar]}')
  normal 02sr11l[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #102')

  " #103
  call setline('.', 'foo{[bar]}baz')
  normal 03l2sr7l[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #103')

  " #104
  call setline('.', 'foo({[bar]})baz')
  normal 03l3sr9l{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #104')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #104')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #105
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #105')

  %delete

  " #106
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #106')

  %delete

  " #107
  call setline('.', '(foo)')
  normal 0sr5la
  call g:assert.equals(getline(1),   'aa',         'failed at #107')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #107')
  call g:assert.equals(getline(3),   'aa',         'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #107')

  %delete

  " #108
  call setline('.', '(foo)')
  normal 0sr5lb
  call g:assert.equals(getline(1),   'bb',         'failed at #108')
  call g:assert.equals(getline(2),   'bbb',        'failed at #108')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #108')
  call g:assert.equals(getline(4),   'bbb',        'failed at #108')
  call g:assert.equals(getline(5),   'bb',         'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #108')

  %delete

  " #109
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15lb
  call g:assert.equals(getline(1),   'bb',         'failed at #109')
  call g:assert.equals(getline(2),   'bbb',        'failed at #109')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #109')
  call g:assert.equals(getline(4),   'bbb',        'failed at #109')
  call g:assert.equals(getline(5),   'bb',         'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #109')

  %delete

  " #110
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21la
  call g:assert.equals(getline(1),   'aa',         'failed at #110')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #110')
  call g:assert.equals(getline(3),   'aa',         'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #110')

  %delete

  " #111
  call append(0, ['aa', 'aaaaa', 'aaafooaaa', 'aaaaa', 'aa'])
  normal gg2sr27lbb
  call g:assert.equals(getline(1),   'bb',         'failed at #111')
  call g:assert.equals(getline(2),   'bbb',        'failed at #111')
  call g:assert.equals(getline(3),   'bbbb',       'failed at #111')
  call g:assert.equals(getline(4),   'bbb',        'failed at #111')
  call g:assert.equals(getline(5),   'bbfoobb',    'failed at #111')
  call g:assert.equals(getline(6),   'bbb',        'failed at #111')
  call g:assert.equals(getline(7),   'bbbb',       'failed at #111')
  call g:assert.equals(getline(8),   'bbb',        'failed at #111')
  call g:assert.equals(getline(9),   'bb',         'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #111')

  %delete

  " #112
  call append(0, ['bb', 'bbb', 'bbbb', 'bbb', 'bbfoobb', 'bbb', 'bbbb', 'bbb', 'bb'])
  normal gg2sr39laa
  call g:assert.equals(getline(1),   'aa',         'failed at #112')
  call g:assert.equals(getline(2),   'aaaaa',      'failed at #112')
  call g:assert.equals(getline(3),   'aaafooaaa',  'failed at #112')
  call g:assert.equals(getline(4),   'aaaaa',      'failed at #112')
  call g:assert.equals(getline(5),   'aa',         'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #112')

  %delete
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 8)<CR>

  " #113
  call setline('.', ['foo(bar)baz'])
  normal 0sriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #113')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #113')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #113')

  %delete

  " #114
  call setline('.', ['foo(bar)baz'])
  normal 02lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #114')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #114')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #114')

  %delete

  " #115
  call setline('.', ['foo(bar)baz'])
  normal 03lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #115')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #115')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #115')

  %delete

  " #116
  call setline('.', ['foo(bar)baz'])
  normal 04lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #116')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #116')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #116')

  %delete

  " #117
  call setline('.', ['foo(bar)baz'])
  normal 06lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #117')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #117')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #117')

  %delete

  " #118
  call setline('.', ['foo(bar)baz'])
  normal 07lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #118')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #118')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #118')

  %delete

  " #119
  call setline('.', ['foo(bar)baz'])
  normal 08lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #119')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #119')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #119')

  %delete

  " #120
  call setline('.', ['foo(bar)baz'])
  normal 010lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #120')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #120')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #120')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>

  " #121
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #121')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #121')

  %delete

  " #122
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #122')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #122')

  %delete

  " #123
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #123')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #123')

  %delete

  " #124
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #124')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #124')

  %delete

  " #125
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #125')

  %delete

  " #126
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #126')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #126')

  %delete

  " #127
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #127')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #127')

  %delete

  " #128
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #128')

  %delete

  " #129
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #129')

  %delete

  " #130
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #130')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #130')

  %delete

  " #131
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #131')

  %delete

  " #132
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #132')

  %delete

  " #133
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #133')

  %delete

  " #134
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #134')

  %delete

  " #135
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #135')
  call g:assert.equals(getline(2),   'bbb',        'failed at #135')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #135')
  call g:assert.equals(getline(4),   'bbb',        'failed at #135')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #135')

  %delete

  " #136
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #136')
  call g:assert.equals(getline(2),   'bbb',        'failed at #136')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #136')
  call g:assert.equals(getline(4),   'bbb',        'failed at #136')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #136')

  %delete

  " #137
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #137')
  call g:assert.equals(getline(2),   'bbb',        'failed at #137')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #137')
  call g:assert.equals(getline(4),   'bbb',        'failed at #137')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #137')

  %delete

  " #138
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #138')
  call g:assert.equals(getline(2),   'bbb',        'failed at #138')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #138')
  call g:assert.equals(getline(4),   'bbb',        'failed at #138')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #138')

  %delete

  " #139
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #139')
  call g:assert.equals(getline(2),   'bbb',        'failed at #139')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #139')
  call g:assert.equals(getline(4),   'bbb',        'failed at #139')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #139')

  %delete

  " #140
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #140')
  call g:assert.equals(getline(2),   'bbb',        'failed at #140')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #140')
  call g:assert.equals(getline(4),   'bbb',        'failed at #140')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #141')
  call g:assert.equals(getline(2),   'bbb',        'failed at #141')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #141')
  call g:assert.equals(getline(4),   'bbb',        'failed at #141')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #141')

  %delete

  " #142
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #142')
  call g:assert.equals(getline(2),   'bbb',        'failed at #142')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #142')
  call g:assert.equals(getline(4),   'bbb',        'failed at #142')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #142')

  %delete

  " #143
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #143')
  call g:assert.equals(getline(2),   'bbb',        'failed at #143')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #143')
  call g:assert.equals(getline(4),   'bbb',        'failed at #143')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #144')
  call g:assert.equals(getline(2),   'bbb',        'failed at #144')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #144')
  call g:assert.equals(getline(4),   'bbb',        'failed at #144')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 3, 6, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #144')

  %delete

  " #145
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj7lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #145')
  call g:assert.equals(getline(2),   'bbb',        'failed at #145')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #145')
  call g:assert.equals(getline(4),   'bbb',        'failed at #145')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #145')

  %delete

  " #146
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #146')
  call g:assert.equals(getline(2),   'bbb',        'failed at #146')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #146')
  call g:assert.equals(getline(4),   'bbb',        'failed at #146')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #146')

  %delete

  " #147
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #147')
  call g:assert.equals(getline(2),   'bbb',        'failed at #147')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #147')
  call g:assert.equals(getline(4),   'bbb',        'failed at #147')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #147')

  %delete

  " #148
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #148')
  call g:assert.equals(getline(2),   'bbb',        'failed at #148')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #148')
  call g:assert.equals(getline(4),   'bbb',        'failed at #148')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #148')

  %delete

  " #149
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #149')
  call g:assert.equals(getline(2),   'bbb',        'failed at #149')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #149')
  call g:assert.equals(getline(4),   'bbb',        'failed at #149')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #149')

  %delete

  " #150
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #150')
  call g:assert.equals(getline(2),   'bbb',        'failed at #150')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #150')
  call g:assert.equals(getline(4),   'bbb',        'failed at #150')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 5, 5, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #150')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 5, 2)<CR>

  " #151
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #151')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #151')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #151')

  %delete

  " #152
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #152')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #152')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #152')

  %delete

  " #153
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #153')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #153')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #154')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #154')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #154')

  %delete

  " #155
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #155')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #155')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #155')

  %delete

  " #156
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #156')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #156')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #156')

  %delete

  " #157
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggj2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #157')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #157')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #157')

  %delete

  " #158
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #158')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #158')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #158')

  %delete

  " #159
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #159')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #159')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #159')

  %delete

  " #160
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #160')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #160')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #160')

  %delete

  " #161
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #161')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #161')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #161')

  %delete

  " #162
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j5lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #162')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #162')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #162')

  %delete

  " #163
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j6lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #163')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #163')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #163')

  %delete

  " #164
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #164')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #164')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #164')

  %delete

  " #165
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #165')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #165')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #165')

  %delete

  " #166
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #166')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #166')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #166')

  %delete

  " #167
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #167')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #167')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #167')

  %delete

  " #168
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #168')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #168')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #168')

  %delete

  " #169
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #169')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #169')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #169')

  %delete

  " #170
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #170')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #170')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #170')

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

  " #171
  call setline('.', '{[(foo)]}')
  normal 02lsr5l"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #171')

  " #172
  call setline('.', '{[(foo)]}')
  normal 0lsr7l"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #172')

  " #173
  call setline('.', '{[(foo)]}')
  normal 0sr9l"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #173')

  " #174
  call setline('.', '<title>foo</title>')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #174')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #175
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #175')

  " #176
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #176')

  """ keep
  " #177
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #177')

  " #178
  normal lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #178')

  """ inner_tail
  " #179
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #179')

  " #180
  normal hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #180')

  """ head
  " #181
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #181')

  " #182
  normal 3lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #182')

  """ tail
  " #183
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #183')

  " #184
  normal 3hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #184')

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
  " #185
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #185')

  " #186
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #186')

  """ off
  " #187
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #187')

  " #188
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #188')

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
  " #189
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #189')

  " #190
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #190')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #191
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #191')

  " #192
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #192')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ on
  " #193
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #193')

  " #194
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #194')

  " #195
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #195')

  " #196
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #196')

  """ off
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #197
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #197')

  " #198
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #198')

  " #199
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #199')

  " #200
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #200')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #201
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #201')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #202
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #202')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #203
  call setline('.', '(foo)')
  normal 0sra("
  call g:assert.equals(getline('.'), '""', 'failed at #203')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #204
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #204')
  call g:assert.equals(getline(2),   'foo',        'failed at #204')
  call g:assert.equals(getline(3),   ']',          'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #204')

  %delete

  " #205
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #205')
  call g:assert.equals(getline(2),   'foo',        'failed at #205')
  call g:assert.equals(getline(3),   ']',          'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #205')

  %delete

  " #206
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #206')
  call g:assert.equals(getline(2),   'foo',        'failed at #206')
  call g:assert.equals(getline(3),   'aa]',        'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #206')

  %delete

  " #207
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #207')
  call g:assert.equals(getline(2),   'foo',        'failed at #207')
  call g:assert.equals(getline(3),   ']',          'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #207')

  %delete

  " #208
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #208')
  call g:assert.equals(getline(2),   'foo',        'failed at #208')
  call g:assert.equals(getline(3),   'aa]',        'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #208')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #209
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #209')
  call g:assert.equals(getline(2),   'foo',        'failed at #209')
  call g:assert.equals(getline(3),   ']',          'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #209')

  %delete

  " #210
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #210')
  call g:assert.equals(getline(2),   'foo',        'failed at #210')
  call g:assert.equals(getline(3),   ']',          'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #210')

  %delete

  " #211
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #211')
  call g:assert.equals(getline(2),   'foo',        'failed at #211')
  call g:assert.equals(getline(3),   ']',          'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #211')

  %delete

  " #212
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #212')
  call g:assert.equals(getline(2),   '[',          'failed at #212')
  call g:assert.equals(getline(3),   'bb',         'failed at #212')
  call g:assert.equals(getline(4),   '',           'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #212')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #213
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #213')

  %delete

  """ on
  " #214
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #214')

  call operator#sandwich#set('replace', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #215
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #215')

  """ 1
  " #216
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3',  'failed at #216')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'char', 'expr', 0)
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #217
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #217')

  " #218
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #218')

  " #219
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #219')

  " #220
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #220')

  " #221
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #221')

  " #222
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #222')

  " #223
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #223')

  " #224
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #224')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #225
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #225')

  " #226
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #226')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #227
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #227')

  " #228
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #228')

  " #229
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #229')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #229')

  " #230
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #230')
  call g:assert.equals(getline(2),   'bar',        'failed at #230')
  call g:assert.equals(getline(3),   'baz]',       'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #230')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #231
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #231')

  %delete

  " #232
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #232')
  call g:assert.equals(getline(2),   'a',          'failed at #232')
  call g:assert.equals(getline(3),   ']',          'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #232')

  %delete

  " #233
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #233')
  call g:assert.equals(getline(2),   ']',          'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #233')

  %delete

  " #234
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #234')
  call g:assert.equals(getline(2),   'a]',         'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #234')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #235
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #235')

  " #236
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #236')

  %delete

  " #237
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #237')
  call g:assert.equals(getline(2),   ']',          'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #237')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #238
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #238')

  " #239
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #239')

  " #240
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #240')

  " #241
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #241')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #241')

  " #242
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #242')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #242')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #243
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #244')

  %delete

  " #245
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #245')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #245')
  call g:assert.equals(getline(3),   'aa',         'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #245')

  %delete

  " #246
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #246')
  call g:assert.equals(getline(2),   'bbb',        'failed at #246')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #246')
  call g:assert.equals(getline(4),   'bbb',        'failed at #246')
  call g:assert.equals(getline(5),   'bb',         'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #246')
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

  " #247
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #247')

  " #248
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #248')

  " #249
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #249')

  " #250
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #250')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #251
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #251')

  " #252
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #252')

  """ keep
  " #253
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #253')

  " #254
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #254')

  """ inner_tail
  " #255
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #255')

  " #256
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #256')

  """ head
  " #257
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #257')

  " #258
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #258')

  """ tail
  " #259
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #259')

  " #260
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #260')

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
  " #261
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #261')

  " #262
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #262')

  """ off
  " #263
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #263')

  " #264
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #264')

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
  " #265
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #265')

  " #266
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #266')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #267
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #267')

  " #268
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #268')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #269
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #269')

  " #270
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #270')

  " #271
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #271')

  " #272
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #272')

  """ off
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #273
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #273')

  " #274
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #274')

  " #275
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #275')

  " #276
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #276')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #277
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #277')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #278
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #278')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #279
  call setline('.', '(foo)')
  normal 0va(sr"
  call g:assert.equals(getline('.'), '""', 'failed at #279')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #280
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #280')
  call g:assert.equals(getline(2),   'foo',        'failed at #280')
  call g:assert.equals(getline(3),   ']',          'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #280')

  %delete

  " #281
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #281')
  call g:assert.equals(getline(2),   'foo',        'failed at #281')
  call g:assert.equals(getline(3),   ']',          'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #281')

  %delete

  " #282
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #282')
  call g:assert.equals(getline(2),   'foo',        'failed at #282')
  call g:assert.equals(getline(3),   'aa]',        'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #283')
  call g:assert.equals(getline(2),   'foo',        'failed at #283')
  call g:assert.equals(getline(3),   ']',          'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #283')

  %delete

  " #284
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #284')
  call g:assert.equals(getline(2),   'foo',        'failed at #284')
  call g:assert.equals(getline(3),   'aa]',        'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #284')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #285
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #285')
  call g:assert.equals(getline(2),   'foo',        'failed at #285')
  call g:assert.equals(getline(3),   ']',          'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #285')

  %delete

  " #286
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #286')
  call g:assert.equals(getline(2),   'foo',        'failed at #286')
  call g:assert.equals(getline(3),   ']',          'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #286')

  %delete

  " #287
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #287')
  call g:assert.equals(getline(2),   'foo',        'failed at #287')
  call g:assert.equals(getline(3),   ']',          'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #287')

  %delete

  " #288
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #288')
  call g:assert.equals(getline(2),   '[',          'failed at #288')
  call g:assert.equals(getline(3),   'bb',         'failed at #288')
  call g:assert.equals(getline(4),   '',           'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #288')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #289
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #289')

  " #290
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #290')

  " #291
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #291')

  " #292
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #292')

  %delete

  " #293
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #293')
  call g:assert.equals(getline(2),   'foo',        'failed at #293')
  call g:assert.equals(getline(3),   ']',          'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #293')

  " #294
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #294')
  call g:assert.equals(getline(2),   'foo',        'failed at #294')
  call g:assert.equals(getline(3),   '}',          'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #294')

  " #295
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #295')
  call g:assert.equals(getline(2),   'foo',        'failed at #295')
  call g:assert.equals(getline(3),   '>',          'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #295')

  " #296
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #296')
  call g:assert.equals(getline(2),   'foo',        'failed at #296')
  call g:assert.equals(getline(3),   ')',          'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #296')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #297
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #297')

  " #298
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #298')

  %delete

  " #297
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #297')
  call g:assert.equals(getline(2),   'foo',        'failed at #297')
  call g:assert.equals(getline(3),   'b',          'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #297')

  %delete

  " #298
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #298')
  call g:assert.equals(getline(2),   'foo',        'failed at #298')
  call g:assert.equals(getline(3),   '*',          'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #298')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #299
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #299')
  call g:assert.equals(getline(2),   'foo',        'failed at #299')
  call g:assert.equals(getline(3),   'bar',        'failed at #299')
  call g:assert.equals(getline(4),   'baz',        'failed at #299')
  call g:assert.equals(getline(5),   ']',          'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #299')

  %delete

  " #300
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #300')
  call g:assert.equals(getline(2),   '[',          'failed at #300')
  call g:assert.equals(getline(3),   'bar',        'failed at #300')
  call g:assert.equals(getline(4),   ']',          'failed at #300')
  call g:assert.equals(getline(5),   'baz',        'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #300')

  %delete

  " #301
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #301')
  call g:assert.equals(getline(2),   'bar',        'failed at #301')
  call g:assert.equals(getline(3),   'baz]',       'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #301')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #302
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #303')
  call g:assert.equals(getline(2),   ']',          'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #303')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #304
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #304')

  " #305
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #306')
  call g:assert.equals(getline(2),   '(',          'failed at #306')
  call g:assert.equals(getline(3),   '{',          'failed at #306')
  call g:assert.equals(getline(4),   '[',          'failed at #306')
  call g:assert.equals(getline(5),   'bar',        'failed at #306')
  call g:assert.equals(getline(6),   ']',          'failed at #306')
  call g:assert.equals(getline(7),   '}',          'failed at #306')
  call g:assert.equals(getline(8),   ')',          'failed at #306')
  call g:assert.equals(getline(9),   'baz',        'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #306')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #307
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #307')

  %delete

  " #308
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #308')

  %delete

  " #309
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #309')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #309')
  call g:assert.equals(getline(3),   'aa',         'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #309')

  %delete

  " #310
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #310')
  call g:assert.equals(getline(2),   'bbb',        'failed at #310')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #310')
  call g:assert.equals(getline(4),   'bbb',        'failed at #310')
  call g:assert.equals(getline(5),   'bb',         'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #310')

  %delete

  " #311
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #311')
  call g:assert.equals(getline(2),   '(',          'failed at #311')
  call g:assert.equals(getline(3),   'foo',        'failed at #311')
  call g:assert.equals(getline(4),   ')',          'failed at #311')
  call g:assert.equals(getline(5),   ')',          'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #312')
  call g:assert.equals(getline(2),   '(',          'failed at #312')
  call g:assert.equals(getline(3),   'foo',        'failed at #312')
  call g:assert.equals(getline(4),   ')',          'failed at #312')
  call g:assert.equals(getline(5),   ')',          'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #312')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_external_textobj() abort"{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #313
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #313')

  " #314
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #314')

  " #315
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #315')

  " #316
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #316')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #317
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #317')

  " #318
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #318')

  """ keep
  " #319
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #319')

  " #320
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #320')

  """ inner_tail
  " #321
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #321')

  " #322
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #322')

  """ head
  " #323
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #323')

  " #324
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #324')

  """ tail
  " #325
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #325')

  " #326
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #326')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #327
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #327')

  " #328
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #328')

  """ off
  " #329
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #329')

  " #330
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #330')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #331
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #331')

  " #332
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #332')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #333
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #333')

  " #334
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #334')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ on
  " #335
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #335')

  " #336
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #336')

  " #337
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #337')

  " #338
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #338')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #339
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #339')

  " #340
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #340')

  " #341
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #341')

  " #342
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #342')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #343
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #343')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #344
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #344')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #345
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '""', 'failed at #345')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #346
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #346')
  call g:assert.equals(getline(2),   'foo',        'failed at #346')
  call g:assert.equals(getline(3),   ']',          'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #346')

  %delete

  " #347
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #347')
  call g:assert.equals(getline(2),   'foo',        'failed at #347')
  call g:assert.equals(getline(3),   '  ]',        'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #347')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #347')

  %delete

  " #348
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #348')
  call g:assert.equals(getline(2),   'foo',        'failed at #348')
  call g:assert.equals(getline(3),   'aa]',        'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #348')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #348')

  %delete

  " #349
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #349')
  call g:assert.equals(getline(2),   'foo',        'failed at #349')
  call g:assert.equals(getline(3),   ']',          'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #349')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #349')

  %delete

  " #350
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #350')
  call g:assert.equals(getline(2),   'foo',        'failed at #350')
  call g:assert.equals(getline(3),   'aa]',        'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #350')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #350')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #350')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #351
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #351')
  call g:assert.equals(getline(2),   'foo',        'failed at #351')
  call g:assert.equals(getline(3),   ']',          'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #351')

  %delete

  " #352
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #352')
  call g:assert.equals(getline(2),   'foo',        'failed at #352')
  call g:assert.equals(getline(3),   ']',          'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #352')

  %delete

  " #353
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #353')
  call g:assert.equals(getline(2),   'foo',        'failed at #353')
  call g:assert.equals(getline(3),   ']',          'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #353')

  %delete

  " #354
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #354')
  call g:assert.equals(getline(2),   '[',          'failed at #354')
  call g:assert.equals(getline(3),   'bb',         'failed at #354')
  call g:assert.equals(getline(4),   '',           'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #354')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #355
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #355')

  %delete

  """ on
  " #356
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #356')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #357
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #357')

  """ 1
  " #358
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3',  'failed at #358')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'expr', 0)
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #359
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #359')

  " #360
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #360')

  " #361
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #361')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #361')

  " #362
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #362')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #362')

  %delete

  " #363
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #363')
  call g:assert.equals(getline(2),   'foo',        'failed at #363')
  call g:assert.equals(getline(3),   ']',          'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #363')

  " #364
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #364')
  call g:assert.equals(getline(2),   'foo',        'failed at #364')
  call g:assert.equals(getline(3),   '}',          'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #364')

  " #365
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #365')
  call g:assert.equals(getline(2),   'foo',        'failed at #365')
  call g:assert.equals(getline(3),   '>',          'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #365')

  " #366
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #366')
  call g:assert.equals(getline(2),   'foo',        'failed at #366')
  call g:assert.equals(getline(3),   ')',          'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #366')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #367
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #367')

  " #368
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #368')

  %delete

  " #367
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #367')
  call g:assert.equals(getline(2),   'foo',        'failed at #367')
  call g:assert.equals(getline(3),   'b',          'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #367')

  %delete

  " #368
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #368')
  call g:assert.equals(getline(2),   'foo',        'failed at #368')
  call g:assert.equals(getline(3),   '*',          'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #368')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #369
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #369')
  call g:assert.equals(getline(2),   'foo',        'failed at #369')
  call g:assert.equals(getline(3),   'bar',        'failed at #369')
  call g:assert.equals(getline(4),   'baz',        'failed at #369')
  call g:assert.equals(getline(5),   ']',          'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #369')

  %delete

  " #370
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #370')
  call g:assert.equals(getline(2),   '[',          'failed at #370')
  call g:assert.equals(getline(3),   'bar',        'failed at #370')
  call g:assert.equals(getline(4),   ']',          'failed at #370')
  call g:assert.equals(getline(5),   'baz',        'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #370')

  %delete

  " #371
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #371')
  call g:assert.equals(getline(2),   'bar',        'failed at #371')
  call g:assert.equals(getline(3),   'baz]',       'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #371')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #372
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #372')

  %delete

  " #373
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #373')
  call g:assert.equals(getline(2),   ']',          'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #373')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #374
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #374')

  " #375
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #375')

  %delete

  " #376
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #376')
  call g:assert.equals(getline(2),   '(',          'failed at #376')
  call g:assert.equals(getline(3),   '{',          'failed at #376')
  call g:assert.equals(getline(4),   '[',          'failed at #376')
  call g:assert.equals(getline(5),   'bar',        'failed at #376')
  call g:assert.equals(getline(6),   ']',          'failed at #376')
  call g:assert.equals(getline(7),   '}',          'failed at #376')
  call g:assert.equals(getline(8),   ')',          'failed at #376')
  call g:assert.equals(getline(9),   'baz',        'failed at #376')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #376')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #377
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #377')

  %delete

  " #378
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #378')

  %delete

  " #379
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #379')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #379')
  call g:assert.equals(getline(3),   'aa',         'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #379')

  %delete

  " #380
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #380')
  call g:assert.equals(getline(2),   'bbb',        'failed at #380')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #380')
  call g:assert.equals(getline(4),   'bbb',        'failed at #380')
  call g:assert.equals(getline(5),   'bb',         'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #380')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #380')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #380')

  %delete

  " #381
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #381')
  call g:assert.equals(getline(2),   '(',          'failed at #381')
  call g:assert.equals(getline(3),   'foo',        'failed at #381')
  call g:assert.equals(getline(4),   ')',          'failed at #381')
  call g:assert.equals(getline(5),   ')',          'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #381')

  %delete

  " #382
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #382')
  call g:assert.equals(getline(2),   '(',          'failed at #382')
  call g:assert.equals(getline(3),   'foo',        'failed at #382')
  call g:assert.equals(getline(4),   ')',          'failed at #382')
  call g:assert.equals(getline(5),   ')',          'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #382')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_external_textobj() abort"{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #383
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #383')

  " #384
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #384')

  " #385
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #385')

  " #386
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #386')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #387
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #387')

  " #388
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #388')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #388')

  """ keep
  " #389
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #389')

  " #390
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #390')

  """ inner_tail
  " #391
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #391')

  " #392
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #392')

  """ head
  " #393
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #393')

  " #394
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #394')

  """ tail
  " #395
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #395')

  " #396
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #396')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #397
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #397')

  " #398
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #398')

  """ off
  " #399
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #399')

  " #400
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #400')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #401
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #401')

  " #402
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #402')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #403
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #403')

  " #404
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #404')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ on
  " #405
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #405')

  " #406
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #406')

  " #407
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #407')

  " #408
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #408')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #409
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #409')

  " #410
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #410')

  " #411
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #411')

  " #412
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #412')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #413
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #413')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #414
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #414')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #415
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '""', 'failed at #415')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #416
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #416')
  call g:assert.equals(getline(2),   'foo',        'failed at #416')
  call g:assert.equals(getline(3),   ']',          'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #416')

  %delete

  " #417
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #417')
  call g:assert.equals(getline(2),   'foo',        'failed at #417')
  call g:assert.equals(getline(3),   '  ]',        'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #417')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #417')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #417')

  %delete

  " #418
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #418')
  call g:assert.equals(getline(2),   'foo',        'failed at #418')
  call g:assert.equals(getline(3),   'aa]',        'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #418')

  %delete

  " #419
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #419')
  call g:assert.equals(getline(2),   'foo',        'failed at #419')
  call g:assert.equals(getline(3),   ']',          'failed at #419')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #419')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #419')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #419')

  %delete

  " #420
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #420')
  call g:assert.equals(getline(2),   'foo',        'failed at #420')
  call g:assert.equals(getline(3),   'aa]',        'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #420')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #421
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #421')
  call g:assert.equals(getline(2),   'foo',        'failed at #421')
  call g:assert.equals(getline(3),   ']',          'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #421')

  %delete

  " #422
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #422')
  call g:assert.equals(getline(2),   'foo',        'failed at #422')
  call g:assert.equals(getline(3),   ']',          'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #422')

  %delete

  " #423
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #423')
  call g:assert.equals(getline(2),   'foo',        'failed at #423')
  call g:assert.equals(getline(3),   ']',          'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #423')

  %delete

  " #424
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #424')
  call g:assert.equals(getline(2),   '[',          'failed at #424')
  call g:assert.equals(getline(3),   'bb',         'failed at #424')
  call g:assert.equals(getline(4),   '',           'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #424')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #425
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #425')

  %delete

  """ on
  " #426
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #426')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #427
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #427')

  """ 1
  " #428
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #428')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'expr', 0)
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #300
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #300')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #300')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #300')

  %delete

  " #301
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #301')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #301')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #301')

  %delete

  " #302
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #302')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #302')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #303')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #303')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #303')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #304
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #304')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #304')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #304')

  " #305
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #305')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #305')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #305')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #306
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #306')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #306')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #307')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #307')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #307')

  %delete

  " #308
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #308')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #308')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #308')

  %delete

  " #309
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #309')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #309')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #309')

  %delete

  " #310
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #310')
  call g:assert.equals(getline(2),   'barbar',     'failed at #310')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #310')

  %delete

  " #311
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #311')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #311')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #312')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #312')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #312')

  %delete

  " #313
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #313')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #313')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #313')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #314
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #314')
  call g:assert.equals(getline(2),   '[b]',        'failed at #314')
  call g:assert.equals(getline(3),   '[c]',        'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #314')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #315
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #315')
  call g:assert.equals(getline(2),   '[]',         'failed at #315')
  call g:assert.equals(getline(3),   '[]',         'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #315')

  %delete

  " #316
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #316')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #316')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #316')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #317
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #317')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #317')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #317')

  %delete

  " #318
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #318')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #318')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #318')

  %delete

  " #319
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #319')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #319')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #319')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #319')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #319')

  %delete

  " #320
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #320')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #320')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #320')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #320')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #320')

  %delete

  " #321
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #321')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #321')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #321')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #321')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #321')

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

  " #322
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #322')
  call g:assert.equals(getline(2), '"bar"', 'failed at #322')
  call g:assert.equals(getline(3), '"baz"', 'failed at #322')

  %delete

  " #323
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #323')
  call g:assert.equals(getline(2), '"bar"', 'failed at #323')
  call g:assert.equals(getline(3), '"baz"', 'failed at #323')

  %delete

  " #324
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #324')
  call g:assert.equals(getline(2), '"bar"', 'failed at #324')
  call g:assert.equals(getline(3), '"baz"', 'failed at #324')

  %delete

  " #325
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #325')
  call g:assert.equals(getline(2), '"bar"', 'failed at #325')
  call g:assert.equals(getline(3), '"baz"', 'failed at #325')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #326
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #326')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #326')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #326')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #326')

  " #327
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #327')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #327')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #327')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #327')

  %delete

  """ keep
  " #328
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #328')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #328')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #328')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #328')

  " #329
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #329')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #329')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #329')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #329')

  %delete

  """ inner_tail
  " #330
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #330')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #330')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #330')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #330')

  " #331
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #331')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #331')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #331')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #331')

  %delete

  """ head
  " #332
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #332')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #332')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #332')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #332')

  " #333
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #333')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #333')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #333')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #333')

  %delete

  """ tail
  " #334
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #334')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #334')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #334')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #334')

  " #335
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #335')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #335')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #335')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #335')

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
  " #336
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #336')
  call g:assert.equals(getline(2), '"bar"', 'failed at #336')
  call g:assert.equals(getline(3), '"baz"', 'failed at #336')

  %delete

  " #337
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #337')
  call g:assert.equals(getline(2), '(bar)', 'failed at #337')
  call g:assert.equals(getline(3), '(baz)', 'failed at #337')

  %delete

  """ off
  " #338
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #338')
  call g:assert.equals(getline(2), '{bar}', 'failed at #338')
  call g:assert.equals(getline(3), '{baz}', 'failed at #338')

  %delete

  " #339
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #339')
  call g:assert.equals(getline(2), '"bar"', 'failed at #339')
  call g:assert.equals(getline(3), '"baz"', 'failed at #339')

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
  " #340
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #340')
  call g:assert.equals(getline(2), '"bar"', 'failed at #340')
  call g:assert.equals(getline(3), '"baz"', 'failed at #340')

  %delete

  " #341
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #341')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #341')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #341')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #342
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #342')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #342')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #342')

  %delete

  " #343
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #343')
  call g:assert.equals(getline(2), '"bar"', 'failed at #343')
  call g:assert.equals(getline(3), '"baz"', 'failed at #343')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #344
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #344')
  call g:assert.equals(getline(2), '(bar)', 'failed at #344')
  call g:assert.equals(getline(3), '(baz)', 'failed at #344')

  %delete

  " #345
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #345')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #345')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #345')

  %delete

  " #346
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #346')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #346')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #346')

  %delete

  " #347
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #347')
  call g:assert.equals(getline(2), '("bar")', 'failed at #347')
  call g:assert.equals(getline(3), '("baz")', 'failed at #347')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #348
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #348')
  call g:assert.equals(getline(2), '(bar)', 'failed at #348')
  call g:assert.equals(getline(3), '(baz)', 'failed at #348')

  %delete

  " #349
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #349')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #349')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #349')

  %delete

  " #350
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #350')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #350')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #350')

  %delete

  " #351
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #351')
  call g:assert.equals(getline(2), '("bar")', 'failed at #351')
  call g:assert.equals(getline(3), '("baz")', 'failed at #351')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #352
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #352')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #352')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #352')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #353
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #353')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #353')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #353')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #354
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '""', 'failed at #354')
  call g:assert.equals(getline(2), '""', 'failed at #354')
  call g:assert.equals(getline(3), '""', 'failed at #354')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #354
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #354')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #354')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #354')

  %delete

  """ on
  " #355
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #355')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #355')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #355')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #356
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #356')

  %delete

  """ 1
  " #357
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #357')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  set whichwrap&
  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'expr', 0)
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #358
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #358')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #358')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #358')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #358')

  %delete

  " #359
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #359')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #359')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #359')

  %delete

  " #360
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #360')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #360')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #360')

  %delete

  " #361
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #361')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #361')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #361')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #361')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #362
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #362')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #362')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #362')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #362')

  " #363
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #363')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #363')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #363')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #363')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #364
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #364')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #364')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #364')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #364')

  %delete

  " #365
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #365')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #365')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #365')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #365')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #365')

  %delete

  " #366
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #366')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #366')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #366')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #366')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #366')

  %delete

  " #367
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #367')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #367')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #367')

  %delete

  " #368
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #368')
  call g:assert.equals(getline(2),   'barbar',     'failed at #368')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #368')

  %delete

  " #369
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #369')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #369')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #369')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #369')

  %delete

  " #370
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #370')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #370')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #370')

  %delete

  " #371
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #371')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #371')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #371')

  %delete

  " #372
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #372')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #372')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #372')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #373
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #373')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #373')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #373')

  %delete

  " #374
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #374')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #374')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #374')

  %delete

  " #375
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #375')
  call g:assert.equals(getline(2),   '',           'failed at #375')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #375')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #376
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #376')
  call g:assert.equals(getline(2),   '[b]',        'failed at #376')
  call g:assert.equals(getline(3),   '[c]',        'failed at #376')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #376')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #376')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #377
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #377')
  call g:assert.equals(getline(2),   '[]',         'failed at #377')
  call g:assert.equals(getline(3),   '[]',         'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #377')

  %delete

  " #378
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #378')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #378')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #378')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #378')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #379
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #379')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #379')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #379')

  %delete

  " #380
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #380')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #380')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #380')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #380')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #380')

  %delete

  " #381
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #381')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #381')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #381')

  %delete

  " #382
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #382')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #382')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #382')

  %delete

  " #383
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #383')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #383')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #383')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #383')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #383')
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

  " #384
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #384')
  call g:assert.equals(getline(2), '"bar"', 'failed at #384')
  call g:assert.equals(getline(3), '"baz"', 'failed at #384')

  %delete

  " #385
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #385')
  call g:assert.equals(getline(2), '"bar"', 'failed at #385')
  call g:assert.equals(getline(3), '"baz"', 'failed at #385')

  %delete

  " #386
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #386')
  call g:assert.equals(getline(2), '"bar"', 'failed at #386')
  call g:assert.equals(getline(3), '"baz"', 'failed at #386')

  %delete

  " #387
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #387')
  call g:assert.equals(getline(2), '"bar"', 'failed at #387')
  call g:assert.equals(getline(3), '"baz"', 'failed at #387')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #388
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #388')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #388')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #388')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #388')

  " #389
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #389')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #389')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #389')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #389')

  %delete

  """ keep
  " #390
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #390')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #390')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #390')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #390')

  " #391
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #391')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #391')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #391')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #391')

  %delete

  """ inner_tail
  " #392
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #392')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #392')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #392')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #392')

  " #393
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #393')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #393')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #393')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #393')

  %delete

  """ head
  " #394
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #394')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #394')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #394')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #394')

  " #395
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #395')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #395')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #395')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #395')

  %delete

  """ tail
  " #396
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #396')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #396')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #396')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #396')

  " #397
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #397')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #397')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #397')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #397')

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
  " #398
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #398')
  call g:assert.equals(getline(2), '"bar"', 'failed at #398')
  call g:assert.equals(getline(3), '"baz"', 'failed at #398')

  %delete

  " #399
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #399')
  call g:assert.equals(getline(2), '(bar)', 'failed at #399')
  call g:assert.equals(getline(3), '(baz)', 'failed at #399')

  %delete

  """ off
  " #400
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #400')
  call g:assert.equals(getline(2), '{bar}', 'failed at #400')
  call g:assert.equals(getline(3), '{baz}', 'failed at #400')

  %delete

  " #401
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #401')
  call g:assert.equals(getline(2), '"bar"', 'failed at #401')
  call g:assert.equals(getline(3), '"baz"', 'failed at #401')

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
  " #402
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #402')
  call g:assert.equals(getline(2), '"bar"', 'failed at #402')
  call g:assert.equals(getline(3), '"baz"', 'failed at #402')

  %delete

  " #403
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #403')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #403')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #403')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #404
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #404')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #404')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #404')

  %delete

  " #405
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #405')
  call g:assert.equals(getline(2), '"bar"', 'failed at #405')
  call g:assert.equals(getline(3), '"baz"', 'failed at #405')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #406
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #406')
  call g:assert.equals(getline(2), '(bar)', 'failed at #406')
  call g:assert.equals(getline(3), '(baz)', 'failed at #406')

  %delete

  " #407
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #407')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #407')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #407')

  %delete

  " #408
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #408')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #408')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #408')

  %delete

  " #409
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #409')
  call g:assert.equals(getline(2), '("bar")', 'failed at #409')
  call g:assert.equals(getline(3), '("baz")', 'failed at #409')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #410
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #410')
  call g:assert.equals(getline(2), '(bar)', 'failed at #410')
  call g:assert.equals(getline(3), '(baz)', 'failed at #410')

  %delete

  " #411
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #411')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #411')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #411')

  %delete

  " #412
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #412')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #412')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #412')

  %delete

  " #413
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #413')
  call g:assert.equals(getline(2), '("bar")', 'failed at #413')
  call g:assert.equals(getline(3), '("baz")', 'failed at #413')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #414
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #414')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #414')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #414')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #415
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #415')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #415')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #415')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #416
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '""', 'failed at #416')
  call g:assert.equals(getline(2), '""', 'failed at #416')
  call g:assert.equals(getline(3), '""', 'failed at #416')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #416
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #416')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #416')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #416')

  %delete

  """ on
  " #417
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #417')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #417')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #417')

  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #418
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #418')

  %delete

  """ 1
  " #419
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #419')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'expr', 0)
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #420
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #420')

  " #421
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #421')

  " #422
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #422')

  " #423
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #423')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
