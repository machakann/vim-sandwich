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
  """ 1
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

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
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
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #200')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #201
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #201')

  " #202
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #202')

  " #203
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #203')

  " #204
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #204')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #205
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #205')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #206
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #206')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #207
  call setline('.', '(foo)')
  normal 0sra("
  call g:assert.equals(getline('.'), '""', 'failed at #207')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #208
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #208')
  call g:assert.equals(getline(2),   'foo',        'failed at #208')
  call g:assert.equals(getline(3),   ']',          'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #208')

  %delete

  " #209
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #209')
  call g:assert.equals(getline(2),   'foo',        'failed at #209')
  call g:assert.equals(getline(3),   ']',          'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #209')

  %delete

  " #210
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #210')
  call g:assert.equals(getline(2),   'foo',        'failed at #210')
  call g:assert.equals(getline(3),   'aa]',        'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #210')

  %delete

  " #211
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #211')
  call g:assert.equals(getline(2),   'foo',        'failed at #211')
  call g:assert.equals(getline(3),   ']',          'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #211')

  %delete

  " #212
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #212')
  call g:assert.equals(getline(2),   'foo',        'failed at #212')
  call g:assert.equals(getline(3),   'aa]',        'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #212')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #213
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #213')
  call g:assert.equals(getline(2),   'foo',        'failed at #213')
  call g:assert.equals(getline(3),   ']',          'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #213')

  %delete

  " #214
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #214')
  call g:assert.equals(getline(2),   'foo',        'failed at #214')
  call g:assert.equals(getline(3),   ']',          'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #214')

  %delete

  " #215
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #215')
  call g:assert.equals(getline(2),   'foo',        'failed at #215')
  call g:assert.equals(getline(3),   ']',          'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #215')

  %delete

  " #216
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #216')
  call g:assert.equals(getline(2),   '[',          'failed at #216')
  call g:assert.equals(getline(3),   'bb',         'failed at #216')
  call g:assert.equals(getline(4),   '',           'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #216')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #217
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #217')

  %delete

  """ on
  " #218
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #218')

  call operator#sandwich#set('replace', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #219
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #219')

  """ 1
  " #220
  call operator#sandwich#set('replace', 'char', 'expr', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3',  'failed at #220')

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

  " #221
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #221')
  call g:assert.equals(getline(2),   '[',          'failed at #221')
  call g:assert.equals(getline(3),   'foo',        'failed at #221')
  call g:assert.equals(getline(4),   ']',          'failed at #221')
  call g:assert.equals(getline(5),   '}',          'failed at #221')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #221')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #221')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #221')
  call g:assert.equals(&l:autoindent,  0,          'failed at #221')
  call g:assert.equals(&l:smartindent, 0,          'failed at #221')
  call g:assert.equals(&l:cindent,     0,          'failed at #221')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #221')

  %delete

  " #222
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #222')
  call g:assert.equals(getline(2),   '    [',      'failed at #222')
  call g:assert.equals(getline(3),   '    foo',    'failed at #222')
  call g:assert.equals(getline(4),   '    ]',      'failed at #222')
  call g:assert.equals(getline(5),   '    }',      'failed at #222')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #222')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #222')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #222')
  call g:assert.equals(&l:autoindent,  1,          'failed at #222')
  call g:assert.equals(&l:smartindent, 0,          'failed at #222')
  call g:assert.equals(&l:cindent,     0,          'failed at #222')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #222')

  %delete

  " #223
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #223')
  call g:assert.equals(getline(2),   '        [',   'failed at #223')
  call g:assert.equals(getline(3),   '        foo', 'failed at #223')
  call g:assert.equals(getline(4),   '    ]',       'failed at #223')
  call g:assert.equals(getline(5),   '}',           'failed at #223')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #223')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #223')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #223')
  call g:assert.equals(&l:autoindent,  1,           'failed at #223')
  call g:assert.equals(&l:smartindent, 1,           'failed at #223')
  call g:assert.equals(&l:cindent,     0,           'failed at #223')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #223')

  %delete

  " #224
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #224')
  call g:assert.equals(getline(2),   '    [',       'failed at #224')
  call g:assert.equals(getline(3),   '        foo', 'failed at #224')
  call g:assert.equals(getline(4),   '    ]',       'failed at #224')
  call g:assert.equals(getline(5),   '    }',       'failed at #224')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #224')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #224')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #224')
  call g:assert.equals(&l:autoindent,  1,           'failed at #224')
  call g:assert.equals(&l:smartindent, 1,           'failed at #224')
  call g:assert.equals(&l:cindent,     1,           'failed at #224')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #224')

  %delete

  " #225
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',           'failed at #225')
  call g:assert.equals(getline(2),   '            [',       'failed at #225')
  call g:assert.equals(getline(3),   '                foo', 'failed at #225')
  call g:assert.equals(getline(4),   '        ]',           'failed at #225')
  call g:assert.equals(getline(5),   '                }',   'failed at #225')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #225')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #225')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #225')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #225')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #225')
  call g:assert.equals(&l:cindent,     1,                   'failed at #225')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #225')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #226
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #226')
  call g:assert.equals(getline(2),   '[',          'failed at #226')
  call g:assert.equals(getline(3),   'foo',        'failed at #226')
  call g:assert.equals(getline(4),   ']',          'failed at #226')
  call g:assert.equals(getline(5),   '}',          'failed at #226')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #226')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #226')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #226')
  call g:assert.equals(&l:autoindent,  0,          'failed at #226')
  call g:assert.equals(&l:smartindent, 0,          'failed at #226')
  call g:assert.equals(&l:cindent,     0,          'failed at #226')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #226')

  %delete

  " #227
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #227')
  call g:assert.equals(getline(2),   '[',          'failed at #227')
  call g:assert.equals(getline(3),   'foo',        'failed at #227')
  call g:assert.equals(getline(4),   ']',          'failed at #227')
  call g:assert.equals(getline(5),   '}',          'failed at #227')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #227')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #227')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #227')
  call g:assert.equals(&l:autoindent,  1,          'failed at #227')
  call g:assert.equals(&l:smartindent, 0,          'failed at #227')
  call g:assert.equals(&l:cindent,     0,          'failed at #227')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #227')

  %delete

  " #228
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #228')
  call g:assert.equals(getline(2),   '[',          'failed at #228')
  call g:assert.equals(getline(3),   'foo',        'failed at #228')
  call g:assert.equals(getline(4),   ']',          'failed at #228')
  call g:assert.equals(getline(5),   '}',          'failed at #228')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #228')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #228')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #228')
  call g:assert.equals(&l:autoindent,  1,          'failed at #228')
  call g:assert.equals(&l:smartindent, 1,          'failed at #228')
  call g:assert.equals(&l:cindent,     0,          'failed at #228')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #228')

  %delete

  " #229
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #229')
  call g:assert.equals(getline(2),   '[',          'failed at #229')
  call g:assert.equals(getline(3),   'foo',        'failed at #229')
  call g:assert.equals(getline(4),   ']',          'failed at #229')
  call g:assert.equals(getline(5),   '}',          'failed at #229')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #229')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #229')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #229')
  call g:assert.equals(&l:autoindent,  1,          'failed at #229')
  call g:assert.equals(&l:smartindent, 1,          'failed at #229')
  call g:assert.equals(&l:cindent,     1,          'failed at #229')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #229')

  %delete

  " #230
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #230')
  call g:assert.equals(getline(2),   '[',              'failed at #230')
  call g:assert.equals(getline(3),   'foo',            'failed at #230')
  call g:assert.equals(getline(4),   ']',              'failed at #230')
  call g:assert.equals(getline(5),   '}',              'failed at #230')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #230')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #230')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #230')
  call g:assert.equals(&l:autoindent,  1,              'failed at #230')
  call g:assert.equals(&l:smartindent, 1,              'failed at #230')
  call g:assert.equals(&l:cindent,     1,              'failed at #230')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #230')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #231
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #231')
  call g:assert.equals(getline(2),   '    [',      'failed at #231')
  call g:assert.equals(getline(3),   '    foo',    'failed at #231')
  call g:assert.equals(getline(4),   '    ]',      'failed at #231')
  call g:assert.equals(getline(5),   '    }',      'failed at #231')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #231')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #231')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #231')
  call g:assert.equals(&l:autoindent,  0,          'failed at #231')
  call g:assert.equals(&l:smartindent, 0,          'failed at #231')
  call g:assert.equals(&l:cindent,     0,          'failed at #231')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #231')

  %delete

  " #232
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #232')
  call g:assert.equals(getline(2),   '    [',      'failed at #232')
  call g:assert.equals(getline(3),   '    foo',    'failed at #232')
  call g:assert.equals(getline(4),   '    ]',      'failed at #232')
  call g:assert.equals(getline(5),   '    }',      'failed at #232')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #232')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #232')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #232')
  call g:assert.equals(&l:autoindent,  1,          'failed at #232')
  call g:assert.equals(&l:smartindent, 0,          'failed at #232')
  call g:assert.equals(&l:cindent,     0,          'failed at #232')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #232')

  %delete

  " #233
  setlocal smartindent
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
  call g:assert.equals(&l:smartindent, 1,          'failed at #233')
  call g:assert.equals(&l:cindent,     0,          'failed at #233')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #233')

  %delete

  " #234
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',      'failed at #234')
  call g:assert.equals(getline(2),   '    [',      'failed at #234')
  call g:assert.equals(getline(3),   '    foo',    'failed at #234')
  call g:assert.equals(getline(4),   '    ]',      'failed at #234')
  call g:assert.equals(getline(5),   '    }',      'failed at #234')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #234')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #234')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #234')
  call g:assert.equals(&l:autoindent,  1,          'failed at #234')
  call g:assert.equals(&l:smartindent, 1,          'failed at #234')
  call g:assert.equals(&l:cindent,     1,          'failed at #234')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #234')

  %delete

  " #235
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #235')
  call g:assert.equals(getline(2),   '    [',          'failed at #235')
  call g:assert.equals(getline(3),   '    foo',        'failed at #235')
  call g:assert.equals(getline(4),   '    ]',          'failed at #235')
  call g:assert.equals(getline(5),   '    }',          'failed at #235')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #235')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #235')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #235')
  call g:assert.equals(&l:autoindent,  1,              'failed at #235')
  call g:assert.equals(&l:smartindent, 1,              'failed at #235')
  call g:assert.equals(&l:cindent,     1,              'failed at #235')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #235')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #236
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #236')
  call g:assert.equals(getline(2),   '        [',   'failed at #236')
  call g:assert.equals(getline(3),   '        foo', 'failed at #236')
  call g:assert.equals(getline(4),   '    ]',       'failed at #236')
  call g:assert.equals(getline(5),   '}',           'failed at #236')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #236')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #236')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #236')
  call g:assert.equals(&l:autoindent,  0,           'failed at #236')
  call g:assert.equals(&l:smartindent, 0,           'failed at #236')
  call g:assert.equals(&l:cindent,     0,           'failed at #236')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #236')

  %delete

  " #237
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #237')
  call g:assert.equals(getline(2),   '        [',   'failed at #237')
  call g:assert.equals(getline(3),   '        foo', 'failed at #237')
  call g:assert.equals(getline(4),   '    ]',       'failed at #237')
  call g:assert.equals(getline(5),   '}',           'failed at #237')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #237')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #237')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #237')
  call g:assert.equals(&l:autoindent,  1,           'failed at #237')
  call g:assert.equals(&l:smartindent, 0,           'failed at #237')
  call g:assert.equals(&l:cindent,     0,           'failed at #237')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #237')

  %delete

  " #238
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #238')
  call g:assert.equals(getline(2),   '        [',   'failed at #238')
  call g:assert.equals(getline(3),   '        foo', 'failed at #238')
  call g:assert.equals(getline(4),   '    ]',       'failed at #238')
  call g:assert.equals(getline(5),   '}',           'failed at #238')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #238')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #238')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #238')
  call g:assert.equals(&l:autoindent,  1,           'failed at #238')
  call g:assert.equals(&l:smartindent, 1,           'failed at #238')
  call g:assert.equals(&l:cindent,     0,           'failed at #238')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #238')

  %delete

  " #239
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',       'failed at #239')
  call g:assert.equals(getline(2),   '        [',   'failed at #239')
  call g:assert.equals(getline(3),   '        foo', 'failed at #239')
  call g:assert.equals(getline(4),   '    ]',       'failed at #239')
  call g:assert.equals(getline(5),   '}',           'failed at #239')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #239')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #239')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #239')
  call g:assert.equals(&l:autoindent,  1,           'failed at #239')
  call g:assert.equals(&l:smartindent, 1,           'failed at #239')
  call g:assert.equals(&l:cindent,     1,           'failed at #239')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #239')

  %delete

  " #240
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '    {',          'failed at #240')
  call g:assert.equals(getline(2),   '        [',      'failed at #240')
  call g:assert.equals(getline(3),   '        foo',    'failed at #240')
  call g:assert.equals(getline(4),   '    ]',          'failed at #240')
  call g:assert.equals(getline(5),   '}',              'failed at #240')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #240')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #240')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #240')
  call g:assert.equals(&l:autoindent,  1,              'failed at #240')
  call g:assert.equals(&l:smartindent, 1,              'failed at #240')
  call g:assert.equals(&l:cindent,     1,              'failed at #240')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #240')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #241
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #241')
  call g:assert.equals(getline(2),   '    [',       'failed at #241')
  call g:assert.equals(getline(3),   '        foo', 'failed at #241')
  call g:assert.equals(getline(4),   '    ]',       'failed at #241')
  call g:assert.equals(getline(5),   '    }',       'failed at #241')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #241')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #241')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #241')
  call g:assert.equals(&l:autoindent,  0,           'failed at #241')
  call g:assert.equals(&l:smartindent, 0,           'failed at #241')
  call g:assert.equals(&l:cindent,     0,           'failed at #241')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #241')

  %delete

  " #242
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #242')
  call g:assert.equals(getline(2),   '    [',       'failed at #242')
  call g:assert.equals(getline(3),   '        foo', 'failed at #242')
  call g:assert.equals(getline(4),   '    ]',       'failed at #242')
  call g:assert.equals(getline(5),   '    }',       'failed at #242')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #242')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #242')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #242')
  call g:assert.equals(&l:autoindent,  1,           'failed at #242')
  call g:assert.equals(&l:smartindent, 0,           'failed at #242')
  call g:assert.equals(&l:cindent,     0,           'failed at #242')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #242')

  %delete

  " #243
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #243')
  call g:assert.equals(getline(2),   '    [',       'failed at #243')
  call g:assert.equals(getline(3),   '        foo', 'failed at #243')
  call g:assert.equals(getline(4),   '    ]',       'failed at #243')
  call g:assert.equals(getline(5),   '    }',       'failed at #243')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #243')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #243')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #243')
  call g:assert.equals(&l:autoindent,  1,           'failed at #243')
  call g:assert.equals(&l:smartindent, 1,           'failed at #243')
  call g:assert.equals(&l:cindent,     0,           'failed at #243')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #243')

  %delete

  " #244
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',           'failed at #244')
  call g:assert.equals(getline(2),   '    [',       'failed at #244')
  call g:assert.equals(getline(3),   '        foo', 'failed at #244')
  call g:assert.equals(getline(4),   '    ]',       'failed at #244')
  call g:assert.equals(getline(5),   '    }',       'failed at #244')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #244')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #244')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #244')
  call g:assert.equals(&l:autoindent,  1,           'failed at #244')
  call g:assert.equals(&l:smartindent, 1,           'failed at #244')
  call g:assert.equals(&l:cindent,     1,           'failed at #244')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #244')

  %delete

  " #245
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',              'failed at #245')
  call g:assert.equals(getline(2),   '    [',          'failed at #245')
  call g:assert.equals(getline(3),   '        foo',    'failed at #245')
  call g:assert.equals(getline(4),   '    ]',          'failed at #245')
  call g:assert.equals(getline(5),   '    }',          'failed at #245')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #245')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #245')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #245')
  call g:assert.equals(&l:autoindent,  1,              'failed at #245')
  call g:assert.equals(&l:smartindent, 1,              'failed at #245')
  call g:assert.equals(&l:cindent,     1,              'failed at #245')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #245')
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

  " #246
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #246')
  call g:assert.equals(getline(2),   'foo',        'failed at #246')
  call g:assert.equals(getline(3),   '    }',      'failed at #246')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #246')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #246')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #246')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #246')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #247
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #247')
  call g:assert.equals(getline(2),   '    foo',    'failed at #247')
  call g:assert.equals(getline(3),   '    }',      'failed at #247')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #247')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #247')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #247')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #247')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #248
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '{',          'failed at #248')
  call g:assert.equals(getline(2),   'foo',        'failed at #248')
  call g:assert.equals(getline(3),   '    }',      'failed at #248')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #248')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #248')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #248')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #248')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #249
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #249')
  call g:assert.equals(getline(2),   'foo',        'failed at #249')
  call g:assert.equals(getline(3),   '    }',      'failed at #249')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #249')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #249')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #249')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #249')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #249')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #250
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',     'failed at #250')
  call g:assert.equals(getline(2),   '    foo',       'failed at #250')
  call g:assert.equals(getline(3),   '            }', 'failed at #250')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #250')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #250')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #250')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #250')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #250')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #251
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^sr2i"a
  call g:assert.equals(getline(1),   '        {',  'failed at #251')
  call g:assert.equals(getline(2),   'foo',        'failed at #251')
  call g:assert.equals(getline(3),   '    }',      'failed at #251')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #251')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #251')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #251')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #251')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #251')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #252
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #252')

  " #253
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #253')

  " #254
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #254')

  " #255
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #255')

  " #256
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #256')

  " #257
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #257')

  " #258
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #258')

  " #259
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #259')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #260
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #260')

  " #261
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #261')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #262
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #262')

  " #263
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #263')

  " #264
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #264')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #264')

  " #265
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #265')
  call g:assert.equals(getline(2),   'bar',        'failed at #265')
  call g:assert.equals(getline(3),   'baz]',       'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #265')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #266
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #266')

  %delete

  " #267
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #267')
  call g:assert.equals(getline(2),   'a',          'failed at #267')
  call g:assert.equals(getline(3),   ']',          'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #267')

  %delete

  " #268
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #268')
  call g:assert.equals(getline(2),   ']',          'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #268')

  %delete

  " #269
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #269')
  call g:assert.equals(getline(2),   'a]',         'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #269')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #270
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #270')

  " #271
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #271')

  %delete

  " #272
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #272')
  call g:assert.equals(getline(2),   ']',          'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #272')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #273
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #273')

  " #274
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #274')

  " #275
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #275')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #275')

  " #276
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #276')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #276')

  " #277
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #277')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #277')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #278
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #278')

  %delete

  " #279
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #279')

  %delete

  " #280
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #280')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #280')
  call g:assert.equals(getline(3),   'aa',         'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #280')

  %delete

  " #281
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #281')
  call g:assert.equals(getline(2),   'bbb',        'failed at #281')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #281')
  call g:assert.equals(getline(4),   'bbb',        'failed at #281')
  call g:assert.equals(getline(5),   'bb',         'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #281')
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

  " #282
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #282')

  " #283
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #283')

  " #284
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #284')

  " #285
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #285')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #286
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #286')

  " #287
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #287')

  """ keep
  " #288
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #288')

  " #289
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #289')

  """ inner_tail
  " #290
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #290')

  " #291
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #291')

  """ head
  " #292
  call operator#sandwich#set('replace', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #292')

  " #293
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #293')

  """ tail
  " #294
  call operator#sandwich#set('replace', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #294')

  " #295
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #295')

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
  " #296
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #296')

  " #297
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #297')

  """ off
  " #298
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #298')

  " #299
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #299')

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
  " #300
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #300')

  " #301
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #301')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #302
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #302')

  " #303
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #303')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ 1
  " #304
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #304')

  " #305
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #305')

  " #306
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #306')

  " #307
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #307')

  """ 2
  call operator#sandwich#set('replace', 'char', 'skip_space', 2)
  " #308
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #308')

  " #309
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #309')

  " #310
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #310')

  " #311
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #311')

  """ 0
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #312
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #312')

  " #313
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #313')

  " #314
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #314')

  " #315
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #315')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #316
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #316')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #317
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #317')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #318
  call setline('.', '(foo)')
  normal 0va(sr"
  call g:assert.equals(getline('.'), '""', 'failed at #318')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #319
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #319')
  call g:assert.equals(getline(2),   'foo',        'failed at #319')
  call g:assert.equals(getline(3),   ']',          'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #319')

  %delete

  " #320
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #320')
  call g:assert.equals(getline(2),   'foo',        'failed at #320')
  call g:assert.equals(getline(3),   ']',          'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #320')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #320')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #320')

  %delete

  " #321
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #321')
  call g:assert.equals(getline(2),   'foo',        'failed at #321')
  call g:assert.equals(getline(3),   'aa]',        'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #321')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #321')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #321')

  %delete

  " #322
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #322')
  call g:assert.equals(getline(2),   'foo',        'failed at #322')
  call g:assert.equals(getline(3),   ']',          'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #322')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #322')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #322')

  %delete

  " #323
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #323')
  call g:assert.equals(getline(2),   'foo',        'failed at #323')
  call g:assert.equals(getline(3),   'aa]',        'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #323')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #323')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #323')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #324
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #324')
  call g:assert.equals(getline(2),   'foo',        'failed at #324')
  call g:assert.equals(getline(3),   ']',          'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #324')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #324')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #324')

  %delete

  " #325
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #325')
  call g:assert.equals(getline(2),   'foo',        'failed at #325')
  call g:assert.equals(getline(3),   ']',          'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #325')

  %delete

  " #326
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #326')
  call g:assert.equals(getline(2),   'foo',        'failed at #326')
  call g:assert.equals(getline(3),   ']',          'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #326')

  %delete

  " #327
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #327')
  call g:assert.equals(getline(2),   '[',          'failed at #327')
  call g:assert.equals(getline(3),   'bb',         'failed at #327')
  call g:assert.equals(getline(4),   '',           'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #327')

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

  " #328
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
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
  call g:assert.equals(&l:autoindent,  0,          'failed at #328')
  call g:assert.equals(&l:smartindent, 0,          'failed at #328')
  call g:assert.equals(&l:cindent,     0,          'failed at #328')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #328')

  %delete

  " #329
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #329')
  call g:assert.equals(getline(2),   '    [',      'failed at #329')
  call g:assert.equals(getline(3),   '    foo',    'failed at #329')
  call g:assert.equals(getline(4),   '    ]',      'failed at #329')
  call g:assert.equals(getline(5),   '    }',      'failed at #329')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #329')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #329')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #329')
  call g:assert.equals(&l:autoindent,  1,          'failed at #329')
  call g:assert.equals(&l:smartindent, 0,          'failed at #329')
  call g:assert.equals(&l:cindent,     0,          'failed at #329')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #329')

  %delete

  " #330
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #330')
  call g:assert.equals(getline(2),   '        [',   'failed at #330')
  call g:assert.equals(getline(3),   '        foo', 'failed at #330')
  call g:assert.equals(getline(4),   '    ]',       'failed at #330')
  call g:assert.equals(getline(5),   '}',           'failed at #330')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #330')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #330')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #330')
  call g:assert.equals(&l:autoindent,  1,           'failed at #330')
  call g:assert.equals(&l:smartindent, 1,           'failed at #330')
  call g:assert.equals(&l:cindent,     0,           'failed at #330')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #330')

  %delete

  " #331
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #331')
  call g:assert.equals(getline(2),   '    [',       'failed at #331')
  call g:assert.equals(getline(3),   '        foo', 'failed at #331')
  call g:assert.equals(getline(4),   '    ]',       'failed at #331')
  call g:assert.equals(getline(5),   '    }',       'failed at #331')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #331')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #331')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #331')
  call g:assert.equals(&l:autoindent,  1,           'failed at #331')
  call g:assert.equals(&l:smartindent, 1,           'failed at #331')
  call g:assert.equals(&l:cindent,     1,           'failed at #331')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #331')

  %delete

  " #332
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',           'failed at #332')
  call g:assert.equals(getline(2),   '            [',       'failed at #332')
  call g:assert.equals(getline(3),   '                foo', 'failed at #332')
  call g:assert.equals(getline(4),   '        ]',           'failed at #332')
  call g:assert.equals(getline(5),   '                }',   'failed at #332')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #332')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #332')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #332')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #332')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #332')
  call g:assert.equals(&l:cindent,     1,                   'failed at #332')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #332')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'char', 'autoindent', 0)

  " #333
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #333')
  call g:assert.equals(getline(2),   '[',          'failed at #333')
  call g:assert.equals(getline(3),   'foo',        'failed at #333')
  call g:assert.equals(getline(4),   ']',          'failed at #333')
  call g:assert.equals(getline(5),   '}',          'failed at #333')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #333')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #333')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #333')
  call g:assert.equals(&l:autoindent,  0,          'failed at #333')
  call g:assert.equals(&l:smartindent, 0,          'failed at #333')
  call g:assert.equals(&l:cindent,     0,          'failed at #333')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #333')

  %delete

  " #334
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #334')
  call g:assert.equals(getline(2),   '[',          'failed at #334')
  call g:assert.equals(getline(3),   'foo',        'failed at #334')
  call g:assert.equals(getline(4),   ']',          'failed at #334')
  call g:assert.equals(getline(5),   '}',          'failed at #334')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #334')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #334')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #334')
  call g:assert.equals(&l:autoindent,  1,          'failed at #334')
  call g:assert.equals(&l:smartindent, 0,          'failed at #334')
  call g:assert.equals(&l:cindent,     0,          'failed at #334')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #334')

  %delete

  " #335
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #335')
  call g:assert.equals(getline(2),   '[',          'failed at #335')
  call g:assert.equals(getline(3),   'foo',        'failed at #335')
  call g:assert.equals(getline(4),   ']',          'failed at #335')
  call g:assert.equals(getline(5),   '}',          'failed at #335')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #335')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #335')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #335')
  call g:assert.equals(&l:autoindent,  1,          'failed at #335')
  call g:assert.equals(&l:smartindent, 1,          'failed at #335')
  call g:assert.equals(&l:cindent,     0,          'failed at #335')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #335')

  %delete

  " #336
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #336')
  call g:assert.equals(getline(2),   '[',          'failed at #336')
  call g:assert.equals(getline(3),   'foo',        'failed at #336')
  call g:assert.equals(getline(4),   ']',          'failed at #336')
  call g:assert.equals(getline(5),   '}',          'failed at #336')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #336')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #336')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #336')
  call g:assert.equals(&l:autoindent,  1,          'failed at #336')
  call g:assert.equals(&l:smartindent, 1,          'failed at #336')
  call g:assert.equals(&l:cindent,     1,          'failed at #336')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #336')

  %delete

  " #337
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #337')
  call g:assert.equals(getline(2),   '[',              'failed at #337')
  call g:assert.equals(getline(3),   'foo',            'failed at #337')
  call g:assert.equals(getline(4),   ']',              'failed at #337')
  call g:assert.equals(getline(5),   '}',              'failed at #337')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #337')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #337')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #337')
  call g:assert.equals(&l:autoindent,  1,              'failed at #337')
  call g:assert.equals(&l:smartindent, 1,              'failed at #337')
  call g:assert.equals(&l:cindent,     1,              'failed at #337')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #337')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'char', 'autoindent', 1)

  " #338
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #338')
  call g:assert.equals(getline(2),   '    [',      'failed at #338')
  call g:assert.equals(getline(3),   '    foo',    'failed at #338')
  call g:assert.equals(getline(4),   '    ]',      'failed at #338')
  call g:assert.equals(getline(5),   '    }',      'failed at #338')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #338')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #338')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #338')
  call g:assert.equals(&l:autoindent,  0,          'failed at #338')
  call g:assert.equals(&l:smartindent, 0,          'failed at #338')
  call g:assert.equals(&l:cindent,     0,          'failed at #338')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #338')

  %delete

  " #339
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #339')
  call g:assert.equals(getline(2),   '    [',      'failed at #339')
  call g:assert.equals(getline(3),   '    foo',    'failed at #339')
  call g:assert.equals(getline(4),   '    ]',      'failed at #339')
  call g:assert.equals(getline(5),   '    }',      'failed at #339')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #339')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #339')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #339')
  call g:assert.equals(&l:autoindent,  1,          'failed at #339')
  call g:assert.equals(&l:smartindent, 0,          'failed at #339')
  call g:assert.equals(&l:cindent,     0,          'failed at #339')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #339')

  %delete

  " #340
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #340')
  call g:assert.equals(getline(2),   '    [',      'failed at #340')
  call g:assert.equals(getline(3),   '    foo',    'failed at #340')
  call g:assert.equals(getline(4),   '    ]',      'failed at #340')
  call g:assert.equals(getline(5),   '    }',      'failed at #340')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #340')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #340')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #340')
  call g:assert.equals(&l:autoindent,  1,          'failed at #340')
  call g:assert.equals(&l:smartindent, 1,          'failed at #340')
  call g:assert.equals(&l:cindent,     0,          'failed at #340')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #340')

  %delete

  " #341
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',      'failed at #341')
  call g:assert.equals(getline(2),   '    [',      'failed at #341')
  call g:assert.equals(getline(3),   '    foo',    'failed at #341')
  call g:assert.equals(getline(4),   '    ]',      'failed at #341')
  call g:assert.equals(getline(5),   '    }',      'failed at #341')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #341')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #341')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #341')
  call g:assert.equals(&l:autoindent,  1,          'failed at #341')
  call g:assert.equals(&l:smartindent, 1,          'failed at #341')
  call g:assert.equals(&l:cindent,     1,          'failed at #341')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #341')

  %delete

  " #342
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #342')
  call g:assert.equals(getline(2),   '    [',          'failed at #342')
  call g:assert.equals(getline(3),   '    foo',        'failed at #342')
  call g:assert.equals(getline(4),   '    ]',          'failed at #342')
  call g:assert.equals(getline(5),   '    }',          'failed at #342')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #342')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #342')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #342')
  call g:assert.equals(&l:autoindent,  1,              'failed at #342')
  call g:assert.equals(&l:smartindent, 1,              'failed at #342')
  call g:assert.equals(&l:cindent,     1,              'failed at #342')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #342')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'char', 'autoindent', 2)

  " #343
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #343')
  call g:assert.equals(getline(2),   '        [',   'failed at #343')
  call g:assert.equals(getline(3),   '        foo', 'failed at #343')
  call g:assert.equals(getline(4),   '    ]',       'failed at #343')
  call g:assert.equals(getline(5),   '}',           'failed at #343')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #343')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #343')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #343')
  call g:assert.equals(&l:autoindent,  0,           'failed at #343')
  call g:assert.equals(&l:smartindent, 0,           'failed at #343')
  call g:assert.equals(&l:cindent,     0,           'failed at #343')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #343')

  %delete

  " #344
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #344')
  call g:assert.equals(getline(2),   '        [',   'failed at #344')
  call g:assert.equals(getline(3),   '        foo', 'failed at #344')
  call g:assert.equals(getline(4),   '    ]',       'failed at #344')
  call g:assert.equals(getline(5),   '}',           'failed at #344')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #344')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #344')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #344')
  call g:assert.equals(&l:autoindent,  1,           'failed at #344')
  call g:assert.equals(&l:smartindent, 0,           'failed at #344')
  call g:assert.equals(&l:cindent,     0,           'failed at #344')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #344')

  %delete

  " #345
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #345')
  call g:assert.equals(getline(2),   '        [',   'failed at #345')
  call g:assert.equals(getline(3),   '        foo', 'failed at #345')
  call g:assert.equals(getline(4),   '    ]',       'failed at #345')
  call g:assert.equals(getline(5),   '}',           'failed at #345')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #345')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #345')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #345')
  call g:assert.equals(&l:autoindent,  1,           'failed at #345')
  call g:assert.equals(&l:smartindent, 1,           'failed at #345')
  call g:assert.equals(&l:cindent,     0,           'failed at #345')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #345')

  %delete

  " #346
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',       'failed at #346')
  call g:assert.equals(getline(2),   '        [',   'failed at #346')
  call g:assert.equals(getline(3),   '        foo', 'failed at #346')
  call g:assert.equals(getline(4),   '    ]',       'failed at #346')
  call g:assert.equals(getline(5),   '}',           'failed at #346')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #346')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #346')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #346')
  call g:assert.equals(&l:autoindent,  1,           'failed at #346')
  call g:assert.equals(&l:smartindent, 1,           'failed at #346')
  call g:assert.equals(&l:cindent,     1,           'failed at #346')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #346')

  %delete

  " #347
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '    {',          'failed at #347')
  call g:assert.equals(getline(2),   '        [',      'failed at #347')
  call g:assert.equals(getline(3),   '        foo',    'failed at #347')
  call g:assert.equals(getline(4),   '    ]',          'failed at #347')
  call g:assert.equals(getline(5),   '}',              'failed at #347')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #347')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #347')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #347')
  call g:assert.equals(&l:autoindent,  1,              'failed at #347')
  call g:assert.equals(&l:smartindent, 1,              'failed at #347')
  call g:assert.equals(&l:cindent,     1,              'failed at #347')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #347')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #348
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #348')
  call g:assert.equals(getline(2),   '    [',       'failed at #348')
  call g:assert.equals(getline(3),   '        foo', 'failed at #348')
  call g:assert.equals(getline(4),   '    ]',       'failed at #348')
  call g:assert.equals(getline(5),   '    }',       'failed at #348')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #348')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #348')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #348')
  call g:assert.equals(&l:autoindent,  0,           'failed at #348')
  call g:assert.equals(&l:smartindent, 0,           'failed at #348')
  call g:assert.equals(&l:cindent,     0,           'failed at #348')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #348')

  %delete

  " #349
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #349')
  call g:assert.equals(getline(2),   '    [',       'failed at #349')
  call g:assert.equals(getline(3),   '        foo', 'failed at #349')
  call g:assert.equals(getline(4),   '    ]',       'failed at #349')
  call g:assert.equals(getline(5),   '    }',       'failed at #349')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #349')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #349')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #349')
  call g:assert.equals(&l:autoindent,  1,           'failed at #349')
  call g:assert.equals(&l:smartindent, 0,           'failed at #349')
  call g:assert.equals(&l:cindent,     0,           'failed at #349')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #349')

  %delete

  " #350
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #350')
  call g:assert.equals(getline(2),   '    [',       'failed at #350')
  call g:assert.equals(getline(3),   '        foo', 'failed at #350')
  call g:assert.equals(getline(4),   '    ]',       'failed at #350')
  call g:assert.equals(getline(5),   '    }',       'failed at #350')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #350')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #350')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #350')
  call g:assert.equals(&l:autoindent,  1,           'failed at #350')
  call g:assert.equals(&l:smartindent, 1,           'failed at #350')
  call g:assert.equals(&l:cindent,     0,           'failed at #350')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #350')

  %delete

  " #351
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',           'failed at #351')
  call g:assert.equals(getline(2),   '    [',       'failed at #351')
  call g:assert.equals(getline(3),   '        foo', 'failed at #351')
  call g:assert.equals(getline(4),   '    ]',       'failed at #351')
  call g:assert.equals(getline(5),   '    }',       'failed at #351')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #351')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #351')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #351')
  call g:assert.equals(&l:autoindent,  1,           'failed at #351')
  call g:assert.equals(&l:smartindent, 1,           'failed at #351')
  call g:assert.equals(&l:cindent,     1,           'failed at #351')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #351')

  %delete

  " #352
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',              'failed at #352')
  call g:assert.equals(getline(2),   '    [',          'failed at #352')
  call g:assert.equals(getline(3),   '        foo',    'failed at #352')
  call g:assert.equals(getline(4),   '    ]',          'failed at #352')
  call g:assert.equals(getline(5),   '    }',          'failed at #352')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #352')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #352')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #352')
  call g:assert.equals(&l:autoindent,  1,              'failed at #352')
  call g:assert.equals(&l:smartindent, 1,              'failed at #352')
  call g:assert.equals(&l:cindent,     1,              'failed at #352')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #352')
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

  " #353
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #353')
  call g:assert.equals(getline(2),   'foo',        'failed at #353')
  call g:assert.equals(getline(3),   '    }',      'failed at #353')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #353')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #353')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #353')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #353')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #354
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #354')
  call g:assert.equals(getline(2),   '    foo',    'failed at #354')
  call g:assert.equals(getline(3),   '    }',      'failed at #354')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #354')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #354')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #354')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #354')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', 3)

  " #355
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '{',          'failed at #355')
  call g:assert.equals(getline(2),   'foo',        'failed at #355')
  call g:assert.equals(getline(3),   '    }',      'failed at #355')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #355')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #355')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #355')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #355')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #356
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #356')
  call g:assert.equals(getline(2),   'foo',        'failed at #356')
  call g:assert.equals(getline(3),   '    }',      'failed at #356')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #356')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #356')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #356')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #356')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #356')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #357
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',     'failed at #357')
  call g:assert.equals(getline(2),   '    foo',       'failed at #357')
  call g:assert.equals(getline(3),   '            }', 'failed at #357')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #357')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #357')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #357')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #357')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #357')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'char', 'autoindent', -1)

  " #358
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  normal ^v2i"sra
  call g:assert.equals(getline(1),   '        {',  'failed at #358')
  call g:assert.equals(getline(2),   'foo',        'failed at #358')
  call g:assert.equals(getline(3),   '    }',      'failed at #358')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #358')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #358')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #358')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #358')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #358')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #359
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #359')

  " #360
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #360')

  " #361
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #361')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #361')

  " #362
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #362')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #362')

  %delete

  " #363
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #363')
  call g:assert.equals(getline(2),   'foo',        'failed at #363')
  call g:assert.equals(getline(3),   ']',          'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #363')

  " #364
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #364')
  call g:assert.equals(getline(2),   'foo',        'failed at #364')
  call g:assert.equals(getline(3),   '}',          'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #364')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #364')

  " #365
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #365')
  call g:assert.equals(getline(2),   'foo',        'failed at #365')
  call g:assert.equals(getline(3),   '>',          'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #365')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #365')

  " #366
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #366')
  call g:assert.equals(getline(2),   'foo',        'failed at #366')
  call g:assert.equals(getline(3),   ')',          'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #366')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #367
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #367')

  " #368
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #368')

  %delete

  " #367
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #367')
  call g:assert.equals(getline(2),   'foo',        'failed at #367')
  call g:assert.equals(getline(3),   'b',          'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #367')

  %delete

  " #368
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #368')
  call g:assert.equals(getline(2),   'foo',        'failed at #368')
  call g:assert.equals(getline(3),   '*',          'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #368')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #369
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
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
  normal gg2jsrVa([
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
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #371')
  call g:assert.equals(getline(2),   'bar',        'failed at #371')
  call g:assert.equals(getline(3),   'baz]',       'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #371')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #372
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #372')

  %delete

  " #373
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #373')
  call g:assert.equals(getline(2),   ']',          'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #373')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #374
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #374')

  " #375
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #375')

  %delete

  " #376
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
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
function! s:suite.linewise_n_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #377
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #377')

  %delete

  " #378
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #378')

  %delete

  " #379
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #379')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #379')
  call g:assert.equals(getline(3),   'aa',         'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #379')

  %delete

  " #380
  call setline('.', '(foo)')
  normal srVlb
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
  normal gg2sr8j((
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
  normal gg2sr12j((
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
function! s:suite.linewise_n_external_textobj() abort"{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #383
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #383')

  " #384
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #384')

  " #385
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #385')

  " #386
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #386')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #387
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #387')

  " #388
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #388')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #388')

  """ keep
  " #389
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #389')

  " #390
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #390')

  """ inner_tail
  " #391
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #391')

  " #392
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #392')

  """ head
  " #393
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #393')

  " #394
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #394')

  """ tail
  " #395
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #395')

  " #396
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #396')

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
  " #397
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #397')

  " #398
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #398')

  """ off
  " #399
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #399')

  " #400
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #400')

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
  " #401
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #401')

  " #402
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #402')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #403
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #403')

  " #404
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #404')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #405
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #405')

  " #406
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #406')

  " #407
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #407')

  " #408
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #408')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #409
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #409')

  " #410
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #410')

  " #411
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #411')

  " #412
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #412')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #413
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #413')

  " #414
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #414')

  " #415
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #415')

  " #416
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #416')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #417
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #417')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #418
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #418')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #419
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '""', 'failed at #419')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #420
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #420')
  call g:assert.equals(getline(2),   'foo',        'failed at #420')
  call g:assert.equals(getline(3),   ']',          'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #420')

  %delete

  " #421
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #421')
  call g:assert.equals(getline(2),   'foo',        'failed at #421')
  call g:assert.equals(getline(3),   '  ]',        'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #421')

  %delete

  " #422
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #422')
  call g:assert.equals(getline(2),   'foo',        'failed at #422')
  call g:assert.equals(getline(3),   'aa]',        'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #422')

  %delete

  " #423
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #423')
  call g:assert.equals(getline(2),   'foo',        'failed at #423')
  call g:assert.equals(getline(3),   ']',          'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #423')

  %delete

  " #424
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #424')
  call g:assert.equals(getline(2),   'foo',        'failed at #424')
  call g:assert.equals(getline(3),   'aa]',        'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #424')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #425
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #425')
  call g:assert.equals(getline(2),   'foo',        'failed at #425')
  call g:assert.equals(getline(3),   ']',          'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #425')

  %delete

  " #426
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #426')
  call g:assert.equals(getline(2),   'foo',        'failed at #426')
  call g:assert.equals(getline(3),   ']',          'failed at #426')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #426')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #426')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #426')

  %delete

  " #427
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #427')
  call g:assert.equals(getline(2),   'foo',        'failed at #427')
  call g:assert.equals(getline(3),   ']',          'failed at #427')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #427')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #427')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #427')

  %delete

  " #428
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #428')
  call g:assert.equals(getline(2),   '[',          'failed at #428')
  call g:assert.equals(getline(3),   'bb',         'failed at #428')
  call g:assert.equals(getline(4),   '',           'failed at #428')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #428')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #428')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #428')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #429
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #429')

  %delete

  """ on
  " #430
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #430')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #431
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #431')

  """ 1
  " #432
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3',  'failed at #432')

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

  " #433
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #433')
  call g:assert.equals(getline(2),   '[',          'failed at #433')
  call g:assert.equals(getline(3),   '',           'failed at #433')
  call g:assert.equals(getline(4),   '    foo',    'failed at #433')
  call g:assert.equals(getline(5),   '',           'failed at #433')
  call g:assert.equals(getline(6),   ']',          'failed at #433')
  call g:assert.equals(getline(7),   '}',          'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #433')
  call g:assert.equals(&l:autoindent,  0,          'failed at #433')
  call g:assert.equals(&l:smartindent, 0,          'failed at #433')
  call g:assert.equals(&l:cindent,     0,          'failed at #433')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #433')

  %delete

  " #434
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
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
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #434')
  call g:assert.equals(&l:autoindent,  1,          'failed at #434')
  call g:assert.equals(&l:smartindent, 0,          'failed at #434')
  call g:assert.equals(&l:cindent,     0,          'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #434')

  %delete

  " #435
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #435')
  call g:assert.equals(getline(2),   '    [',       'failed at #435')
  call g:assert.equals(getline(3),   '',            'failed at #435')
  call g:assert.equals(getline(4),   '    foo',     'failed at #435')
  call g:assert.equals(getline(5),   '',            'failed at #435')
  call g:assert.equals(getline(6),   '    ]',       'failed at #435')
  call g:assert.equals(getline(7),   '}',           'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #435')
  call g:assert.equals(&l:autoindent,  1,           'failed at #435')
  call g:assert.equals(&l:smartindent, 1,           'failed at #435')
  call g:assert.equals(&l:cindent,     0,           'failed at #435')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #435')

  %delete

  " #436
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '',            'failed at #436')
  call g:assert.equals(getline(4),   '    foo',     'failed at #436')
  call g:assert.equals(getline(5),   '',            'failed at #436')
  call g:assert.equals(getline(6),   '    ]',       'failed at #436')
  call g:assert.equals(getline(7),   '    }',       'failed at #436')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #436')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #436')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #436')
  call g:assert.equals(&l:autoindent,  1,           'failed at #436')
  call g:assert.equals(&l:smartindent, 1,           'failed at #436')
  call g:assert.equals(&l:cindent,     1,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',            'failed at #437')
  call g:assert.equals(getline(2),   '           [',        'failed at #437')
  call g:assert.equals(getline(3),   '',                    'failed at #437')
  call g:assert.equals(getline(4),   '    foo',             'failed at #437')
  call g:assert.equals(getline(5),   '',                    'failed at #437')
  call g:assert.equals(getline(6),   '        ]',           'failed at #437')
  call g:assert.equals(getline(7),   '                }',   'failed at #437')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #437')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #437')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #437')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #437')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #437')
  call g:assert.equals(&l:cindent,     1,                   'failed at #437')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #437')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #438
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #438')
  call g:assert.equals(getline(2),   '[',          'failed at #438')
  call g:assert.equals(getline(3),   '',           'failed at #438')
  call g:assert.equals(getline(4),   '    foo',    'failed at #438')
  call g:assert.equals(getline(5),   '',           'failed at #438')
  call g:assert.equals(getline(6),   ']',          'failed at #438')
  call g:assert.equals(getline(7),   '}',          'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #438')
  call g:assert.equals(&l:autoindent,  0,          'failed at #438')
  call g:assert.equals(&l:smartindent, 0,          'failed at #438')
  call g:assert.equals(&l:cindent,     0,          'failed at #438')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #438')

  %delete

  " #439
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #439')
  call g:assert.equals(getline(2),   '[',          'failed at #439')
  call g:assert.equals(getline(3),   '',           'failed at #439')
  call g:assert.equals(getline(4),   '    foo',    'failed at #439')
  call g:assert.equals(getline(5),   '',           'failed at #439')
  call g:assert.equals(getline(6),   ']',          'failed at #439')
  call g:assert.equals(getline(7),   '}',          'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #439')
  call g:assert.equals(&l:autoindent,  1,          'failed at #439')
  call g:assert.equals(&l:smartindent, 0,          'failed at #439')
  call g:assert.equals(&l:cindent,     0,          'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #439')

  %delete

  " #440
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #440')
  call g:assert.equals(getline(2),   '[',          'failed at #440')
  call g:assert.equals(getline(3),   '',           'failed at #440')
  call g:assert.equals(getline(4),   '    foo',    'failed at #440')
  call g:assert.equals(getline(5),   '',           'failed at #440')
  call g:assert.equals(getline(6),   ']',          'failed at #440')
  call g:assert.equals(getline(7),   '}',          'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #440')
  call g:assert.equals(&l:autoindent,  1,          'failed at #440')
  call g:assert.equals(&l:smartindent, 1,          'failed at #440')
  call g:assert.equals(&l:cindent,     0,          'failed at #440')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #440')

  %delete

  " #441
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #441')
  call g:assert.equals(getline(2),   '[',          'failed at #441')
  call g:assert.equals(getline(3),   '',           'failed at #441')
  call g:assert.equals(getline(4),   '    foo',    'failed at #441')
  call g:assert.equals(getline(5),   '',           'failed at #441')
  call g:assert.equals(getline(6),   ']',          'failed at #441')
  call g:assert.equals(getline(7),   '}',          'failed at #441')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #441')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #441')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #441')
  call g:assert.equals(&l:autoindent,  1,          'failed at #441')
  call g:assert.equals(&l:smartindent, 1,          'failed at #441')
  call g:assert.equals(&l:cindent,     1,          'failed at #441')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #441')

  %delete

  " #442
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #442')
  call g:assert.equals(getline(2),   '[',              'failed at #442')
  call g:assert.equals(getline(3),   '',               'failed at #442')
  call g:assert.equals(getline(4),   '    foo',        'failed at #442')
  call g:assert.equals(getline(5),   '',               'failed at #442')
  call g:assert.equals(getline(6),   ']',              'failed at #442')
  call g:assert.equals(getline(7),   '}',              'failed at #442')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #442')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #442')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #442')
  call g:assert.equals(&l:autoindent,  1,              'failed at #442')
  call g:assert.equals(&l:smartindent, 1,              'failed at #442')
  call g:assert.equals(&l:cindent,     1,              'failed at #442')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #442')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #443
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #443')
  call g:assert.equals(getline(2),   '    [',      'failed at #443')
  call g:assert.equals(getline(3),   '',           'failed at #443')
  call g:assert.equals(getline(4),   '    foo',    'failed at #443')
  call g:assert.equals(getline(5),   '',           'failed at #443')
  call g:assert.equals(getline(6),   '    ]',      'failed at #443')
  call g:assert.equals(getline(7),   '    }',      'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #443')
  call g:assert.equals(&l:autoindent,  0,          'failed at #443')
  call g:assert.equals(&l:smartindent, 0,          'failed at #443')
  call g:assert.equals(&l:cindent,     0,          'failed at #443')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #443')

  %delete

  " #444
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #444')
  call g:assert.equals(getline(2),   '    [',      'failed at #444')
  call g:assert.equals(getline(3),   '',           'failed at #444')
  call g:assert.equals(getline(4),   '    foo',    'failed at #444')
  call g:assert.equals(getline(5),   '',           'failed at #444')
  call g:assert.equals(getline(6),   '    ]',      'failed at #444')
  call g:assert.equals(getline(7),   '    }',      'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #444')
  call g:assert.equals(&l:autoindent,  1,          'failed at #444')
  call g:assert.equals(&l:smartindent, 0,          'failed at #444')
  call g:assert.equals(&l:cindent,     0,          'failed at #444')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #444')

  %delete

  " #445
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #445')
  call g:assert.equals(getline(2),   '    [',      'failed at #445')
  call g:assert.equals(getline(3),   '',           'failed at #445')
  call g:assert.equals(getline(4),   '    foo',    'failed at #445')
  call g:assert.equals(getline(5),   '',           'failed at #445')
  call g:assert.equals(getline(6),   '    ]',      'failed at #445')
  call g:assert.equals(getline(7),   '    }',      'failed at #445')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #445')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #445')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #445')
  call g:assert.equals(&l:autoindent,  1,          'failed at #445')
  call g:assert.equals(&l:smartindent, 1,          'failed at #445')
  call g:assert.equals(&l:cindent,     0,          'failed at #445')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #445')

  %delete

  " #446
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',      'failed at #446')
  call g:assert.equals(getline(2),   '    [',      'failed at #446')
  call g:assert.equals(getline(3),   '',           'failed at #446')
  call g:assert.equals(getline(4),   '    foo',    'failed at #446')
  call g:assert.equals(getline(5),   '',           'failed at #446')
  call g:assert.equals(getline(6),   '    ]',      'failed at #446')
  call g:assert.equals(getline(7),   '    }',      'failed at #446')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #446')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #446')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #446')
  call g:assert.equals(&l:autoindent,  1,          'failed at #446')
  call g:assert.equals(&l:smartindent, 1,          'failed at #446')
  call g:assert.equals(&l:cindent,     1,          'failed at #446')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #446')

  %delete

  " #447
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',          'failed at #447')
  call g:assert.equals(getline(2),   '    [',          'failed at #447')
  call g:assert.equals(getline(3),   '',               'failed at #447')
  call g:assert.equals(getline(4),   '    foo',        'failed at #447')
  call g:assert.equals(getline(5),   '',               'failed at #447')
  call g:assert.equals(getline(6),   '    ]',          'failed at #447')
  call g:assert.equals(getline(7),   '    }',          'failed at #447')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #447')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #447')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #447')
  call g:assert.equals(&l:autoindent,  1,              'failed at #447')
  call g:assert.equals(&l:smartindent, 1,              'failed at #447')
  call g:assert.equals(&l:cindent,     1,              'failed at #447')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #447')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #448
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #448')
  call g:assert.equals(getline(2),   '    [',       'failed at #448')
  call g:assert.equals(getline(3),   '',            'failed at #448')
  call g:assert.equals(getline(4),   '    foo',     'failed at #448')
  call g:assert.equals(getline(5),   '',            'failed at #448')
  call g:assert.equals(getline(6),   '    ]',       'failed at #448')
  call g:assert.equals(getline(7),   '}',           'failed at #448')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #448')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #448')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #448')
  call g:assert.equals(&l:autoindent,  0,           'failed at #448')
  call g:assert.equals(&l:smartindent, 0,           'failed at #448')
  call g:assert.equals(&l:cindent,     0,           'failed at #448')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #448')

  %delete

  " #449
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #449')
  call g:assert.equals(getline(2),   '    [',       'failed at #449')
  call g:assert.equals(getline(3),   '',            'failed at #449')
  call g:assert.equals(getline(4),   '    foo',     'failed at #449')
  call g:assert.equals(getline(5),   '',            'failed at #449')
  call g:assert.equals(getline(6),   '    ]',       'failed at #449')
  call g:assert.equals(getline(7),   '}',           'failed at #449')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #449')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #449')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #449')
  call g:assert.equals(&l:autoindent,  1,           'failed at #449')
  call g:assert.equals(&l:smartindent, 0,           'failed at #449')
  call g:assert.equals(&l:cindent,     0,           'failed at #449')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #449')

  %delete

  " #450
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #450')
  call g:assert.equals(getline(2),   '    [',       'failed at #450')
  call g:assert.equals(getline(3),   '',            'failed at #450')
  call g:assert.equals(getline(4),   '    foo',     'failed at #450')
  call g:assert.equals(getline(5),   '',            'failed at #450')
  call g:assert.equals(getline(6),   '    ]',       'failed at #450')
  call g:assert.equals(getline(7),   '}',           'failed at #450')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #450')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #450')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #450')
  call g:assert.equals(&l:autoindent,  1,           'failed at #450')
  call g:assert.equals(&l:smartindent, 1,           'failed at #450')
  call g:assert.equals(&l:cindent,     0,           'failed at #450')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #450')

  %delete

  " #451
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #451')
  call g:assert.equals(getline(2),   '    [',       'failed at #451')
  call g:assert.equals(getline(3),   '',            'failed at #451')
  call g:assert.equals(getline(4),   '    foo',     'failed at #451')
  call g:assert.equals(getline(5),   '',            'failed at #451')
  call g:assert.equals(getline(6),   '    ]',       'failed at #451')
  call g:assert.equals(getline(7),   '}',           'failed at #451')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #451')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #451')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #451')
  call g:assert.equals(&l:autoindent,  1,           'failed at #451')
  call g:assert.equals(&l:smartindent, 1,           'failed at #451')
  call g:assert.equals(&l:cindent,     1,           'failed at #451')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #451')

  %delete

  " #452
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #452')
  call g:assert.equals(getline(2),   '    [',          'failed at #452')
  call g:assert.equals(getline(3),   '',               'failed at #452')
  call g:assert.equals(getline(4),   '    foo',        'failed at #452')
  call g:assert.equals(getline(5),   '',               'failed at #452')
  call g:assert.equals(getline(6),   '    ]',          'failed at #452')
  call g:assert.equals(getline(7),   '}',              'failed at #452')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #452')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #452')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #452')
  call g:assert.equals(&l:autoindent,  1,              'failed at #452')
  call g:assert.equals(&l:smartindent, 1,              'failed at #452')
  call g:assert.equals(&l:cindent,     1,              'failed at #452')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #452')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #453
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #453')
  call g:assert.equals(getline(2),   '    [',       'failed at #453')
  call g:assert.equals(getline(3),   '',            'failed at #453')
  call g:assert.equals(getline(4),   '    foo',     'failed at #453')
  call g:assert.equals(getline(5),   '',            'failed at #453')
  call g:assert.equals(getline(6),   '    ]',       'failed at #453')
  call g:assert.equals(getline(7),   '    }',       'failed at #453')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #453')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #453')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #453')
  call g:assert.equals(&l:autoindent,  0,           'failed at #453')
  call g:assert.equals(&l:smartindent, 0,           'failed at #453')
  call g:assert.equals(&l:cindent,     0,           'failed at #453')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #453')

  %delete

  " #454
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #454')
  call g:assert.equals(getline(2),   '    [',       'failed at #454')
  call g:assert.equals(getline(3),   '',            'failed at #454')
  call g:assert.equals(getline(4),   '    foo',     'failed at #454')
  call g:assert.equals(getline(5),   '',            'failed at #454')
  call g:assert.equals(getline(6),   '    ]',       'failed at #454')
  call g:assert.equals(getline(7),   '    }',       'failed at #454')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #454')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #454')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #454')
  call g:assert.equals(&l:autoindent,  1,           'failed at #454')
  call g:assert.equals(&l:smartindent, 0,           'failed at #454')
  call g:assert.equals(&l:cindent,     0,           'failed at #454')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #454')

  %delete

  " #455
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #455')
  call g:assert.equals(getline(2),   '    [',       'failed at #455')
  call g:assert.equals(getline(3),   '',            'failed at #455')
  call g:assert.equals(getline(4),   '    foo',     'failed at #455')
  call g:assert.equals(getline(5),   '',            'failed at #455')
  call g:assert.equals(getline(6),   '    ]',       'failed at #455')
  call g:assert.equals(getline(7),   '    }',       'failed at #455')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #455')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #455')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #455')
  call g:assert.equals(&l:autoindent,  1,           'failed at #455')
  call g:assert.equals(&l:smartindent, 1,           'failed at #455')
  call g:assert.equals(&l:cindent,     0,           'failed at #455')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #455')

  %delete

  " #456
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',           'failed at #456')
  call g:assert.equals(getline(2),   '    [',       'failed at #456')
  call g:assert.equals(getline(3),   '',            'failed at #456')
  call g:assert.equals(getline(4),   '    foo',     'failed at #456')
  call g:assert.equals(getline(5),   '',            'failed at #456')
  call g:assert.equals(getline(6),   '    ]',       'failed at #456')
  call g:assert.equals(getline(7),   '    }',       'failed at #456')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #456')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #456')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #456')
  call g:assert.equals(&l:autoindent,  1,           'failed at #456')
  call g:assert.equals(&l:smartindent, 1,           'failed at #456')
  call g:assert.equals(&l:cindent,     1,           'failed at #456')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #456')

  %delete

  " #457
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',              'failed at #457')
  call g:assert.equals(getline(2),   '    [',          'failed at #457')
  call g:assert.equals(getline(3),   '',               'failed at #457')
  call g:assert.equals(getline(4),   '    foo',        'failed at #457')
  call g:assert.equals(getline(5),   '',               'failed at #457')
  call g:assert.equals(getline(6),   '    ]',          'failed at #457')
  call g:assert.equals(getline(7),   '    }',          'failed at #457')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #457')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #457')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #457')
  call g:assert.equals(&l:autoindent,  1,              'failed at #457')
  call g:assert.equals(&l:smartindent, 1,              'failed at #457')
  call g:assert.equals(&l:cindent,     1,              'failed at #457')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #457')
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

  " #458
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #458')
  call g:assert.equals(getline(2),   '',           'failed at #458')
  call g:assert.equals(getline(3),   '    foo',    'failed at #458')
  call g:assert.equals(getline(4),   '',           'failed at #458')
  call g:assert.equals(getline(5),   '    }',      'failed at #458')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #458')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #458')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #458')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #458')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #458')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #459
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #459')
  call g:assert.equals(getline(2),   '',           'failed at #459')
  call g:assert.equals(getline(3),   '    foo',    'failed at #459')
  call g:assert.equals(getline(4),   '',           'failed at #459')
  call g:assert.equals(getline(5),   '    }',      'failed at #459')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #459')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #459')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #459')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #459')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #459')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #460
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '{',          'failed at #460')
  call g:assert.equals(getline(2),   '',           'failed at #460')
  call g:assert.equals(getline(3),   '    foo',    'failed at #460')
  call g:assert.equals(getline(4),   '',           'failed at #460')
  call g:assert.equals(getline(5),   '    }',      'failed at #460')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #460')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #460')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #460')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #460')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #460')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #461
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #461')
  call g:assert.equals(getline(2),   '',              'failed at #461')
  call g:assert.equals(getline(3),   '    foo',       'failed at #461')
  call g:assert.equals(getline(4),   '',              'failed at #461')
  call g:assert.equals(getline(5),   '    }',         'failed at #461')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #461')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #461')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #461')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #461')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #461')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #462
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '       {',      'failed at #462')
  call g:assert.equals(getline(2),   '',              'failed at #462')
  call g:assert.equals(getline(3),   '    foo',       'failed at #462')
  call g:assert.equals(getline(4),   '',              'failed at #462')
  call g:assert.equals(getline(5),   '            }', 'failed at #462')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #462')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #462')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #462')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #462')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #462')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #463
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggsrV2ja
  call g:assert.equals(getline(1),   '    {',         'failed at #463')
  call g:assert.equals(getline(2),   '',              'failed at #463')
  call g:assert.equals(getline(3),   '    foo',       'failed at #463')
  call g:assert.equals(getline(4),   '',              'failed at #463')
  call g:assert.equals(getline(5),   '    }',         'failed at #463')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #463')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #463')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #463')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #463')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #463')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #464
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #464')

  " #465
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #465')

  " #466
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #466')

  " #467
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #467')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #467')

  %delete

  " #468
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #468')
  call g:assert.equals(getline(2),   'foo',        'failed at #468')
  call g:assert.equals(getline(3),   ']',          'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #468')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #468')

  " #469
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #469')
  call g:assert.equals(getline(2),   'foo',        'failed at #469')
  call g:assert.equals(getline(3),   '}',          'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #469')

  " #470
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #470')
  call g:assert.equals(getline(2),   'foo',        'failed at #470')
  call g:assert.equals(getline(3),   '>',          'failed at #470')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #470')

  " #471
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #471')
  call g:assert.equals(getline(2),   'foo',        'failed at #471')
  call g:assert.equals(getline(3),   ')',          'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #471')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #472
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #472')

  " #473
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #473')

  %delete

  " #472
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #472')
  call g:assert.equals(getline(2),   'foo',        'failed at #472')
  call g:assert.equals(getline(3),   'b',          'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #472')

  %delete

  " #473
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #473')
  call g:assert.equals(getline(2),   'foo',        'failed at #473')
  call g:assert.equals(getline(3),   '*',          'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #473')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #474
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #474')
  call g:assert.equals(getline(2),   'foo',        'failed at #474')
  call g:assert.equals(getline(3),   'bar',        'failed at #474')
  call g:assert.equals(getline(4),   'baz',        'failed at #474')
  call g:assert.equals(getline(5),   ']',          'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #474')

  %delete

  " #475
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #475')
  call g:assert.equals(getline(2),   '[',          'failed at #475')
  call g:assert.equals(getline(3),   'bar',        'failed at #475')
  call g:assert.equals(getline(4),   ']',          'failed at #475')
  call g:assert.equals(getline(5),   'baz',        'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #475')

  %delete

  " #476
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #476')
  call g:assert.equals(getline(2),   'bar',        'failed at #476')
  call g:assert.equals(getline(3),   'baz]',       'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #476')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #476')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #477
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #477')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #477')

  %delete

  " #478
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #478')
  call g:assert.equals(getline(2),   ']',          'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #478')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  " #479
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #479')

  " #480
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #480')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #480')

  %delete

  " #481
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #481')
  call g:assert.equals(getline(2),   '(',          'failed at #481')
  call g:assert.equals(getline(3),   '{',          'failed at #481')
  call g:assert.equals(getline(4),   '[',          'failed at #481')
  call g:assert.equals(getline(5),   'bar',        'failed at #481')
  call g:assert.equals(getline(6),   ']',          'failed at #481')
  call g:assert.equals(getline(7),   '}',          'failed at #481')
  call g:assert.equals(getline(8),   ')',          'failed at #481')
  call g:assert.equals(getline(9),   'baz',        'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #481')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #482
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #482')

  %delete

  " #483
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #483')

  %delete

  " #484
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #484')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #484')
  call g:assert.equals(getline(3),   'aa',         'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #484')

  %delete

  " #485
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #485')
  call g:assert.equals(getline(2),   'bbb',        'failed at #485')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #485')
  call g:assert.equals(getline(4),   'bbb',        'failed at #485')
  call g:assert.equals(getline(5),   'bb',         'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #485')

  %delete

  " #486
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #486')
  call g:assert.equals(getline(2),   '(',          'failed at #486')
  call g:assert.equals(getline(3),   'foo',        'failed at #486')
  call g:assert.equals(getline(4),   ')',          'failed at #486')
  call g:assert.equals(getline(5),   ')',          'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #486')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #486')

  %delete

  " #487
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #487')
  call g:assert.equals(getline(2),   '(',          'failed at #487')
  call g:assert.equals(getline(3),   'foo',        'failed at #487')
  call g:assert.equals(getline(4),   ')',          'failed at #487')
  call g:assert.equals(getline(5),   ')',          'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #487')

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

  " #488
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #488')

  " #489
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #489')

  " #490
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #490')

  " #491
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #491')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" cursor
  """ inner_head
  " #492
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #492')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #492')

  " #493
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #493')

  """ keep
  " #494
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #494')

  " #495
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #495')

  """ inner_tail
  " #496
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #496')

  " #497
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #497')

  """ head
  " #498
  call operator#sandwich#set('replace', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #498')

  " #499
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #499')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #499')

  """ tail
  " #500
  call operator#sandwich#set('replace', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #500')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #500')

  " #501
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #501')

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
  " #502
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #502')

  " #503
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #503')

  """ off
  " #504
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #504')

  " #505
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #505')

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
  " #506
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #506')

  " #507
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #507')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #508
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #508')

  " #509
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #509')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ 2
  " #510
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #510')

  " #511
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #511')

  " #512
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #512')

  " #513
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo) ', 'failed at #513')

  """ 1
  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
  " #514
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #514')

  " #515
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #515')

  " #516
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #516')

  " #517
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #517')

  """ 0
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #518
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #518')

  " #519
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #519')

  " #520
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #520')

  " #521
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #521')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """ off
  " #522
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #522')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #523
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #523')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #524
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '""', 'failed at #524')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #525
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #525')
  call g:assert.equals(getline(2),   'foo',        'failed at #525')
  call g:assert.equals(getline(3),   ']',          'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #525')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #525')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #525')

  %delete

  " #526
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #526')
  call g:assert.equals(getline(2),   'foo',        'failed at #526')
  call g:assert.equals(getline(3),   '  ]',        'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #526')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #526')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #526')

  %delete

  " #527
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #527')
  call g:assert.equals(getline(2),   'foo',        'failed at #527')
  call g:assert.equals(getline(3),   'aa]',        'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #527')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #527')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #527')

  %delete

  " #528
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #528')
  call g:assert.equals(getline(2),   'foo',        'failed at #528')
  call g:assert.equals(getline(3),   ']',          'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #528')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #528')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #528')

  %delete

  " #529
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #529')
  call g:assert.equals(getline(2),   'foo',        'failed at #529')
  call g:assert.equals(getline(3),   'aa]',        'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #529')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #529')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #529')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #530
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #530')
  call g:assert.equals(getline(2),   'foo',        'failed at #530')
  call g:assert.equals(getline(3),   ']',          'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #530')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #530')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #530')

  %delete

  " #531
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #531')
  call g:assert.equals(getline(2),   'foo',        'failed at #531')
  call g:assert.equals(getline(3),   ']',          'failed at #531')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #531')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #531')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #531')

  %delete

  " #532
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #532')
  call g:assert.equals(getline(2),   'foo',        'failed at #532')
  call g:assert.equals(getline(3),   ']',          'failed at #532')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #532')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #532')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #532')

  %delete

  " #533
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #533')
  call g:assert.equals(getline(2),   '[',          'failed at #533')
  call g:assert.equals(getline(3),   'bb',         'failed at #533')
  call g:assert.equals(getline(4),   '',           'failed at #533')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #533')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #533')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #533')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" query_once
  """ off
  " #534
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #534')

  %delete

  """ on
  " #535
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #535')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 1)

  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #536
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #536')

  """ 1
  " #537
  call operator#sandwich#set('replace', 'line', 'expr', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #537')

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

  " #538
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #538')
  call g:assert.equals(getline(2),   '[',          'failed at #538')
  call g:assert.equals(getline(3),   '',           'failed at #538')
  call g:assert.equals(getline(4),   '    foo',    'failed at #538')
  call g:assert.equals(getline(5),   '',           'failed at #538')
  call g:assert.equals(getline(6),   ']',          'failed at #538')
  call g:assert.equals(getline(7),   '}',          'failed at #538')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #538')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #538')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #538')
  call g:assert.equals(&l:autoindent,  0,          'failed at #538')
  call g:assert.equals(&l:smartindent, 0,          'failed at #538')
  call g:assert.equals(&l:cindent,     0,          'failed at #538')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #538')

  %delete

  " #539
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #539')
  call g:assert.equals(getline(2),   '    [',      'failed at #539')
  call g:assert.equals(getline(3),   '',           'failed at #539')
  call g:assert.equals(getline(4),   '    foo',    'failed at #539')
  call g:assert.equals(getline(5),   '',           'failed at #539')
  call g:assert.equals(getline(6),   '    ]',      'failed at #539')
  call g:assert.equals(getline(7),   '    }',      'failed at #539')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #539')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #539')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #539')
  call g:assert.equals(&l:autoindent,  1,          'failed at #539')
  call g:assert.equals(&l:smartindent, 0,          'failed at #539')
  call g:assert.equals(&l:cindent,     0,          'failed at #539')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #539')

  %delete

  " #540
  setlocal smartindent
  setlocal nocindent
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
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #540')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #540')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #540')
  call g:assert.equals(&l:autoindent,  1,           'failed at #540')
  call g:assert.equals(&l:smartindent, 1,           'failed at #540')
  call g:assert.equals(&l:cindent,     0,           'failed at #540')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #540')

  %delete

  " #541
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #541')
  call g:assert.equals(getline(2),   '    [',       'failed at #541')
  call g:assert.equals(getline(3),   '',            'failed at #541')
  call g:assert.equals(getline(4),   '    foo',     'failed at #541')
  call g:assert.equals(getline(5),   '',            'failed at #541')
  call g:assert.equals(getline(6),   '    ]',       'failed at #541')
  call g:assert.equals(getline(7),   '    }',       'failed at #541')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #541')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #541')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #541')
  call g:assert.equals(&l:autoindent,  1,           'failed at #541')
  call g:assert.equals(&l:smartindent, 1,           'failed at #541')
  call g:assert.equals(&l:cindent,     1,           'failed at #541')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #541')

  %delete

  " #542
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',            'failed at #542')
  call g:assert.equals(getline(2),   '           [',        'failed at #542')
  call g:assert.equals(getline(3),   '',                    'failed at #542')
  call g:assert.equals(getline(4),   '    foo',             'failed at #542')
  call g:assert.equals(getline(5),   '',                    'failed at #542')
  call g:assert.equals(getline(6),   '        ]',           'failed at #542')
  call g:assert.equals(getline(7),   '                }',   'failed at #542')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #542')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #542')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #542')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #542')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #542')
  call g:assert.equals(&l:cindent,     1,                   'failed at #542')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #542')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'line', 'autoindent', 0)

  " #543
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #543')
  call g:assert.equals(getline(2),   '[',          'failed at #543')
  call g:assert.equals(getline(3),   '',           'failed at #543')
  call g:assert.equals(getline(4),   '    foo',    'failed at #543')
  call g:assert.equals(getline(5),   '',           'failed at #543')
  call g:assert.equals(getline(6),   ']',          'failed at #543')
  call g:assert.equals(getline(7),   '}',          'failed at #543')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #543')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #543')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #543')
  call g:assert.equals(&l:autoindent,  0,          'failed at #543')
  call g:assert.equals(&l:smartindent, 0,          'failed at #543')
  call g:assert.equals(&l:cindent,     0,          'failed at #543')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #543')

  %delete

  " #544
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #544')
  call g:assert.equals(getline(2),   '[',          'failed at #544')
  call g:assert.equals(getline(3),   '',           'failed at #544')
  call g:assert.equals(getline(4),   '    foo',    'failed at #544')
  call g:assert.equals(getline(5),   '',           'failed at #544')
  call g:assert.equals(getline(6),   ']',          'failed at #544')
  call g:assert.equals(getline(7),   '}',          'failed at #544')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #544')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #544')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #544')
  call g:assert.equals(&l:autoindent,  1,          'failed at #544')
  call g:assert.equals(&l:smartindent, 0,          'failed at #544')
  call g:assert.equals(&l:cindent,     0,          'failed at #544')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #544')

  %delete

  " #545
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #545')
  call g:assert.equals(getline(2),   '[',          'failed at #545')
  call g:assert.equals(getline(3),   '',           'failed at #545')
  call g:assert.equals(getline(4),   '    foo',    'failed at #545')
  call g:assert.equals(getline(5),   '',           'failed at #545')
  call g:assert.equals(getline(6),   ']',          'failed at #545')
  call g:assert.equals(getline(7),   '}',          'failed at #545')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #545')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #545')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #545')
  call g:assert.equals(&l:autoindent,  1,          'failed at #545')
  call g:assert.equals(&l:smartindent, 1,          'failed at #545')
  call g:assert.equals(&l:cindent,     0,          'failed at #545')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #545')

  %delete

  " #546
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #546')
  call g:assert.equals(getline(2),   '[',          'failed at #546')
  call g:assert.equals(getline(3),   '',           'failed at #546')
  call g:assert.equals(getline(4),   '    foo',    'failed at #546')
  call g:assert.equals(getline(5),   '',           'failed at #546')
  call g:assert.equals(getline(6),   ']',          'failed at #546')
  call g:assert.equals(getline(7),   '}',          'failed at #546')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #546')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #546')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #546')
  call g:assert.equals(&l:autoindent,  1,          'failed at #546')
  call g:assert.equals(&l:smartindent, 1,          'failed at #546')
  call g:assert.equals(&l:cindent,     1,          'failed at #546')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #546')

  %delete

  " #547
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #547')
  call g:assert.equals(getline(2),   '[',              'failed at #547')
  call g:assert.equals(getline(3),   '',               'failed at #547')
  call g:assert.equals(getline(4),   '    foo',        'failed at #547')
  call g:assert.equals(getline(5),   '',               'failed at #547')
  call g:assert.equals(getline(6),   ']',              'failed at #547')
  call g:assert.equals(getline(7),   '}',              'failed at #547')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #547')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #547')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #547')
  call g:assert.equals(&l:autoindent,  1,              'failed at #547')
  call g:assert.equals(&l:smartindent, 1,              'failed at #547')
  call g:assert.equals(&l:cindent,     1,              'failed at #547')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #547')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'line', 'autoindent', 1)

  " #548
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #548')
  call g:assert.equals(getline(2),   '    [',      'failed at #548')
  call g:assert.equals(getline(3),   '',           'failed at #548')
  call g:assert.equals(getline(4),   '    foo',    'failed at #548')
  call g:assert.equals(getline(5),   '',           'failed at #548')
  call g:assert.equals(getline(6),   '    ]',      'failed at #548')
  call g:assert.equals(getline(7),   '    }',      'failed at #548')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #548')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #548')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #548')
  call g:assert.equals(&l:autoindent,  0,          'failed at #548')
  call g:assert.equals(&l:smartindent, 0,          'failed at #548')
  call g:assert.equals(&l:cindent,     0,          'failed at #548')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #548')

  %delete

  " #549
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #549')
  call g:assert.equals(getline(2),   '    [',      'failed at #549')
  call g:assert.equals(getline(3),   '',           'failed at #549')
  call g:assert.equals(getline(4),   '    foo',    'failed at #549')
  call g:assert.equals(getline(5),   '',           'failed at #549')
  call g:assert.equals(getline(6),   '    ]',      'failed at #549')
  call g:assert.equals(getline(7),   '    }',      'failed at #549')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #549')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #549')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #549')
  call g:assert.equals(&l:autoindent,  1,          'failed at #549')
  call g:assert.equals(&l:smartindent, 0,          'failed at #549')
  call g:assert.equals(&l:cindent,     0,          'failed at #549')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #549')

  %delete

  " #550
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #550')
  call g:assert.equals(getline(2),   '    [',      'failed at #550')
  call g:assert.equals(getline(3),   '',           'failed at #550')
  call g:assert.equals(getline(4),   '    foo',    'failed at #550')
  call g:assert.equals(getline(5),   '',           'failed at #550')
  call g:assert.equals(getline(6),   '    ]',      'failed at #550')
  call g:assert.equals(getline(7),   '    }',      'failed at #550')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #550')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #550')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #550')
  call g:assert.equals(&l:autoindent,  1,          'failed at #550')
  call g:assert.equals(&l:smartindent, 1,          'failed at #550')
  call g:assert.equals(&l:cindent,     0,          'failed at #550')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #550')

  %delete

  " #551
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',      'failed at #551')
  call g:assert.equals(getline(2),   '    [',      'failed at #551')
  call g:assert.equals(getline(3),   '',           'failed at #551')
  call g:assert.equals(getline(4),   '    foo',    'failed at #551')
  call g:assert.equals(getline(5),   '',           'failed at #551')
  call g:assert.equals(getline(6),   '    ]',      'failed at #551')
  call g:assert.equals(getline(7),   '    }',      'failed at #551')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #551')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #551')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #551')
  call g:assert.equals(&l:autoindent,  1,          'failed at #551')
  call g:assert.equals(&l:smartindent, 1,          'failed at #551')
  call g:assert.equals(&l:cindent,     1,          'failed at #551')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #551')

  %delete

  " #552
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',          'failed at #552')
  call g:assert.equals(getline(2),   '    [',          'failed at #552')
  call g:assert.equals(getline(3),   '',               'failed at #552')
  call g:assert.equals(getline(4),   '    foo',        'failed at #552')
  call g:assert.equals(getline(5),   '',               'failed at #552')
  call g:assert.equals(getline(6),   '    ]',          'failed at #552')
  call g:assert.equals(getline(7),   '    }',          'failed at #552')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #552')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #552')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #552')
  call g:assert.equals(&l:autoindent,  1,              'failed at #552')
  call g:assert.equals(&l:smartindent, 1,              'failed at #552')
  call g:assert.equals(&l:cindent,     1,              'failed at #552')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #552')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'line', 'autoindent', 2)

  " #553
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #553')
  call g:assert.equals(getline(2),   '    [',       'failed at #553')
  call g:assert.equals(getline(3),   '',            'failed at #553')
  call g:assert.equals(getline(4),   '    foo',     'failed at #553')
  call g:assert.equals(getline(5),   '',            'failed at #553')
  call g:assert.equals(getline(6),   '    ]',       'failed at #553')
  call g:assert.equals(getline(7),   '}',           'failed at #553')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #553')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #553')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #553')
  call g:assert.equals(&l:autoindent,  0,           'failed at #553')
  call g:assert.equals(&l:smartindent, 0,           'failed at #553')
  call g:assert.equals(&l:cindent,     0,           'failed at #553')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #553')

  %delete

  " #554
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #554')
  call g:assert.equals(getline(2),   '    [',       'failed at #554')
  call g:assert.equals(getline(3),   '',            'failed at #554')
  call g:assert.equals(getline(4),   '    foo',     'failed at #554')
  call g:assert.equals(getline(5),   '',            'failed at #554')
  call g:assert.equals(getline(6),   '    ]',       'failed at #554')
  call g:assert.equals(getline(7),   '}',           'failed at #554')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #554')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #554')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #554')
  call g:assert.equals(&l:autoindent,  1,           'failed at #554')
  call g:assert.equals(&l:smartindent, 0,           'failed at #554')
  call g:assert.equals(&l:cindent,     0,           'failed at #554')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #554')

  %delete

  " #555
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #555')
  call g:assert.equals(getline(2),   '    [',       'failed at #555')
  call g:assert.equals(getline(3),   '',            'failed at #555')
  call g:assert.equals(getline(4),   '    foo',     'failed at #555')
  call g:assert.equals(getline(5),   '',            'failed at #555')
  call g:assert.equals(getline(6),   '    ]',       'failed at #555')
  call g:assert.equals(getline(7),   '}',           'failed at #555')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #555')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #555')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #555')
  call g:assert.equals(&l:autoindent,  1,           'failed at #555')
  call g:assert.equals(&l:smartindent, 1,           'failed at #555')
  call g:assert.equals(&l:cindent,     0,           'failed at #555')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #555')

  %delete

  " #556
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #556')
  call g:assert.equals(getline(2),   '    [',       'failed at #556')
  call g:assert.equals(getline(3),   '',            'failed at #556')
  call g:assert.equals(getline(4),   '    foo',     'failed at #556')
  call g:assert.equals(getline(5),   '',            'failed at #556')
  call g:assert.equals(getline(6),   '    ]',       'failed at #556')
  call g:assert.equals(getline(7),   '}',           'failed at #556')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #556')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #556')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #556')
  call g:assert.equals(&l:autoindent,  1,           'failed at #556')
  call g:assert.equals(&l:smartindent, 1,           'failed at #556')
  call g:assert.equals(&l:cindent,     1,           'failed at #556')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #556')

  %delete

  " #557
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #557')
  call g:assert.equals(getline(2),   '    [',          'failed at #557')
  call g:assert.equals(getline(3),   '',               'failed at #557')
  call g:assert.equals(getline(4),   '    foo',        'failed at #557')
  call g:assert.equals(getline(5),   '',               'failed at #557')
  call g:assert.equals(getline(6),   '    ]',          'failed at #557')
  call g:assert.equals(getline(7),   '}',              'failed at #557')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #557')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #557')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #557')
  call g:assert.equals(&l:autoindent,  1,              'failed at #557')
  call g:assert.equals(&l:smartindent, 1,              'failed at #557')
  call g:assert.equals(&l:cindent,     1,              'failed at #557')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #557')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #558
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #558')
  call g:assert.equals(getline(2),   '    [',       'failed at #558')
  call g:assert.equals(getline(3),   '',            'failed at #558')
  call g:assert.equals(getline(4),   '    foo',     'failed at #558')
  call g:assert.equals(getline(5),   '',            'failed at #558')
  call g:assert.equals(getline(6),   '    ]',       'failed at #558')
  call g:assert.equals(getline(7),   '    }',       'failed at #558')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #558')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #558')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #558')
  call g:assert.equals(&l:autoindent,  0,           'failed at #558')
  call g:assert.equals(&l:smartindent, 0,           'failed at #558')
  call g:assert.equals(&l:cindent,     0,           'failed at #558')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #558')

  %delete

  " #559
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #559')
  call g:assert.equals(getline(2),   '    [',       'failed at #559')
  call g:assert.equals(getline(3),   '',            'failed at #559')
  call g:assert.equals(getline(4),   '    foo',     'failed at #559')
  call g:assert.equals(getline(5),   '',            'failed at #559')
  call g:assert.equals(getline(6),   '    ]',       'failed at #559')
  call g:assert.equals(getline(7),   '    }',       'failed at #559')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #559')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #559')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #559')
  call g:assert.equals(&l:autoindent,  1,           'failed at #559')
  call g:assert.equals(&l:smartindent, 0,           'failed at #559')
  call g:assert.equals(&l:cindent,     0,           'failed at #559')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #559')

  %delete

  " #560
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #560')
  call g:assert.equals(getline(2),   '    [',       'failed at #560')
  call g:assert.equals(getline(3),   '',            'failed at #560')
  call g:assert.equals(getline(4),   '    foo',     'failed at #560')
  call g:assert.equals(getline(5),   '',            'failed at #560')
  call g:assert.equals(getline(6),   '    ]',       'failed at #560')
  call g:assert.equals(getline(7),   '    }',       'failed at #560')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #560')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #560')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #560')
  call g:assert.equals(&l:autoindent,  1,           'failed at #560')
  call g:assert.equals(&l:smartindent, 1,           'failed at #560')
  call g:assert.equals(&l:cindent,     0,           'failed at #560')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #560')

  %delete

  " #561
  setlocal cindent
  setlocal indentexpr=
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',           'failed at #561')
  call g:assert.equals(getline(2),   '    [',       'failed at #561')
  call g:assert.equals(getline(3),   '',            'failed at #561')
  call g:assert.equals(getline(4),   '    foo',     'failed at #561')
  call g:assert.equals(getline(5),   '',            'failed at #561')
  call g:assert.equals(getline(6),   '    ]',       'failed at #561')
  call g:assert.equals(getline(7),   '    }',       'failed at #561')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #561')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #561')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #561')
  call g:assert.equals(&l:autoindent,  1,           'failed at #561')
  call g:assert.equals(&l:smartindent, 1,           'failed at #561')
  call g:assert.equals(&l:cindent,     1,           'failed at #561')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #561')

  %delete

  " #562
  setlocal indentexpr=TestIndent()
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',              'failed at #562')
  call g:assert.equals(getline(2),   '    [',          'failed at #562')
  call g:assert.equals(getline(3),   '',               'failed at #562')
  call g:assert.equals(getline(4),   '    foo',        'failed at #562')
  call g:assert.equals(getline(5),   '',               'failed at #562')
  call g:assert.equals(getline(6),   '    ]',          'failed at #562')
  call g:assert.equals(getline(7),   '    }',          'failed at #562')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #562')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #562')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #562')
  call g:assert.equals(&l:autoindent,  1,              'failed at #562')
  call g:assert.equals(&l:smartindent, 1,              'failed at #562')
  call g:assert.equals(&l:cindent,     1,              'failed at #562')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #562')
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

  " #563
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #563')
  call g:assert.equals(getline(2),   '',           'failed at #563')
  call g:assert.equals(getline(3),   '    foo',    'failed at #563')
  call g:assert.equals(getline(4),   '',           'failed at #563')
  call g:assert.equals(getline(5),   '    }',      'failed at #563')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #563')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #563')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #563')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #563')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #563')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #564
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #564')
  call g:assert.equals(getline(2),   '',           'failed at #564')
  call g:assert.equals(getline(3),   '    foo',    'failed at #564')
  call g:assert.equals(getline(4),   '',           'failed at #564')
  call g:assert.equals(getline(5),   '    }',      'failed at #564')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #564')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #564')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #564')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #564')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #564')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', 3)

  " #565
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '{',          'failed at #565')
  call g:assert.equals(getline(2),   '',           'failed at #565')
  call g:assert.equals(getline(3),   '    foo',    'failed at #565')
  call g:assert.equals(getline(4),   '',           'failed at #565')
  call g:assert.equals(getline(5),   '    }',      'failed at #565')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #565')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #565')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #565')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #565')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #565')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #566
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #566')
  call g:assert.equals(getline(2),   '',              'failed at #566')
  call g:assert.equals(getline(3),   '    foo',       'failed at #566')
  call g:assert.equals(getline(4),   '',              'failed at #566')
  call g:assert.equals(getline(5),   '    }',         'failed at #566')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #566')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #566')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #566')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #566')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #566')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #567
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys+', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '       {',      'failed at #567')
  call g:assert.equals(getline(2),   '',              'failed at #567')
  call g:assert.equals(getline(3),   '    foo',       'failed at #567')
  call g:assert.equals(getline(4),   '',              'failed at #567')
  call g:assert.equals(getline(5),   '            }', 'failed at #567')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #567')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #567')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #567')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #567')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #567')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'line', 'linewise', 2)
  call operator#sandwich#set('replace', 'line', 'autoindent', -1)

  " #568
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'line', 'indentkeys-', 'O,o')
  call append(0, ['    "', '    foo', '    "'])
  normal ggV2jsra
  call g:assert.equals(getline(1),   '    {',         'failed at #568')
  call g:assert.equals(getline(2),   '',              'failed at #568')
  call g:assert.equals(getline(3),   '    foo',       'failed at #568')
  call g:assert.equals(getline(4),   '',              'failed at #568')
  call g:assert.equals(getline(5),   '    }',         'failed at #568')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #568')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #568')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #568')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #568')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #568')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #569
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #569')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #569')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #569')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #569')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #569')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #569')

  %delete

  " #570
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #570')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #570')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #570')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #570')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #570')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #570')

  %delete

  " #571
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #571')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #571')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #571')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #571')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #571')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #571')

  %delete

  " #572
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #572')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #572')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #572')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #572')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #572')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #572')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #573
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #573')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #573')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #573')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #573')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #573')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #573')

  " #574
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #574')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #574')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #574')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #574')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #574')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #574')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #575
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #575')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #575')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #575')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #575')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #575')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #575')

  %delete

  " #576
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #576')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #576')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #576')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #576')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #576')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #576')

  %delete

  " #577
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #577')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #577')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #577')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #577')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #577')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #577')

  %delete

  " #578
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #578')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #578')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #578')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #578')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #578')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #578')

  %delete

  " #579
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #579')
  call g:assert.equals(getline(2),   'barbar',     'failed at #579')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #579')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #579')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #579')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #579')

  %delete

  " #580
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #580')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #580')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #580')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #580')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #580')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #580')

  %delete

  " #581
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #581')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #581')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #581')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #581')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #581')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #581')

  %delete

  " #582
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsr\<C-v>20l["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #582')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #582')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #582')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #582')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #582')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #582')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #583
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #583')
  call g:assert.equals(getline(2),   '[b]',        'failed at #583')
  call g:assert.equals(getline(3),   '[c]',        'failed at #583')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #583')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #583')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #583')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #584
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #584')
  call g:assert.equals(getline(2),   '[]',         'failed at #584')
  call g:assert.equals(getline(3),   '[]',         'failed at #584')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #584')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #584')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #584')

  %delete

  " #585
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #585')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #585')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #585')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #585')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #585')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #585')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #586
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #586')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #586')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #586')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #586')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #586')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #586')

  %delete

  " #587
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #587')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #587')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #587')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #587')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #587')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #587')

  %delete

  " #588
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #588')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #588')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #588')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #588')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #588')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #588')

  %delete

  " #589
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #589')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #589')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #589')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #589')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #589')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #589')

  %delete

  " #590
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #590')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #590')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #590')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #590')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #590')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #590')

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

  " #591
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #591')
  call g:assert.equals(getline(2), '"bar"', 'failed at #591')
  call g:assert.equals(getline(3), '"baz"', 'failed at #591')

  %delete

  " #592
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #592')
  call g:assert.equals(getline(2), '"bar"', 'failed at #592')
  call g:assert.equals(getline(3), '"baz"', 'failed at #592')

  %delete

  " #593
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #593')
  call g:assert.equals(getline(2), '"bar"', 'failed at #593')
  call g:assert.equals(getline(3), '"baz"', 'failed at #593')

  %delete

  " #594
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #594')
  call g:assert.equals(getline(2), '"bar"', 'failed at #594')
  call g:assert.equals(getline(3), '"baz"', 'failed at #594')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #595
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #595')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #595')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #595')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #595')

  " #596
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #596')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #596')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #596')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #596')

  %delete

  """ keep
  " #597
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #597')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #597')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #597')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #597')

  " #598
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #598')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #598')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #598')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #598')

  %delete

  """ inner_tail
  " #599
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #599')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #599')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #599')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #599')

  " #600
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #600')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #600')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #600')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #600')

  %delete

  """ head
  " #601
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #601')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #601')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #601')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #601')

  " #602
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #602')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #602')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #602')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #602')

  %delete

  """ tail
  " #603
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #603')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #603')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #603')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #603')

  " #604
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #604')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #604')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #604')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #604')

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
  " #605
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #605')
  call g:assert.equals(getline(2), '"bar"', 'failed at #605')
  call g:assert.equals(getline(3), '"baz"', 'failed at #605')

  %delete

  " #606
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #606')
  call g:assert.equals(getline(2), '(bar)', 'failed at #606')
  call g:assert.equals(getline(3), '(baz)', 'failed at #606')

  %delete

  """ off
  " #607
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #607')
  call g:assert.equals(getline(2), '{bar}', 'failed at #607')
  call g:assert.equals(getline(3), '{baz}', 'failed at #607')

  %delete

  " #608
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #608')
  call g:assert.equals(getline(2), '"bar"', 'failed at #608')
  call g:assert.equals(getline(3), '"baz"', 'failed at #608')

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
  " #609
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #609')
  call g:assert.equals(getline(2), '"bar"', 'failed at #609')
  call g:assert.equals(getline(3), '"baz"', 'failed at #609')

  %delete

  " #610
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #610')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #610')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #610')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #611
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #611')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #611')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #611')

  %delete

  " #612
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #612')
  call g:assert.equals(getline(2), '"bar"', 'failed at #612')
  call g:assert.equals(getline(3), '"baz"', 'failed at #612')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ 1
  " #613
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #613')
  call g:assert.equals(getline(2), '(bar)', 'failed at #613')
  call g:assert.equals(getline(3), '(baz)', 'failed at #613')

  %delete

  " #614
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #614')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #614')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #614')

  %delete

  " #615
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #615')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #615')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #615')

  %delete

  " #616
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #616')
  call g:assert.equals(getline(2), '("bar")', 'failed at #616')
  call g:assert.equals(getline(3), '("baz")', 'failed at #616')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #617
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #617')
  call g:assert.equals(getline(2), '(bar)', 'failed at #617')
  call g:assert.equals(getline(3), '(baz)', 'failed at #617')

  %delete

  " #618
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #618')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #618')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #618')

  %delete

  " #619
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #619')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #619')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #619')

  %delete

  " #620
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #620')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #620')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #620')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #621
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #621')
  call g:assert.equals(getline(2), '(bar)', 'failed at #621')
  call g:assert.equals(getline(3), '(baz)', 'failed at #621')

  %delete

  " #622
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #622')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #622')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #622')

  %delete

  " #623
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #623')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #623')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #623')

  %delete

  " #624
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #624')
  call g:assert.equals(getline(2), '("bar")', 'failed at #624')
  call g:assert.equals(getline(3), '("baz")', 'failed at #624')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #625
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #625')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #625')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #625')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #626
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #626')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #626')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #626')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #627
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '""', 'failed at #627')
  call g:assert.equals(getline(2), '""', 'failed at #627')
  call g:assert.equals(getline(3), '""', 'failed at #627')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #627
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #627')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #627')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #627')

  %delete

  """ on
  " #628
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #628')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #628')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #628')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #629
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #629')

  %delete

  """ 1
  " #630
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #630')

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

  " #631
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #631')
  call g:assert.equals(getline(2),   '[',          'failed at #631')
  call g:assert.equals(getline(3),   'foo',        'failed at #631')
  call g:assert.equals(getline(4),   ']',          'failed at #631')
  call g:assert.equals(getline(5),   '}',          'failed at #631')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #631')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #631')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #631')
  call g:assert.equals(&l:autoindent,  0,          'failed at #631')
  call g:assert.equals(&l:smartindent, 0,          'failed at #631')
  call g:assert.equals(&l:cindent,     0,          'failed at #631')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #631')

  %delete

  " #632
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #632')
  call g:assert.equals(getline(2),   '    [',      'failed at #632')
  call g:assert.equals(getline(3),   '    foo',    'failed at #632')
  call g:assert.equals(getline(4),   '    ]',      'failed at #632')
  call g:assert.equals(getline(5),   '    }',      'failed at #632')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #632')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #632')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #632')
  call g:assert.equals(&l:autoindent,  1,          'failed at #632')
  call g:assert.equals(&l:smartindent, 0,          'failed at #632')
  call g:assert.equals(&l:cindent,     0,          'failed at #632')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #632')

  %delete

  " #633
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #633')
  call g:assert.equals(getline(2),   '        [',   'failed at #633')
  call g:assert.equals(getline(3),   '        foo', 'failed at #633')
  call g:assert.equals(getline(4),   '    ]',       'failed at #633')
  call g:assert.equals(getline(5),   '}',           'failed at #633')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #633')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #633')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #633')
  call g:assert.equals(&l:autoindent,  1,           'failed at #633')
  call g:assert.equals(&l:smartindent, 1,           'failed at #633')
  call g:assert.equals(&l:cindent,     0,           'failed at #633')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #633')

  %delete

  " #634
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #634')
  call g:assert.equals(getline(2),   '    [',       'failed at #634')
  call g:assert.equals(getline(3),   '        foo', 'failed at #634')
  call g:assert.equals(getline(4),   '    ]',       'failed at #634')
  call g:assert.equals(getline(5),   '    }',       'failed at #634')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #634')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #634')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #634')
  call g:assert.equals(&l:autoindent,  1,           'failed at #634')
  call g:assert.equals(&l:smartindent, 1,           'failed at #634')
  call g:assert.equals(&l:cindent,     1,           'failed at #634')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #634')

  %delete

  " #635
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',           'failed at #635')
  call g:assert.equals(getline(2),   '            [',       'failed at #635')
  call g:assert.equals(getline(3),   '                foo', 'failed at #635')
  call g:assert.equals(getline(4),   '        ]',           'failed at #635')
  call g:assert.equals(getline(5),   '                }',   'failed at #635')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #635')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #635')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #635')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #635')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #635')
  call g:assert.equals(&l:cindent,     1,                   'failed at #635')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #635')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #636
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #636')
  call g:assert.equals(getline(2),   '[',          'failed at #636')
  call g:assert.equals(getline(3),   'foo',        'failed at #636')
  call g:assert.equals(getline(4),   ']',          'failed at #636')
  call g:assert.equals(getline(5),   '}',          'failed at #636')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #636')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #636')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #636')
  call g:assert.equals(&l:autoindent,  0,          'failed at #636')
  call g:assert.equals(&l:smartindent, 0,          'failed at #636')
  call g:assert.equals(&l:cindent,     0,          'failed at #636')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #636')

  %delete

  " #637
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #637')
  call g:assert.equals(getline(2),   '[',          'failed at #637')
  call g:assert.equals(getline(3),   'foo',        'failed at #637')
  call g:assert.equals(getline(4),   ']',          'failed at #637')
  call g:assert.equals(getline(5),   '}',          'failed at #637')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #637')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #637')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #637')
  call g:assert.equals(&l:autoindent,  1,          'failed at #637')
  call g:assert.equals(&l:smartindent, 0,          'failed at #637')
  call g:assert.equals(&l:cindent,     0,          'failed at #637')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #637')

  %delete

  " #638
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #638')
  call g:assert.equals(getline(2),   '[',          'failed at #638')
  call g:assert.equals(getline(3),   'foo',        'failed at #638')
  call g:assert.equals(getline(4),   ']',          'failed at #638')
  call g:assert.equals(getline(5),   '}',          'failed at #638')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #638')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #638')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #638')
  call g:assert.equals(&l:autoindent,  1,          'failed at #638')
  call g:assert.equals(&l:smartindent, 1,          'failed at #638')
  call g:assert.equals(&l:cindent,     0,          'failed at #638')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #638')

  %delete

  " #639
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #639')
  call g:assert.equals(getline(2),   '[',          'failed at #639')
  call g:assert.equals(getline(3),   'foo',        'failed at #639')
  call g:assert.equals(getline(4),   ']',          'failed at #639')
  call g:assert.equals(getline(5),   '}',          'failed at #639')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #639')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #639')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #639')
  call g:assert.equals(&l:autoindent,  1,          'failed at #639')
  call g:assert.equals(&l:smartindent, 1,          'failed at #639')
  call g:assert.equals(&l:cindent,     1,          'failed at #639')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #639')

  %delete

  " #640
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #640')
  call g:assert.equals(getline(2),   '[',              'failed at #640')
  call g:assert.equals(getline(3),   'foo',            'failed at #640')
  call g:assert.equals(getline(4),   ']',              'failed at #640')
  call g:assert.equals(getline(5),   '}',              'failed at #640')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #640')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #640')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #640')
  call g:assert.equals(&l:autoindent,  1,              'failed at #640')
  call g:assert.equals(&l:smartindent, 1,              'failed at #640')
  call g:assert.equals(&l:cindent,     1,              'failed at #640')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #640')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #641
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #641')
  call g:assert.equals(getline(2),   '    [',      'failed at #641')
  call g:assert.equals(getline(3),   '    foo',    'failed at #641')
  call g:assert.equals(getline(4),   '    ]',      'failed at #641')
  call g:assert.equals(getline(5),   '    }',      'failed at #641')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #641')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #641')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #641')
  call g:assert.equals(&l:autoindent,  0,          'failed at #641')
  call g:assert.equals(&l:smartindent, 0,          'failed at #641')
  call g:assert.equals(&l:cindent,     0,          'failed at #641')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #641')

  %delete

  " #642
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #642')
  call g:assert.equals(getline(2),   '    [',      'failed at #642')
  call g:assert.equals(getline(3),   '    foo',    'failed at #642')
  call g:assert.equals(getline(4),   '    ]',      'failed at #642')
  call g:assert.equals(getline(5),   '    }',      'failed at #642')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #642')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #642')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #642')
  call g:assert.equals(&l:autoindent,  1,          'failed at #642')
  call g:assert.equals(&l:smartindent, 0,          'failed at #642')
  call g:assert.equals(&l:cindent,     0,          'failed at #642')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #642')

  %delete

  " #643
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #643')
  call g:assert.equals(getline(2),   '    [',      'failed at #643')
  call g:assert.equals(getline(3),   '    foo',    'failed at #643')
  call g:assert.equals(getline(4),   '    ]',      'failed at #643')
  call g:assert.equals(getline(5),   '    }',      'failed at #643')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #643')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #643')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #643')
  call g:assert.equals(&l:autoindent,  1,          'failed at #643')
  call g:assert.equals(&l:smartindent, 1,          'failed at #643')
  call g:assert.equals(&l:cindent,     0,          'failed at #643')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #643')

  %delete

  " #644
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',      'failed at #644')
  call g:assert.equals(getline(2),   '    [',      'failed at #644')
  call g:assert.equals(getline(3),   '    foo',    'failed at #644')
  call g:assert.equals(getline(4),   '    ]',      'failed at #644')
  call g:assert.equals(getline(5),   '    }',      'failed at #644')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #644')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #644')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #644')
  call g:assert.equals(&l:autoindent,  1,          'failed at #644')
  call g:assert.equals(&l:smartindent, 1,          'failed at #644')
  call g:assert.equals(&l:cindent,     1,          'failed at #644')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #644')

  %delete

  " #645
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #645')
  call g:assert.equals(getline(2),   '    [',          'failed at #645')
  call g:assert.equals(getline(3),   '    foo',        'failed at #645')
  call g:assert.equals(getline(4),   '    ]',          'failed at #645')
  call g:assert.equals(getline(5),   '    }',          'failed at #645')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #645')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #645')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #645')
  call g:assert.equals(&l:autoindent,  1,              'failed at #645')
  call g:assert.equals(&l:smartindent, 1,              'failed at #645')
  call g:assert.equals(&l:cindent,     1,              'failed at #645')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #645')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #646
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #646')
  call g:assert.equals(getline(2),   '        [',   'failed at #646')
  call g:assert.equals(getline(3),   '        foo', 'failed at #646')
  call g:assert.equals(getline(4),   '    ]',       'failed at #646')
  call g:assert.equals(getline(5),   '}',           'failed at #646')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #646')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #646')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #646')
  call g:assert.equals(&l:autoindent,  0,           'failed at #646')
  call g:assert.equals(&l:smartindent, 0,           'failed at #646')
  call g:assert.equals(&l:cindent,     0,           'failed at #646')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #646')

  %delete

  " #647
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #647')
  call g:assert.equals(getline(2),   '        [',   'failed at #647')
  call g:assert.equals(getline(3),   '        foo', 'failed at #647')
  call g:assert.equals(getline(4),   '    ]',       'failed at #647')
  call g:assert.equals(getline(5),   '}',           'failed at #647')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #647')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #647')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #647')
  call g:assert.equals(&l:autoindent,  1,           'failed at #647')
  call g:assert.equals(&l:smartindent, 0,           'failed at #647')
  call g:assert.equals(&l:cindent,     0,           'failed at #647')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #647')

  %delete

  " #648
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #648')
  call g:assert.equals(getline(2),   '        [',   'failed at #648')
  call g:assert.equals(getline(3),   '        foo', 'failed at #648')
  call g:assert.equals(getline(4),   '    ]',       'failed at #648')
  call g:assert.equals(getline(5),   '}',           'failed at #648')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #648')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #648')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #648')
  call g:assert.equals(&l:autoindent,  1,           'failed at #648')
  call g:assert.equals(&l:smartindent, 1,           'failed at #648')
  call g:assert.equals(&l:cindent,     0,           'failed at #648')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #648')

  %delete

  " #649
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',       'failed at #649')
  call g:assert.equals(getline(2),   '        [',   'failed at #649')
  call g:assert.equals(getline(3),   '        foo', 'failed at #649')
  call g:assert.equals(getline(4),   '    ]',       'failed at #649')
  call g:assert.equals(getline(5),   '}',           'failed at #649')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #649')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #649')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #649')
  call g:assert.equals(&l:autoindent,  1,           'failed at #649')
  call g:assert.equals(&l:smartindent, 1,           'failed at #649')
  call g:assert.equals(&l:cindent,     1,           'failed at #649')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #649')

  %delete

  " #650
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '    {',          'failed at #650')
  call g:assert.equals(getline(2),   '        [',      'failed at #650')
  call g:assert.equals(getline(3),   '        foo',    'failed at #650')
  call g:assert.equals(getline(4),   '    ]',          'failed at #650')
  call g:assert.equals(getline(5),   '}',              'failed at #650')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #650')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #650')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #650')
  call g:assert.equals(&l:autoindent,  1,              'failed at #650')
  call g:assert.equals(&l:smartindent, 1,              'failed at #650')
  call g:assert.equals(&l:cindent,     1,              'failed at #650')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #650')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #651
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #651')
  call g:assert.equals(getline(2),   '    [',       'failed at #651')
  call g:assert.equals(getline(3),   '        foo', 'failed at #651')
  call g:assert.equals(getline(4),   '    ]',       'failed at #651')
  call g:assert.equals(getline(5),   '    }',       'failed at #651')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #651')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #651')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #651')
  call g:assert.equals(&l:autoindent,  0,           'failed at #651')
  call g:assert.equals(&l:smartindent, 0,           'failed at #651')
  call g:assert.equals(&l:cindent,     0,           'failed at #651')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #651')

  %delete

  " #652
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #652')
  call g:assert.equals(getline(2),   '    [',       'failed at #652')
  call g:assert.equals(getline(3),   '        foo', 'failed at #652')
  call g:assert.equals(getline(4),   '    ]',       'failed at #652')
  call g:assert.equals(getline(5),   '    }',       'failed at #652')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #652')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #652')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #652')
  call g:assert.equals(&l:autoindent,  1,           'failed at #652')
  call g:assert.equals(&l:smartindent, 0,           'failed at #652')
  call g:assert.equals(&l:cindent,     0,           'failed at #652')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #652')

  %delete

  " #653
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #653')
  call g:assert.equals(getline(2),   '    [',       'failed at #653')
  call g:assert.equals(getline(3),   '        foo', 'failed at #653')
  call g:assert.equals(getline(4),   '    ]',       'failed at #653')
  call g:assert.equals(getline(5),   '    }',       'failed at #653')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #653')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #653')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #653')
  call g:assert.equals(&l:autoindent,  1,           'failed at #653')
  call g:assert.equals(&l:smartindent, 1,           'failed at #653')
  call g:assert.equals(&l:cindent,     0,           'failed at #653')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #653')

  %delete

  " #654
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',           'failed at #654')
  call g:assert.equals(getline(2),   '    [',       'failed at #654')
  call g:assert.equals(getline(3),   '        foo', 'failed at #654')
  call g:assert.equals(getline(4),   '    ]',       'failed at #654')
  call g:assert.equals(getline(5),   '    }',       'failed at #654')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #654')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #654')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #654')
  call g:assert.equals(&l:autoindent,  1,           'failed at #654')
  call g:assert.equals(&l:smartindent, 1,           'failed at #654')
  call g:assert.equals(&l:cindent,     1,           'failed at #654')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #654')

  %delete

  " #655
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',              'failed at #655')
  call g:assert.equals(getline(2),   '    [',          'failed at #655')
  call g:assert.equals(getline(3),   '        foo',    'failed at #655')
  call g:assert.equals(getline(4),   '    ]',          'failed at #655')
  call g:assert.equals(getline(5),   '    }',          'failed at #655')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #655')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #655')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #655')
  call g:assert.equals(&l:autoindent,  1,              'failed at #655')
  call g:assert.equals(&l:smartindent, 1,              'failed at #655')
  call g:assert.equals(&l:cindent,     1,              'failed at #655')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #655')
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

  " #656
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #656')
  call g:assert.equals(getline(2),   'foo',        'failed at #656')
  call g:assert.equals(getline(3),   '    }',      'failed at #656')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #656')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #656')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #656')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #656')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #656')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #657
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #657')
  call g:assert.equals(getline(2),   '    foo',    'failed at #657')
  call g:assert.equals(getline(3),   '    }',      'failed at #657')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #657')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #657')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #657')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #657')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #657')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #658
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '{',          'failed at #658')
  call g:assert.equals(getline(2),   'foo',        'failed at #658')
  call g:assert.equals(getline(3),   '    }',      'failed at #658')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #658')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #658')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #658')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #658')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #658')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #659
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #659')
  call g:assert.equals(getline(2),   'foo',        'failed at #659')
  call g:assert.equals(getline(3),   '    }',      'failed at #659')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #659')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #659')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #659')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #659')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #659')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #660
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',     'failed at #660')
  call g:assert.equals(getline(2),   '    foo',       'failed at #660')
  call g:assert.equals(getline(3),   '            }', 'failed at #660')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #660')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #660')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #660')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #660')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #660')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #661
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^sr\<C-v>2i\"a"
  call g:assert.equals(getline(1),   '        {',  'failed at #661')
  call g:assert.equals(getline(2),   'foo',        'failed at #661')
  call g:assert.equals(getline(3),   '    }',      'failed at #661')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #661')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #661')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #661')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #661')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #661')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #662
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #662')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #662')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #662')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #662')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #662')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #662')

  %delete

  " #663
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #663')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #663')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #663')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #663')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #663')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #663')

  %delete

  " #664
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #664')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #664')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #664')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #664')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #664')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #664')

  %delete

  " #665
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #665')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #665')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #665')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #665')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #665')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #665')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #666
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #666')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #666')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #666')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #666')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #666')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #666')

  " #667
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #667')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #667')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #667')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #667')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #667')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #667')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #668
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #668')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #668')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #668')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #668')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #668')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #668')

  %delete

  " #669
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #669')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #669')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #669')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #669')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #669')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #669')

  %delete

  " #670
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #670')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #670')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #670')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #670')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #670')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #670')

  %delete

  " #671
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #671')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #671')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #671')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #671')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #671')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #671')

  %delete

  " #672
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #672')
  call g:assert.equals(getline(2),   'barbar',     'failed at #672')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #672')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #672')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #672')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #672')

  %delete

  " #673
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #673')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #673')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #673')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #673')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #673')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #673')

  %delete

  " #674
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #674')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #674')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #674')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #674')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #674')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #674')

  %delete

  " #675
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #675')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #675')
  call g:assert.equals(getline(3),   '[baaz]',     'failed at #675')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #675')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #675')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #675')

  %delete

  " #676
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsr["
  call g:assert.equals(getline(1),   '[fooo]',     'failed at #676')
  call g:assert.equals(getline(2),   '[baar]',     'failed at #676')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #676')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #676')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #676')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #676')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #677
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #677')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #677')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #677')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #677')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #677')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #677')

  %delete

  " #678
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #678')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #678')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #678')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #678')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #678')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #678')

  %delete

  " #679
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #679')
  call g:assert.equals(getline(2),   '',           'failed at #679')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #679')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #679')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #679')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #679')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #680
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #680')
  call g:assert.equals(getline(2),   '[b]',        'failed at #680')
  call g:assert.equals(getline(3),   '[c]',        'failed at #680')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #680')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #680')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #680')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #681
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #681')
  call g:assert.equals(getline(2),   '[]',         'failed at #681')
  call g:assert.equals(getline(3),   '[]',         'failed at #681')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #681')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #681')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #681')

  %delete

  " #682
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #682')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #682')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #682')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #682')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #682')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #682')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #683
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #683')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #683')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #683')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #683')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #683')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #683')

  %delete

  " #684
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #684')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #684')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #684')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #684')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #684')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #684')

  %delete

  " #685
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #685')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #685')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #685')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #685')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #685')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #685')

  %delete

  " #686
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #686')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #686')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #686')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #686')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #686')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #686')

  %delete

  " #687
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #687')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #687')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #687')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #687')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #687')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #687')
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

  " #688
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #688')
  call g:assert.equals(getline(2), '"bar"', 'failed at #688')
  call g:assert.equals(getline(3), '"baz"', 'failed at #688')

  %delete

  " #689
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #689')
  call g:assert.equals(getline(2), '"bar"', 'failed at #689')
  call g:assert.equals(getline(3), '"baz"', 'failed at #689')

  %delete

  " #690
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #690')
  call g:assert.equals(getline(2), '"bar"', 'failed at #690')
  call g:assert.equals(getline(3), '"baz"', 'failed at #690')

  %delete

  " #691
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #691')
  call g:assert.equals(getline(2), '"bar"', 'failed at #691')
  call g:assert.equals(getline(3), '"baz"', 'failed at #691')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #692
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #692')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #692')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #692')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #692')

  " #693
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #693')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #693')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #693')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #693')

  %delete

  """ keep
  " #694
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #694')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #694')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #694')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #694')

  " #695
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #695')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #695')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #695')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #695')

  %delete

  """ inner_tail
  " #696
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #696')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #696')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #696')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #696')

  " #697
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #697')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #697')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #697')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #697')

  %delete

  """ head
  " #698
  call operator#sandwich#set('replace', 'block', 'cursor', 'head')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #698')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #698')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #698')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #698')

  " #699
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #699')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #699')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #699')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #699')

  %delete

  """ tail
  " #700
  call operator#sandwich#set('replace', 'block', 'cursor', 'tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #700')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #700')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #700')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #700')

  " #701
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #701')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #701')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #701')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #701')

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
  " #702
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #702')
  call g:assert.equals(getline(2), '"bar"', 'failed at #702')
  call g:assert.equals(getline(3), '"baz"', 'failed at #702')

  %delete

  " #703
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #703')
  call g:assert.equals(getline(2), '(bar)', 'failed at #703')
  call g:assert.equals(getline(3), '(baz)', 'failed at #703')

  %delete

  """ off
  " #704
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #704')
  call g:assert.equals(getline(2), '{bar}', 'failed at #704')
  call g:assert.equals(getline(3), '{baz}', 'failed at #704')

  %delete

  " #705
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #705')
  call g:assert.equals(getline(2), '"bar"', 'failed at #705')
  call g:assert.equals(getline(3), '"baz"', 'failed at #705')

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
  " #706
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #706')
  call g:assert.equals(getline(2), '"bar"', 'failed at #706')
  call g:assert.equals(getline(3), '"baz"', 'failed at #706')

  %delete

  " #707
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #707')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #707')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #707')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #708
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #708')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #708')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #708')

  %delete

  " #709
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #709')
  call g:assert.equals(getline(2), '"bar"', 'failed at #709')
  call g:assert.equals(getline(3), '"baz"', 'failed at #709')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ 1
  " #710
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #710')
  call g:assert.equals(getline(2), '(bar)', 'failed at #710')
  call g:assert.equals(getline(3), '(baz)', 'failed at #710')

  %delete

  " #711
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #711')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #711')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #711')

  %delete

  " #712
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #712')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #712')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #712')

  %delete

  " #713
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #713')
  call g:assert.equals(getline(2), '("bar")', 'failed at #713')
  call g:assert.equals(getline(3), '("baz")', 'failed at #713')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'skip_space', 2)
  " #714
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #714')
  call g:assert.equals(getline(2), '(bar)', 'failed at #714')
  call g:assert.equals(getline(3), '(baz)', 'failed at #714')

  %delete

  " #715
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #715')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #715')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #715')

  %delete

  " #716
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #716')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #716')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #716')

  %delete

  " #717
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), ' (foo) ', 'failed at #717')
  call g:assert.equals(getline(2), ' (bar) ', 'failed at #717')
  call g:assert.equals(getline(3), ' (baz) ', 'failed at #717')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #718
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #718')
  call g:assert.equals(getline(2), '(bar)', 'failed at #718')
  call g:assert.equals(getline(3), '(baz)', 'failed at #718')

  %delete

  " #719
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #719')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #719')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #719')

  %delete

  " #720
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #720')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #720')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #720')

  %delete

  " #721
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #721')
  call g:assert.equals(getline(2), '("bar")', 'failed at #721')
  call g:assert.equals(getline(3), '("baz")', 'failed at #721')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #722
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #722')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #722')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #722')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #723
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #723')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #723')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #723')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #724
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '""', 'failed at #724')
  call g:assert.equals(getline(2), '""', 'failed at #724')
  call g:assert.equals(getline(3), '""', 'failed at #724')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #724
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #724')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #724')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #724')

  %delete

  """ on
  " #725
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #725')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #725')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #725')

  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #726
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #726')

  %delete

  """ 1
  " #727
  call operator#sandwich#set('replace', 'block', 'expr', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #727')

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

  " #728
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #728')
  call g:assert.equals(getline(2),   '[',          'failed at #728')
  call g:assert.equals(getline(3),   'foo',        'failed at #728')
  call g:assert.equals(getline(4),   ']',          'failed at #728')
  call g:assert.equals(getline(5),   '}',          'failed at #728')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #728')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #728')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #728')
  call g:assert.equals(&l:autoindent,  0,          'failed at #728')
  call g:assert.equals(&l:smartindent, 0,          'failed at #728')
  call g:assert.equals(&l:cindent,     0,          'failed at #728')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #728')

  %delete

  " #729
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #729')
  call g:assert.equals(getline(2),   '    [',      'failed at #729')
  call g:assert.equals(getline(3),   '    foo',    'failed at #729')
  call g:assert.equals(getline(4),   '    ]',      'failed at #729')
  call g:assert.equals(getline(5),   '    }',      'failed at #729')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #729')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #729')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #729')
  call g:assert.equals(&l:autoindent,  1,          'failed at #729')
  call g:assert.equals(&l:smartindent, 0,          'failed at #729')
  call g:assert.equals(&l:cindent,     0,          'failed at #729')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #729')

  %delete

  " #730
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #730')
  call g:assert.equals(getline(2),   '        [',   'failed at #730')
  call g:assert.equals(getline(3),   '        foo', 'failed at #730')
  call g:assert.equals(getline(4),   '    ]',       'failed at #730')
  call g:assert.equals(getline(5),   '}',           'failed at #730')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #730')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #730')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #730')
  call g:assert.equals(&l:autoindent,  1,           'failed at #730')
  call g:assert.equals(&l:smartindent, 1,           'failed at #730')
  call g:assert.equals(&l:cindent,     0,           'failed at #730')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #730')

  %delete

  " #731
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #731')
  call g:assert.equals(getline(2),   '    [',       'failed at #731')
  call g:assert.equals(getline(3),   '        foo', 'failed at #731')
  call g:assert.equals(getline(4),   '    ]',       'failed at #731')
  call g:assert.equals(getline(5),   '    }',       'failed at #731')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #731')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #731')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #731')
  call g:assert.equals(&l:autoindent,  1,           'failed at #731')
  call g:assert.equals(&l:smartindent, 1,           'failed at #731')
  call g:assert.equals(&l:cindent,     1,           'failed at #731')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #731')

  %delete

  " #732
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',           'failed at #732')
  call g:assert.equals(getline(2),   '            [',       'failed at #732')
  call g:assert.equals(getline(3),   '                foo', 'failed at #732')
  call g:assert.equals(getline(4),   '        ]',           'failed at #732')
  call g:assert.equals(getline(5),   '                }',   'failed at #732')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #732')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #732')
  " call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #732')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #732')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #732')
  call g:assert.equals(&l:cindent,     1,                   'failed at #732')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #732')

  %delete

  """ 0
  call operator#sandwich#set('replace', 'block', 'autoindent', 0)

  " #733
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #733')
  call g:assert.equals(getline(2),   '[',          'failed at #733')
  call g:assert.equals(getline(3),   'foo',        'failed at #733')
  call g:assert.equals(getline(4),   ']',          'failed at #733')
  call g:assert.equals(getline(5),   '}',          'failed at #733')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #733')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #733')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #733')
  call g:assert.equals(&l:autoindent,  0,          'failed at #733')
  call g:assert.equals(&l:smartindent, 0,          'failed at #733')
  call g:assert.equals(&l:cindent,     0,          'failed at #733')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #733')

  %delete

  " #734
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #734')
  call g:assert.equals(getline(2),   '[',          'failed at #734')
  call g:assert.equals(getline(3),   'foo',        'failed at #734')
  call g:assert.equals(getline(4),   ']',          'failed at #734')
  call g:assert.equals(getline(5),   '}',          'failed at #734')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #734')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #734')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #734')
  call g:assert.equals(&l:autoindent,  1,          'failed at #734')
  call g:assert.equals(&l:smartindent, 0,          'failed at #734')
  call g:assert.equals(&l:cindent,     0,          'failed at #734')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #734')

  %delete

  " #735
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #735')
  call g:assert.equals(getline(2),   '[',          'failed at #735')
  call g:assert.equals(getline(3),   'foo',        'failed at #735')
  call g:assert.equals(getline(4),   ']',          'failed at #735')
  call g:assert.equals(getline(5),   '}',          'failed at #735')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #735')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #735')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #735')
  call g:assert.equals(&l:autoindent,  1,          'failed at #735')
  call g:assert.equals(&l:smartindent, 1,          'failed at #735')
  call g:assert.equals(&l:cindent,     0,          'failed at #735')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #735')

  %delete

  " #736
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #736')
  call g:assert.equals(getline(2),   '[',          'failed at #736')
  call g:assert.equals(getline(3),   'foo',        'failed at #736')
  call g:assert.equals(getline(4),   ']',          'failed at #736')
  call g:assert.equals(getline(5),   '}',          'failed at #736')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #736')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #736')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #736')
  call g:assert.equals(&l:autoindent,  1,          'failed at #736')
  call g:assert.equals(&l:smartindent, 1,          'failed at #736')
  call g:assert.equals(&l:cindent,     1,          'failed at #736')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #736')

  %delete

  " #737
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #737')
  call g:assert.equals(getline(2),   '[',              'failed at #737')
  call g:assert.equals(getline(3),   'foo',            'failed at #737')
  call g:assert.equals(getline(4),   ']',              'failed at #737')
  call g:assert.equals(getline(5),   '}',              'failed at #737')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #737')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #737')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #737')
  call g:assert.equals(&l:autoindent,  1,              'failed at #737')
  call g:assert.equals(&l:smartindent, 1,              'failed at #737')
  call g:assert.equals(&l:cindent,     1,              'failed at #737')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #737')

  %delete

  """ 1
  call operator#sandwich#set('replace', 'block', 'autoindent', 1)

  " #738
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #738')
  call g:assert.equals(getline(2),   '    [',      'failed at #738')
  call g:assert.equals(getline(3),   '    foo',    'failed at #738')
  call g:assert.equals(getline(4),   '    ]',      'failed at #738')
  call g:assert.equals(getline(5),   '    }',      'failed at #738')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #738')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #738')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #738')
  call g:assert.equals(&l:autoindent,  0,          'failed at #738')
  call g:assert.equals(&l:smartindent, 0,          'failed at #738')
  call g:assert.equals(&l:cindent,     0,          'failed at #738')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #738')

  %delete

  " #739
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #739')
  call g:assert.equals(getline(2),   '    [',      'failed at #739')
  call g:assert.equals(getline(3),   '    foo',    'failed at #739')
  call g:assert.equals(getline(4),   '    ]',      'failed at #739')
  call g:assert.equals(getline(5),   '    }',      'failed at #739')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #739')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #739')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #739')
  call g:assert.equals(&l:autoindent,  1,          'failed at #739')
  call g:assert.equals(&l:smartindent, 0,          'failed at #739')
  call g:assert.equals(&l:cindent,     0,          'failed at #739')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #739')

  %delete

  " #740
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #740')
  call g:assert.equals(getline(2),   '    [',      'failed at #740')
  call g:assert.equals(getline(3),   '    foo',    'failed at #740')
  call g:assert.equals(getline(4),   '    ]',      'failed at #740')
  call g:assert.equals(getline(5),   '    }',      'failed at #740')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #740')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #740')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #740')
  call g:assert.equals(&l:autoindent,  1,          'failed at #740')
  call g:assert.equals(&l:smartindent, 1,          'failed at #740')
  call g:assert.equals(&l:cindent,     0,          'failed at #740')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #740')

  %delete

  " #741
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',      'failed at #741')
  call g:assert.equals(getline(2),   '    [',      'failed at #741')
  call g:assert.equals(getline(3),   '    foo',    'failed at #741')
  call g:assert.equals(getline(4),   '    ]',      'failed at #741')
  call g:assert.equals(getline(5),   '    }',      'failed at #741')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #741')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #741')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #741')
  call g:assert.equals(&l:autoindent,  1,          'failed at #741')
  call g:assert.equals(&l:smartindent, 1,          'failed at #741')
  call g:assert.equals(&l:cindent,     1,          'failed at #741')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #741')

  %delete

  " #742
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #742')
  call g:assert.equals(getline(2),   '    [',          'failed at #742')
  call g:assert.equals(getline(3),   '    foo',        'failed at #742')
  call g:assert.equals(getline(4),   '    ]',          'failed at #742')
  call g:assert.equals(getline(5),   '    }',          'failed at #742')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #742')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #742')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #742')
  call g:assert.equals(&l:autoindent,  1,              'failed at #742')
  call g:assert.equals(&l:smartindent, 1,              'failed at #742')
  call g:assert.equals(&l:cindent,     1,              'failed at #742')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #742')

  %delete

  """ 2
  call operator#sandwich#set('replace', 'block', 'autoindent', 2)

  " #743
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #743')
  call g:assert.equals(getline(2),   '        [',   'failed at #743')
  call g:assert.equals(getline(3),   '        foo', 'failed at #743')
  call g:assert.equals(getline(4),   '    ]',       'failed at #743')
  call g:assert.equals(getline(5),   '}',           'failed at #743')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #743')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #743')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #743')
  call g:assert.equals(&l:autoindent,  0,           'failed at #743')
  call g:assert.equals(&l:smartindent, 0,           'failed at #743')
  call g:assert.equals(&l:cindent,     0,           'failed at #743')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #743')

  %delete

  " #744
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #744')
  call g:assert.equals(getline(2),   '        [',   'failed at #744')
  call g:assert.equals(getline(3),   '        foo', 'failed at #744')
  call g:assert.equals(getline(4),   '    ]',       'failed at #744')
  call g:assert.equals(getline(5),   '}',           'failed at #744')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #744')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #744')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #744')
  call g:assert.equals(&l:autoindent,  1,           'failed at #744')
  call g:assert.equals(&l:smartindent, 0,           'failed at #744')
  call g:assert.equals(&l:cindent,     0,           'failed at #744')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #744')

  %delete

  " #745
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #745')
  call g:assert.equals(getline(2),   '        [',   'failed at #745')
  call g:assert.equals(getline(3),   '        foo', 'failed at #745')
  call g:assert.equals(getline(4),   '    ]',       'failed at #745')
  call g:assert.equals(getline(5),   '}',           'failed at #745')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #745')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #745')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #745')
  call g:assert.equals(&l:autoindent,  1,           'failed at #745')
  call g:assert.equals(&l:smartindent, 1,           'failed at #745')
  call g:assert.equals(&l:cindent,     0,           'failed at #745')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #745')

  %delete

  " #746
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',       'failed at #746')
  call g:assert.equals(getline(2),   '        [',   'failed at #746')
  call g:assert.equals(getline(3),   '        foo', 'failed at #746')
  call g:assert.equals(getline(4),   '    ]',       'failed at #746')
  call g:assert.equals(getline(5),   '}',           'failed at #746')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #746')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #746')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #746')
  call g:assert.equals(&l:autoindent,  1,           'failed at #746')
  call g:assert.equals(&l:smartindent, 1,           'failed at #746')
  call g:assert.equals(&l:cindent,     1,           'failed at #746')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #746')

  %delete

  " #747
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '    {',          'failed at #747')
  call g:assert.equals(getline(2),   '        [',      'failed at #747')
  call g:assert.equals(getline(3),   '        foo',    'failed at #747')
  call g:assert.equals(getline(4),   '    ]',          'failed at #747')
  call g:assert.equals(getline(5),   '}',              'failed at #747')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #747')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #747')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #747')
  call g:assert.equals(&l:autoindent,  1,              'failed at #747')
  call g:assert.equals(&l:smartindent, 1,              'failed at #747')
  call g:assert.equals(&l:cindent,     1,              'failed at #747')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #747')

  %delete

  """ 3
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #748
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #748')
  call g:assert.equals(getline(2),   '    [',       'failed at #748')
  call g:assert.equals(getline(3),   '        foo', 'failed at #748')
  call g:assert.equals(getline(4),   '    ]',       'failed at #748')
  call g:assert.equals(getline(5),   '    }',       'failed at #748')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #748')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #748')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #748')
  call g:assert.equals(&l:autoindent,  0,           'failed at #748')
  call g:assert.equals(&l:smartindent, 0,           'failed at #748')
  call g:assert.equals(&l:cindent,     0,           'failed at #748')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #748')

  %delete

  " #749
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #749')
  call g:assert.equals(getline(2),   '    [',       'failed at #749')
  call g:assert.equals(getline(3),   '        foo', 'failed at #749')
  call g:assert.equals(getline(4),   '    ]',       'failed at #749')
  call g:assert.equals(getline(5),   '    }',       'failed at #749')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #749')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #749')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #749')
  call g:assert.equals(&l:autoindent,  1,           'failed at #749')
  call g:assert.equals(&l:smartindent, 0,           'failed at #749')
  call g:assert.equals(&l:cindent,     0,           'failed at #749')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #749')

  %delete

  " #750
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #750')
  call g:assert.equals(getline(2),   '    [',       'failed at #750')
  call g:assert.equals(getline(3),   '        foo', 'failed at #750')
  call g:assert.equals(getline(4),   '    ]',       'failed at #750')
  call g:assert.equals(getline(5),   '    }',       'failed at #750')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #750')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #750')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #750')
  call g:assert.equals(&l:autoindent,  1,           'failed at #750')
  call g:assert.equals(&l:smartindent, 1,           'failed at #750')
  call g:assert.equals(&l:cindent,     0,           'failed at #750')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #750')

  %delete

  " #751
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',           'failed at #751')
  call g:assert.equals(getline(2),   '    [',       'failed at #751')
  call g:assert.equals(getline(3),   '        foo', 'failed at #751')
  call g:assert.equals(getline(4),   '    ]',       'failed at #751')
  call g:assert.equals(getline(5),   '    }',       'failed at #751')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #751')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #751')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #751')
  call g:assert.equals(&l:autoindent,  1,           'failed at #751')
  call g:assert.equals(&l:smartindent, 1,           'failed at #751')
  call g:assert.equals(&l:cindent,     1,           'failed at #751')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #751')

  %delete

  " #752
  setlocal indentexpr=TestIndent()
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',              'failed at #752')
  call g:assert.equals(getline(2),   '    [',          'failed at #752')
  call g:assert.equals(getline(3),   '        foo',    'failed at #752')
  call g:assert.equals(getline(4),   '    ]',          'failed at #752')
  call g:assert.equals(getline(5),   '    }',          'failed at #752')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #752')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #752')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #752')
  call g:assert.equals(&l:autoindent,  1,              'failed at #752')
  call g:assert.equals(&l:smartindent, 1,              'failed at #752')
  call g:assert.equals(&l:cindent,     1,              'failed at #752')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #752')
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

  " #753
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #753')
  call g:assert.equals(getline(2),   'foo',        'failed at #753')
  call g:assert.equals(getline(3),   '    }',      'failed at #753')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #753')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #753')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #753')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #753')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #753')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #754
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #754')
  call g:assert.equals(getline(2),   '    foo',    'failed at #754')
  call g:assert.equals(getline(3),   '    }',      'failed at #754')
  " call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #754')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #754')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #754')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #754')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #754')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', 3)

  " #755
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '{',          'failed at #755')
  call g:assert.equals(getline(2),   'foo',        'failed at #755')
  call g:assert.equals(getline(3),   '    }',      'failed at #755')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #755')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #755')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #755')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #755')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #755')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #756
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #756')
  call g:assert.equals(getline(2),   'foo',        'failed at #756')
  call g:assert.equals(getline(3),   '    }',      'failed at #756')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #756')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #756')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #756')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #756')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #756')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #757
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',     'failed at #757')
  call g:assert.equals(getline(2),   '    foo',       'failed at #757')
  call g:assert.equals(getline(3),   '            }', 'failed at #757')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #757')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #757')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #757')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #757')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #757')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('replace', 'block', 'autoindent', -1)

  " #758
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('replace', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    "foo"')
  execute "normal ^\<C-v>2i\"sra"
  call g:assert.equals(getline(1),   '        {',  'failed at #758')
  call g:assert.equals(getline(2),   'foo',        'failed at #758')
  call g:assert.equals(getline(3),   '    }',      'failed at #758')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #758')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #758')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #758')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #758')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #758')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssr <Esc>:call operator#sandwich#prerequisite('replace', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #759
  call setline('.', '(foo)')
  normal 0sra([
  call g:assert.equals(getline('.'), '(foo)',      'failed at #759')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #759')

  " #760
  call setline('.', '[foo]')
  normal 0sra[(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #760')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #760')

  " #761
  call setline('.', '(foo)')
  normal 0ssra([
  call g:assert.equals(getline('.'), '[foo[',      'failed at #761')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #761')

  " #762
  call setline('.', '[foo]')
  normal 0ssra[(
  call g:assert.equals(getline('.'), '[foo]',      'failed at #762')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #762')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #763
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sr$"
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #763')

  " #764
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sr$""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #764')

  " #765
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sr$"""
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #765')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
