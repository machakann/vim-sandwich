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
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

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

  " #217
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #217')
  call g:assert.equals(getline(2),   '[',          'failed at #217')
  call g:assert.equals(getline(3),   'foo',        'failed at #217')
  call g:assert.equals(getline(4),   ']',          'failed at #217')
  call g:assert.equals(getline(5),   '}',          'failed at #217')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #217')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #217')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #217')
  call g:assert.equals(&l:autoindent,  0,          'failed at #217')
  call g:assert.equals(&l:smartindent, 0,          'failed at #217')
  call g:assert.equals(&l:cindent,     0,          'failed at #217')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #217')

  %delete

  " #218
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #218')
  call g:assert.equals(getline(2),   '    [',      'failed at #218')
  call g:assert.equals(getline(3),   '    foo',    'failed at #218')
  call g:assert.equals(getline(4),   '    ]',      'failed at #218')
  call g:assert.equals(getline(5),   '    }',      'failed at #218')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #218')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #218')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #218')
  call g:assert.equals(&l:autoindent,  1,          'failed at #218')
  call g:assert.equals(&l:smartindent, 0,          'failed at #218')
  call g:assert.equals(&l:cindent,     0,          'failed at #218')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #218')

  %delete

  " #219
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #219')
  call g:assert.equals(getline(2),   '        [',   'failed at #219')
  call g:assert.equals(getline(3),   '        foo', 'failed at #219')
  call g:assert.equals(getline(4),   '    ]',       'failed at #219')
  call g:assert.equals(getline(5),   '}',           'failed at #219')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #219')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #219')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #219')
  call g:assert.equals(&l:autoindent,  1,           'failed at #219')
  call g:assert.equals(&l:smartindent, 1,           'failed at #219')
  call g:assert.equals(&l:cindent,     0,           'failed at #219')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #219')

  %delete

  " #220
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #220')
  call g:assert.equals(getline(2),   '    [',       'failed at #220')
  call g:assert.equals(getline(3),   '        foo', 'failed at #220')
  call g:assert.equals(getline(4),   '    ]',       'failed at #220')
  call g:assert.equals(getline(5),   '    }',       'failed at #220')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #220')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #220')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #220')
  call g:assert.equals(&l:autoindent,  1,           'failed at #220')
  call g:assert.equals(&l:smartindent, 1,           'failed at #220')
  call g:assert.equals(&l:cindent,     1,           'failed at #220')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #220')

  %delete

  " #221
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',           'failed at #221')
  call g:assert.equals(getline(2),   '            [',       'failed at #221')
  call g:assert.equals(getline(3),   '                foo', 'failed at #221')
  call g:assert.equals(getline(4),   '        ]',           'failed at #221')
  call g:assert.equals(getline(5),   '                }',   'failed at #221')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #221')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #221')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #221')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #221')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #221')
  call g:assert.equals(&l:cindent,     1,                   'failed at #221')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #221')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #222
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #222')
  call g:assert.equals(getline(2),   '[',          'failed at #222')
  call g:assert.equals(getline(3),   'foo',        'failed at #222')
  call g:assert.equals(getline(4),   ']',          'failed at #222')
  call g:assert.equals(getline(5),   '}',          'failed at #222')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #222')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #222')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #222')
  call g:assert.equals(&l:autoindent,  0,          'failed at #222')
  call g:assert.equals(&l:smartindent, 0,          'failed at #222')
  call g:assert.equals(&l:cindent,     0,          'failed at #222')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #222')

  %delete

  " #223
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #223')
  call g:assert.equals(getline(2),   '[',          'failed at #223')
  call g:assert.equals(getline(3),   'foo',        'failed at #223')
  call g:assert.equals(getline(4),   ']',          'failed at #223')
  call g:assert.equals(getline(5),   '}',          'failed at #223')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #223')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #223')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #223')
  call g:assert.equals(&l:autoindent,  1,          'failed at #223')
  call g:assert.equals(&l:smartindent, 0,          'failed at #223')
  call g:assert.equals(&l:cindent,     0,          'failed at #223')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #223')

  %delete

  " #224
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #224')
  call g:assert.equals(getline(2),   '[',          'failed at #224')
  call g:assert.equals(getline(3),   'foo',        'failed at #224')
  call g:assert.equals(getline(4),   ']',          'failed at #224')
  call g:assert.equals(getline(5),   '}',          'failed at #224')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #224')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #224')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #224')
  call g:assert.equals(&l:autoindent,  1,          'failed at #224')
  call g:assert.equals(&l:smartindent, 1,          'failed at #224')
  call g:assert.equals(&l:cindent,     0,          'failed at #224')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #224')

  %delete

  " #225
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #225')
  call g:assert.equals(getline(2),   '[',          'failed at #225')
  call g:assert.equals(getline(3),   'foo',        'failed at #225')
  call g:assert.equals(getline(4),   ']',          'failed at #225')
  call g:assert.equals(getline(5),   '}',          'failed at #225')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #225')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #225')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #225')
  call g:assert.equals(&l:autoindent,  1,          'failed at #225')
  call g:assert.equals(&l:smartindent, 1,          'failed at #225')
  call g:assert.equals(&l:cindent,     1,          'failed at #225')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #225')

  %delete

  " #226
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #226')
  call g:assert.equals(getline(2),   '[',              'failed at #226')
  call g:assert.equals(getline(3),   'foo',            'failed at #226')
  call g:assert.equals(getline(4),   ']',              'failed at #226')
  call g:assert.equals(getline(5),   '}',              'failed at #226')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #226')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #226')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #226')
  call g:assert.equals(&l:autoindent,  1,              'failed at #226')
  call g:assert.equals(&l:smartindent, 1,              'failed at #226')
  call g:assert.equals(&l:cindent,     1,              'failed at #226')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #226')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #227
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #227')
  call g:assert.equals(getline(2),   '    [',      'failed at #227')
  call g:assert.equals(getline(3),   '    foo',    'failed at #227')
  call g:assert.equals(getline(4),   '    ]',      'failed at #227')
  call g:assert.equals(getline(5),   '    }',      'failed at #227')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #227')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #227')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #227')
  call g:assert.equals(&l:autoindent,  0,          'failed at #227')
  call g:assert.equals(&l:smartindent, 0,          'failed at #227')
  call g:assert.equals(&l:cindent,     0,          'failed at #227')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #227')

  %delete

  " #228
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #228')
  call g:assert.equals(getline(2),   '    [',      'failed at #228')
  call g:assert.equals(getline(3),   '    foo',    'failed at #228')
  call g:assert.equals(getline(4),   '    ]',      'failed at #228')
  call g:assert.equals(getline(5),   '    }',      'failed at #228')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #228')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #228')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #228')
  call g:assert.equals(&l:autoindent,  1,          'failed at #228')
  call g:assert.equals(&l:smartindent, 0,          'failed at #228')
  call g:assert.equals(&l:cindent,     0,          'failed at #228')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #228')

  %delete

  " #229
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #229')
  call g:assert.equals(getline(2),   '    [',      'failed at #229')
  call g:assert.equals(getline(3),   '    foo',    'failed at #229')
  call g:assert.equals(getline(4),   '    ]',      'failed at #229')
  call g:assert.equals(getline(5),   '    }',      'failed at #229')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #229')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #229')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #229')
  call g:assert.equals(&l:autoindent,  1,          'failed at #229')
  call g:assert.equals(&l:smartindent, 1,          'failed at #229')
  call g:assert.equals(&l:cindent,     0,          'failed at #229')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #229')

  %delete

  " #230
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #230')
  call g:assert.equals(getline(2),   '    [',      'failed at #230')
  call g:assert.equals(getline(3),   '    foo',    'failed at #230')
  call g:assert.equals(getline(4),   '    ]',      'failed at #230')
  call g:assert.equals(getline(5),   '    }',      'failed at #230')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #230')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #230')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #230')
  call g:assert.equals(&l:autoindent,  1,          'failed at #230')
  call g:assert.equals(&l:smartindent, 1,          'failed at #230')
  call g:assert.equals(&l:cindent,     1,          'failed at #230')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #230')

  %delete

  " #231
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #231')
  call g:assert.equals(getline(2),   '    [',          'failed at #231')
  call g:assert.equals(getline(3),   '    foo',        'failed at #231')
  call g:assert.equals(getline(4),   '    ]',          'failed at #231')
  call g:assert.equals(getline(5),   '    }',          'failed at #231')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #231')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #231')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #231')
  call g:assert.equals(&l:autoindent,  1,              'failed at #231')
  call g:assert.equals(&l:smartindent, 1,              'failed at #231')
  call g:assert.equals(&l:cindent,     1,              'failed at #231')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #231')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #232
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #232')
  call g:assert.equals(getline(2),   '        [',   'failed at #232')
  call g:assert.equals(getline(3),   '        foo', 'failed at #232')
  call g:assert.equals(getline(4),   '    ]',       'failed at #232')
  call g:assert.equals(getline(5),   '}',           'failed at #232')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #232')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #232')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #232')
  call g:assert.equals(&l:autoindent,  0,           'failed at #232')
  call g:assert.equals(&l:smartindent, 0,           'failed at #232')
  call g:assert.equals(&l:cindent,     0,           'failed at #232')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #232')

  %delete

  " #233
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #233')
  call g:assert.equals(getline(2),   '        [',   'failed at #233')
  call g:assert.equals(getline(3),   '        foo', 'failed at #233')
  call g:assert.equals(getline(4),   '    ]',       'failed at #233')
  call g:assert.equals(getline(5),   '}',           'failed at #233')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #233')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #233')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #233')
  call g:assert.equals(&l:autoindent,  1,           'failed at #233')
  call g:assert.equals(&l:smartindent, 0,           'failed at #233')
  call g:assert.equals(&l:cindent,     0,           'failed at #233')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #233')

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
  call g:assert.equals(getline(1),   '    {',       'failed at #235')
  call g:assert.equals(getline(2),   '        [',   'failed at #235')
  call g:assert.equals(getline(3),   '        foo', 'failed at #235')
  call g:assert.equals(getline(4),   '    ]',       'failed at #235')
  call g:assert.equals(getline(5),   '}',           'failed at #235')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #235')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #235')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #235')
  call g:assert.equals(&l:autoindent,  1,           'failed at #235')
  call g:assert.equals(&l:smartindent, 1,           'failed at #235')
  call g:assert.equals(&l:cindent,     1,           'failed at #235')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #235')

  %delete

  " #236
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #236')
  call g:assert.equals(getline(2),   '        [',      'failed at #236')
  call g:assert.equals(getline(3),   '        foo',    'failed at #236')
  call g:assert.equals(getline(4),   '    ]',          'failed at #236')
  call g:assert.equals(getline(5),   '}',              'failed at #236')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #236')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #236')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #236')
  call g:assert.equals(&l:autoindent,  1,              'failed at #236')
  call g:assert.equals(&l:smartindent, 1,              'failed at #236')
  call g:assert.equals(&l:cindent,     1,              'failed at #236')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #236')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #237
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #237')
  call g:assert.equals(getline(2),   '    [',       'failed at #237')
  call g:assert.equals(getline(3),   '        foo', 'failed at #237')
  call g:assert.equals(getline(4),   '    ]',       'failed at #237')
  call g:assert.equals(getline(5),   '    }',       'failed at #237')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #237')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #237')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #237')
  call g:assert.equals(&l:autoindent,  0,           'failed at #237')
  call g:assert.equals(&l:smartindent, 0,           'failed at #237')
  call g:assert.equals(&l:cindent,     0,           'failed at #237')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #237')

  %delete

  " #238
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #238')
  call g:assert.equals(getline(2),   '    [',       'failed at #238')
  call g:assert.equals(getline(3),   '        foo', 'failed at #238')
  call g:assert.equals(getline(4),   '    ]',       'failed at #238')
  call g:assert.equals(getline(5),   '    }',       'failed at #238')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #238')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #238')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #238')
  call g:assert.equals(&l:autoindent,  1,           'failed at #238')
  call g:assert.equals(&l:smartindent, 0,           'failed at #238')
  call g:assert.equals(&l:cindent,     0,           'failed at #238')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #238')

  %delete

  " #239
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #239')
  call g:assert.equals(getline(2),   '    [',       'failed at #239')
  call g:assert.equals(getline(3),   '        foo', 'failed at #239')
  call g:assert.equals(getline(4),   '    ]',       'failed at #239')
  call g:assert.equals(getline(5),   '    }',       'failed at #239')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #239')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #239')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #239')
  call g:assert.equals(&l:autoindent,  1,           'failed at #239')
  call g:assert.equals(&l:smartindent, 1,           'failed at #239')
  call g:assert.equals(&l:cindent,     0,           'failed at #239')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #239')

  %delete

  " #240
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #240')
  call g:assert.equals(getline(2),   '    [',       'failed at #240')
  call g:assert.equals(getline(3),   '        foo', 'failed at #240')
  call g:assert.equals(getline(4),   '    ]',       'failed at #240')
  call g:assert.equals(getline(5),   '    }',       'failed at #240')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #240')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #240')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #240')
  call g:assert.equals(&l:autoindent,  1,           'failed at #240')
  call g:assert.equals(&l:smartindent, 1,           'failed at #240')
  call g:assert.equals(&l:cindent,     1,           'failed at #240')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #240')

  %delete

  " #241
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',              'failed at #241')
  call g:assert.equals(getline(2),   '    [',          'failed at #241')
  call g:assert.equals(getline(3),   '        foo',    'failed at #241')
  call g:assert.equals(getline(4),   '    ]',          'failed at #241')
  call g:assert.equals(getline(5),   '    }',          'failed at #241')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #241')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #241')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #241')
  call g:assert.equals(&l:autoindent,  1,              'failed at #241')
  call g:assert.equals(&l:smartindent, 1,              'failed at #241')
  call g:assert.equals(&l:cindent,     1,              'failed at #241')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #241')
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

  " #242
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #242')
  call g:assert.equals(getline(2),   'foo',        'failed at #242')
  call g:assert.equals(getline(3),   '    }',      'failed at #242')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #242')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #242')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #242')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #242')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #243
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #243')
  call g:assert.equals(getline(2),   '    foo',    'failed at #243')
  call g:assert.equals(getline(3),   '    }',      'failed at #243')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #243')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #243')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #243')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #243')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #244
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #244')
  call g:assert.equals(getline(2),   'foo',        'failed at #244')
  call g:assert.equals(getline(3),   '    }',      'failed at #244')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #244')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #244')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #244')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #244')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #245
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #245')
  call g:assert.equals(getline(2),   'foo',        'failed at #245')
  call g:assert.equals(getline(3),   '    }',      'failed at #245')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #245')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #245')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #245')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #245')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #245')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #246
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',     'failed at #246')
  call g:assert.equals(getline(2),   '    foo',       'failed at #246')
  call g:assert.equals(getline(3),   '            }', 'failed at #246')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #246')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #246')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #246')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #246')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #246')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #247
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #247')
  call g:assert.equals(getline(2),   'foo',        'failed at #247')
  call g:assert.equals(getline(3),   '    }',      'failed at #247')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #247')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #247')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #247')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #247')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #247')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #248
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #248')

  " #249
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #249')

  " #250
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #250')

  " #251
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #251')

  " #252
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #252')

  " #253
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #253')

  " #254
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #254')

  " #255
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #255')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #256
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #256')

  " #257
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #257')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #258
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #258')

  " #259
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #259')

  " #260
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #260')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #260')

  " #261
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #261')
  call g:assert.equals(getline(2),   'bar',        'failed at #261')
  call g:assert.equals(getline(3),   'baz]',       'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #261')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #262
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #262')

  %delete

  " #263
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #263')
  call g:assert.equals(getline(2),   'a',          'failed at #263')
  call g:assert.equals(getline(3),   ']',          'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #263')

  %delete

  " #264
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #264')
  call g:assert.equals(getline(2),   ']',          'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #264')

  %delete

  " #265
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #265')
  call g:assert.equals(getline(2),   'a]',         'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #265')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #266
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #266')

  " #267
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #267')

  %delete

  " #268
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #268')
  call g:assert.equals(getline(2),   ']',          'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #268')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #269
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #269')

  " #270
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #270')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #270')

  " #271
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #271')

  " #272
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #272')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #272')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #272')

  " #273
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #273')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #273')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #274
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #274')

  %delete

  " #275
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #275')

  %delete

  " #276
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #276')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #276')
  call g:assert.equals(getline(3),   'aa',         'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #276')

  %delete

  " #277
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #277')
  call g:assert.equals(getline(2),   'bbb',        'failed at #277')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #277')
  call g:assert.equals(getline(4),   'bbb',        'failed at #277')
  call g:assert.equals(getline(5),   'bb',         'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #277')
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

  " #278
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #278')

  " #279
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #279')

  " #280
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #280')

  " #281
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #281')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #282
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #282')

  " #283
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #283')

  """ keep
  " #284
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #284')

  " #285
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #285')

  """ inner_tail
  " #286
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #286')

  " #287
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #287')

  """ head
  " #288
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #288')

  " #289
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #289')

  """ tail
  " #290
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #290')

  " #291
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #291')

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
  " #292
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #292')

  " #293
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #293')

  """ off
  " #294
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #294')

  " #295
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #295')

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
  " #296
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #296')

  " #297
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #297')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #298
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #298')

  " #299
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #299')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #300
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #300')

  " #301
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #301')

  " #302
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #302')

  " #303
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #303')

  """ off
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #304
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #304')

  " #305
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #305')

  " #306
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #306')

  " #307
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #307')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #308
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #308')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #309
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #309')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #310
  call setline('.', '(foo)')
  normal 0va(sr"
  call g:assert.equals(getline('.'), '""', 'failed at #310')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #311
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #311')
  call g:assert.equals(getline(2),   'foo',        'failed at #311')
  call g:assert.equals(getline(3),   ']',          'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #312')
  call g:assert.equals(getline(2),   'foo',        'failed at #312')
  call g:assert.equals(getline(3),   ']',          'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #312')

  %delete

  " #313
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #313')
  call g:assert.equals(getline(2),   'foo',        'failed at #313')
  call g:assert.equals(getline(3),   'aa]',        'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #314')
  call g:assert.equals(getline(2),   'foo',        'failed at #314')
  call g:assert.equals(getline(3),   ']',          'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #314')

  %delete

  " #315
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #315')
  call g:assert.equals(getline(2),   'foo',        'failed at #315')
  call g:assert.equals(getline(3),   'aa]',        'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #315')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #316
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #316')
  call g:assert.equals(getline(2),   'foo',        'failed at #316')
  call g:assert.equals(getline(3),   ']',          'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #316')

  %delete

  " #317
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #317')
  call g:assert.equals(getline(2),   'foo',        'failed at #317')
  call g:assert.equals(getline(3),   ']',          'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #317')

  %delete

  " #318
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #318')
  call g:assert.equals(getline(2),   'foo',        'failed at #318')
  call g:assert.equals(getline(3),   ']',          'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #318')

  %delete

  " #319
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #319')
  call g:assert.equals(getline(2),   '[',          'failed at #319')
  call g:assert.equals(getline(3),   'bb',         'failed at #319')
  call g:assert.equals(getline(4),   '',           'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #319')

  set whichwrap&
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

  " #320
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #320')
  call g:assert.equals(getline(2),   '[',          'failed at #320')
  call g:assert.equals(getline(3),   'foo',        'failed at #320')
  call g:assert.equals(getline(4),   ']',          'failed at #320')
  call g:assert.equals(getline(5),   '}',          'failed at #320')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #320')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #320')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #320')
  call g:assert.equals(&l:autoindent,  0,          'failed at #320')
  call g:assert.equals(&l:smartindent, 0,          'failed at #320')
  call g:assert.equals(&l:cindent,     0,          'failed at #320')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #320')

  %delete

  " #321
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #321')
  call g:assert.equals(getline(2),   '    [',      'failed at #321')
  call g:assert.equals(getline(3),   '    foo',    'failed at #321')
  call g:assert.equals(getline(4),   '    ]',      'failed at #321')
  call g:assert.equals(getline(5),   '    }',      'failed at #321')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #321')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #321')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #321')
  call g:assert.equals(&l:autoindent,  1,          'failed at #321')
  call g:assert.equals(&l:smartindent, 0,          'failed at #321')
  call g:assert.equals(&l:cindent,     0,          'failed at #321')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #321')

  %delete

  " #322
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #322')
  call g:assert.equals(getline(2),   '        [',   'failed at #322')
  call g:assert.equals(getline(3),   '        foo', 'failed at #322')
  call g:assert.equals(getline(4),   '    ]',       'failed at #322')
  call g:assert.equals(getline(5),   '}',           'failed at #322')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #322')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #322')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #322')
  call g:assert.equals(&l:autoindent,  1,           'failed at #322')
  call g:assert.equals(&l:smartindent, 1,           'failed at #322')
  call g:assert.equals(&l:cindent,     0,           'failed at #322')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #322')

  %delete

  " #323
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #323')
  call g:assert.equals(getline(2),   '    [',       'failed at #323')
  call g:assert.equals(getline(3),   '        foo', 'failed at #323')
  call g:assert.equals(getline(4),   '    ]',       'failed at #323')
  call g:assert.equals(getline(5),   '    }',       'failed at #323')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #323')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #323')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #323')
  call g:assert.equals(&l:autoindent,  1,           'failed at #323')
  call g:assert.equals(&l:smartindent, 1,           'failed at #323')
  call g:assert.equals(&l:cindent,     1,           'failed at #323')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #323')

  %delete

  " #324
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',           'failed at #324')
  call g:assert.equals(getline(2),   '            [',       'failed at #324')
  call g:assert.equals(getline(3),   '                foo', 'failed at #324')
  call g:assert.equals(getline(4),   '        ]',           'failed at #324')
  call g:assert.equals(getline(5),   '                }',   'failed at #324')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #324')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #324')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #324')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #324')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #324')
  call g:assert.equals(&l:cindent,     1,                   'failed at #324')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #324')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #325
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #325')
  call g:assert.equals(getline(2),   '[',          'failed at #325')
  call g:assert.equals(getline(3),   'foo',        'failed at #325')
  call g:assert.equals(getline(4),   ']',          'failed at #325')
  call g:assert.equals(getline(5),   '}',          'failed at #325')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #325')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #325')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #325')
  call g:assert.equals(&l:autoindent,  0,          'failed at #325')
  call g:assert.equals(&l:smartindent, 0,          'failed at #325')
  call g:assert.equals(&l:cindent,     0,          'failed at #325')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #325')

  %delete

  " #326
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #326')
  call g:assert.equals(getline(2),   '[',          'failed at #326')
  call g:assert.equals(getline(3),   'foo',        'failed at #326')
  call g:assert.equals(getline(4),   ']',          'failed at #326')
  call g:assert.equals(getline(5),   '}',          'failed at #326')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #326')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #326')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #326')
  call g:assert.equals(&l:autoindent,  1,          'failed at #326')
  call g:assert.equals(&l:smartindent, 0,          'failed at #326')
  call g:assert.equals(&l:cindent,     0,          'failed at #326')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #326')

  %delete

  " #327
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #327')
  call g:assert.equals(getline(2),   '[',          'failed at #327')
  call g:assert.equals(getline(3),   'foo',        'failed at #327')
  call g:assert.equals(getline(4),   ']',          'failed at #327')
  call g:assert.equals(getline(5),   '}',          'failed at #327')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #327')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #327')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #327')
  call g:assert.equals(&l:autoindent,  1,          'failed at #327')
  call g:assert.equals(&l:smartindent, 1,          'failed at #327')
  call g:assert.equals(&l:cindent,     0,          'failed at #327')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #327')

  %delete

  " #328
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #328')
  call g:assert.equals(getline(2),   '[',          'failed at #328')
  call g:assert.equals(getline(3),   'foo',        'failed at #328')
  call g:assert.equals(getline(4),   ']',          'failed at #328')
  call g:assert.equals(getline(5),   '}',          'failed at #328')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #328')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #328')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #328')
  call g:assert.equals(&l:autoindent,  1,          'failed at #328')
  call g:assert.equals(&l:smartindent, 1,          'failed at #328')
  call g:assert.equals(&l:cindent,     1,          'failed at #328')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #328')

  %delete

  " #329
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #329')
  call g:assert.equals(getline(2),   '[',              'failed at #329')
  call g:assert.equals(getline(3),   'foo',            'failed at #329')
  call g:assert.equals(getline(4),   ']',              'failed at #329')
  call g:assert.equals(getline(5),   '}',              'failed at #329')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #329')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #329')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #329')
  call g:assert.equals(&l:autoindent,  1,              'failed at #329')
  call g:assert.equals(&l:smartindent, 1,              'failed at #329')
  call g:assert.equals(&l:cindent,     1,              'failed at #329')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #329')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #330
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #330')
  call g:assert.equals(getline(2),   '    [',      'failed at #330')
  call g:assert.equals(getline(3),   '    foo',    'failed at #330')
  call g:assert.equals(getline(4),   '    ]',      'failed at #330')
  call g:assert.equals(getline(5),   '    }',      'failed at #330')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #330')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #330')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #330')
  call g:assert.equals(&l:autoindent,  0,          'failed at #330')
  call g:assert.equals(&l:smartindent, 0,          'failed at #330')
  call g:assert.equals(&l:cindent,     0,          'failed at #330')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #330')

  %delete

  " #331
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #331')
  call g:assert.equals(getline(2),   '    [',      'failed at #331')
  call g:assert.equals(getline(3),   '    foo',    'failed at #331')
  call g:assert.equals(getline(4),   '    ]',      'failed at #331')
  call g:assert.equals(getline(5),   '    }',      'failed at #331')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #331')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #331')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #331')
  call g:assert.equals(&l:autoindent,  1,          'failed at #331')
  call g:assert.equals(&l:smartindent, 0,          'failed at #331')
  call g:assert.equals(&l:cindent,     0,          'failed at #331')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #331')

  %delete

  " #332
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #332')
  call g:assert.equals(getline(2),   '    [',      'failed at #332')
  call g:assert.equals(getline(3),   '    foo',    'failed at #332')
  call g:assert.equals(getline(4),   '    ]',      'failed at #332')
  call g:assert.equals(getline(5),   '    }',      'failed at #332')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #332')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #332')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #332')
  call g:assert.equals(&l:autoindent,  1,          'failed at #332')
  call g:assert.equals(&l:smartindent, 1,          'failed at #332')
  call g:assert.equals(&l:cindent,     0,          'failed at #332')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #332')

  %delete

  " #333
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #333')
  call g:assert.equals(getline(2),   '    [',      'failed at #333')
  call g:assert.equals(getline(3),   '    foo',    'failed at #333')
  call g:assert.equals(getline(4),   '    ]',      'failed at #333')
  call g:assert.equals(getline(5),   '    }',      'failed at #333')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #333')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #333')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #333')
  call g:assert.equals(&l:autoindent,  1,          'failed at #333')
  call g:assert.equals(&l:smartindent, 1,          'failed at #333')
  call g:assert.equals(&l:cindent,     1,          'failed at #333')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #333')

  %delete

  " #334
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #334')
  call g:assert.equals(getline(2),   '    [',          'failed at #334')
  call g:assert.equals(getline(3),   '    foo',        'failed at #334')
  call g:assert.equals(getline(4),   '    ]',          'failed at #334')
  call g:assert.equals(getline(5),   '    }',          'failed at #334')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #334')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #334')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #334')
  call g:assert.equals(&l:autoindent,  1,              'failed at #334')
  call g:assert.equals(&l:smartindent, 1,              'failed at #334')
  call g:assert.equals(&l:cindent,     1,              'failed at #334')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #334')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #335
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #335')
  call g:assert.equals(getline(2),   '        [',   'failed at #335')
  call g:assert.equals(getline(3),   '        foo', 'failed at #335')
  call g:assert.equals(getline(4),   '    ]',       'failed at #335')
  call g:assert.equals(getline(5),   '}',           'failed at #335')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #335')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #335')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #335')
  call g:assert.equals(&l:autoindent,  0,           'failed at #335')
  call g:assert.equals(&l:smartindent, 0,           'failed at #335')
  call g:assert.equals(&l:cindent,     0,           'failed at #335')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #335')

  %delete

  " #336
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #336')
  call g:assert.equals(getline(2),   '        [',   'failed at #336')
  call g:assert.equals(getline(3),   '        foo', 'failed at #336')
  call g:assert.equals(getline(4),   '    ]',       'failed at #336')
  call g:assert.equals(getline(5),   '}',           'failed at #336')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #336')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #336')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #336')
  call g:assert.equals(&l:autoindent,  1,           'failed at #336')
  call g:assert.equals(&l:smartindent, 0,           'failed at #336')
  call g:assert.equals(&l:cindent,     0,           'failed at #336')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #336')

  %delete

  " #337
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #337')
  call g:assert.equals(getline(2),   '        [',   'failed at #337')
  call g:assert.equals(getline(3),   '        foo', 'failed at #337')
  call g:assert.equals(getline(4),   '    ]',       'failed at #337')
  call g:assert.equals(getline(5),   '}',           'failed at #337')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #337')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #337')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #337')
  call g:assert.equals(&l:autoindent,  1,           'failed at #337')
  call g:assert.equals(&l:smartindent, 1,           'failed at #337')
  call g:assert.equals(&l:cindent,     0,           'failed at #337')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #337')

  %delete

  " #338
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #338')
  call g:assert.equals(getline(2),   '        [',   'failed at #338')
  call g:assert.equals(getline(3),   '        foo', 'failed at #338')
  call g:assert.equals(getline(4),   '    ]',       'failed at #338')
  call g:assert.equals(getline(5),   '}',           'failed at #338')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #338')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #338')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #338')
  call g:assert.equals(&l:autoindent,  1,           'failed at #338')
  call g:assert.equals(&l:smartindent, 1,           'failed at #338')
  call g:assert.equals(&l:cindent,     1,           'failed at #338')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #338')

  %delete

  " #339
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #339')
  call g:assert.equals(getline(2),   '        [',      'failed at #339')
  call g:assert.equals(getline(3),   '        foo',    'failed at #339')
  call g:assert.equals(getline(4),   '    ]',          'failed at #339')
  call g:assert.equals(getline(5),   '}',              'failed at #339')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #339')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #339')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #339')
  call g:assert.equals(&l:autoindent,  1,              'failed at #339')
  call g:assert.equals(&l:smartindent, 1,              'failed at #339')
  call g:assert.equals(&l:cindent,     1,              'failed at #339')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #339')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #340
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #340')
  call g:assert.equals(getline(2),   '    [',       'failed at #340')
  call g:assert.equals(getline(3),   '        foo', 'failed at #340')
  call g:assert.equals(getline(4),   '    ]',       'failed at #340')
  call g:assert.equals(getline(5),   '    }',       'failed at #340')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #340')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #340')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #340')
  call g:assert.equals(&l:autoindent,  0,           'failed at #340')
  call g:assert.equals(&l:smartindent, 0,           'failed at #340')
  call g:assert.equals(&l:cindent,     0,           'failed at #340')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #340')

  %delete

  " #341
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #341')
  call g:assert.equals(getline(2),   '    [',       'failed at #341')
  call g:assert.equals(getline(3),   '        foo', 'failed at #341')
  call g:assert.equals(getline(4),   '    ]',       'failed at #341')
  call g:assert.equals(getline(5),   '    }',       'failed at #341')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #341')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #341')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #341')
  call g:assert.equals(&l:autoindent,  1,           'failed at #341')
  call g:assert.equals(&l:smartindent, 0,           'failed at #341')
  call g:assert.equals(&l:cindent,     0,           'failed at #341')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #341')

  %delete

  " #342
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #342')
  call g:assert.equals(getline(2),   '    [',       'failed at #342')
  call g:assert.equals(getline(3),   '        foo', 'failed at #342')
  call g:assert.equals(getline(4),   '    ]',       'failed at #342')
  call g:assert.equals(getline(5),   '    }',       'failed at #342')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #342')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #342')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #342')
  call g:assert.equals(&l:autoindent,  1,           'failed at #342')
  call g:assert.equals(&l:smartindent, 1,           'failed at #342')
  call g:assert.equals(&l:cindent,     0,           'failed at #342')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #342')

  %delete

  " #343
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #343')
  call g:assert.equals(getline(2),   '    [',       'failed at #343')
  call g:assert.equals(getline(3),   '        foo', 'failed at #343')
  call g:assert.equals(getline(4),   '    ]',       'failed at #343')
  call g:assert.equals(getline(5),   '    }',       'failed at #343')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #343')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #343')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #343')
  call g:assert.equals(&l:autoindent,  1,           'failed at #343')
  call g:assert.equals(&l:smartindent, 1,           'failed at #343')
  call g:assert.equals(&l:cindent,     1,           'failed at #343')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #343')

  %delete

  " #344
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',              'failed at #344')
  call g:assert.equals(getline(2),   '    [',          'failed at #344')
  call g:assert.equals(getline(3),   '        foo',    'failed at #344')
  call g:assert.equals(getline(4),   '    ]',          'failed at #344')
  call g:assert.equals(getline(5),   '    }',          'failed at #344')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #344')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #344')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #344')
  call g:assert.equals(&l:autoindent,  1,              'failed at #344')
  call g:assert.equals(&l:smartindent, 1,              'failed at #344')
  call g:assert.equals(&l:cindent,     1,              'failed at #344')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #344')
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

  " #345
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #345')
  call g:assert.equals(getline(2),   'foo',        'failed at #345')
  call g:assert.equals(getline(3),   '    }',      'failed at #345')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #345')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #345')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #345')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #345')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #345')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #346
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #346')
  call g:assert.equals(getline(2),   '    foo',    'failed at #346')
  call g:assert.equals(getline(3),   '    }',      'failed at #346')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #346')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #346')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #346')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #346')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #347
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #347')
  call g:assert.equals(getline(2),   'foo',        'failed at #347')
  call g:assert.equals(getline(3),   '    }',      'failed at #347')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #347')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #347')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #347')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #347')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #347')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #348
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #348')
  call g:assert.equals(getline(2),   'foo',        'failed at #348')
  call g:assert.equals(getline(3),   '    }',      'failed at #348')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #348')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #348')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #348')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #348')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #348')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #349
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',     'failed at #349')
  call g:assert.equals(getline(2),   '    foo',       'failed at #349')
  call g:assert.equals(getline(3),   '            }', 'failed at #349')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #349')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #349')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #349')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #349')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #349')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #350
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #350')
  call g:assert.equals(getline(2),   'foo',        'failed at #350')
  call g:assert.equals(getline(3),   '    }',      'failed at #350')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #350')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #350')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #350')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #350')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #350')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #351
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #351')

  " #352
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #352')

  " #353
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #353')

  " #354
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #354')

  %delete

  " #355
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #355')
  call g:assert.equals(getline(2),   'foo',        'failed at #355')
  call g:assert.equals(getline(3),   ']',          'failed at #355')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #355')

  " #356
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #356')
  call g:assert.equals(getline(2),   'foo',        'failed at #356')
  call g:assert.equals(getline(3),   '}',          'failed at #356')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #356')

  " #357
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #357')
  call g:assert.equals(getline(2),   'foo',        'failed at #357')
  call g:assert.equals(getline(3),   '>',          'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #357')

  " #358
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #358')
  call g:assert.equals(getline(2),   'foo',        'failed at #358')
  call g:assert.equals(getline(3),   ')',          'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #358')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #359
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #359')

  " #360
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #360')

  %delete

  " #359
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #359')
  call g:assert.equals(getline(2),   'foo',        'failed at #359')
  call g:assert.equals(getline(3),   'b',          'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #359')

  %delete

  " #360
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #360')
  call g:assert.equals(getline(2),   'foo',        'failed at #360')
  call g:assert.equals(getline(3),   '*',          'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #360')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #361
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #361')
  call g:assert.equals(getline(2),   'foo',        'failed at #361')
  call g:assert.equals(getline(3),   'bar',        'failed at #361')
  call g:assert.equals(getline(4),   'baz',        'failed at #361')
  call g:assert.equals(getline(5),   ']',          'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #361')

  %delete

  " #362
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #362')
  call g:assert.equals(getline(2),   '[',          'failed at #362')
  call g:assert.equals(getline(3),   'bar',        'failed at #362')
  call g:assert.equals(getline(4),   ']',          'failed at #362')
  call g:assert.equals(getline(5),   'baz',        'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #362')

  %delete

  " #363
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #363')
  call g:assert.equals(getline(2),   'bar',        'failed at #363')
  call g:assert.equals(getline(3),   'baz]',       'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #363')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #363')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #364
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #364')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #364')

  %delete

  " #365
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #365')
  call g:assert.equals(getline(2),   ']',          'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #365')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #366
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #366')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #366')

  " #367
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #367')

  %delete

  " #368
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #368')
  call g:assert.equals(getline(2),   '(',          'failed at #368')
  call g:assert.equals(getline(3),   '{',          'failed at #368')
  call g:assert.equals(getline(4),   '[',          'failed at #368')
  call g:assert.equals(getline(5),   'bar',        'failed at #368')
  call g:assert.equals(getline(6),   ']',          'failed at #368')
  call g:assert.equals(getline(7),   '}',          'failed at #368')
  call g:assert.equals(getline(8),   ')',          'failed at #368')
  call g:assert.equals(getline(9),   'baz',        'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #368')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #369
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #369')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #369')

  %delete

  " #370
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #370')

  %delete

  " #371
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #371')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #371')
  call g:assert.equals(getline(3),   'aa',         'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #371')

  %delete

  " #372
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #372')
  call g:assert.equals(getline(2),   'bbb',        'failed at #372')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #372')
  call g:assert.equals(getline(4),   'bbb',        'failed at #372')
  call g:assert.equals(getline(5),   'bb',         'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #372')

  %delete

  " #373
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #373')
  call g:assert.equals(getline(2),   '(',          'failed at #373')
  call g:assert.equals(getline(3),   'foo',        'failed at #373')
  call g:assert.equals(getline(4),   ')',          'failed at #373')
  call g:assert.equals(getline(5),   ')',          'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #373')

  %delete

  " #374
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #374')
  call g:assert.equals(getline(2),   '(',          'failed at #374')
  call g:assert.equals(getline(3),   'foo',        'failed at #374')
  call g:assert.equals(getline(4),   ')',          'failed at #374')
  call g:assert.equals(getline(5),   ')',          'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #374')

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

  " #375
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #375')

  " #376
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #376')

  " #377
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #377')

  " #378
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #378')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #379
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #379')

  " #380
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #380')

  """ keep
  " #381
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #381')

  " #382
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #382')

  """ inner_tail
  " #383
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #383')

  " #384
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #384')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #384')

  """ head
  " #385
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #385')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #385')

  " #386
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #386')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #386')

  """ tail
  " #387
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #387')

  " #388
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #388')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #388')

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
  " #389
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #389')

  " #390
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #390')

  """ off
  " #391
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #391')

  " #392
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #392')

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
  " #393
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #393')

  " #394
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #394')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #395
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #395')

  " #396
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #396')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ on
  " #397
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #397')

  " #398
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #398')

  " #399
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #399')

  " #400
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #400')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #401
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #401')

  " #402
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #402')

  " #403
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #403')

  " #404
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #404')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #405
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #405')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #406
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #406')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #407
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '""', 'failed at #407')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #408
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #408')
  call g:assert.equals(getline(2),   'foo',        'failed at #408')
  call g:assert.equals(getline(3),   ']',          'failed at #408')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #408')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #408')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #408')

  %delete

  " #409
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #409')
  call g:assert.equals(getline(2),   'foo',        'failed at #409')
  call g:assert.equals(getline(3),   '  ]',        'failed at #409')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #409')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #409')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #409')

  %delete

  " #410
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #410')
  call g:assert.equals(getline(2),   'foo',        'failed at #410')
  call g:assert.equals(getline(3),   'aa]',        'failed at #410')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #410')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #410')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #410')

  %delete

  " #411
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #411')
  call g:assert.equals(getline(2),   'foo',        'failed at #411')
  call g:assert.equals(getline(3),   ']',          'failed at #411')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #411')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #411')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #411')

  %delete

  " #412
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #412')
  call g:assert.equals(getline(2),   'foo',        'failed at #412')
  call g:assert.equals(getline(3),   'aa]',        'failed at #412')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #412')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #412')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #412')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #413
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #413')
  call g:assert.equals(getline(2),   'foo',        'failed at #413')
  call g:assert.equals(getline(3),   ']',          'failed at #413')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #413')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #413')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #413')

  %delete

  " #414
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #414')
  call g:assert.equals(getline(2),   'foo',        'failed at #414')
  call g:assert.equals(getline(3),   ']',          'failed at #414')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #414')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #414')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #414')

  %delete

  " #415
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #415')
  call g:assert.equals(getline(2),   'foo',        'failed at #415')
  call g:assert.equals(getline(3),   ']',          'failed at #415')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #415')

  %delete

  " #416
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #416')
  call g:assert.equals(getline(2),   '[',          'failed at #416')
  call g:assert.equals(getline(3),   'bb',         'failed at #416')
  call g:assert.equals(getline(4),   '',           'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #416')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #417
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #417')

  %delete

  """ on
  " #418
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #418')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #419
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #419')

  """ 1
  " #420
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3',  'failed at #420')

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

  " #421
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #421')
  call g:assert.equals(getline(2),   '[',          'failed at #421')
  call g:assert.equals(getline(3),   '',           'failed at #421')
  call g:assert.equals(getline(4),   '    foo',    'failed at #421')
  call g:assert.equals(getline(5),   '',           'failed at #421')
  call g:assert.equals(getline(6),   ']',          'failed at #421')
  call g:assert.equals(getline(7),   '}',          'failed at #421')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #421')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #421')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #421')
  call g:assert.equals(&l:autoindent,  0,          'failed at #421')
  call g:assert.equals(&l:smartindent, 0,          'failed at #421')
  call g:assert.equals(&l:cindent,     0,          'failed at #421')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #421')

  %delete

  " #422
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #422')
  call g:assert.equals(getline(2),   '    [',      'failed at #422')
  call g:assert.equals(getline(3),   '',           'failed at #422')
  call g:assert.equals(getline(4),   '    foo',    'failed at #422')
  call g:assert.equals(getline(5),   '',           'failed at #422')
  call g:assert.equals(getline(6),   '    ]',      'failed at #422')
  call g:assert.equals(getline(7),   '    }',      'failed at #422')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #422')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #422')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #422')
  call g:assert.equals(&l:autoindent,  1,          'failed at #422')
  call g:assert.equals(&l:smartindent, 0,          'failed at #422')
  call g:assert.equals(&l:cindent,     0,          'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #422')

  %delete

  " #423
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #423')
  call g:assert.equals(getline(2),   '    [',       'failed at #423')
  call g:assert.equals(getline(3),   '',            'failed at #423')
  call g:assert.equals(getline(4),   '    foo',     'failed at #423')
  call g:assert.equals(getline(5),   '',            'failed at #423')
  call g:assert.equals(getline(6),   '    ]',       'failed at #423')
  call g:assert.equals(getline(7),   '}',           'failed at #423')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #423')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #423')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #423')
  call g:assert.equals(&l:autoindent,  1,           'failed at #423')
  call g:assert.equals(&l:smartindent, 1,           'failed at #423')
  call g:assert.equals(&l:cindent,     0,           'failed at #423')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #423')

  %delete

  " #424
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #424')
  call g:assert.equals(getline(2),   '    [',       'failed at #424')
  call g:assert.equals(getline(3),   '',            'failed at #424')
  call g:assert.equals(getline(4),   '    foo',     'failed at #424')
  call g:assert.equals(getline(5),   '',            'failed at #424')
  call g:assert.equals(getline(6),   '    ]',       'failed at #424')
  call g:assert.equals(getline(7),   '    }',       'failed at #424')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #424')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #424')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #424')
  call g:assert.equals(&l:autoindent,  1,           'failed at #424')
  call g:assert.equals(&l:smartindent, 1,           'failed at #424')
  call g:assert.equals(&l:cindent,     1,           'failed at #424')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #424')

  %delete

  " #425
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',            'failed at #425')
  call g:assert.equals(getline(2),   '           [',        'failed at #425')
  call g:assert.equals(getline(3),   '',                    'failed at #425')
  call g:assert.equals(getline(4),   '    foo',             'failed at #425')
  call g:assert.equals(getline(5),   '',                    'failed at #425')
  call g:assert.equals(getline(6),   '        ]',           'failed at #425')
  call g:assert.equals(getline(7),   '                }',   'failed at #425')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #425')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #425')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #425')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #425')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #425')
  call g:assert.equals(&l:cindent,     1,                   'failed at #425')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #425')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #426
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #426')
  call g:assert.equals(getline(2),   '[',          'failed at #426')
  call g:assert.equals(getline(3),   '',           'failed at #426')
  call g:assert.equals(getline(4),   '    foo',    'failed at #426')
  call g:assert.equals(getline(5),   '',           'failed at #426')
  call g:assert.equals(getline(6),   ']',          'failed at #426')
  call g:assert.equals(getline(7),   '}',          'failed at #426')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #426')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #426')
  call g:assert.equals(&l:autoindent,  0,          'failed at #426')
  call g:assert.equals(&l:smartindent, 0,          'failed at #426')
  call g:assert.equals(&l:cindent,     0,          'failed at #426')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #426')

  %delete

  " #427
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #427')
  call g:assert.equals(getline(2),   '[',          'failed at #427')
  call g:assert.equals(getline(3),   '',           'failed at #427')
  call g:assert.equals(getline(4),   '    foo',    'failed at #427')
  call g:assert.equals(getline(5),   '',           'failed at #427')
  call g:assert.equals(getline(6),   ']',          'failed at #427')
  call g:assert.equals(getline(7),   '}',          'failed at #427')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #427')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #427')
  call g:assert.equals(&l:autoindent,  1,          'failed at #427')
  call g:assert.equals(&l:smartindent, 0,          'failed at #427')
  call g:assert.equals(&l:cindent,     0,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #428')
  call g:assert.equals(getline(2),   '[',          'failed at #428')
  call g:assert.equals(getline(3),   '',           'failed at #428')
  call g:assert.equals(getline(4),   '    foo',    'failed at #428')
  call g:assert.equals(getline(5),   '',           'failed at #428')
  call g:assert.equals(getline(6),   ']',          'failed at #428')
  call g:assert.equals(getline(7),   '}',          'failed at #428')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #428')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #428')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #428')
  call g:assert.equals(&l:autoindent,  1,          'failed at #428')
  call g:assert.equals(&l:smartindent, 1,          'failed at #428')
  call g:assert.equals(&l:cindent,     0,          'failed at #428')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #428')

  %delete

  " #429
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #429')
  call g:assert.equals(getline(2),   '[',          'failed at #429')
  call g:assert.equals(getline(3),   '',           'failed at #429')
  call g:assert.equals(getline(4),   '    foo',    'failed at #429')
  call g:assert.equals(getline(5),   '',           'failed at #429')
  call g:assert.equals(getline(6),   ']',          'failed at #429')
  call g:assert.equals(getline(7),   '}',          'failed at #429')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #429')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #429')
  call g:assert.equals(&l:autoindent,  1,          'failed at #429')
  call g:assert.equals(&l:smartindent, 1,          'failed at #429')
  call g:assert.equals(&l:cindent,     1,          'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #429')

  %delete

  " #430
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #430')
  call g:assert.equals(getline(2),   '[',              'failed at #430')
  call g:assert.equals(getline(3),   '',               'failed at #430')
  call g:assert.equals(getline(4),   '    foo',        'failed at #430')
  call g:assert.equals(getline(5),   '',               'failed at #430')
  call g:assert.equals(getline(6),   ']',              'failed at #430')
  call g:assert.equals(getline(7),   '}',              'failed at #430')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #430')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #430')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #430')
  call g:assert.equals(&l:autoindent,  1,              'failed at #430')
  call g:assert.equals(&l:smartindent, 1,              'failed at #430')
  call g:assert.equals(&l:cindent,     1,              'failed at #430')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #430')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #431
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #431')
  call g:assert.equals(getline(2),   '    [',      'failed at #431')
  call g:assert.equals(getline(3),   '',           'failed at #431')
  call g:assert.equals(getline(4),   '    foo',    'failed at #431')
  call g:assert.equals(getline(5),   '',           'failed at #431')
  call g:assert.equals(getline(6),   '    ]',      'failed at #431')
  call g:assert.equals(getline(7),   '    }',      'failed at #431')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #431')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #431')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #431')
  call g:assert.equals(&l:autoindent,  0,          'failed at #431')
  call g:assert.equals(&l:smartindent, 0,          'failed at #431')
  call g:assert.equals(&l:cindent,     0,          'failed at #431')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #431')

  %delete

  " #432
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #432')
  call g:assert.equals(getline(2),   '    [',      'failed at #432')
  call g:assert.equals(getline(3),   '',           'failed at #432')
  call g:assert.equals(getline(4),   '    foo',    'failed at #432')
  call g:assert.equals(getline(5),   '',           'failed at #432')
  call g:assert.equals(getline(6),   '    ]',      'failed at #432')
  call g:assert.equals(getline(7),   '    }',      'failed at #432')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #432')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #432')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #432')
  call g:assert.equals(&l:autoindent,  1,          'failed at #432')
  call g:assert.equals(&l:smartindent, 0,          'failed at #432')
  call g:assert.equals(&l:cindent,     0,          'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #432')

  %delete

  " #433
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #433')
  call g:assert.equals(getline(2),   '    [',      'failed at #433')
  call g:assert.equals(getline(3),   '',           'failed at #433')
  call g:assert.equals(getline(4),   '    foo',    'failed at #433')
  call g:assert.equals(getline(5),   '',           'failed at #433')
  call g:assert.equals(getline(6),   '    ]',      'failed at #433')
  call g:assert.equals(getline(7),   '    }',      'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #433')
  call g:assert.equals(&l:autoindent,  1,          'failed at #433')
  call g:assert.equals(&l:smartindent, 1,          'failed at #433')
  call g:assert.equals(&l:cindent,     0,          'failed at #433')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #433')

  %delete

  " #434
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #434')
  call g:assert.equals(getline(2),   '    [',      'failed at #434')
  call g:assert.equals(getline(3),   '',           'failed at #434')
  call g:assert.equals(getline(4),   '    foo',    'failed at #434')
  call g:assert.equals(getline(5),   '',           'failed at #434')
  call g:assert.equals(getline(6),   '    ]',      'failed at #434')
  call g:assert.equals(getline(7),   '    }',      'failed at #434')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #434')
  call g:assert.equals(&l:autoindent,  1,          'failed at #434')
  call g:assert.equals(&l:smartindent, 1,          'failed at #434')
  call g:assert.equals(&l:cindent,     1,          'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #434')

  %delete

  " #435
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',          'failed at #435')
  call g:assert.equals(getline(2),   '    [',          'failed at #435')
  call g:assert.equals(getline(3),   '',               'failed at #435')
  call g:assert.equals(getline(4),   '    foo',        'failed at #435')
  call g:assert.equals(getline(5),   '',               'failed at #435')
  call g:assert.equals(getline(6),   '    ]',          'failed at #435')
  call g:assert.equals(getline(7),   '    }',          'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #435')
  call g:assert.equals(&l:autoindent,  1,              'failed at #435')
  call g:assert.equals(&l:smartindent, 1,              'failed at #435')
  call g:assert.equals(&l:cindent,     1,              'failed at #435')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #435')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #436
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '',            'failed at #436')
  call g:assert.equals(getline(4),   '    foo',     'failed at #436')
  call g:assert.equals(getline(5),   '',            'failed at #436')
  call g:assert.equals(getline(6),   '    ]',       'failed at #436')
  call g:assert.equals(getline(7),   '}',           'failed at #436')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #436')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #436')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #436')
  call g:assert.equals(&l:autoindent,  0,           'failed at #436')
  call g:assert.equals(&l:smartindent, 0,           'failed at #436')
  call g:assert.equals(&l:cindent,     0,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #437')
  call g:assert.equals(getline(2),   '    [',       'failed at #437')
  call g:assert.equals(getline(3),   '',            'failed at #437')
  call g:assert.equals(getline(4),   '    foo',     'failed at #437')
  call g:assert.equals(getline(5),   '',            'failed at #437')
  call g:assert.equals(getline(6),   '    ]',       'failed at #437')
  call g:assert.equals(getline(7),   '}',           'failed at #437')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #437')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #437')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #437')
  call g:assert.equals(&l:autoindent,  1,           'failed at #437')
  call g:assert.equals(&l:smartindent, 0,           'failed at #437')
  call g:assert.equals(&l:cindent,     0,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #438')
  call g:assert.equals(getline(2),   '    [',       'failed at #438')
  call g:assert.equals(getline(3),   '',            'failed at #438')
  call g:assert.equals(getline(4),   '    foo',     'failed at #438')
  call g:assert.equals(getline(5),   '',            'failed at #438')
  call g:assert.equals(getline(6),   '    ]',       'failed at #438')
  call g:assert.equals(getline(7),   '}',           'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #438')
  call g:assert.equals(&l:autoindent,  1,           'failed at #438')
  call g:assert.equals(&l:smartindent, 1,           'failed at #438')
  call g:assert.equals(&l:cindent,     0,           'failed at #438')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #438')

  %delete

  " #439
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #439')
  call g:assert.equals(getline(2),   '    [',       'failed at #439')
  call g:assert.equals(getline(3),   '',            'failed at #439')
  call g:assert.equals(getline(4),   '    foo',     'failed at #439')
  call g:assert.equals(getline(5),   '',            'failed at #439')
  call g:assert.equals(getline(6),   '    ]',       'failed at #439')
  call g:assert.equals(getline(7),   '}',           'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #439')
  call g:assert.equals(&l:autoindent,  1,           'failed at #439')
  call g:assert.equals(&l:smartindent, 1,           'failed at #439')
  call g:assert.equals(&l:cindent,     1,           'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #439')

  %delete

  " #440
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #440')
  call g:assert.equals(getline(2),   '    [',          'failed at #440')
  call g:assert.equals(getline(3),   '',               'failed at #440')
  call g:assert.equals(getline(4),   '    foo',        'failed at #440')
  call g:assert.equals(getline(5),   '',               'failed at #440')
  call g:assert.equals(getline(6),   '    ]',          'failed at #440')
  call g:assert.equals(getline(7),   '}',              'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #440')
  call g:assert.equals(&l:autoindent,  1,              'failed at #440')
  call g:assert.equals(&l:smartindent, 1,              'failed at #440')
  call g:assert.equals(&l:cindent,     1,              'failed at #440')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #440')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #441
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #441')
  call g:assert.equals(getline(2),   '    [',       'failed at #441')
  call g:assert.equals(getline(3),   '',            'failed at #441')
  call g:assert.equals(getline(4),   '    foo',     'failed at #441')
  call g:assert.equals(getline(5),   '',            'failed at #441')
  call g:assert.equals(getline(6),   '    ]',       'failed at #441')
  call g:assert.equals(getline(7),   '    }',       'failed at #441')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #441')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #441')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #441')
  call g:assert.equals(&l:autoindent,  0,           'failed at #441')
  call g:assert.equals(&l:smartindent, 0,           'failed at #441')
  call g:assert.equals(&l:cindent,     0,           'failed at #441')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #441')

  %delete

  " #442
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #442')
  call g:assert.equals(getline(2),   '    [',       'failed at #442')
  call g:assert.equals(getline(3),   '',            'failed at #442')
  call g:assert.equals(getline(4),   '    foo',     'failed at #442')
  call g:assert.equals(getline(5),   '',            'failed at #442')
  call g:assert.equals(getline(6),   '    ]',       'failed at #442')
  call g:assert.equals(getline(7),   '    }',       'failed at #442')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #442')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #442')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #442')
  call g:assert.equals(&l:autoindent,  1,           'failed at #442')
  call g:assert.equals(&l:smartindent, 0,           'failed at #442')
  call g:assert.equals(&l:cindent,     0,           'failed at #442')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #442')

  %delete

  " #443
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #443')
  call g:assert.equals(getline(2),   '    [',       'failed at #443')
  call g:assert.equals(getline(3),   '',            'failed at #443')
  call g:assert.equals(getline(4),   '    foo',     'failed at #443')
  call g:assert.equals(getline(5),   '',            'failed at #443')
  call g:assert.equals(getline(6),   '    ]',       'failed at #443')
  call g:assert.equals(getline(7),   '    }',       'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #443')
  call g:assert.equals(&l:autoindent,  1,           'failed at #443')
  call g:assert.equals(&l:smartindent, 1,           'failed at #443')
  call g:assert.equals(&l:cindent,     0,           'failed at #443')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #443')

  %delete

  " #444
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #444')
  call g:assert.equals(getline(2),   '    [',       'failed at #444')
  call g:assert.equals(getline(3),   '',            'failed at #444')
  call g:assert.equals(getline(4),   '    foo',     'failed at #444')
  call g:assert.equals(getline(5),   '',            'failed at #444')
  call g:assert.equals(getline(6),   '    ]',       'failed at #444')
  call g:assert.equals(getline(7),   '    }',       'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #444')
  call g:assert.equals(&l:autoindent,  1,           'failed at #444')
  call g:assert.equals(&l:smartindent, 1,           'failed at #444')
  call g:assert.equals(&l:cindent,     1,           'failed at #444')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #444')

  %delete

  " #445
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #445')
  call g:assert.equals(getline(2),   '    [',          'failed at #445')
  call g:assert.equals(getline(3),   '',               'failed at #445')
  call g:assert.equals(getline(4),   '    foo',        'failed at #445')
  call g:assert.equals(getline(5),   '',               'failed at #445')
  call g:assert.equals(getline(6),   '    ]',          'failed at #445')
  call g:assert.equals(getline(7),   '    }',          'failed at #445')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #445')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #445')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #445')
  call g:assert.equals(&l:autoindent,  1,              'failed at #445')
  call g:assert.equals(&l:smartindent, 1,              'failed at #445')
  call g:assert.equals(&l:cindent,     1,              'failed at #445')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #445')
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

  " #446
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #446')
  call g:assert.equals(getline(2),   '',           'failed at #446')
  call g:assert.equals(getline(3),   '    foo',    'failed at #446')
  call g:assert.equals(getline(4),   '',           'failed at #446')
  call g:assert.equals(getline(5),   '    }',      'failed at #446')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #446')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #446')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #446')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #446')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #446')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #447
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #447')
  call g:assert.equals(getline(2),   '',           'failed at #447')
  call g:assert.equals(getline(3),   '    foo',    'failed at #447')
  call g:assert.equals(getline(4),   '',           'failed at #447')
  call g:assert.equals(getline(5),   '    }',      'failed at #447')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #447')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #447')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #447')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #447')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #447')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #448
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #448')
  call g:assert.equals(getline(2),   '',           'failed at #448')
  call g:assert.equals(getline(3),   '    foo',    'failed at #448')
  call g:assert.equals(getline(4),   '',           'failed at #448')
  call g:assert.equals(getline(5),   '    }',      'failed at #448')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #448')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #448')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #448')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #448')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #448')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #449
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #449')
  call g:assert.equals(getline(2),   '',              'failed at #449')
  call g:assert.equals(getline(3),   '    foo',       'failed at #449')
  call g:assert.equals(getline(4),   '',              'failed at #449')
  call g:assert.equals(getline(5),   '    }',         'failed at #449')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #449')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #449')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #449')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #449')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #449')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #450
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',      'failed at #450')
  call g:assert.equals(getline(2),   '',              'failed at #450')
  call g:assert.equals(getline(3),   '    foo',       'failed at #450')
  call g:assert.equals(getline(4),   '',              'failed at #450')
  call g:assert.equals(getline(5),   '            }', 'failed at #450')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #450')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #450')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #450')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #450')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #450')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #451
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #451')
  call g:assert.equals(getline(2),   '',              'failed at #451')
  call g:assert.equals(getline(3),   '    foo',       'failed at #451')
  call g:assert.equals(getline(4),   '',              'failed at #451')
  call g:assert.equals(getline(5),   '    }',         'failed at #451')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #451')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #451')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #451')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #451')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #451')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #452
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #452')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #452')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #452')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #452')

  " #453
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #453')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #453')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #453')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #453')

  " #454
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #454')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #454')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #454')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #454')

  " #455
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #455')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #455')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #455')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #455')

  %delete

  " #456
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #456')
  call g:assert.equals(getline(2),   'foo',        'failed at #456')
  call g:assert.equals(getline(3),   ']',          'failed at #456')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #456')

  " #457
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #457')
  call g:assert.equals(getline(2),   'foo',        'failed at #457')
  call g:assert.equals(getline(3),   '}',          'failed at #457')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #457')

  " #458
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #458')
  call g:assert.equals(getline(2),   'foo',        'failed at #458')
  call g:assert.equals(getline(3),   '>',          'failed at #458')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #458')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #458')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #458')

  " #459
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #459')
  call g:assert.equals(getline(2),   'foo',        'failed at #459')
  call g:assert.equals(getline(3),   ')',          'failed at #459')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #459')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #460
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #460')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #460')

  " #461
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #461')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #461')

  %delete

  " #460
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #460')
  call g:assert.equals(getline(2),   'foo',        'failed at #460')
  call g:assert.equals(getline(3),   'b',          'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #460')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #460')

  %delete

  " #461
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #461')
  call g:assert.equals(getline(2),   'foo',        'failed at #461')
  call g:assert.equals(getline(3),   '*',          'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #461')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #461')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #462
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #462')
  call g:assert.equals(getline(2),   'foo',        'failed at #462')
  call g:assert.equals(getline(3),   'bar',        'failed at #462')
  call g:assert.equals(getline(4),   'baz',        'failed at #462')
  call g:assert.equals(getline(5),   ']',          'failed at #462')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #462')

  %delete

  " #463
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #463')
  call g:assert.equals(getline(2),   '[',          'failed at #463')
  call g:assert.equals(getline(3),   'bar',        'failed at #463')
  call g:assert.equals(getline(4),   ']',          'failed at #463')
  call g:assert.equals(getline(5),   'baz',        'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #463')

  %delete

  " #464
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #464')
  call g:assert.equals(getline(2),   'bar',        'failed at #464')
  call g:assert.equals(getline(3),   'baz]',       'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #464')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #465
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #465')

  %delete

  " #466
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #466')
  call g:assert.equals(getline(2),   ']',          'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #466')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #467
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #467')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #467')

  " #468
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #468')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #468')

  %delete

  " #469
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #469')
  call g:assert.equals(getline(2),   '(',          'failed at #469')
  call g:assert.equals(getline(3),   '{',          'failed at #469')
  call g:assert.equals(getline(4),   '[',          'failed at #469')
  call g:assert.equals(getline(5),   'bar',        'failed at #469')
  call g:assert.equals(getline(6),   ']',          'failed at #469')
  call g:assert.equals(getline(7),   '}',          'failed at #469')
  call g:assert.equals(getline(8),   ')',          'failed at #469')
  call g:assert.equals(getline(9),   'baz',        'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #469')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #470
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #470')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #470')

  %delete

  " #471
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #471')

  %delete

  " #472
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #472')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #472')
  call g:assert.equals(getline(3),   'aa',         'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #472')

  %delete

  " #473
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #473')
  call g:assert.equals(getline(2),   'bbb',        'failed at #473')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #473')
  call g:assert.equals(getline(4),   'bbb',        'failed at #473')
  call g:assert.equals(getline(5),   'bb',         'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #473')

  %delete

  " #474
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #474')
  call g:assert.equals(getline(2),   '(',          'failed at #474')
  call g:assert.equals(getline(3),   'foo',        'failed at #474')
  call g:assert.equals(getline(4),   ')',          'failed at #474')
  call g:assert.equals(getline(5),   ')',          'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #474')

  %delete

  " #475
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #475')
  call g:assert.equals(getline(2),   '(',          'failed at #475')
  call g:assert.equals(getline(3),   'foo',        'failed at #475')
  call g:assert.equals(getline(4),   ')',          'failed at #475')
  call g:assert.equals(getline(5),   ')',          'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #475')

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

  " #476
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #476')

  " #477
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #477')

  " #478
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #478')

  " #479
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #479')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #480
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #480')

  " #481
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #481')

  """ keep
  " #482
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #482')

  " #483
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #483')

  """ inner_tail
  " #484
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #484')

  " #485
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #485')

  """ head
  " #486
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #486')

  " #487
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #487')

  """ tail
  " #488
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #488')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #488')

  " #489
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #489')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #489')

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
  " #490
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #490')

  " #491
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #491')

  """ off
  " #492
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #492')

  " #493
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #493')

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
  " #494
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #494')

  " #495
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #495')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #496
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #496')

  " #497
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #497')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ on
  " #498
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #498')

  " #499
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #499')

  " #500
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #500')

  " #501
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #501')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #502
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #502')

  " #503
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #503')

  " #504
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #504')

  " #505
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #505')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #506
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #506')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #507
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #507')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #508
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '""', 'failed at #508')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #509
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #509')
  call g:assert.equals(getline(2),   'foo',        'failed at #509')
  call g:assert.equals(getline(3),   ']',          'failed at #509')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #509')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #509')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #509')

  %delete

  " #510
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #510')
  call g:assert.equals(getline(2),   'foo',        'failed at #510')
  call g:assert.equals(getline(3),   '  ]',        'failed at #510')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #510')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #510')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #510')

  %delete

  " #511
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #511')
  call g:assert.equals(getline(2),   'foo',        'failed at #511')
  call g:assert.equals(getline(3),   'aa]',        'failed at #511')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #511')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #511')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #511')

  %delete

  " #512
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #512')
  call g:assert.equals(getline(2),   'foo',        'failed at #512')
  call g:assert.equals(getline(3),   ']',          'failed at #512')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #512')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #512')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #512')

  %delete

  " #513
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #513')
  call g:assert.equals(getline(2),   'foo',        'failed at #513')
  call g:assert.equals(getline(3),   'aa]',        'failed at #513')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #513')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #514
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #514')
  call g:assert.equals(getline(2),   'foo',        'failed at #514')
  call g:assert.equals(getline(3),   ']',          'failed at #514')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #514')

  %delete

  " #515
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #515')
  call g:assert.equals(getline(2),   'foo',        'failed at #515')
  call g:assert.equals(getline(3),   ']',          'failed at #515')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #515')

  %delete

  " #516
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #516')
  call g:assert.equals(getline(2),   'foo',        'failed at #516')
  call g:assert.equals(getline(3),   ']',          'failed at #516')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #516')

  %delete

  " #517
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #517')
  call g:assert.equals(getline(2),   '[',          'failed at #517')
  call g:assert.equals(getline(3),   'bb',         'failed at #517')
  call g:assert.equals(getline(4),   '',           'failed at #517')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #517')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #517')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #517')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #518
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #518')

  %delete

  """ on
  " #519
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #519')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #520
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #520')

  """ 1
  " #521
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #521')

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

  " #522
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #522')
  call g:assert.equals(getline(2),   '[',          'failed at #522')
  call g:assert.equals(getline(3),   '',           'failed at #522')
  call g:assert.equals(getline(4),   '    foo',    'failed at #522')
  call g:assert.equals(getline(5),   '',           'failed at #522')
  call g:assert.equals(getline(6),   ']',          'failed at #522')
  call g:assert.equals(getline(7),   '}',          'failed at #522')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #522')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #522')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #522')
  call g:assert.equals(&l:autoindent,  0,          'failed at #522')
  call g:assert.equals(&l:smartindent, 0,          'failed at #522')
  call g:assert.equals(&l:cindent,     0,          'failed at #522')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #522')

  %delete

  " #523
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #523')
  call g:assert.equals(getline(2),   '    [',      'failed at #523')
  call g:assert.equals(getline(3),   '',           'failed at #523')
  call g:assert.equals(getline(4),   '    foo',    'failed at #523')
  call g:assert.equals(getline(5),   '',           'failed at #523')
  call g:assert.equals(getline(6),   '    ]',      'failed at #523')
  call g:assert.equals(getline(7),   '    }',      'failed at #523')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #523')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #523')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #523')
  call g:assert.equals(&l:autoindent,  1,          'failed at #523')
  call g:assert.equals(&l:smartindent, 0,          'failed at #523')
  call g:assert.equals(&l:cindent,     0,          'failed at #523')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #523')

  %delete

  " #524
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #524')
  call g:assert.equals(getline(2),   '    [',       'failed at #524')
  call g:assert.equals(getline(3),   '',            'failed at #524')
  call g:assert.equals(getline(4),   '    foo',     'failed at #524')
  call g:assert.equals(getline(5),   '',            'failed at #524')
  call g:assert.equals(getline(6),   '    ]',       'failed at #524')
  call g:assert.equals(getline(7),   '}',           'failed at #524')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #524')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #524')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #524')
  call g:assert.equals(&l:autoindent,  1,           'failed at #524')
  call g:assert.equals(&l:smartindent, 1,           'failed at #524')
  call g:assert.equals(&l:cindent,     0,           'failed at #524')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #524')

  %delete

  " #525
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #525')
  call g:assert.equals(getline(2),   '    [',       'failed at #525')
  call g:assert.equals(getline(3),   '',            'failed at #525')
  call g:assert.equals(getline(4),   '    foo',     'failed at #525')
  call g:assert.equals(getline(5),   '',            'failed at #525')
  call g:assert.equals(getline(6),   '    ]',       'failed at #525')
  call g:assert.equals(getline(7),   '    }',       'failed at #525')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #525')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #525')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #525')
  call g:assert.equals(&l:autoindent,  1,           'failed at #525')
  call g:assert.equals(&l:smartindent, 1,           'failed at #525')
  call g:assert.equals(&l:cindent,     1,           'failed at #525')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #525')

  %delete

  " #526
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',            'failed at #526')
  call g:assert.equals(getline(2),   '           [',        'failed at #526')
  call g:assert.equals(getline(3),   '',                    'failed at #526')
  call g:assert.equals(getline(4),   '    foo',             'failed at #526')
  call g:assert.equals(getline(5),   '',                    'failed at #526')
  call g:assert.equals(getline(6),   '        ]',           'failed at #526')
  call g:assert.equals(getline(7),   '                }',   'failed at #526')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #526')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #526')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #526')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #526')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #526')
  call g:assert.equals(&l:cindent,     1,                   'failed at #526')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #526')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #527
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #527')
  call g:assert.equals(getline(2),   '[',          'failed at #527')
  call g:assert.equals(getline(3),   '',           'failed at #527')
  call g:assert.equals(getline(4),   '    foo',    'failed at #527')
  call g:assert.equals(getline(5),   '',           'failed at #527')
  call g:assert.equals(getline(6),   ']',          'failed at #527')
  call g:assert.equals(getline(7),   '}',          'failed at #527')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #527')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #527')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #527')
  call g:assert.equals(&l:autoindent,  0,          'failed at #527')
  call g:assert.equals(&l:smartindent, 0,          'failed at #527')
  call g:assert.equals(&l:cindent,     0,          'failed at #527')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #527')

  %delete

  " #528
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #528')
  call g:assert.equals(getline(2),   '[',          'failed at #528')
  call g:assert.equals(getline(3),   '',           'failed at #528')
  call g:assert.equals(getline(4),   '    foo',    'failed at #528')
  call g:assert.equals(getline(5),   '',           'failed at #528')
  call g:assert.equals(getline(6),   ']',          'failed at #528')
  call g:assert.equals(getline(7),   '}',          'failed at #528')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #528')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #528')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #528')
  call g:assert.equals(&l:autoindent,  1,          'failed at #528')
  call g:assert.equals(&l:smartindent, 0,          'failed at #528')
  call g:assert.equals(&l:cindent,     0,          'failed at #528')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #528')

  %delete

  " #529
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #529')
  call g:assert.equals(getline(2),   '[',          'failed at #529')
  call g:assert.equals(getline(3),   '',           'failed at #529')
  call g:assert.equals(getline(4),   '    foo',    'failed at #529')
  call g:assert.equals(getline(5),   '',           'failed at #529')
  call g:assert.equals(getline(6),   ']',          'failed at #529')
  call g:assert.equals(getline(7),   '}',          'failed at #529')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #529')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #529')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #529')
  call g:assert.equals(&l:autoindent,  1,          'failed at #529')
  call g:assert.equals(&l:smartindent, 1,          'failed at #529')
  call g:assert.equals(&l:cindent,     0,          'failed at #529')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #529')

  %delete

  " #530
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #530')
  call g:assert.equals(getline(2),   '[',          'failed at #530')
  call g:assert.equals(getline(3),   '',           'failed at #530')
  call g:assert.equals(getline(4),   '    foo',    'failed at #530')
  call g:assert.equals(getline(5),   '',           'failed at #530')
  call g:assert.equals(getline(6),   ']',          'failed at #530')
  call g:assert.equals(getline(7),   '}',          'failed at #530')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #530')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #530')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #530')
  call g:assert.equals(&l:autoindent,  1,          'failed at #530')
  call g:assert.equals(&l:smartindent, 1,          'failed at #530')
  call g:assert.equals(&l:cindent,     1,          'failed at #530')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #530')

  %delete

  " #531
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #531')
  call g:assert.equals(getline(2),   '[',              'failed at #531')
  call g:assert.equals(getline(3),   '',               'failed at #531')
  call g:assert.equals(getline(4),   '    foo',        'failed at #531')
  call g:assert.equals(getline(5),   '',               'failed at #531')
  call g:assert.equals(getline(6),   ']',              'failed at #531')
  call g:assert.equals(getline(7),   '}',              'failed at #531')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #531')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #531')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #531')
  call g:assert.equals(&l:autoindent,  1,              'failed at #531')
  call g:assert.equals(&l:smartindent, 1,              'failed at #531')
  call g:assert.equals(&l:cindent,     1,              'failed at #531')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #531')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #532
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #532')
  call g:assert.equals(getline(2),   '    [',      'failed at #532')
  call g:assert.equals(getline(3),   '',           'failed at #532')
  call g:assert.equals(getline(4),   '    foo',    'failed at #532')
  call g:assert.equals(getline(5),   '',           'failed at #532')
  call g:assert.equals(getline(6),   '    ]',      'failed at #532')
  call g:assert.equals(getline(7),   '    }',      'failed at #532')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #532')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #532')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #532')
  call g:assert.equals(&l:autoindent,  0,          'failed at #532')
  call g:assert.equals(&l:smartindent, 0,          'failed at #532')
  call g:assert.equals(&l:cindent,     0,          'failed at #532')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #532')

  %delete

  " #533
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #533')
  call g:assert.equals(getline(2),   '    [',      'failed at #533')
  call g:assert.equals(getline(3),   '',           'failed at #533')
  call g:assert.equals(getline(4),   '    foo',    'failed at #533')
  call g:assert.equals(getline(5),   '',           'failed at #533')
  call g:assert.equals(getline(6),   '    ]',      'failed at #533')
  call g:assert.equals(getline(7),   '    }',      'failed at #533')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #533')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #533')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #533')
  call g:assert.equals(&l:autoindent,  1,          'failed at #533')
  call g:assert.equals(&l:smartindent, 0,          'failed at #533')
  call g:assert.equals(&l:cindent,     0,          'failed at #533')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #533')

  %delete

  " #534
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #534')
  call g:assert.equals(getline(2),   '    [',      'failed at #534')
  call g:assert.equals(getline(3),   '',           'failed at #534')
  call g:assert.equals(getline(4),   '    foo',    'failed at #534')
  call g:assert.equals(getline(5),   '',           'failed at #534')
  call g:assert.equals(getline(6),   '    ]',      'failed at #534')
  call g:assert.equals(getline(7),   '    }',      'failed at #534')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #534')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #534')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #534')
  call g:assert.equals(&l:autoindent,  1,          'failed at #534')
  call g:assert.equals(&l:smartindent, 1,          'failed at #534')
  call g:assert.equals(&l:cindent,     0,          'failed at #534')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #534')

  %delete

  " #535
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #535')
  call g:assert.equals(getline(2),   '    [',      'failed at #535')
  call g:assert.equals(getline(3),   '',           'failed at #535')
  call g:assert.equals(getline(4),   '    foo',    'failed at #535')
  call g:assert.equals(getline(5),   '',           'failed at #535')
  call g:assert.equals(getline(6),   '    ]',      'failed at #535')
  call g:assert.equals(getline(7),   '    }',      'failed at #535')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #535')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #535')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #535')
  call g:assert.equals(&l:autoindent,  1,          'failed at #535')
  call g:assert.equals(&l:smartindent, 1,          'failed at #535')
  call g:assert.equals(&l:cindent,     1,          'failed at #535')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #535')

  %delete

  " #536
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',          'failed at #536')
  call g:assert.equals(getline(2),   '    [',          'failed at #536')
  call g:assert.equals(getline(3),   '',               'failed at #536')
  call g:assert.equals(getline(4),   '    foo',        'failed at #536')
  call g:assert.equals(getline(5),   '',               'failed at #536')
  call g:assert.equals(getline(6),   '    ]',          'failed at #536')
  call g:assert.equals(getline(7),   '    }',          'failed at #536')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #536')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #536')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #536')
  call g:assert.equals(&l:autoindent,  1,              'failed at #536')
  call g:assert.equals(&l:smartindent, 1,              'failed at #536')
  call g:assert.equals(&l:cindent,     1,              'failed at #536')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #536')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #537
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #537')
  call g:assert.equals(getline(2),   '    [',       'failed at #537')
  call g:assert.equals(getline(3),   '',            'failed at #537')
  call g:assert.equals(getline(4),   '    foo',     'failed at #537')
  call g:assert.equals(getline(5),   '',            'failed at #537')
  call g:assert.equals(getline(6),   '    ]',       'failed at #537')
  call g:assert.equals(getline(7),   '}',           'failed at #537')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #537')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #537')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #537')
  call g:assert.equals(&l:autoindent,  0,           'failed at #537')
  call g:assert.equals(&l:smartindent, 0,           'failed at #537')
  call g:assert.equals(&l:cindent,     0,           'failed at #537')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #537')

  %delete

  " #538
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #538')
  call g:assert.equals(getline(2),   '    [',       'failed at #538')
  call g:assert.equals(getline(3),   '',            'failed at #538')
  call g:assert.equals(getline(4),   '    foo',     'failed at #538')
  call g:assert.equals(getline(5),   '',            'failed at #538')
  call g:assert.equals(getline(6),   '    ]',       'failed at #538')
  call g:assert.equals(getline(7),   '}',           'failed at #538')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #538')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #538')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #538')
  call g:assert.equals(&l:autoindent,  1,           'failed at #538')
  call g:assert.equals(&l:smartindent, 0,           'failed at #538')
  call g:assert.equals(&l:cindent,     0,           'failed at #538')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #538')

  %delete

  " #539
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #539')
  call g:assert.equals(getline(2),   '    [',       'failed at #539')
  call g:assert.equals(getline(3),   '',            'failed at #539')
  call g:assert.equals(getline(4),   '    foo',     'failed at #539')
  call g:assert.equals(getline(5),   '',            'failed at #539')
  call g:assert.equals(getline(6),   '    ]',       'failed at #539')
  call g:assert.equals(getline(7),   '}',           'failed at #539')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #539')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #539')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #539')
  call g:assert.equals(&l:autoindent,  1,           'failed at #539')
  call g:assert.equals(&l:smartindent, 1,           'failed at #539')
  call g:assert.equals(&l:cindent,     0,           'failed at #539')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #539')

  %delete

  " #540
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #540')
  call g:assert.equals(getline(2),   '    [',       'failed at #540')
  call g:assert.equals(getline(3),   '',            'failed at #540')
  call g:assert.equals(getline(4),   '    foo',     'failed at #540')
  call g:assert.equals(getline(5),   '',            'failed at #540')
  call g:assert.equals(getline(6),   '    ]',       'failed at #540')
  call g:assert.equals(getline(7),   '}',           'failed at #540')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #540')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #540')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #540')
  call g:assert.equals(&l:autoindent,  1,           'failed at #540')
  call g:assert.equals(&l:smartindent, 1,           'failed at #540')
  call g:assert.equals(&l:cindent,     1,           'failed at #540')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #540')

  %delete

  " #541
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #541')
  call g:assert.equals(getline(2),   '    [',          'failed at #541')
  call g:assert.equals(getline(3),   '',               'failed at #541')
  call g:assert.equals(getline(4),   '    foo',        'failed at #541')
  call g:assert.equals(getline(5),   '',               'failed at #541')
  call g:assert.equals(getline(6),   '    ]',          'failed at #541')
  call g:assert.equals(getline(7),   '}',              'failed at #541')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #541')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #541')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #541')
  call g:assert.equals(&l:autoindent,  1,              'failed at #541')
  call g:assert.equals(&l:smartindent, 1,              'failed at #541')
  call g:assert.equals(&l:cindent,     1,              'failed at #541')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #541')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #542
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #542')
  call g:assert.equals(getline(2),   '    [',       'failed at #542')
  call g:assert.equals(getline(3),   '',            'failed at #542')
  call g:assert.equals(getline(4),   '    foo',     'failed at #542')
  call g:assert.equals(getline(5),   '',            'failed at #542')
  call g:assert.equals(getline(6),   '    ]',       'failed at #542')
  call g:assert.equals(getline(7),   '    }',       'failed at #542')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #542')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #542')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #542')
  call g:assert.equals(&l:autoindent,  0,           'failed at #542')
  call g:assert.equals(&l:smartindent, 0,           'failed at #542')
  call g:assert.equals(&l:cindent,     0,           'failed at #542')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #542')

  %delete

  " #543
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #543')
  call g:assert.equals(getline(2),   '    [',       'failed at #543')
  call g:assert.equals(getline(3),   '',            'failed at #543')
  call g:assert.equals(getline(4),   '    foo',     'failed at #543')
  call g:assert.equals(getline(5),   '',            'failed at #543')
  call g:assert.equals(getline(6),   '    ]',       'failed at #543')
  call g:assert.equals(getline(7),   '    }',       'failed at #543')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #543')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #543')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #543')
  call g:assert.equals(&l:autoindent,  1,           'failed at #543')
  call g:assert.equals(&l:smartindent, 0,           'failed at #543')
  call g:assert.equals(&l:cindent,     0,           'failed at #543')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #543')

  %delete

  " #544
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #544')
  call g:assert.equals(getline(2),   '    [',       'failed at #544')
  call g:assert.equals(getline(3),   '',            'failed at #544')
  call g:assert.equals(getline(4),   '    foo',     'failed at #544')
  call g:assert.equals(getline(5),   '',            'failed at #544')
  call g:assert.equals(getline(6),   '    ]',       'failed at #544')
  call g:assert.equals(getline(7),   '    }',       'failed at #544')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #544')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #544')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #544')
  call g:assert.equals(&l:autoindent,  1,           'failed at #544')
  call g:assert.equals(&l:smartindent, 1,           'failed at #544')
  call g:assert.equals(&l:cindent,     0,           'failed at #544')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #544')

  %delete

  " #545
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #545')
  call g:assert.equals(getline(2),   '    [',       'failed at #545')
  call g:assert.equals(getline(3),   '',            'failed at #545')
  call g:assert.equals(getline(4),   '    foo',     'failed at #545')
  call g:assert.equals(getline(5),   '',            'failed at #545')
  call g:assert.equals(getline(6),   '    ]',       'failed at #545')
  call g:assert.equals(getline(7),   '    }',       'failed at #545')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #545')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #545')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #545')
  call g:assert.equals(&l:autoindent,  1,           'failed at #545')
  call g:assert.equals(&l:smartindent, 1,           'failed at #545')
  call g:assert.equals(&l:cindent,     1,           'failed at #545')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #545')

  %delete

  " #546
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #546')
  call g:assert.equals(getline(2),   '    [',          'failed at #546')
  call g:assert.equals(getline(3),   '',               'failed at #546')
  call g:assert.equals(getline(4),   '    foo',        'failed at #546')
  call g:assert.equals(getline(5),   '',               'failed at #546')
  call g:assert.equals(getline(6),   '    ]',          'failed at #546')
  call g:assert.equals(getline(7),   '    }',          'failed at #546')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #546')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #546')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #546')
  call g:assert.equals(&l:autoindent,  1,              'failed at #546')
  call g:assert.equals(&l:smartindent, 1,              'failed at #546')
  call g:assert.equals(&l:cindent,     1,              'failed at #546')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #546')
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

  " #547
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #547')
  call g:assert.equals(getline(2),   '',           'failed at #547')
  call g:assert.equals(getline(3),   '    foo',    'failed at #547')
  call g:assert.equals(getline(4),   '',           'failed at #547')
  call g:assert.equals(getline(5),   '    }',      'failed at #547')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #547')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #547')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #547')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #547')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #547')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #548
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #548')
  call g:assert.equals(getline(2),   '',           'failed at #548')
  call g:assert.equals(getline(3),   '    foo',    'failed at #548')
  call g:assert.equals(getline(4),   '',           'failed at #548')
  call g:assert.equals(getline(5),   '    }',      'failed at #548')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #548')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #548')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #548')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #548')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #548')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #549
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #549')
  call g:assert.equals(getline(2),   '',           'failed at #549')
  call g:assert.equals(getline(3),   '    foo',    'failed at #549')
  call g:assert.equals(getline(4),   '',           'failed at #549')
  call g:assert.equals(getline(5),   '    }',      'failed at #549')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #549')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #549')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #549')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #549')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #549')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #550
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #550')
  call g:assert.equals(getline(2),   '',              'failed at #550')
  call g:assert.equals(getline(3),   '    foo',       'failed at #550')
  call g:assert.equals(getline(4),   '',              'failed at #550')
  call g:assert.equals(getline(5),   '    }',         'failed at #550')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #550')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #550')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #550')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #550')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #550')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #551
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',      'failed at #551')
  call g:assert.equals(getline(2),   '',              'failed at #551')
  call g:assert.equals(getline(3),   '    foo',       'failed at #551')
  call g:assert.equals(getline(4),   '',              'failed at #551')
  call g:assert.equals(getline(5),   '            }', 'failed at #551')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #551')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #551')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #551')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #551')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #551')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #552
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #552')
  call g:assert.equals(getline(2),   '',              'failed at #552')
  call g:assert.equals(getline(3),   '    foo',       'failed at #552')
  call g:assert.equals(getline(4),   '',              'failed at #552')
  call g:assert.equals(getline(5),   '    }',         'failed at #552')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #552')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #552')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #552')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #552')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #552')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #553
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #553')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #553')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #553')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #553')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #553')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #553')

  %delete

  " #554
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #554')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #554')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #554')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #554')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #554')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #554')

  %delete

  " #555
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #555')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #555')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #555')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #555')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #555')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #555')

  %delete

  " #556
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #556')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #556')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #556')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #556')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #556')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #556')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #557
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #557')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #557')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #557')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #557')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #557')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #557')

  " #558
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #558')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #558')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #558')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #558')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #558')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #558')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #559
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #559')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #559')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #559')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #559')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #559')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #559')

  %delete

  " #560
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #560')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #560')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #560')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #560')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #560')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #560')

  %delete

  " #561
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #561')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #561')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #561')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #561')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #561')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #561')

  %delete

  " #562
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #562')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #562')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #562')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #562')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #562')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #562')

  %delete

  " #563
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #563')
  call g:assert.equals(getline(2),   'barbar',     'failed at #563')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #563')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #563')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #563')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #563')

  %delete

  " #564
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #564')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #564')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #564')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #564')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #564')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #564')

  %delete

  " #565
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #565')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #565')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #565')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #565')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #565')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #565')

  %delete

  " #566
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #566')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #566')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #566')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #566')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #566')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #566')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #567
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #567')
  call g:assert.equals(getline(2),   '[b]',        'failed at #567')
  call g:assert.equals(getline(3),   '[c]',        'failed at #567')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #567')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #567')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #567')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #568
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #568')
  call g:assert.equals(getline(2),   '[]',         'failed at #568')
  call g:assert.equals(getline(3),   '[]',         'failed at #568')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #568')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #568')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #568')

  %delete

  " #569
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #569')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #569')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #569')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #569')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #569')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #569')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #570
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #570')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #570')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #570')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #570')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #570')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #570')

  %delete

  " #571
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #571')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #571')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #571')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #571')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #571')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #571')

  %delete

  " #572
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #572')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #572')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #572')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #572')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #572')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #572')

  %delete

  " #573
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #573')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #573')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #573')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #573')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #573')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #573')

  %delete

  " #574
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #574')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #574')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #574')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #574')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #574')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #574')

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

  " #575
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #575')
  call g:assert.equals(getline(2), '"bar"', 'failed at #575')
  call g:assert.equals(getline(3), '"baz"', 'failed at #575')

  %delete

  " #576
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #576')
  call g:assert.equals(getline(2), '"bar"', 'failed at #576')
  call g:assert.equals(getline(3), '"baz"', 'failed at #576')

  %delete

  " #577
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #577')
  call g:assert.equals(getline(2), '"bar"', 'failed at #577')
  call g:assert.equals(getline(3), '"baz"', 'failed at #577')

  %delete

  " #578
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #578')
  call g:assert.equals(getline(2), '"bar"', 'failed at #578')
  call g:assert.equals(getline(3), '"baz"', 'failed at #578')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #579
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #579')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #579')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #579')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #579')

  " #580
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #580')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #580')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #580')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #580')

  %delete

  """ keep
  " #581
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #581')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #581')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #581')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #581')

  " #582
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #582')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #582')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #582')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #582')

  %delete

  """ inner_tail
  " #583
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #583')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #583')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #583')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #583')

  " #584
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #584')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #584')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #584')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #584')

  %delete

  """ head
  " #585
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #585')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #585')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #585')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #585')

  " #586
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #586')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #586')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #586')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #586')

  %delete

  """ tail
  " #587
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #587')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #587')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #587')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #587')

  " #588
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #588')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #588')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #588')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #588')

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
  " #589
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #589')
  call g:assert.equals(getline(2), '"bar"', 'failed at #589')
  call g:assert.equals(getline(3), '"baz"', 'failed at #589')

  %delete

  " #590
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #590')
  call g:assert.equals(getline(2), '(bar)', 'failed at #590')
  call g:assert.equals(getline(3), '(baz)', 'failed at #590')

  %delete

  """ off
  " #591
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #591')
  call g:assert.equals(getline(2), '{bar}', 'failed at #591')
  call g:assert.equals(getline(3), '{baz}', 'failed at #591')

  %delete

  " #592
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #592')
  call g:assert.equals(getline(2), '"bar"', 'failed at #592')
  call g:assert.equals(getline(3), '"baz"', 'failed at #592')

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
  " #593
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #593')
  call g:assert.equals(getline(2), '"bar"', 'failed at #593')
  call g:assert.equals(getline(3), '"baz"', 'failed at #593')

  %delete

  " #594
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #594')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #594')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #594')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #595
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #595')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #595')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #595')

  %delete

  " #596
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #596')
  call g:assert.equals(getline(2), '"bar"', 'failed at #596')
  call g:assert.equals(getline(3), '"baz"', 'failed at #596')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #597
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #597')
  call g:assert.equals(getline(2), '(bar)', 'failed at #597')
  call g:assert.equals(getline(3), '(baz)', 'failed at #597')

  %delete

  " #598
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #598')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #598')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #598')

  %delete

  " #599
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #599')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #599')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #599')

  %delete

  " #600
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #600')
  call g:assert.equals(getline(2), '("bar")', 'failed at #600')
  call g:assert.equals(getline(3), '("baz")', 'failed at #600')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #601
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #601')
  call g:assert.equals(getline(2), '(bar)', 'failed at #601')
  call g:assert.equals(getline(3), '(baz)', 'failed at #601')

  %delete

  " #602
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #602')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #602')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #602')

  %delete

  " #603
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #603')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #603')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #603')

  %delete

  " #604
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #604')
  call g:assert.equals(getline(2), '("bar")', 'failed at #604')
  call g:assert.equals(getline(3), '("baz")', 'failed at #604')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #605
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #605')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #605')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #605')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #606
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #606')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #606')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #606')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #607
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '""', 'failed at #607')
  call g:assert.equals(getline(2), '""', 'failed at #607')
  call g:assert.equals(getline(3), '""', 'failed at #607')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #607
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #607')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #607')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #607')

  %delete

  """ on
  " #608
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #608')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #608')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #608')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #609
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #609')

  %delete

  """ 1
  " #610
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #610')

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

  " #416
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #416')
  call g:assert.equals(getline(2),   '[',          'failed at #416')
  call g:assert.equals(getline(3),   'foo',        'failed at #416')
  call g:assert.equals(getline(4),   ']',          'failed at #416')
  call g:assert.equals(getline(5),   '}',          'failed at #416')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #416')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #416')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #416')
  call g:assert.equals(&l:autoindent,  0,          'failed at #416')
  call g:assert.equals(&l:smartindent, 0,          'failed at #416')
  call g:assert.equals(&l:cindent,     0,          'failed at #416')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #416')

  %delete

  " #417
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #417')
  call g:assert.equals(getline(2),   '    [',      'failed at #417')
  call g:assert.equals(getline(3),   '    foo',    'failed at #417')
  call g:assert.equals(getline(4),   '    ]',      'failed at #417')
  call g:assert.equals(getline(5),   '    }',      'failed at #417')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #417')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #417')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #417')
  call g:assert.equals(&l:autoindent,  1,          'failed at #417')
  call g:assert.equals(&l:smartindent, 0,          'failed at #417')
  call g:assert.equals(&l:cindent,     0,          'failed at #417')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #417')

  %delete

  " #418
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #418')
  call g:assert.equals(getline(2),   '        [',   'failed at #418')
  call g:assert.equals(getline(3),   '        foo', 'failed at #418')
  call g:assert.equals(getline(4),   '    ]',       'failed at #418')
  call g:assert.equals(getline(5),   '}',           'failed at #418')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #418')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #418')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #418')
  call g:assert.equals(&l:autoindent,  1,           'failed at #418')
  call g:assert.equals(&l:smartindent, 1,           'failed at #418')
  call g:assert.equals(&l:cindent,     0,           'failed at #418')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #418')

  %delete

  " #419
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #419')
  call g:assert.equals(getline(2),   '    [',       'failed at #419')
  call g:assert.equals(getline(3),   '        foo', 'failed at #419')
  call g:assert.equals(getline(4),   '    ]',       'failed at #419')
  call g:assert.equals(getline(5),   '    }',       'failed at #419')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #419')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #419')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #419')
  call g:assert.equals(&l:autoindent,  1,           'failed at #419')
  call g:assert.equals(&l:smartindent, 1,           'failed at #419')
  call g:assert.equals(&l:cindent,     1,           'failed at #419')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #419')

  %delete

  " #420
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',           'failed at #420')
  call g:assert.equals(getline(2),   '            [',       'failed at #420')
  call g:assert.equals(getline(3),   '                foo', 'failed at #420')
  call g:assert.equals(getline(4),   '        ]',           'failed at #420')
  call g:assert.equals(getline(5),   '                }',   'failed at #420')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #420')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #420')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #420')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #420')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #420')
  call g:assert.equals(&l:cindent,     1,                   'failed at #420')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #420')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #421
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #421')
  call g:assert.equals(getline(2),   '[',          'failed at #421')
  call g:assert.equals(getline(3),   'foo',        'failed at #421')
  call g:assert.equals(getline(4),   ']',          'failed at #421')
  call g:assert.equals(getline(5),   '}',          'failed at #421')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #421')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #421')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #421')
  call g:assert.equals(&l:autoindent,  0,          'failed at #421')
  call g:assert.equals(&l:smartindent, 0,          'failed at #421')
  call g:assert.equals(&l:cindent,     0,          'failed at #421')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #421')

  %delete

  " #422
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #422')
  call g:assert.equals(getline(2),   '[',          'failed at #422')
  call g:assert.equals(getline(3),   'foo',        'failed at #422')
  call g:assert.equals(getline(4),   ']',          'failed at #422')
  call g:assert.equals(getline(5),   '}',          'failed at #422')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #422')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #422')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #422')
  call g:assert.equals(&l:autoindent,  1,          'failed at #422')
  call g:assert.equals(&l:smartindent, 0,          'failed at #422')
  call g:assert.equals(&l:cindent,     0,          'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #422')

  %delete

  " #423
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #423')
  call g:assert.equals(getline(2),   '[',          'failed at #423')
  call g:assert.equals(getline(3),   'foo',        'failed at #423')
  call g:assert.equals(getline(4),   ']',          'failed at #423')
  call g:assert.equals(getline(5),   '}',          'failed at #423')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #423')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #423')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #423')
  call g:assert.equals(&l:autoindent,  1,          'failed at #423')
  call g:assert.equals(&l:smartindent, 1,          'failed at #423')
  call g:assert.equals(&l:cindent,     0,          'failed at #423')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #423')

  %delete

  " #424
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #424')
  call g:assert.equals(getline(2),   '[',          'failed at #424')
  call g:assert.equals(getline(3),   'foo',        'failed at #424')
  call g:assert.equals(getline(4),   ']',          'failed at #424')
  call g:assert.equals(getline(5),   '}',          'failed at #424')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #424')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #424')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #424')
  call g:assert.equals(&l:autoindent,  1,          'failed at #424')
  call g:assert.equals(&l:smartindent, 1,          'failed at #424')
  call g:assert.equals(&l:cindent,     1,          'failed at #424')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #424')

  %delete

  " #425
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #425')
  call g:assert.equals(getline(2),   '[',              'failed at #425')
  call g:assert.equals(getline(3),   'foo',            'failed at #425')
  call g:assert.equals(getline(4),   ']',              'failed at #425')
  call g:assert.equals(getline(5),   '}',              'failed at #425')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #425')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #425')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #425')
  call g:assert.equals(&l:autoindent,  1,              'failed at #425')
  call g:assert.equals(&l:smartindent, 1,              'failed at #425')
  call g:assert.equals(&l:cindent,     1,              'failed at #425')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #425')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #426
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #426')
  call g:assert.equals(getline(2),   '    [',      'failed at #426')
  call g:assert.equals(getline(3),   '    foo',    'failed at #426')
  call g:assert.equals(getline(4),   '    ]',      'failed at #426')
  call g:assert.equals(getline(5),   '    }',      'failed at #426')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #426')
  call g:assert.equals(&l:autoindent,  0,          'failed at #426')
  call g:assert.equals(&l:smartindent, 0,          'failed at #426')
  call g:assert.equals(&l:cindent,     0,          'failed at #426')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #426')

  %delete

  " #427
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #427')
  call g:assert.equals(getline(2),   '    [',      'failed at #427')
  call g:assert.equals(getline(3),   '    foo',    'failed at #427')
  call g:assert.equals(getline(4),   '    ]',      'failed at #427')
  call g:assert.equals(getline(5),   '    }',      'failed at #427')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #427')
  call g:assert.equals(&l:autoindent,  1,          'failed at #427')
  call g:assert.equals(&l:smartindent, 0,          'failed at #427')
  call g:assert.equals(&l:cindent,     0,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #428')
  call g:assert.equals(getline(2),   '    [',      'failed at #428')
  call g:assert.equals(getline(3),   '    foo',    'failed at #428')
  call g:assert.equals(getline(4),   '    ]',      'failed at #428')
  call g:assert.equals(getline(5),   '    }',      'failed at #428')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #428')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #428')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #428')
  call g:assert.equals(&l:autoindent,  1,          'failed at #428')
  call g:assert.equals(&l:smartindent, 1,          'failed at #428')
  call g:assert.equals(&l:cindent,     0,          'failed at #428')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #428')

  %delete

  " #429
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #429')
  call g:assert.equals(getline(2),   '    [',      'failed at #429')
  call g:assert.equals(getline(3),   '    foo',    'failed at #429')
  call g:assert.equals(getline(4),   '    ]',      'failed at #429')
  call g:assert.equals(getline(5),   '    }',      'failed at #429')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #429')
  call g:assert.equals(&l:autoindent,  1,          'failed at #429')
  call g:assert.equals(&l:smartindent, 1,          'failed at #429')
  call g:assert.equals(&l:cindent,     1,          'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #429')

  %delete

  " #430
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #430')
  call g:assert.equals(getline(2),   '    [',          'failed at #430')
  call g:assert.equals(getline(3),   '    foo',        'failed at #430')
  call g:assert.equals(getline(4),   '    ]',          'failed at #430')
  call g:assert.equals(getline(5),   '    }',          'failed at #430')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #430')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #430')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #430')
  call g:assert.equals(&l:autoindent,  1,              'failed at #430')
  call g:assert.equals(&l:smartindent, 1,              'failed at #430')
  call g:assert.equals(&l:cindent,     1,              'failed at #430')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #430')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #431
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #431')
  call g:assert.equals(getline(2),   '        [',   'failed at #431')
  call g:assert.equals(getline(3),   '        foo', 'failed at #431')
  call g:assert.equals(getline(4),   '    ]',       'failed at #431')
  call g:assert.equals(getline(5),   '}',           'failed at #431')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #431')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #431')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #431')
  call g:assert.equals(&l:autoindent,  0,           'failed at #431')
  call g:assert.equals(&l:smartindent, 0,           'failed at #431')
  call g:assert.equals(&l:cindent,     0,           'failed at #431')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #431')

  %delete

  " #432
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #432')
  call g:assert.equals(getline(2),   '        [',   'failed at #432')
  call g:assert.equals(getline(3),   '        foo', 'failed at #432')
  call g:assert.equals(getline(4),   '    ]',       'failed at #432')
  call g:assert.equals(getline(5),   '}',           'failed at #432')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #432')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #432')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #432')
  call g:assert.equals(&l:autoindent,  1,           'failed at #432')
  call g:assert.equals(&l:smartindent, 0,           'failed at #432')
  call g:assert.equals(&l:cindent,     0,           'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #432')

  %delete

  " #433
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #433')
  call g:assert.equals(getline(2),   '        [',   'failed at #433')
  call g:assert.equals(getline(3),   '        foo', 'failed at #433')
  call g:assert.equals(getline(4),   '    ]',       'failed at #433')
  call g:assert.equals(getline(5),   '}',           'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #433')
  call g:assert.equals(&l:autoindent,  1,           'failed at #433')
  call g:assert.equals(&l:smartindent, 1,           'failed at #433')
  call g:assert.equals(&l:cindent,     0,           'failed at #433')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #433')

  %delete

  " #434
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #434')
  call g:assert.equals(getline(2),   '        [',   'failed at #434')
  call g:assert.equals(getline(3),   '        foo', 'failed at #434')
  call g:assert.equals(getline(4),   '    ]',       'failed at #434')
  call g:assert.equals(getline(5),   '}',           'failed at #434')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #434')
  call g:assert.equals(&l:autoindent,  1,           'failed at #434')
  call g:assert.equals(&l:smartindent, 1,           'failed at #434')
  call g:assert.equals(&l:cindent,     1,           'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #434')

  %delete

  " #435
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #435')
  call g:assert.equals(getline(2),   '        [',      'failed at #435')
  call g:assert.equals(getline(3),   '        foo',    'failed at #435')
  call g:assert.equals(getline(4),   '    ]',          'failed at #435')
  call g:assert.equals(getline(5),   '}',              'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #435')
  call g:assert.equals(&l:autoindent,  1,              'failed at #435')
  call g:assert.equals(&l:smartindent, 1,              'failed at #435')
  call g:assert.equals(&l:cindent,     1,              'failed at #435')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #435')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #436
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '        foo', 'failed at #436')
  call g:assert.equals(getline(4),   '    ]',       'failed at #436')
  call g:assert.equals(getline(5),   '    }',       'failed at #436')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #436')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #436')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #436')
  call g:assert.equals(&l:autoindent,  0,           'failed at #436')
  call g:assert.equals(&l:smartindent, 0,           'failed at #436')
  call g:assert.equals(&l:cindent,     0,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #437')
  call g:assert.equals(getline(2),   '    [',       'failed at #437')
  call g:assert.equals(getline(3),   '        foo', 'failed at #437')
  call g:assert.equals(getline(4),   '    ]',       'failed at #437')
  call g:assert.equals(getline(5),   '    }',       'failed at #437')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #437')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #437')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #437')
  call g:assert.equals(&l:autoindent,  1,           'failed at #437')
  call g:assert.equals(&l:smartindent, 0,           'failed at #437')
  call g:assert.equals(&l:cindent,     0,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #438')
  call g:assert.equals(getline(2),   '    [',       'failed at #438')
  call g:assert.equals(getline(3),   '        foo', 'failed at #438')
  call g:assert.equals(getline(4),   '    ]',       'failed at #438')
  call g:assert.equals(getline(5),   '    }',       'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #438')
  call g:assert.equals(&l:autoindent,  1,           'failed at #438')
  call g:assert.equals(&l:smartindent, 1,           'failed at #438')
  call g:assert.equals(&l:cindent,     0,           'failed at #438')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #438')

  %delete

  " #439
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #439')
  call g:assert.equals(getline(2),   '    [',       'failed at #439')
  call g:assert.equals(getline(3),   '        foo', 'failed at #439')
  call g:assert.equals(getline(4),   '    ]',       'failed at #439')
  call g:assert.equals(getline(5),   '    }',       'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #439')
  call g:assert.equals(&l:autoindent,  1,           'failed at #439')
  call g:assert.equals(&l:smartindent, 1,           'failed at #439')
  call g:assert.equals(&l:cindent,     1,           'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #439')

  %delete

  " #440
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',              'failed at #440')
  call g:assert.equals(getline(2),   '    [',          'failed at #440')
  call g:assert.equals(getline(3),   '        foo',    'failed at #440')
  call g:assert.equals(getline(4),   '    ]',          'failed at #440')
  call g:assert.equals(getline(5),   '    }',          'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #440')
  call g:assert.equals(&l:autoindent,  1,              'failed at #440')
  call g:assert.equals(&l:smartindent, 1,              'failed at #440')
  call g:assert.equals(&l:cindent,     1,              'failed at #440')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #440')
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

  " #441
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
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
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #442
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #442')
  call g:assert.equals(getline(2),   '    foo',    'failed at #442')
  call g:assert.equals(getline(3),   '    }',      'failed at #442')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #442')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #442')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #442')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #442')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #442')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #443
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #443')
  call g:assert.equals(getline(2),   'foo',        'failed at #443')
  call g:assert.equals(getline(3),   '    }',      'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #443')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #443')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #443')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #444
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #444')
  call g:assert.equals(getline(2),   'foo',        'failed at #444')
  call g:assert.equals(getline(3),   '    }',      'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #444')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #444')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #444')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #445
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',     'failed at #445')
  call g:assert.equals(getline(2),   '    foo',       'failed at #445')
  call g:assert.equals(getline(3),   '            }', 'failed at #445')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #445')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #445')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #445')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #445')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #445')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #446
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #446')
  call g:assert.equals(getline(2),   'foo',        'failed at #446')
  call g:assert.equals(getline(3),   '    }',      'failed at #446')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #446')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #446')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #446')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #446')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #446')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #611
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #611')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #611')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #611')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #611')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #611')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #611')

  %delete

  " #612
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #612')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #612')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #612')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #612')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #612')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #612')

  %delete

  " #613
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #613')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #613')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #613')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #613')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #613')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #613')

  %delete

  " #614
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #614')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #614')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #614')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #614')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #614')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #614')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #615
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #615')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #615')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #615')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #615')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #615')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #615')

  " #616
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #616')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #616')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #616')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #616')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #616')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #616')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #617
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #617')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #617')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #617')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #617')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #617')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #617')

  %delete

  " #618
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #618')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #618')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #618')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #618')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #618')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #618')

  %delete

  " #619
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #619')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #619')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #619')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #619')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #619')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #619')

  %delete

  " #620
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #620')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #620')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #620')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #620')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #620')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #620')

  %delete

  " #621
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #621')
  call g:assert.equals(getline(2),   'barbar',     'failed at #621')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #621')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #621')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #621')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #621')

  %delete

  " #622
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #622')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #622')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #622')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #622')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #622')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #622')

  %delete

  " #623
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #623')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #623')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #623')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #623')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #623')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #623')

  %delete

  " #624
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #624')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #624')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #624')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #624')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #624')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #624')

  %delete

  " #625
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #625')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #625')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #625')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #625')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #625')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #625')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #626
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #626')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #626')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #626')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #626')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #626')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #626')

  %delete

  " #627
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #627')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #627')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #627')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #627')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #627')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #627')

  %delete

  " #628
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #628')
  call g:assert.equals(getline(2),   '',           'failed at #628')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #628')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #628')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #628')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #628')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #629
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #629')
  call g:assert.equals(getline(2),   '[b]',        'failed at #629')
  call g:assert.equals(getline(3),   '[c]',        'failed at #629')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #629')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #629')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #629')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #630
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #630')
  call g:assert.equals(getline(2),   '[]',         'failed at #630')
  call g:assert.equals(getline(3),   '[]',         'failed at #630')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #630')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #630')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #630')

  %delete

  " #631
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #631')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #631')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #631')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #631')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #631')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #631')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #632
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #632')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #632')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #632')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #632')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #632')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #632')

  %delete

  " #633
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #633')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #633')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #633')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #633')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #633')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #633')

  %delete

  " #634
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #634')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #634')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #634')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #634')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #634')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #634')

  %delete

  " #635
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #635')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #635')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #635')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #635')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #635')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #635')

  %delete

  " #636
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #636')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #636')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #636')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #636')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #636')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #636')
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

  " #637
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #637')
  call g:assert.equals(getline(2), '"bar"', 'failed at #637')
  call g:assert.equals(getline(3), '"baz"', 'failed at #637')

  %delete

  " #638
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #638')
  call g:assert.equals(getline(2), '"bar"', 'failed at #638')
  call g:assert.equals(getline(3), '"baz"', 'failed at #638')

  %delete

  " #639
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #639')
  call g:assert.equals(getline(2), '"bar"', 'failed at #639')
  call g:assert.equals(getline(3), '"baz"', 'failed at #639')

  %delete

  " #640
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #640')
  call g:assert.equals(getline(2), '"bar"', 'failed at #640')
  call g:assert.equals(getline(3), '"baz"', 'failed at #640')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #641
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #641')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #641')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #641')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #641')

  " #642
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #642')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #642')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #642')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #642')

  %delete

  """ keep
  " #643
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #643')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #643')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #643')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #643')

  " #644
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #644')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #644')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #644')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #644')

  %delete

  """ inner_tail
  " #645
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #645')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #645')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #645')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #645')

  " #646
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #646')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #646')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #646')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #646')

  %delete

  """ head
  " #647
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #647')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #647')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #647')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #647')

  " #648
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #648')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #648')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #648')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #648')

  %delete

  """ tail
  " #649
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #649')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #649')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #649')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #649')

  " #650
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #650')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #650')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #650')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #650')

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
  " #651
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #651')
  call g:assert.equals(getline(2), '"bar"', 'failed at #651')
  call g:assert.equals(getline(3), '"baz"', 'failed at #651')

  %delete

  " #652
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #652')
  call g:assert.equals(getline(2), '(bar)', 'failed at #652')
  call g:assert.equals(getline(3), '(baz)', 'failed at #652')

  %delete

  """ off
  " #653
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #653')
  call g:assert.equals(getline(2), '{bar}', 'failed at #653')
  call g:assert.equals(getline(3), '{baz}', 'failed at #653')

  %delete

  " #654
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #654')
  call g:assert.equals(getline(2), '"bar"', 'failed at #654')
  call g:assert.equals(getline(3), '"baz"', 'failed at #654')

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
  " #655
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #655')
  call g:assert.equals(getline(2), '"bar"', 'failed at #655')
  call g:assert.equals(getline(3), '"baz"', 'failed at #655')

  %delete

  " #656
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #656')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #656')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #656')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #657
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #657')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #657')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #657')

  %delete

  " #658
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #658')
  call g:assert.equals(getline(2), '"bar"', 'failed at #658')
  call g:assert.equals(getline(3), '"baz"', 'failed at #658')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #659
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #659')
  call g:assert.equals(getline(2), '(bar)', 'failed at #659')
  call g:assert.equals(getline(3), '(baz)', 'failed at #659')

  %delete

  " #660
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #660')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #660')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #660')

  %delete

  " #661
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #661')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #661')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #661')

  %delete

  " #662
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #662')
  call g:assert.equals(getline(2), '("bar")', 'failed at #662')
  call g:assert.equals(getline(3), '("baz")', 'failed at #662')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #663
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #663')
  call g:assert.equals(getline(2), '(bar)', 'failed at #663')
  call g:assert.equals(getline(3), '(baz)', 'failed at #663')

  %delete

  " #664
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #664')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #664')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #664')

  %delete

  " #665
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #665')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #665')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #665')

  %delete

  " #666
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #666')
  call g:assert.equals(getline(2), '("bar")', 'failed at #666')
  call g:assert.equals(getline(3), '("baz")', 'failed at #666')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #667
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #667')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #667')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #667')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #668
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #668')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #668')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #668')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #669
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '""', 'failed at #669')
  call g:assert.equals(getline(2), '""', 'failed at #669')
  call g:assert.equals(getline(3), '""', 'failed at #669')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #669
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #669')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #669')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #669')

  %delete

  """ on
  " #670
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #670')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #670')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #670')

  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #671
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #671')

  %delete

  """ 1
  " #672
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #672')

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

  " #416
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #416')
  call g:assert.equals(getline(2),   '[',          'failed at #416')
  call g:assert.equals(getline(3),   'foo',        'failed at #416')
  call g:assert.equals(getline(4),   ']',          'failed at #416')
  call g:assert.equals(getline(5),   '}',          'failed at #416')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #416')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #416')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #416')
  call g:assert.equals(&l:autoindent,  0,          'failed at #416')
  call g:assert.equals(&l:smartindent, 0,          'failed at #416')
  call g:assert.equals(&l:cindent,     0,          'failed at #416')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #416')

  %delete

  " #417
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #417')
  call g:assert.equals(getline(2),   '    [',      'failed at #417')
  call g:assert.equals(getline(3),   '    foo',    'failed at #417')
  call g:assert.equals(getline(4),   '    ]',      'failed at #417')
  call g:assert.equals(getline(5),   '    }',      'failed at #417')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #417')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #417')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #417')
  call g:assert.equals(&l:autoindent,  1,          'failed at #417')
  call g:assert.equals(&l:smartindent, 0,          'failed at #417')
  call g:assert.equals(&l:cindent,     0,          'failed at #417')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #417')

  %delete

  " #418
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #418')
  call g:assert.equals(getline(2),   '        [',   'failed at #418')
  call g:assert.equals(getline(3),   '        foo', 'failed at #418')
  call g:assert.equals(getline(4),   '    ]',       'failed at #418')
  call g:assert.equals(getline(5),   '}',           'failed at #418')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #418')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #418')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #418')
  call g:assert.equals(&l:autoindent,  1,           'failed at #418')
  call g:assert.equals(&l:smartindent, 1,           'failed at #418')
  call g:assert.equals(&l:cindent,     0,           'failed at #418')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #418')

  %delete

  " #419
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #419')
  call g:assert.equals(getline(2),   '    [',       'failed at #419')
  call g:assert.equals(getline(3),   '        foo', 'failed at #419')
  call g:assert.equals(getline(4),   '    ]',       'failed at #419')
  call g:assert.equals(getline(5),   '    }',       'failed at #419')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #419')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #419')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #419')
  call g:assert.equals(&l:autoindent,  1,           'failed at #419')
  call g:assert.equals(&l:smartindent, 1,           'failed at #419')
  call g:assert.equals(&l:cindent,     1,           'failed at #419')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #419')

  %delete

  " #420
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',           'failed at #420')
  call g:assert.equals(getline(2),   '            [',       'failed at #420')
  call g:assert.equals(getline(3),   '                foo', 'failed at #420')
  call g:assert.equals(getline(4),   '        ]',           'failed at #420')
  call g:assert.equals(getline(5),   '                }',   'failed at #420')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #420')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #420')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #420')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #420')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #420')
  call g:assert.equals(&l:cindent,     1,                   'failed at #420')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #420')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #421
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #421')
  call g:assert.equals(getline(2),   '[',          'failed at #421')
  call g:assert.equals(getline(3),   'foo',        'failed at #421')
  call g:assert.equals(getline(4),   ']',          'failed at #421')
  call g:assert.equals(getline(5),   '}',          'failed at #421')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #421')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #421')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #421')
  call g:assert.equals(&l:autoindent,  0,          'failed at #421')
  call g:assert.equals(&l:smartindent, 0,          'failed at #421')
  call g:assert.equals(&l:cindent,     0,          'failed at #421')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #421')

  %delete

  " #422
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #422')
  call g:assert.equals(getline(2),   '[',          'failed at #422')
  call g:assert.equals(getline(3),   'foo',        'failed at #422')
  call g:assert.equals(getline(4),   ']',          'failed at #422')
  call g:assert.equals(getline(5),   '}',          'failed at #422')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #422')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #422')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #422')
  call g:assert.equals(&l:autoindent,  1,          'failed at #422')
  call g:assert.equals(&l:smartindent, 0,          'failed at #422')
  call g:assert.equals(&l:cindent,     0,          'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #422')

  %delete

  " #423
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #423')
  call g:assert.equals(getline(2),   '[',          'failed at #423')
  call g:assert.equals(getline(3),   'foo',        'failed at #423')
  call g:assert.equals(getline(4),   ']',          'failed at #423')
  call g:assert.equals(getline(5),   '}',          'failed at #423')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #423')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #423')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #423')
  call g:assert.equals(&l:autoindent,  1,          'failed at #423')
  call g:assert.equals(&l:smartindent, 1,          'failed at #423')
  call g:assert.equals(&l:cindent,     0,          'failed at #423')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #423')

  %delete

  " #424
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #424')
  call g:assert.equals(getline(2),   '[',          'failed at #424')
  call g:assert.equals(getline(3),   'foo',        'failed at #424')
  call g:assert.equals(getline(4),   ']',          'failed at #424')
  call g:assert.equals(getline(5),   '}',          'failed at #424')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #424')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #424')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #424')
  call g:assert.equals(&l:autoindent,  1,          'failed at #424')
  call g:assert.equals(&l:smartindent, 1,          'failed at #424')
  call g:assert.equals(&l:cindent,     1,          'failed at #424')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #424')

  %delete

  " #425
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #425')
  call g:assert.equals(getline(2),   '[',              'failed at #425')
  call g:assert.equals(getline(3),   'foo',            'failed at #425')
  call g:assert.equals(getline(4),   ']',              'failed at #425')
  call g:assert.equals(getline(5),   '}',              'failed at #425')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #425')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #425')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #425')
  call g:assert.equals(&l:autoindent,  1,              'failed at #425')
  call g:assert.equals(&l:smartindent, 1,              'failed at #425')
  call g:assert.equals(&l:cindent,     1,              'failed at #425')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #425')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #426
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #426')
  call g:assert.equals(getline(2),   '    [',      'failed at #426')
  call g:assert.equals(getline(3),   '    foo',    'failed at #426')
  call g:assert.equals(getline(4),   '    ]',      'failed at #426')
  call g:assert.equals(getline(5),   '    }',      'failed at #426')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #426')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #426')
  call g:assert.equals(&l:autoindent,  0,          'failed at #426')
  call g:assert.equals(&l:smartindent, 0,          'failed at #426')
  call g:assert.equals(&l:cindent,     0,          'failed at #426')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #426')

  %delete

  " #427
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #427')
  call g:assert.equals(getline(2),   '    [',      'failed at #427')
  call g:assert.equals(getline(3),   '    foo',    'failed at #427')
  call g:assert.equals(getline(4),   '    ]',      'failed at #427')
  call g:assert.equals(getline(5),   '    }',      'failed at #427')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #427')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #427')
  call g:assert.equals(&l:autoindent,  1,          'failed at #427')
  call g:assert.equals(&l:smartindent, 0,          'failed at #427')
  call g:assert.equals(&l:cindent,     0,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #428')
  call g:assert.equals(getline(2),   '    [',      'failed at #428')
  call g:assert.equals(getline(3),   '    foo',    'failed at #428')
  call g:assert.equals(getline(4),   '    ]',      'failed at #428')
  call g:assert.equals(getline(5),   '    }',      'failed at #428')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #428')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #428')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #428')
  call g:assert.equals(&l:autoindent,  1,          'failed at #428')
  call g:assert.equals(&l:smartindent, 1,          'failed at #428')
  call g:assert.equals(&l:cindent,     0,          'failed at #428')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #428')

  %delete

  " #429
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #429')
  call g:assert.equals(getline(2),   '    [',      'failed at #429')
  call g:assert.equals(getline(3),   '    foo',    'failed at #429')
  call g:assert.equals(getline(4),   '    ]',      'failed at #429')
  call g:assert.equals(getline(5),   '    }',      'failed at #429')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #429')
  call g:assert.equals(&l:autoindent,  1,          'failed at #429')
  call g:assert.equals(&l:smartindent, 1,          'failed at #429')
  call g:assert.equals(&l:cindent,     1,          'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #429')

  %delete

  " #430
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #430')
  call g:assert.equals(getline(2),   '    [',          'failed at #430')
  call g:assert.equals(getline(3),   '    foo',        'failed at #430')
  call g:assert.equals(getline(4),   '    ]',          'failed at #430')
  call g:assert.equals(getline(5),   '    }',          'failed at #430')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #430')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #430')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #430')
  call g:assert.equals(&l:autoindent,  1,              'failed at #430')
  call g:assert.equals(&l:smartindent, 1,              'failed at #430')
  call g:assert.equals(&l:cindent,     1,              'failed at #430')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #430')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #431
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #431')
  call g:assert.equals(getline(2),   '        [',   'failed at #431')
  call g:assert.equals(getline(3),   '        foo', 'failed at #431')
  call g:assert.equals(getline(4),   '    ]',       'failed at #431')
  call g:assert.equals(getline(5),   '}',           'failed at #431')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #431')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #431')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #431')
  call g:assert.equals(&l:autoindent,  0,           'failed at #431')
  call g:assert.equals(&l:smartindent, 0,           'failed at #431')
  call g:assert.equals(&l:cindent,     0,           'failed at #431')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #431')

  %delete

  " #432
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #432')
  call g:assert.equals(getline(2),   '        [',   'failed at #432')
  call g:assert.equals(getline(3),   '        foo', 'failed at #432')
  call g:assert.equals(getline(4),   '    ]',       'failed at #432')
  call g:assert.equals(getline(5),   '}',           'failed at #432')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #432')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #432')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #432')
  call g:assert.equals(&l:autoindent,  1,           'failed at #432')
  call g:assert.equals(&l:smartindent, 0,           'failed at #432')
  call g:assert.equals(&l:cindent,     0,           'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #432')

  %delete

  " #433
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #433')
  call g:assert.equals(getline(2),   '        [',   'failed at #433')
  call g:assert.equals(getline(3),   '        foo', 'failed at #433')
  call g:assert.equals(getline(4),   '    ]',       'failed at #433')
  call g:assert.equals(getline(5),   '}',           'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #433')
  call g:assert.equals(&l:autoindent,  1,           'failed at #433')
  call g:assert.equals(&l:smartindent, 1,           'failed at #433')
  call g:assert.equals(&l:cindent,     0,           'failed at #433')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #433')

  %delete

  " #434
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #434')
  call g:assert.equals(getline(2),   '        [',   'failed at #434')
  call g:assert.equals(getline(3),   '        foo', 'failed at #434')
  call g:assert.equals(getline(4),   '    ]',       'failed at #434')
  call g:assert.equals(getline(5),   '}',           'failed at #434')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #434')
  call g:assert.equals(&l:autoindent,  1,           'failed at #434')
  call g:assert.equals(&l:smartindent, 1,           'failed at #434')
  call g:assert.equals(&l:cindent,     1,           'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #434')

  %delete

  " #435
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #435')
  call g:assert.equals(getline(2),   '        [',      'failed at #435')
  call g:assert.equals(getline(3),   '        foo',    'failed at #435')
  call g:assert.equals(getline(4),   '    ]',          'failed at #435')
  call g:assert.equals(getline(5),   '}',              'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #435')
  call g:assert.equals(&l:autoindent,  1,              'failed at #435')
  call g:assert.equals(&l:smartindent, 1,              'failed at #435')
  call g:assert.equals(&l:cindent,     1,              'failed at #435')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #435')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #436
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '        foo', 'failed at #436')
  call g:assert.equals(getline(4),   '    ]',       'failed at #436')
  call g:assert.equals(getline(5),   '    }',       'failed at #436')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #436')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #436')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #436')
  call g:assert.equals(&l:autoindent,  0,           'failed at #436')
  call g:assert.equals(&l:smartindent, 0,           'failed at #436')
  call g:assert.equals(&l:cindent,     0,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #437')
  call g:assert.equals(getline(2),   '    [',       'failed at #437')
  call g:assert.equals(getline(3),   '        foo', 'failed at #437')
  call g:assert.equals(getline(4),   '    ]',       'failed at #437')
  call g:assert.equals(getline(5),   '    }',       'failed at #437')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #437')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #437')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #437')
  call g:assert.equals(&l:autoindent,  1,           'failed at #437')
  call g:assert.equals(&l:smartindent, 0,           'failed at #437')
  call g:assert.equals(&l:cindent,     0,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #438')
  call g:assert.equals(getline(2),   '    [',       'failed at #438')
  call g:assert.equals(getline(3),   '        foo', 'failed at #438')
  call g:assert.equals(getline(4),   '    ]',       'failed at #438')
  call g:assert.equals(getline(5),   '    }',       'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #438')
  call g:assert.equals(&l:autoindent,  1,           'failed at #438')
  call g:assert.equals(&l:smartindent, 1,           'failed at #438')
  call g:assert.equals(&l:cindent,     0,           'failed at #438')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #438')

  %delete

  " #439
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #439')
  call g:assert.equals(getline(2),   '    [',       'failed at #439')
  call g:assert.equals(getline(3),   '        foo', 'failed at #439')
  call g:assert.equals(getline(4),   '    ]',       'failed at #439')
  call g:assert.equals(getline(5),   '    }',       'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #439')
  call g:assert.equals(&l:autoindent,  1,           'failed at #439')
  call g:assert.equals(&l:smartindent, 1,           'failed at #439')
  call g:assert.equals(&l:cindent,     1,           'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #439')

  %delete

  " #440
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',              'failed at #440')
  call g:assert.equals(getline(2),   '    [',          'failed at #440')
  call g:assert.equals(getline(3),   '        foo',    'failed at #440')
  call g:assert.equals(getline(4),   '    ]',          'failed at #440')
  call g:assert.equals(getline(5),   '    }',          'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #440')
  call g:assert.equals(&l:autoindent,  1,              'failed at #440')
  call g:assert.equals(&l:smartindent, 1,              'failed at #440')
  call g:assert.equals(&l:cindent,     1,              'failed at #440')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #440')
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

  " #441
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
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
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #442
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #442')
  call g:assert.equals(getline(2),   '    foo',    'failed at #442')
  call g:assert.equals(getline(3),   '    }',      'failed at #442')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #442')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #442')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #442')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #442')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #442')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #443
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #443')
  call g:assert.equals(getline(2),   'foo',        'failed at #443')
  call g:assert.equals(getline(3),   '    }',      'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #443')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #443')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #443')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #444
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #444')
  call g:assert.equals(getline(2),   'foo',        'failed at #444')
  call g:assert.equals(getline(3),   '    }',      'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #444')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #444')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #444')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #445
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',     'failed at #445')
  call g:assert.equals(getline(2),   '    foo',       'failed at #445')
  call g:assert.equals(getline(3),   '            }', 'failed at #445')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #445')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #445')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #445')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #445')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #445')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #446
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #446')
  call g:assert.equals(getline(2),   'foo',        'failed at #446')
  call g:assert.equals(getline(3),   '    }',      'failed at #446')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #446')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #446')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #446')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #446')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #446')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #673
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #673')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #673')

  " #674
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #674')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #674')

  " #675
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #675')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #675')

  " #676
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #676')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #676')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
