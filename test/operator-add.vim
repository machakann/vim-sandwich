scriptencoding utf-8

let s:suite = themis#suite('operator-sandwich: add:')
let s:object = 'g:operator#sandwich#object'

function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
  set ambiwidth&
  set expandtab
  set shiftwidth&
  set softtabstop&
  set autoindent&
  set smartindent&
  set cindent&
  set indentexpr&
  silent! mapc!
  silent! ounmap ii
  silent! ounmap ssa
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
  let g:operator#sandwich#recipes = [{'buns': ['(', ')']}]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'input': ['a', 'b']}]

  " #2
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline('.'), '(foo)', 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(', 'failed at #4')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['`', '`']},
        \   {'buns': ['``', '``']},
        \   {'buns': ['```', '```']},
        \ ]

  " #5
  call setline('.', 'foo')
  normal 0saiw`
  call g:assert.equals(getline('.'), '`foo`', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 0saiw``
  call g:assert.equals(getline('.'), '``foo``', 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '``foo``', 'failed at #8')

  " #9
  call setline('.', 'foo')
  normal 0saiw```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #9')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #10
  call setline('.', 'foo')
  normal 0saiw`
  call g:assert.equals(getline('.'), '`foo`', 'failed at #10')

  " #11
  call setline('.', 'foo')
  normal 0saiw`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #11')

  " #12
  call setline('.', 'foo')
  normal 0saiw``
  call g:assert.equals(getline('.'), '`foo`', 'failed at #12')

  " #13
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #13')

  " #14
  call setline('.', 'foo')
  normal 0saiw```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #14')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #15
  call setline('.', 'foo')
  normal 0saiw`
  call g:assert.equals(getline('.'), '"foo"', 'failed at #15')

  " #16
  call setline('.', 'foo')
  normal 0saiw`h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #16')

  " #17
  call setline('.', 'foo')
  normal 0saiw``
  call g:assert.equals(getline('.'), '"foo"', 'failed at #17')

  " #18
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #18')

  " #19
  call setline('.', 'foo')
  normal 0saiw```
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
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #20')

  " #21
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #21')

  " #22
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #22')

  set filetype=vim

  " #23
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #23')

  " #24
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #24')

  " #25
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo<', 'failed at #25')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #26
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \ ]

  " #27
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #27')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['delete'], 'input': ['(', ')']},
        \ ]

  " #28
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #28')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['replace'], 'input': ['(', ')']},
        \ ]

  " #29
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #29')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['operator'], 'input': ['(', ')']},
        \ ]

  " #30
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #30')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #31
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #31')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #32
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #32')

  " #33
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #33')

  " #34
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #34')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['(', ')']},
        \ ]

  " #35
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #35')

  " #36
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #36')

  " #37
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #37')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['(', ')']},
        \ ]

  " #38
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #38')

  " #39
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #39')

  " #40
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #40')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['(', ')']},
        \ ]

  " #41
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #41')

  " #42
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #42')

  " #43
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #43')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['(', ')']},
        \ ]

  " #44
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #44')

  " #45
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #45')

  " #46
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #46')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #47
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #47')

  " #48
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #48')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['(', ')']},
        \ ]

  " #49
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #49')

  " #50
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #50')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #51
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #51')

  " #52
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #52')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #53
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #53')

  " #54
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #54')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['(', ')']},
        \ ]

  " #55
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #55')

  " #56
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #56')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['(', ')']},
        \ ]

  " #57
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #57')

  " #58
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #58')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['(', ')']},
        \ ]

  " #59
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #59')

  " #60
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #60')
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

  " #61
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #61')

  " #62
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #62')

  " #63
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #63')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #64
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #64')

  " #65
  call setline('.', 'foo')
  normal 0saiw)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #65')

  " #66
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #66')

  " #67
  call setline('.', 'foo')
  normal 0saiw]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #67')

  " #68
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #68')

  " #69
  call setline('.', 'foo')
  normal 0saiw}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #69')

  " #70
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #70')

  " #71
  call setline('.', 'foo')
  normal 0saiw>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #71')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #72
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #72')

  " #73
  call setline('.', 'foo')
  normal 0saiw*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #73')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #74
  call setline('.', 'foobar')
  normal 0sa3l(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #74')

  " #75
  call setline('.', 'foobar')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #75')

  " #76
  call setline('.', 'foobarbaz')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #76')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #77
  call setline('.', 'foobarbaz')
  normal 0saii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #77')

  " #78
  call setline('.', 'foobarbaz')
  normal 02lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #78')

  " #79
  call setline('.', 'foobarbaz')
  normal 03lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #79')

  " #80
  call setline('.', 'foobarbaz')
  normal 05lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #80')

  " #81
  call setline('.', 'foobarbaz')
  normal 06lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #81')

  " #82
  call setline('.', 'foobarbaz')
  normal 08lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #82')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  %delete

  " #83
  set whichwrap=h,l
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa11l(
  call g:assert.equals(getline(1),   '(foo',       'failed at #83')
  call g:assert.equals(getline(2),   'bar',        'failed at #83')
  call g:assert.equals(getline(3),   'baz)',       'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #83')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #84
  call setline('.', 'a')
  normal 0sal(
  call g:assert.equals(getline('.'), '(a)',        'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #84')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \   {'buns': ["cc\n cc", "ccc\n  "], 'input':['c']},
        \ ]

  " #85
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1),   'aa',         'failed at #85')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #85')
  call g:assert.equals(getline(3),   'aa',         'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #85')

  %delete

  " #86
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline(1),   'bb',         'failed at #86')
  call g:assert.equals(getline(2),   'bbb',        'failed at #86')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #86')
  call g:assert.equals(getline(4),   'bbb',        'failed at #86')
  call g:assert.equals(getline(5),   'bb',         'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #86')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #87
  call setline('.', 'foobarbaz')
  normal ggsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #87')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #87')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #87')

  %delete

  " #88
  call setline('.', 'foobarbaz')
  normal gg2lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #88')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #88')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #88')

  %delete

  " #89
  call setline('.', 'foobarbaz')
  normal gg3lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #89')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #89')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #89')

  %delete

  " #90
  call setline('.', 'foobarbaz')
  normal gg5lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #90')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #90')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #90')

  %delete

  " #91
  call setline('.', 'foobarbaz')
  normal gg6lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #91')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #91')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #91')

  %delete

  " #92
  call setline('.', 'foobarbaz')
  normal gg$saiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #92')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #92')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #92')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #92')

  %delete

  set autoindent
  onoremap ii :<C-u>call TextobjCoord(1, 8, 1, 10)<CR>

  " #93
  call setline('.', '    foobarbaz')
  normal ggsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #93')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #93')
  call g:assert.equals(getline(3),   '      baz',     'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],    'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #93')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #93')

  %delete

  " #94
  call setline('.', '    foobarbaz')
  normal gg2lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #94')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #94')
  call g:assert.equals(getline(3),   '      baz',     'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],    'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #94')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #94')

  %delete

  " #95
  call setline('.', '    foobarbaz')
  normal gg3lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #95')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #95')
  call g:assert.equals(getline(3),   '      baz',     'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0],    'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #95')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #95')

  %delete

  " #96
  call setline('.', '    foobarbaz')
  normal gg5lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #96')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #96')
  call g:assert.equals(getline(3),   '      baz',     'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 2, 10, 0],   'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #96')
  call g:assert.equals(getpos("']"), [0, 3,  7, 0],   'failed at #96')

  %delete

  " #97
  call setline('.', '    foobarbaz')
  normal gg6lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #97')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #97')
  call g:assert.equals(getline(3),   '      baz',     'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0],    'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #97')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #97')

  %delete

  " #98
  call setline('.', '    foobarbaz')
  normal gg$saiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #98')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #98')
  call g:assert.equals(getline(3),   '      baz',     'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #98')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #98')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #99
  call setline('.', 'foo')
  normal 02saiw([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #99')

  " #100
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #100')

  " #101
  call setline('.', 'foo bar')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #101')

  " #102
  call setline('.', 'foo bar')
  normal 0sa3iw(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #102')

  " #103
  call setline('.', 'foo bar')
  normal 02sa3iw([
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #103')

  " #104
  call setline('.', 'foobarbaz')
  normal 03l2sa3l([
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #104')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #104')

  " #105
  call setline('.', 'foobarbaz')
  normal 03l3sa3l([{
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #105')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #105')
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #106
  call setline('.', 'α')
  normal 0sal(
  call g:assert.equals(getline('.'), '(α)',       'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #106')

  " #107
  call setline('.', 'aα')
  normal 0sa2l(
  call g:assert.equals(getline('.'), '(aα)',      'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #107')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #108
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'αaα',      'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #108')

  " #109
  call setline('.', 'α')
  normal 0sala
  call g:assert.equals(getline('.'), 'ααα',      'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #109')

  " #110
  call setline('.', 'aα')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'αaαα',    'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #110')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #111
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'aαaaα',    'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #111')

  " #112
  call setline('.', 'α')
  normal 0sala
  call g:assert.equals(getline('.'), 'aααaα',   'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #112')

  " #113
  call setline('.', 'aα')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'aαaαaα',  'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #113')

  unlet g:operator#sandwich#recipes

  " #114
  call setline('.', '“')
  normal 0sal(
  call g:assert.equals(getline('.'), '(“)',       'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #114')

  " #115
  call setline('.', 'a“')
  normal 0sa2l(
  call g:assert.equals(getline('.'), '(a“)',      'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #115')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #116
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), '“a“',      'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #116')

  " #117
  call setline('.', '“')
  normal 0sala
  call g:assert.equals(getline('.'), '“““',      'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #117')

  " #118
  call setline('.', 'a“')
  normal 0sa2la
  call g:assert.equals(getline('.'), '“a““',    'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #118')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #119
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'a“aa“',    'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #119')

  " #120
  call setline('.', '“')
  normal 0sala
  call g:assert.equals(getline('.'), 'a““a“',   'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #120')

  " #121
  call setline('.', 'a“')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'a“a“a“',  'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #121')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #122
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #122')

  " #123
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #123')

  """ keep
  " #124
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #124')

  " #125
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #125')

  """ inner_tail
  " #126
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #126')

  " #127
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #127')

  """ head
  " #128
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')

  " #129
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #129')

  """ tail
  " #130
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #130')

  " #131
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #131')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #132
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #132')

  %delete

  """ on
  " #133
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #133')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #134
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #134')

  """ 1
  " #135
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #135')

  " #136
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline('.'), 'foo',  'failed at #136')
  call g:assert.equals(exists(s:object), 0,  'failed at #136')

  " #137
  call setline('.', 'foo')
  normal 0saiwc
  call g:assert.equals(getline('.'), 'foo',  'failed at #137')
  call g:assert.equals(exists(s:object), 0,  'failed at #137')

  " #138
  call setline('.', 'foo')
  normal 02saiwab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #138')
  call g:assert.equals(exists(s:object), 0,   'failed at #138')

  " #139
  call setline('.', 'foo')
  normal 02saiwac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #139')
  call g:assert.equals(exists(s:object), 0,   'failed at #139')

  " #140
  call setline('.', 'foo')
  normal 02saiwba
  call g:assert.equals(getline('.'), 'foo', 'failed at #140')
  call g:assert.equals(exists(s:object), 0, 'failed at #140')

  " #141
  call setline('.', 'foo')
  normal 02saiwbc
  call g:assert.equals(getline('.'), 'foo', 'failed at #141')
  call g:assert.equals(exists(s:object), 0, 'failed at #141')

  " #142
  call setline('.', 'foo')
  normal 0saiwd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #142')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'char', 'expr', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #143
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #143')

  """ off
  " #144
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #144')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #145
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #145')

  """ on
  " #146
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #146')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  """"" command
  " #147
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  normal 0ffsaiw(
  call g:assert.equals(getline('.'), '""',  'failed at #147')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #148
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #148')
  call g:assert.equals(getline(2), 'foo', 'failed at #148')
  call g:assert.equals(getline(3), ')',   'failed at #148')

  %delete

  " #149
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #149')
  call g:assert.equals(getline(2),   '    foo',    'failed at #149')
  call g:assert.equals(getline(3),   '    )',      'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #149')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
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
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #150
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #150')
  call g:assert.equals(getline(2),   '[',          'failed at #150')
  call g:assert.equals(getline(3),   'foo',        'failed at #150')
  call g:assert.equals(getline(4),   ']',          'failed at #150')
  call g:assert.equals(getline(5),   '}',          'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #150')
  call g:assert.equals(&l:autoindent,  0,          'failed at #150')
  call g:assert.equals(&l:smartindent, 0,          'failed at #150')
  call g:assert.equals(&l:cindent,     0,          'failed at #150')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #150')

  %delete

  " #151
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #151')
  call g:assert.equals(getline(2),   '    [',      'failed at #151')
  call g:assert.equals(getline(3),   '    foo',    'failed at #151')
  call g:assert.equals(getline(4),   '    ]',      'failed at #151')
  call g:assert.equals(getline(5),   '    }',      'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #151')
  call g:assert.equals(&l:autoindent,  1,          'failed at #151')
  call g:assert.equals(&l:smartindent, 0,          'failed at #151')
  call g:assert.equals(&l:cindent,     0,          'failed at #151')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #151')

  %delete

  " #152
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #152')
  call g:assert.equals(getline(2),   '        [',   'failed at #152')
  call g:assert.equals(getline(3),   '        foo', 'failed at #152')
  call g:assert.equals(getline(4),   '    ]',       'failed at #152')
  call g:assert.equals(getline(5),   '}',           'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #152')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #152')
  call g:assert.equals(&l:autoindent,  1,           'failed at #152')
  call g:assert.equals(&l:smartindent, 1,           'failed at #152')
  call g:assert.equals(&l:cindent,     0,           'failed at #152')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #152')

  %delete

  " #153
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #153')
  call g:assert.equals(getline(2),   '    [',       'failed at #153')
  call g:assert.equals(getline(3),   '        foo', 'failed at #153')
  call g:assert.equals(getline(4),   '    ]',       'failed at #153')
  call g:assert.equals(getline(5),   '    }',       'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #153')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #153')
  call g:assert.equals(&l:autoindent,  1,           'failed at #153')
  call g:assert.equals(&l:smartindent, 1,           'failed at #153')
  call g:assert.equals(&l:cindent,     1,           'failed at #153')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #153')

  %delete

  " #154
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',           'failed at #154')
  call g:assert.equals(getline(2),   '            [',       'failed at #154')
  call g:assert.equals(getline(3),   '                foo', 'failed at #154')
  call g:assert.equals(getline(4),   '        ]',           'failed at #154')
  call g:assert.equals(getline(5),   '                }',   'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #154')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #154')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #154')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #154')
  call g:assert.equals(&l:cindent,     1,                   'failed at #154')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #154')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #155
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #155')
  call g:assert.equals(getline(2),   '[',          'failed at #155')
  call g:assert.equals(getline(3),   'foo',        'failed at #155')
  call g:assert.equals(getline(4),   ']',          'failed at #155')
  call g:assert.equals(getline(5),   '}',          'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #155')
  call g:assert.equals(&l:autoindent,  0,          'failed at #155')
  call g:assert.equals(&l:smartindent, 0,          'failed at #155')
  call g:assert.equals(&l:cindent,     0,          'failed at #155')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #155')

  %delete

  " #156
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #156')
  call g:assert.equals(getline(2),   '[',          'failed at #156')
  call g:assert.equals(getline(3),   'foo',        'failed at #156')
  call g:assert.equals(getline(4),   ']',          'failed at #156')
  call g:assert.equals(getline(5),   '}',          'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #156')
  call g:assert.equals(&l:autoindent,  1,          'failed at #156')
  call g:assert.equals(&l:smartindent, 0,          'failed at #156')
  call g:assert.equals(&l:cindent,     0,          'failed at #156')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #156')

  %delete

  " #157
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #157')
  call g:assert.equals(getline(2),   '[',          'failed at #157')
  call g:assert.equals(getline(3),   'foo',        'failed at #157')
  call g:assert.equals(getline(4),   ']',          'failed at #157')
  call g:assert.equals(getline(5),   '}',          'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #157')
  call g:assert.equals(&l:autoindent,  1,          'failed at #157')
  call g:assert.equals(&l:smartindent, 1,          'failed at #157')
  call g:assert.equals(&l:cindent,     0,          'failed at #157')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #157')

  %delete

  " #158
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #158')
  call g:assert.equals(getline(2),   '[',          'failed at #158')
  call g:assert.equals(getline(3),   'foo',        'failed at #158')
  call g:assert.equals(getline(4),   ']',          'failed at #158')
  call g:assert.equals(getline(5),   '}',          'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #158')
  call g:assert.equals(&l:autoindent,  1,          'failed at #158')
  call g:assert.equals(&l:smartindent, 1,          'failed at #158')
  call g:assert.equals(&l:cindent,     1,          'failed at #158')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #158')

  %delete

  " #159
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #159')
  call g:assert.equals(getline(2),   '[',              'failed at #159')
  call g:assert.equals(getline(3),   'foo',            'failed at #159')
  call g:assert.equals(getline(4),   ']',              'failed at #159')
  call g:assert.equals(getline(5),   '}',              'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #159')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #159')
  call g:assert.equals(&l:autoindent,  1,              'failed at #159')
  call g:assert.equals(&l:smartindent, 1,              'failed at #159')
  call g:assert.equals(&l:cindent,     1,              'failed at #159')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #159')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #160
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #160')
  call g:assert.equals(getline(2),   '    [',      'failed at #160')
  call g:assert.equals(getline(3),   '    foo',    'failed at #160')
  call g:assert.equals(getline(4),   '    ]',      'failed at #160')
  call g:assert.equals(getline(5),   '    }',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #160')
  call g:assert.equals(&l:autoindent,  0,          'failed at #160')
  call g:assert.equals(&l:smartindent, 0,          'failed at #160')
  call g:assert.equals(&l:cindent,     0,          'failed at #160')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #160')

  %delete

  " #161
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #161')
  call g:assert.equals(getline(2),   '    [',      'failed at #161')
  call g:assert.equals(getline(3),   '    foo',    'failed at #161')
  call g:assert.equals(getline(4),   '    ]',      'failed at #161')
  call g:assert.equals(getline(5),   '    }',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #161')
  call g:assert.equals(&l:autoindent,  1,          'failed at #161')
  call g:assert.equals(&l:smartindent, 0,          'failed at #161')
  call g:assert.equals(&l:cindent,     0,          'failed at #161')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #161')

  %delete

  " #162
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #162')
  call g:assert.equals(getline(2),   '    [',      'failed at #162')
  call g:assert.equals(getline(3),   '    foo',    'failed at #162')
  call g:assert.equals(getline(4),   '    ]',      'failed at #162')
  call g:assert.equals(getline(5),   '    }',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #162')
  call g:assert.equals(&l:autoindent,  1,          'failed at #162')
  call g:assert.equals(&l:smartindent, 1,          'failed at #162')
  call g:assert.equals(&l:cindent,     0,          'failed at #162')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #162')

  %delete

  " #163
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #163')
  call g:assert.equals(getline(2),   '    [',      'failed at #163')
  call g:assert.equals(getline(3),   '    foo',    'failed at #163')
  call g:assert.equals(getline(4),   '    ]',      'failed at #163')
  call g:assert.equals(getline(5),   '    }',      'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #163')
  call g:assert.equals(&l:autoindent,  1,          'failed at #163')
  call g:assert.equals(&l:smartindent, 1,          'failed at #163')
  call g:assert.equals(&l:cindent,     1,          'failed at #163')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #163')

  %delete

  " #164
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #164')
  call g:assert.equals(getline(2),   '    [',          'failed at #164')
  call g:assert.equals(getline(3),   '    foo',        'failed at #164')
  call g:assert.equals(getline(4),   '    ]',          'failed at #164')
  call g:assert.equals(getline(5),   '    }',          'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #164')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #164')
  call g:assert.equals(&l:autoindent,  1,              'failed at #164')
  call g:assert.equals(&l:smartindent, 1,              'failed at #164')
  call g:assert.equals(&l:cindent,     1,              'failed at #164')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #164')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #165
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #165')
  call g:assert.equals(getline(2),   '        [',   'failed at #165')
  call g:assert.equals(getline(3),   '        foo', 'failed at #165')
  call g:assert.equals(getline(4),   '    ]',       'failed at #165')
  call g:assert.equals(getline(5),   '}',           'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #165')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #165')
  call g:assert.equals(&l:autoindent,  0,           'failed at #165')
  call g:assert.equals(&l:smartindent, 0,           'failed at #165')
  call g:assert.equals(&l:cindent,     0,           'failed at #165')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #165')

  %delete

  " #166
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #166')
  call g:assert.equals(getline(2),   '        [',   'failed at #166')
  call g:assert.equals(getline(3),   '        foo', 'failed at #166')
  call g:assert.equals(getline(4),   '    ]',       'failed at #166')
  call g:assert.equals(getline(5),   '}',           'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #166')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #166')
  call g:assert.equals(&l:autoindent,  1,           'failed at #166')
  call g:assert.equals(&l:smartindent, 0,           'failed at #166')
  call g:assert.equals(&l:cindent,     0,           'failed at #166')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #166')

  %delete

  " #167
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #167')
  call g:assert.equals(getline(2),   '        [',   'failed at #167')
  call g:assert.equals(getline(3),   '        foo', 'failed at #167')
  call g:assert.equals(getline(4),   '    ]',       'failed at #167')
  call g:assert.equals(getline(5),   '}',           'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #167')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #167')
  call g:assert.equals(&l:autoindent,  1,           'failed at #167')
  call g:assert.equals(&l:smartindent, 1,           'failed at #167')
  call g:assert.equals(&l:cindent,     0,           'failed at #167')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #167')

  %delete

  " #168
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #168')
  call g:assert.equals(getline(2),   '        [',   'failed at #168')
  call g:assert.equals(getline(3),   '        foo', 'failed at #168')
  call g:assert.equals(getline(4),   '    ]',       'failed at #168')
  call g:assert.equals(getline(5),   '}',           'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #168')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #168')
  call g:assert.equals(&l:autoindent,  1,           'failed at #168')
  call g:assert.equals(&l:smartindent, 1,           'failed at #168')
  call g:assert.equals(&l:cindent,     1,           'failed at #168')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #168')

  %delete

  " #169
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #169')
  call g:assert.equals(getline(2),   '        [',      'failed at #169')
  call g:assert.equals(getline(3),   '        foo',    'failed at #169')
  call g:assert.equals(getline(4),   '    ]',          'failed at #169')
  call g:assert.equals(getline(5),   '}',              'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #169')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #169')
  call g:assert.equals(&l:autoindent,  1,              'failed at #169')
  call g:assert.equals(&l:smartindent, 1,              'failed at #169')
  call g:assert.equals(&l:cindent,     1,              'failed at #169')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #169')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #170
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #170')
  call g:assert.equals(getline(2),   '    [',       'failed at #170')
  call g:assert.equals(getline(3),   '        foo', 'failed at #170')
  call g:assert.equals(getline(4),   '    ]',       'failed at #170')
  call g:assert.equals(getline(5),   '    }',       'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #170')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #170')
  call g:assert.equals(&l:autoindent,  0,           'failed at #170')
  call g:assert.equals(&l:smartindent, 0,           'failed at #170')
  call g:assert.equals(&l:cindent,     0,           'failed at #170')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #170')

  %delete

  " #171
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #171')
  call g:assert.equals(getline(2),   '    [',       'failed at #171')
  call g:assert.equals(getline(3),   '        foo', 'failed at #171')
  call g:assert.equals(getline(4),   '    ]',       'failed at #171')
  call g:assert.equals(getline(5),   '    }',       'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #171')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #171')
  call g:assert.equals(&l:autoindent,  1,           'failed at #171')
  call g:assert.equals(&l:smartindent, 0,           'failed at #171')
  call g:assert.equals(&l:cindent,     0,           'failed at #171')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #171')

  %delete

  " #172
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #172')
  call g:assert.equals(getline(2),   '    [',       'failed at #172')
  call g:assert.equals(getline(3),   '        foo', 'failed at #172')
  call g:assert.equals(getline(4),   '    ]',       'failed at #172')
  call g:assert.equals(getline(5),   '    }',       'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #172')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #172')
  call g:assert.equals(&l:autoindent,  1,           'failed at #172')
  call g:assert.equals(&l:smartindent, 1,           'failed at #172')
  call g:assert.equals(&l:cindent,     0,           'failed at #172')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #172')

  %delete

  " #173
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #173')
  call g:assert.equals(getline(2),   '    [',       'failed at #173')
  call g:assert.equals(getline(3),   '        foo', 'failed at #173')
  call g:assert.equals(getline(4),   '    ]',       'failed at #173')
  call g:assert.equals(getline(5),   '    }',       'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #173')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #173')
  call g:assert.equals(&l:autoindent,  1,           'failed at #173')
  call g:assert.equals(&l:smartindent, 1,           'failed at #173')
  call g:assert.equals(&l:cindent,     1,           'failed at #173')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #173')

  %delete

  " #174
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',              'failed at #174')
  call g:assert.equals(getline(2),   '    [',          'failed at #174')
  call g:assert.equals(getline(3),   '        foo',    'failed at #174')
  call g:assert.equals(getline(4),   '    ]',          'failed at #174')
  call g:assert.equals(getline(5),   '    }',          'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #174')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #174')
  call g:assert.equals(&l:autoindent,  1,              'failed at #174')
  call g:assert.equals(&l:smartindent, 1,              'failed at #174')
  call g:assert.equals(&l:cindent,     1,              'failed at #174')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #174')
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
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #175
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #175')
  call g:assert.equals(getline(2),   'foo',        'failed at #175')
  call g:assert.equals(getline(3),   '    }',      'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #175')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #175')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #175')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #176
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #176')
  call g:assert.equals(getline(2),   '    foo',    'failed at #176')
  call g:assert.equals(getline(3),   '    }',      'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #176')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #176')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #176')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #176')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #176')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #177
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #177')
  call g:assert.equals(getline(2),   'foo',        'failed at #177')
  call g:assert.equals(getline(3),   '    }',      'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #177')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #177')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #177')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #178
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #178')
  call g:assert.equals(getline(2),   'foo',        'failed at #178')
  call g:assert.equals(getline(3),   '    }',      'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #178')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #178')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #178')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #178')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #179
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',     'failed at #179')
  call g:assert.equals(getline(2),   '    foo',       'failed at #179')
  call g:assert.equals(getline(3),   '            }', 'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #179')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #179')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #179')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #179')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #179')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #180
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #180')
  call g:assert.equals(getline(2),   'foo',        'failed at #180')
  call g:assert.equals(getline(3),   '    }',      'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #180')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #180')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #180')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #180')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #181
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'ailed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'ailed at #181')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'ailed at #181')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'ailed at #181')

  " #182
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #182')

  " #183
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #183')

  " #184
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #184')

  " #185
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #185')

  " #186
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #186')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #186')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #186')

  " #187
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #187')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #187')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #187')

  " #188
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #188')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #188')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #189
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #189')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #189')

  " #190
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #190')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #190')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #191
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #191')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #191')

  " #192
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #192')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #192')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #192')

  " #193
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #193')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #193')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #193')

  " #194
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #194')
  call g:assert.equals(getline(2),   'bar',        'failed at #194')
  call g:assert.equals(getline(3),   'baz)',       'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #194')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #194')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #195
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #195')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #195')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  " #196
  call append(0, ['', 'foo'])
  normal ggvj$sa(
  call g:assert.equals(getline(1), '(',    'failed at #196')
  call g:assert.equals(getline(2), 'foo)', 'failed at #196')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #196')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #196')
  " call g:assert.equals(getpos("']"), [0, 2, 5, 0], 'failed at #196')

  %delete

  " #197
  call append(0, ['foo', ''])
  normal ggvjsa(
  call g:assert.equals(getline(1), '(foo', 'failed at #197')
  call g:assert.equals(getline(2), ')',    'failed at #197')
  " call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #197')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  " call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #197')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #198
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #198')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #198')
  call g:assert.equals(getline(3), 'aa',           'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #198')

  %delete

  " #199
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #199')
  call g:assert.equals(getline(2),   'bbb',        'failed at #199')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #199')
  call g:assert.equals(getline(4),   'bbb',        'failed at #199')
  call g:assert.equals(getline(5),   'bb',         'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #199')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #200
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #200')

  " #201
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #201')
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #202
  call setline('.', 'α')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(α)',       'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #202')

  " #203
  call setline('.', 'aα')
  normal 0vlsa(
  call g:assert.equals(getline('.'), '(aα)',      'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #203')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #204
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'αaα',      'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #204')

  " #205
  call setline('.', 'α')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'ααα',      'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #205')

  " #206
  call setline('.', 'aα')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'αaαα',    'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #206')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #207
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'aαaaα',    'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #207')

  " #208
  call setline('.', 'α')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'aααaα',   'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #208')

  " #209
  call setline('.', 'aα')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'aαaαaα',  'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #209')

  unlet g:operator#sandwich#recipes

  " #210
  call setline('.', '“')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(“)',       'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #210')

  " #211
  call setline('.', 'a“')
  normal 0vlsa(
  call g:assert.equals(getline('.'), '(a“)',      'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #211')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #212
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), '“a“',      'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #212')

  " #213
  call setline('.', '“')
  normal 0vsaa
  call g:assert.equals(getline('.'), '“““',      'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #213')

  " #214
  call setline('.', 'a“')
  normal 0vlsaa
  call g:assert.equals(getline('.'), '“a““',    'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #214')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #215
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'a“aa“',    'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #215')

  " #216
  call setline('.', '“')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'a““a“',   'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #216')

  " #217
  call setline('.', 'a“')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'a“a“a“',  'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #217')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #218
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #218')

  " #219
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #219')

  """ keep
  " #220
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #220')

  " #221
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #221')

  """ inner_tail
  " #222
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #222')

  " #223
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #223')

  """ head
  " #224
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #224')

  " #225
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #225')

  """ tail
  " #226
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #226')

  " #227
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #227')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #228
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #228')

  """ on
  " #229
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #229')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #230
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #230')

  """ 1
  " #231
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #231')

  " #232
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline('.'), 'foo', 'failed at #232')
  call g:assert.equals(exists(s:object), 0, 'failed at #232')

  " #233
  call setline('.', 'foo')
  normal 0viwsac
  call g:assert.equals(getline('.'), 'foo', 'failed at #233')
  call g:assert.equals(exists(s:object), 0, 'failed at #233')

  " #234
  call setline('.', 'foo')
  normal 0viw2saab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #234')
  call g:assert.equals(exists(s:object), 0,   'failed at #234')

  " #235
  call setline('.', 'foo')
  normal 0viw2saac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #235')
  call g:assert.equals(exists(s:object), 0,   'failed at #235')

  " #236
  call setline('.', 'foo')
  normal 0viw2saba
  call g:assert.equals(getline('.'), 'foo', 'failed at #236')
  call g:assert.equals(exists(s:object), 0, 'failed at #236')

  " #237
  call setline('.', 'foo')
  normal 0viw2sabc
  call g:assert.equals(getline('.'), 'foo', 'failed at #237')
  call g:assert.equals(exists(s:object), 0, 'failed at #237')

  " #238
  call setline('.', 'foo')
  normal 0viwsad
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #238')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'char', 'expr', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #239
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #239')

  """ off
  " #240
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #240')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #241
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #241')

  """ on
  " #242
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #242')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #243
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[d`]"])
  call setline('.', '"foo"')
  normal 0ffviwsa(
  call g:assert.equals(getline('.'), '""',  'failed at #243')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #244
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #244')
  call g:assert.equals(getline(2), 'foo', 'failed at #244')
  call g:assert.equals(getline(3), ')',   'failed at #244')

  %delete

  " #245
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #204')
  call g:assert.equals(getline(2),   '    foo',    'failed at #204')
  call g:assert.equals(getline(3),   '    )',      'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #204')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
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
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #246
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #246')
  call g:assert.equals(getline(2),   '[',          'failed at #246')
  call g:assert.equals(getline(3),   'foo',        'failed at #246')
  call g:assert.equals(getline(4),   ']',          'failed at #246')
  call g:assert.equals(getline(5),   '}',          'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #246')
  call g:assert.equals(&l:autoindent,  0,          'failed at #246')
  call g:assert.equals(&l:smartindent, 0,          'failed at #246')
  call g:assert.equals(&l:cindent,     0,          'failed at #246')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #246')

  %delete

  " #247
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #247')
  call g:assert.equals(getline(2),   '    [',      'failed at #247')
  call g:assert.equals(getline(3),   '    foo',    'failed at #247')
  call g:assert.equals(getline(4),   '    ]',      'failed at #247')
  call g:assert.equals(getline(5),   '    }',      'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #247')
  call g:assert.equals(&l:autoindent,  1,          'failed at #247')
  call g:assert.equals(&l:smartindent, 0,          'failed at #247')
  call g:assert.equals(&l:cindent,     0,          'failed at #247')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #247')

  %delete

  " #248
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #248')
  call g:assert.equals(getline(2),   '        [',   'failed at #248')
  call g:assert.equals(getline(3),   '        foo', 'failed at #248')
  call g:assert.equals(getline(4),   '    ]',       'failed at #248')
  call g:assert.equals(getline(5),   '}',           'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #248')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #248')
  call g:assert.equals(&l:autoindent,  1,           'failed at #248')
  call g:assert.equals(&l:smartindent, 1,           'failed at #248')
  call g:assert.equals(&l:cindent,     0,           'failed at #248')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #248')

  %delete

  " #249
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #249')
  call g:assert.equals(getline(2),   '    [',       'failed at #249')
  call g:assert.equals(getline(3),   '        foo', 'failed at #249')
  call g:assert.equals(getline(4),   '    ]',       'failed at #249')
  call g:assert.equals(getline(5),   '    }',       'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #249')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #249')
  call g:assert.equals(&l:autoindent,  1,           'failed at #249')
  call g:assert.equals(&l:smartindent, 1,           'failed at #249')
  call g:assert.equals(&l:cindent,     1,           'failed at #249')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #249')

  %delete

  " #250
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',           'failed at #250')
  call g:assert.equals(getline(2),   '            [',       'failed at #250')
  call g:assert.equals(getline(3),   '                foo', 'failed at #250')
  call g:assert.equals(getline(4),   '        ]',           'failed at #250')
  call g:assert.equals(getline(5),   '                }',   'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #250')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #250')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #250')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #250')
  call g:assert.equals(&l:cindent,     1,                   'failed at #250')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #250')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #251
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #251')
  call g:assert.equals(getline(2),   '[',          'failed at #251')
  call g:assert.equals(getline(3),   'foo',        'failed at #251')
  call g:assert.equals(getline(4),   ']',          'failed at #251')
  call g:assert.equals(getline(5),   '}',          'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #251')
  call g:assert.equals(&l:autoindent,  0,          'failed at #251')
  call g:assert.equals(&l:smartindent, 0,          'failed at #251')
  call g:assert.equals(&l:cindent,     0,          'failed at #251')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #251')

  %delete

  " #252
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #252')
  call g:assert.equals(getline(2),   '[',          'failed at #252')
  call g:assert.equals(getline(3),   'foo',        'failed at #252')
  call g:assert.equals(getline(4),   ']',          'failed at #252')
  call g:assert.equals(getline(5),   '}',          'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #252')
  call g:assert.equals(&l:autoindent,  1,          'failed at #252')
  call g:assert.equals(&l:smartindent, 0,          'failed at #252')
  call g:assert.equals(&l:cindent,     0,          'failed at #252')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #252')

  %delete

  " #253
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #253')
  call g:assert.equals(getline(2),   '[',          'failed at #253')
  call g:assert.equals(getline(3),   'foo',        'failed at #253')
  call g:assert.equals(getline(4),   ']',          'failed at #253')
  call g:assert.equals(getline(5),   '}',          'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #253')
  call g:assert.equals(&l:autoindent,  1,          'failed at #253')
  call g:assert.equals(&l:smartindent, 1,          'failed at #253')
  call g:assert.equals(&l:cindent,     0,          'failed at #253')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #253')

  %delete

  " #254
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #254')
  call g:assert.equals(getline(2),   '[',          'failed at #254')
  call g:assert.equals(getline(3),   'foo',        'failed at #254')
  call g:assert.equals(getline(4),   ']',          'failed at #254')
  call g:assert.equals(getline(5),   '}',          'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #254')
  call g:assert.equals(&l:autoindent,  1,          'failed at #254')
  call g:assert.equals(&l:smartindent, 1,          'failed at #254')
  call g:assert.equals(&l:cindent,     1,          'failed at #254')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #254')

  %delete

  " #255
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #255')
  call g:assert.equals(getline(2),   '[',              'failed at #255')
  call g:assert.equals(getline(3),   'foo',            'failed at #255')
  call g:assert.equals(getline(4),   ']',              'failed at #255')
  call g:assert.equals(getline(5),   '}',              'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #255')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #255')
  call g:assert.equals(&l:autoindent,  1,              'failed at #255')
  call g:assert.equals(&l:smartindent, 1,              'failed at #255')
  call g:assert.equals(&l:cindent,     1,              'failed at #255')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #255')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #256
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #256')
  call g:assert.equals(getline(2),   '    [',      'failed at #256')
  call g:assert.equals(getline(3),   '    foo',    'failed at #256')
  call g:assert.equals(getline(4),   '    ]',      'failed at #256')
  call g:assert.equals(getline(5),   '    }',      'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #256')
  call g:assert.equals(&l:autoindent,  0,          'failed at #256')
  call g:assert.equals(&l:smartindent, 0,          'failed at #256')
  call g:assert.equals(&l:cindent,     0,          'failed at #256')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #256')

  %delete

  " #257
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #257')
  call g:assert.equals(getline(2),   '    [',      'failed at #257')
  call g:assert.equals(getline(3),   '    foo',    'failed at #257')
  call g:assert.equals(getline(4),   '    ]',      'failed at #257')
  call g:assert.equals(getline(5),   '    }',      'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #257')
  call g:assert.equals(&l:autoindent,  1,          'failed at #257')
  call g:assert.equals(&l:smartindent, 0,          'failed at #257')
  call g:assert.equals(&l:cindent,     0,          'failed at #257')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #257')

  %delete

  " #258
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #258')
  call g:assert.equals(getline(2),   '    [',      'failed at #258')
  call g:assert.equals(getline(3),   '    foo',    'failed at #258')
  call g:assert.equals(getline(4),   '    ]',      'failed at #258')
  call g:assert.equals(getline(5),   '    }',      'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #258')
  call g:assert.equals(&l:autoindent,  1,          'failed at #258')
  call g:assert.equals(&l:smartindent, 1,          'failed at #258')
  call g:assert.equals(&l:cindent,     0,          'failed at #258')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #258')

  %delete

  " #259
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #259')
  call g:assert.equals(getline(2),   '    [',      'failed at #259')
  call g:assert.equals(getline(3),   '    foo',    'failed at #259')
  call g:assert.equals(getline(4),   '    ]',      'failed at #259')
  call g:assert.equals(getline(5),   '    }',      'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #259')
  call g:assert.equals(&l:autoindent,  1,          'failed at #259')
  call g:assert.equals(&l:smartindent, 1,          'failed at #259')
  call g:assert.equals(&l:cindent,     1,          'failed at #259')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #259')

  %delete

  " #260
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #260')
  call g:assert.equals(getline(2),   '    [',          'failed at #260')
  call g:assert.equals(getline(3),   '    foo',        'failed at #260')
  call g:assert.equals(getline(4),   '    ]',          'failed at #260')
  call g:assert.equals(getline(5),   '    }',          'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #260')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #260')
  call g:assert.equals(&l:autoindent,  1,              'failed at #260')
  call g:assert.equals(&l:smartindent, 1,              'failed at #260')
  call g:assert.equals(&l:cindent,     1,              'failed at #260')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #260')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #261
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #261')
  call g:assert.equals(getline(2),   '        [',   'failed at #261')
  call g:assert.equals(getline(3),   '        foo', 'failed at #261')
  call g:assert.equals(getline(4),   '    ]',       'failed at #261')
  call g:assert.equals(getline(5),   '}',           'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #261')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #261')
  call g:assert.equals(&l:autoindent,  0,           'failed at #261')
  call g:assert.equals(&l:smartindent, 0,           'failed at #261')
  call g:assert.equals(&l:cindent,     0,           'failed at #261')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #261')

  %delete

  " #262
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #262')
  call g:assert.equals(getline(2),   '        [',   'failed at #262')
  call g:assert.equals(getline(3),   '        foo', 'failed at #262')
  call g:assert.equals(getline(4),   '    ]',       'failed at #262')
  call g:assert.equals(getline(5),   '}',           'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #262')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #262')
  call g:assert.equals(&l:autoindent,  1,           'failed at #262')
  call g:assert.equals(&l:smartindent, 0,           'failed at #262')
  call g:assert.equals(&l:cindent,     0,           'failed at #262')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #262')

  %delete

  " #263
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #263')
  call g:assert.equals(getline(2),   '        [',   'failed at #263')
  call g:assert.equals(getline(3),   '        foo', 'failed at #263')
  call g:assert.equals(getline(4),   '    ]',       'failed at #263')
  call g:assert.equals(getline(5),   '}',           'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #263')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #263')
  call g:assert.equals(&l:autoindent,  1,           'failed at #263')
  call g:assert.equals(&l:smartindent, 1,           'failed at #263')
  call g:assert.equals(&l:cindent,     0,           'failed at #263')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #263')

  %delete

  " #264
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #264')
  call g:assert.equals(getline(2),   '        [',   'failed at #264')
  call g:assert.equals(getline(3),   '        foo', 'failed at #264')
  call g:assert.equals(getline(4),   '    ]',       'failed at #264')
  call g:assert.equals(getline(5),   '}',           'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #264')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #264')
  call g:assert.equals(&l:autoindent,  1,           'failed at #264')
  call g:assert.equals(&l:smartindent, 1,           'failed at #264')
  call g:assert.equals(&l:cindent,     1,           'failed at #264')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #264')

  %delete

  " #265
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #265')
  call g:assert.equals(getline(2),   '        [',      'failed at #265')
  call g:assert.equals(getline(3),   '        foo',    'failed at #265')
  call g:assert.equals(getline(4),   '    ]',          'failed at #265')
  call g:assert.equals(getline(5),   '}',              'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #265')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #265')
  call g:assert.equals(&l:autoindent,  1,              'failed at #265')
  call g:assert.equals(&l:smartindent, 1,              'failed at #265')
  call g:assert.equals(&l:cindent,     1,              'failed at #265')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #265')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #266
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #266')
  call g:assert.equals(getline(2),   '    [',       'failed at #266')
  call g:assert.equals(getline(3),   '        foo', 'failed at #266')
  call g:assert.equals(getline(4),   '    ]',       'failed at #266')
  call g:assert.equals(getline(5),   '    }',       'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #266')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #266')
  call g:assert.equals(&l:autoindent,  0,           'failed at #266')
  call g:assert.equals(&l:smartindent, 0,           'failed at #266')
  call g:assert.equals(&l:cindent,     0,           'failed at #266')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #266')

  %delete

  " #267
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #267')
  call g:assert.equals(getline(2),   '    [',       'failed at #267')
  call g:assert.equals(getline(3),   '        foo', 'failed at #267')
  call g:assert.equals(getline(4),   '    ]',       'failed at #267')
  call g:assert.equals(getline(5),   '    }',       'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #267')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #267')
  call g:assert.equals(&l:autoindent,  1,           'failed at #267')
  call g:assert.equals(&l:smartindent, 0,           'failed at #267')
  call g:assert.equals(&l:cindent,     0,           'failed at #267')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #267')

  %delete

  " #268
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #268')
  call g:assert.equals(getline(2),   '    [',       'failed at #268')
  call g:assert.equals(getline(3),   '        foo', 'failed at #268')
  call g:assert.equals(getline(4),   '    ]',       'failed at #268')
  call g:assert.equals(getline(5),   '    }',       'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #268')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #268')
  call g:assert.equals(&l:autoindent,  1,           'failed at #268')
  call g:assert.equals(&l:smartindent, 1,           'failed at #268')
  call g:assert.equals(&l:cindent,     0,           'failed at #268')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #268')

  %delete

  " #269
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #269')
  call g:assert.equals(getline(2),   '    [',       'failed at #269')
  call g:assert.equals(getline(3),   '        foo', 'failed at #269')
  call g:assert.equals(getline(4),   '    ]',       'failed at #269')
  call g:assert.equals(getline(5),   '    }',       'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #269')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #269')
  call g:assert.equals(&l:autoindent,  1,           'failed at #269')
  call g:assert.equals(&l:smartindent, 1,           'failed at #269')
  call g:assert.equals(&l:cindent,     1,           'failed at #269')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #269')

  %delete

  " #270
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',              'failed at #270')
  call g:assert.equals(getline(2),   '    [',          'failed at #270')
  call g:assert.equals(getline(3),   '        foo',    'failed at #270')
  call g:assert.equals(getline(4),   '    ]',          'failed at #270')
  call g:assert.equals(getline(5),   '    }',          'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #270')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #270')
  call g:assert.equals(&l:autoindent,  1,              'failed at #270')
  call g:assert.equals(&l:smartindent, 1,              'failed at #270')
  call g:assert.equals(&l:cindent,     1,              'failed at #270')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #270')
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
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #271
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #271')
  call g:assert.equals(getline(2),   'foo',        'failed at #271')
  call g:assert.equals(getline(3),   '    }',      'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #271')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #271')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #271')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #272
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #272')
  call g:assert.equals(getline(2),   '    foo',    'failed at #272')
  call g:assert.equals(getline(3),   '    }',      'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #272')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #272')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #272')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #272')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #273
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #273')
  call g:assert.equals(getline(2),   'foo',        'failed at #273')
  call g:assert.equals(getline(3),   '    }',      'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #273')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #273')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #273')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #274
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #274')
  call g:assert.equals(getline(2),   'foo',        'failed at #274')
  call g:assert.equals(getline(3),   '    }',      'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #274')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #274')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #274')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #275
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',     'failed at #275')
  call g:assert.equals(getline(2),   '    foo',       'failed at #275')
  call g:assert.equals(getline(3),   '            }', 'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #275')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #275')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #275')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #275')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #276
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #276')
  call g:assert.equals(getline(2),   'foo',        'failed at #276')
  call g:assert.equals(getline(3),   '    }',      'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #276')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #276')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #276')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #277
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #277')
  call g:assert.equals(getline(2),   'foo',        'failed at #277')
  call g:assert.equals(getline(3),   ')',          'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #277')

  %delete

  " #278
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #278')
  call g:assert.equals(getline(2),   'foo',        'failed at #278')
  call g:assert.equals(getline(3),   ')',          'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #278')

  %delete

  " #279
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #279')
  call g:assert.equals(getline(2),   'foo',        'failed at #279')
  call g:assert.equals(getline(3),   ']',          'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #279')

  %delete

  " #280
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #280')
  call g:assert.equals(getline(2),   'foo',        'failed at #280')
  call g:assert.equals(getline(3),   ']',          'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #280')

  %delete

  " #281
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #281')
  call g:assert.equals(getline(2),   'foo',        'failed at #281')
  call g:assert.equals(getline(3),   '}',          'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #281')

  %delete

  " #282
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #282')
  call g:assert.equals(getline(2),   'foo',        'failed at #282')
  call g:assert.equals(getline(3),   '}',          'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #282')

  %delete

  " #283
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #283')
  call g:assert.equals(getline(2),   'foo',        'failed at #283')
  call g:assert.equals(getline(3),   '>',          'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #283')

  %delete

  " #284
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #284')
  call g:assert.equals(getline(2),   'foo',        'failed at #284')
  call g:assert.equals(getline(3),   '>',          'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #284')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #285
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #285')
  call g:assert.equals(getline(2),   'foo',        'failed at #285')
  call g:assert.equals(getline(3),   'a',          'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #285')

  %delete

  " #286
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #286')
  call g:assert.equals(getline(2),   'foo',        'failed at #286')
  call g:assert.equals(getline(3),   '*',          'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #286')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #287
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #287')
  call g:assert.equals(getline(2),   'foo',        'failed at #287')
  call g:assert.equals(getline(3),   'bar',        'failed at #287')
  call g:assert.equals(getline(4),   'baz',        'failed at #287')
  call g:assert.equals(getline(5),   ')',          'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #287')

  " #288
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #288')
  call g:assert.equals(getline(2),   '(',          'failed at #288')
  call g:assert.equals(getline(3),   'bar',        'failed at #288')
  call g:assert.equals(getline(4),   ')',          'failed at #288')
  call g:assert.equals(getline(5),   'baz',        'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #288')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #289
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #289')
  call g:assert.equals(getline(2),   'a',          'failed at #289')
  call g:assert.equals(getline(3),   ')',          'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #289')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #290
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #290')
  call g:assert.equals(getline(2),   'aaa',        'failed at #290')
  call g:assert.equals(getline(3),   'foo',        'failed at #290')
  call g:assert.equals(getline(4),   'aaa',        'failed at #290')
  call g:assert.equals(getline(5),   'aa',         'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #290')

  %delete

  " #291
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #291')
  call g:assert.equals(getline(2),   'bbb',        'failed at #291')
  call g:assert.equals(getline(3),   'bb',         'failed at #291')
  call g:assert.equals(getline(4),   'foo',        'failed at #291')
  call g:assert.equals(getline(5),   'bb',         'failed at #291')
  call g:assert.equals(getline(6),   'bbb',        'failed at #291')
  call g:assert.equals(getline(7),   'bb',         'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #291')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #292
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #292')
  call g:assert.equals(getline(2),   '(',          'failed at #292')
  call g:assert.equals(getline(3),   'foo',        'failed at #292')
  call g:assert.equals(getline(4),   ')',          'failed at #292')
  call g:assert.equals(getline(5),   ']',          'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #292')

  %delete

  " #293
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #293')
  call g:assert.equals(getline(2),   '[',          'failed at #293')
  call g:assert.equals(getline(3),   '(',          'failed at #293')
  call g:assert.equals(getline(4),   'foo',        'failed at #293')
  call g:assert.equals(getline(5),   ')',          'failed at #293')
  call g:assert.equals(getline(6),   ']',          'failed at #293')
  call g:assert.equals(getline(7),   '}',          'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #293')

  %delete

  " #294
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #294')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #294')
  call g:assert.equals(getline(3), ')',            'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #294')

  %delete

  " #295
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #295')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #295')
  call g:assert.equals(getline(3), ')',            'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #295')

  %delete

  " #296
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #296')
  call g:assert.equals(getline(2), '(',            'failed at #296')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #296')
  call g:assert.equals(getline(4), ')',            'failed at #296')
  call g:assert.equals(getline(5), ']',            'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #296')

  %delete

  " #297
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #297')
  call g:assert.equals(getline(2), '[',            'failed at #297')
  call g:assert.equals(getline(3), '(',            'failed at #297')
  call g:assert.equals(getline(4), 'foo',          'failed at #297')
  call g:assert.equals(getline(5), ')',            'failed at #297')
  call g:assert.equals(getline(6), ']',            'failed at #297')
  call g:assert.equals(getline(7), 'aa',           'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #297')
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #298
  call setline('.', 'α')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',            'failed at #298')
  call g:assert.equals(getline(2), 'α',           'failed at #298')
  call g:assert.equals(getline(3), ')',            'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #298')

  %delete

  " #299
  call setline('.', 'aα')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',            'failed at #299')
  call g:assert.equals(getline(2), 'aα',          'failed at #299')
  call g:assert.equals(getline(3), ')',            'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #299')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #300
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'α', 'failed at #300')
  call g:assert.equals(getline(2), 'a',  'failed at #300')
  call g:assert.equals(getline(3), 'α', 'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #300')

  %delete

  " #301
  call setline('.', 'α')
  normal 0saVla
  call g:assert.equals(getline(1), 'α', 'failed at #301')
  call g:assert.equals(getline(2), 'α', 'failed at #301')
  call g:assert.equals(getline(3), 'α', 'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #301')

  %delete

  " #302
  call setline('.', 'aα')
  normal 0saVla
  call g:assert.equals(getline(1), 'α',  'failed at #302')
  call g:assert.equals(getline(2), 'aα', 'failed at #302')
  call g:assert.equals(getline(3), 'α',  'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #302')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #303
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #303')
  call g:assert.equals(getline(2), 'a',   'failed at #303')
  call g:assert.equals(getline(3), 'aα', 'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #303')

  %delete

  " #304
  call setline('.', 'α')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #304')
  call g:assert.equals(getline(2), 'α',  'failed at #304')
  call g:assert.equals(getline(3), 'aα', 'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #304')

  %delete

  " #305
  call setline('.', 'aα')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #305')
  call g:assert.equals(getline(2), 'aα', 'failed at #305')
  call g:assert.equals(getline(3), 'aα', 'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #305')

  %delete
  unlet g:operator#sandwich#recipes

  " #306
  call setline('.', '“')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',  'failed at #306')
  call g:assert.equals(getline(2), '“', 'failed at #306')
  call g:assert.equals(getline(3), ')',  'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #306')

  %delete

  " #307
  call setline('.', 'a“')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',   'failed at #307')
  call g:assert.equals(getline(2), 'a“', 'failed at #307')
  call g:assert.equals(getline(3), ')',   'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #307')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #308
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), '“', 'failed at #308')
  call g:assert.equals(getline(2), 'a',  'failed at #308')
  call g:assert.equals(getline(3), '“', 'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #308')

  %delete

  " #309
  call setline('.', '“')
  normal 0saVla
  call g:assert.equals(getline(1), '“', 'failed at #309')
  call g:assert.equals(getline(2), '“', 'failed at #309')
  call g:assert.equals(getline(3), '“', 'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #309')

  %delete

  " #310
  call setline('.', 'a“')
  normal 0saVla
  call g:assert.equals(getline(1), '“',  'failed at #310')
  call g:assert.equals(getline(2), 'a“', 'failed at #310')
  call g:assert.equals(getline(3), '“',  'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #310')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #311
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #311')
  call g:assert.equals(getline(2), 'a',   'failed at #311')
  call g:assert.equals(getline(3), 'a“', 'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #311')

  %delete

  " #312
  call setline('.', '“')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #312')
  call g:assert.equals(getline(2), '“',  'failed at #312')
  call g:assert.equals(getline(3), 'a“', 'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #312')

  %delete

  " #313
  call setline('.', 'a“')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #313')
  call g:assert.equals(getline(2), 'a“', 'failed at #313')
  call g:assert.equals(getline(3), 'a“', 'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #313')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #314
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #314')
  call g:assert.equals(getline(2),   '(',          'failed at #314')
  call g:assert.equals(getline(3),   'foo',        'failed at #314')
  call g:assert.equals(getline(4),   ')',          'failed at #314')
  call g:assert.equals(getline(5),   ')',          'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #314')

  " #315
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #315')
  call g:assert.equals(getline(2),   '(',          'failed at #315')
  call g:assert.equals(getline(3),   '(',          'failed at #315')
  call g:assert.equals(getline(4),   'foo',        'failed at #315')
  call g:assert.equals(getline(5),   ')',          'failed at #315')
  call g:assert.equals(getline(6),   ')',          'failed at #315')
  call g:assert.equals(getline(7),   ')',          'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #315')

  %delete

  """ keep
  " #316
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #316')
  call g:assert.equals(getline(2),   '(',          'failed at #316')
  call g:assert.equals(getline(3),   'foo',        'failed at #316')
  call g:assert.equals(getline(4),   ')',          'failed at #316')
  call g:assert.equals(getline(5),   ')',          'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #316')

  " #317
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #317')
  call g:assert.equals(getline(2),   '(',          'failed at #317')
  call g:assert.equals(getline(3),   '(',          'failed at #317')
  call g:assert.equals(getline(4),   'foo',        'failed at #317')
  call g:assert.equals(getline(5),   ')',          'failed at #317')
  call g:assert.equals(getline(6),   ')',          'failed at #317')
  call g:assert.equals(getline(7),   ')',          'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #317')

  %delete

  """ inner_tail
  " #318
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #318')
  call g:assert.equals(getline(2),   '(',          'failed at #318')
  call g:assert.equals(getline(3),   'foo',        'failed at #318')
  call g:assert.equals(getline(4),   ')',          'failed at #318')
  call g:assert.equals(getline(5),   ')',          'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #318')

  " #319
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #319')
  call g:assert.equals(getline(2),   '(',          'failed at #319')
  call g:assert.equals(getline(3),   '(',          'failed at #319')
  call g:assert.equals(getline(4),   'foo',        'failed at #319')
  call g:assert.equals(getline(5),   ')',          'failed at #319')
  call g:assert.equals(getline(6),   ')',          'failed at #319')
  call g:assert.equals(getline(7),   ')',          'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #319')

  %delete

  """ head
  " #320
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #320')
  call g:assert.equals(getline(2),   '(',          'failed at #320')
  call g:assert.equals(getline(3),   'foo',        'failed at #320')
  call g:assert.equals(getline(4),   ')',          'failed at #320')
  call g:assert.equals(getline(5),   ')',          'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #320')

  " #321
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #321')
  call g:assert.equals(getline(2),   '(',          'failed at #321')
  call g:assert.equals(getline(3),   '(',          'failed at #321')
  call g:assert.equals(getline(4),   'foo',        'failed at #321')
  call g:assert.equals(getline(5),   ')',          'failed at #321')
  call g:assert.equals(getline(6),   ')',          'failed at #321')
  call g:assert.equals(getline(7),   ')',          'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #321')

  %delete

  """ tail
  " #322
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #322')
  call g:assert.equals(getline(2),   '(',          'failed at #322')
  call g:assert.equals(getline(3),   'foo',        'failed at #322')
  call g:assert.equals(getline(4),   ')',          'failed at #322')
  call g:assert.equals(getline(5),   ')',          'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #322')

  " #323
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #323')
  call g:assert.equals(getline(2),   '(',          'failed at #323')
  call g:assert.equals(getline(3),   '(',          'failed at #323')
  call g:assert.equals(getline(4),   'foo',        'failed at #323')
  call g:assert.equals(getline(5),   ')',          'failed at #323')
  call g:assert.equals(getline(6),   ')',          'failed at #323')
  call g:assert.equals(getline(7),   ')',          'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #323')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #324
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #324')
  call g:assert.equals(getline(2), '[',   'failed at #324')
  call g:assert.equals(getline(3), '(',   'failed at #324')
  call g:assert.equals(getline(4), 'foo', 'failed at #324')
  call g:assert.equals(getline(5), ')',   'failed at #324')
  call g:assert.equals(getline(6), ']',   'failed at #324')
  call g:assert.equals(getline(7), '}',   'failed at #324')

  %delete

  """ on
  " #325
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #325')
  call g:assert.equals(getline(2), '(',   'failed at #325')
  call g:assert.equals(getline(3), '(',   'failed at #325')
  call g:assert.equals(getline(4), 'foo', 'failed at #325')
  call g:assert.equals(getline(5), ')',   'failed at #325')
  call g:assert.equals(getline(6), ')',   'failed at #325')
  call g:assert.equals(getline(7), ')',   'failed at #325')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #326
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #326')
  call g:assert.equals(getline(2), 'foo', 'failed at #326')
  call g:assert.equals(getline(3), '1+2', 'failed at #326')

  %delete

  """ 1
  " #327
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #327')
  call g:assert.equals(getline(2), 'foo', 'failed at #327')
  call g:assert.equals(getline(3), '3',   'failed at #327')

  %delete

  " #328
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1), 'foo',   'failed at #328')
  call g:assert.equals(exists(s:object), 0, 'failed at #328')

  %delete

  " #329
  call setline('.', 'foo')
  normal 0saViwc
  call g:assert.equals(getline(1), 'foo',   'failed at #329')
  call g:assert.equals(exists(s:object), 0, 'failed at #329')

  %delete

  " #330
  call setline('.', 'foo')
  normal 02saViwab
  call g:assert.equals(getline(1), '2',     'failed at #330')
  call g:assert.equals(getline(2), 'foo',   'failed at #330')
  call g:assert.equals(getline(3), '3',     'failed at #330')
  call g:assert.equals(exists(s:object), 0, 'failed at #330')

  %delete

  " #331
  call setline('.', 'foo')
  normal 02saViwac
  call g:assert.equals(getline(1), '2',     'failed at #331')
  call g:assert.equals(getline(2), 'foo',   'failed at #331')
  call g:assert.equals(getline(3), '3',     'failed at #331')
  call g:assert.equals(exists(s:object), 0, 'failed at #331')

  %delete

  " #332
  call setline('.', 'foo')
  normal 02saViwba
  call g:assert.equals(getline(1), 'foo',   'failed at #332')
  call g:assert.equals(exists(s:object), 0, 'failed at #332')

  %delete

  " #333
  call setline('.', 'foo')
  normal 02saViwca
  call g:assert.equals(getline(1), 'foo',   'failed at #333')
  call g:assert.equals(exists(s:object), 0, 'failed at #333')

  %delete

  " #334
  call setline('.', 'foo')
  normal 0saViwd
  call g:assert.equals(getline(1), 'head', 'failed at #334')
  call g:assert.equals(getline(2), 'foo',  'failed at #334')
  call g:assert.equals(getline(3), 'tail', 'failed at #334')

  %delete

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'line', 'expr', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #335
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #335')
  call g:assert.equals(getline(2), 'foo', 'failed at #335')
  call g:assert.equals(getline(3), ']]',  'failed at #335')

  %delete

  """ off
  " #336
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #336')
  call g:assert.equals(getline(2), 'foo', 'failed at #336')
  call g:assert.equals(getline(3), '}}',  'failed at #336')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #337
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #337')
  call g:assert.equals(getline(2), 'foo ', 'failed at #337')
  call g:assert.equals(getline(3), ')',    'failed at #337')

  %delete

  """ off
  " #338
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #338')
  call g:assert.equals(getline(2), 'foo ', 'failed at #338')
  call g:assert.equals(getline(3), ')',    'failed at #338')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #339
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjsaViw(
  call g:assert.equals(getline(1), '[', 'failed at #339')
  call g:assert.equals(getline(2), ']', 'failed at #339')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #340
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #340')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #341
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #341')
  call g:assert.equals(getline(2),   '    foo',    'failed at #341')
  call g:assert.equals(getline(3),   '    )',      'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #341')

  set autoindent&
endfunction
"}}}
function! s:suite.linewise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #342
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #342')
  call g:assert.equals(getline(2),   '[',          'failed at #342')
  call g:assert.equals(getline(3),   '',           'failed at #342')
  call g:assert.equals(getline(4),   '    foo',    'failed at #342')
  call g:assert.equals(getline(5),   '',           'failed at #342')
  call g:assert.equals(getline(6),   ']',          'failed at #342')
  call g:assert.equals(getline(7),   '}',          'failed at #342')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #342')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #342')
  call g:assert.equals(&l:autoindent,  0,          'failed at #342')
  call g:assert.equals(&l:smartindent, 0,          'failed at #342')
  call g:assert.equals(&l:cindent,     0,          'failed at #342')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #342')

  %delete

  " #343
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #343')
  call g:assert.equals(getline(2),   '    [',      'failed at #343')
  call g:assert.equals(getline(3),   '',           'failed at #343')
  call g:assert.equals(getline(4),   '    foo',    'failed at #343')
  call g:assert.equals(getline(5),   '',           'failed at #343')
  call g:assert.equals(getline(6),   '    ]',      'failed at #343')
  call g:assert.equals(getline(7),   '    }',      'failed at #343')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #343')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #343')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #343')
  call g:assert.equals(&l:autoindent,  1,          'failed at #343')
  call g:assert.equals(&l:smartindent, 0,          'failed at #343')
  call g:assert.equals(&l:cindent,     0,          'failed at #343')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #343')

  %delete

  " #344
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #344')
  call g:assert.equals(getline(2),   '    [',       'failed at #344')
  call g:assert.equals(getline(3),   '',            'failed at #344')
  call g:assert.equals(getline(4),   '    foo',     'failed at #344')
  call g:assert.equals(getline(5),   '',            'failed at #344')
  call g:assert.equals(getline(6),   '    ]',       'failed at #344')
  call g:assert.equals(getline(7),   '}',           'failed at #344')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #344')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #344')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #344')
  call g:assert.equals(&l:autoindent,  1,           'failed at #344')
  call g:assert.equals(&l:smartindent, 1,           'failed at #344')
  call g:assert.equals(&l:cindent,     0,           'failed at #344')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #344')

  %delete

  " #345
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #345')
  call g:assert.equals(getline(2),   '    [',       'failed at #345')
  call g:assert.equals(getline(3),   '',            'failed at #345')
  call g:assert.equals(getline(4),   '    foo',     'failed at #345')
  call g:assert.equals(getline(5),   '',            'failed at #345')
  call g:assert.equals(getline(6),   '    ]',       'failed at #345')
  call g:assert.equals(getline(7),   '    }',       'failed at #345')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #345')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #345')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #345')
  call g:assert.equals(&l:autoindent,  1,           'failed at #345')
  call g:assert.equals(&l:smartindent, 1,           'failed at #345')
  call g:assert.equals(&l:cindent,     1,           'failed at #345')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #345')

  %delete

  " #346
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',            'failed at #346')
  call g:assert.equals(getline(2),   '           [',        'failed at #346')
  call g:assert.equals(getline(3),   '',                    'failed at #346')
  call g:assert.equals(getline(4),   '    foo',             'failed at #346')
  call g:assert.equals(getline(5),   '',                    'failed at #346')
  call g:assert.equals(getline(6),   '        ]',           'failed at #346')
  call g:assert.equals(getline(7),   '                }',   'failed at #346')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #346')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #346')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #346')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #346')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #346')
  call g:assert.equals(&l:cindent,     1,                   'failed at #346')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #346')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #347
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #347')
  call g:assert.equals(getline(2),   '[',          'failed at #347')
  call g:assert.equals(getline(3),   '',           'failed at #347')
  call g:assert.equals(getline(4),   '    foo',    'failed at #347')
  call g:assert.equals(getline(5),   '',           'failed at #347')
  call g:assert.equals(getline(6),   ']',          'failed at #347')
  call g:assert.equals(getline(7),   '}',          'failed at #347')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #347')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #347')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #347')
  call g:assert.equals(&l:autoindent,  0,          'failed at #347')
  call g:assert.equals(&l:smartindent, 0,          'failed at #347')
  call g:assert.equals(&l:cindent,     0,          'failed at #347')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #347')

  %delete

  " #348
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #348')
  call g:assert.equals(getline(2),   '[',          'failed at #348')
  call g:assert.equals(getline(3),   '',           'failed at #348')
  call g:assert.equals(getline(4),   '    foo',    'failed at #348')
  call g:assert.equals(getline(5),   '',           'failed at #348')
  call g:assert.equals(getline(6),   ']',          'failed at #348')
  call g:assert.equals(getline(7),   '}',          'failed at #348')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #348')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #348')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #348')
  call g:assert.equals(&l:autoindent,  1,          'failed at #348')
  call g:assert.equals(&l:smartindent, 0,          'failed at #348')
  call g:assert.equals(&l:cindent,     0,          'failed at #348')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #348')

  %delete

  " #349
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #349')
  call g:assert.equals(getline(2),   '[',          'failed at #349')
  call g:assert.equals(getline(3),   '',           'failed at #349')
  call g:assert.equals(getline(4),   '    foo',    'failed at #349')
  call g:assert.equals(getline(5),   '',           'failed at #349')
  call g:assert.equals(getline(6),   ']',          'failed at #349')
  call g:assert.equals(getline(7),   '}',          'failed at #349')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #349')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #349')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #349')
  call g:assert.equals(&l:autoindent,  1,          'failed at #349')
  call g:assert.equals(&l:smartindent, 1,          'failed at #349')
  call g:assert.equals(&l:cindent,     0,          'failed at #349')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #349')

  %delete

  " #350
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #350')
  call g:assert.equals(getline(2),   '[',          'failed at #350')
  call g:assert.equals(getline(3),   '',           'failed at #350')
  call g:assert.equals(getline(4),   '    foo',    'failed at #350')
  call g:assert.equals(getline(5),   '',           'failed at #350')
  call g:assert.equals(getline(6),   ']',          'failed at #350')
  call g:assert.equals(getline(7),   '}',          'failed at #350')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #350')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #350')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #350')
  call g:assert.equals(&l:autoindent,  1,          'failed at #350')
  call g:assert.equals(&l:smartindent, 1,          'failed at #350')
  call g:assert.equals(&l:cindent,     1,          'failed at #350')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #350')

  %delete

  " #351
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #351')
  call g:assert.equals(getline(2),   '[',              'failed at #351')
  call g:assert.equals(getline(3),   '',               'failed at #351')
  call g:assert.equals(getline(4),   '    foo',        'failed at #351')
  call g:assert.equals(getline(5),   '',               'failed at #351')
  call g:assert.equals(getline(6),   ']',              'failed at #351')
  call g:assert.equals(getline(7),   '}',              'failed at #351')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #351')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #351')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #351')
  call g:assert.equals(&l:autoindent,  1,              'failed at #351')
  call g:assert.equals(&l:smartindent, 1,              'failed at #351')
  call g:assert.equals(&l:cindent,     1,              'failed at #351')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #351')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #352
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #352')
  call g:assert.equals(getline(2),   '    [',      'failed at #352')
  call g:assert.equals(getline(3),   '',           'failed at #352')
  call g:assert.equals(getline(4),   '    foo',    'failed at #352')
  call g:assert.equals(getline(5),   '',           'failed at #352')
  call g:assert.equals(getline(6),   '    ]',      'failed at #352')
  call g:assert.equals(getline(7),   '    }',      'failed at #352')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #352')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #352')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #352')
  call g:assert.equals(&l:autoindent,  0,          'failed at #352')
  call g:assert.equals(&l:smartindent, 0,          'failed at #352')
  call g:assert.equals(&l:cindent,     0,          'failed at #352')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #352')

  %delete

  " #353
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #353')
  call g:assert.equals(getline(2),   '    [',      'failed at #353')
  call g:assert.equals(getline(3),   '',           'failed at #353')
  call g:assert.equals(getline(4),   '    foo',    'failed at #353')
  call g:assert.equals(getline(5),   '',           'failed at #353')
  call g:assert.equals(getline(6),   '    ]',      'failed at #353')
  call g:assert.equals(getline(7),   '    }',      'failed at #353')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #353')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #353')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #353')
  call g:assert.equals(&l:autoindent,  1,          'failed at #353')
  call g:assert.equals(&l:smartindent, 0,          'failed at #353')
  call g:assert.equals(&l:cindent,     0,          'failed at #353')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #353')

  %delete

  " #354
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #354')
  call g:assert.equals(getline(2),   '    [',      'failed at #354')
  call g:assert.equals(getline(3),   '',           'failed at #354')
  call g:assert.equals(getline(4),   '    foo',    'failed at #354')
  call g:assert.equals(getline(5),   '',           'failed at #354')
  call g:assert.equals(getline(6),   '    ]',      'failed at #354')
  call g:assert.equals(getline(7),   '    }',      'failed at #354')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #354')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #354')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #354')
  call g:assert.equals(&l:autoindent,  1,          'failed at #354')
  call g:assert.equals(&l:smartindent, 1,          'failed at #354')
  call g:assert.equals(&l:cindent,     0,          'failed at #354')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #354')

  %delete

  " #355
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #355')
  call g:assert.equals(getline(2),   '    [',      'failed at #355')
  call g:assert.equals(getline(3),   '',           'failed at #355')
  call g:assert.equals(getline(4),   '    foo',    'failed at #355')
  call g:assert.equals(getline(5),   '',           'failed at #355')
  call g:assert.equals(getline(6),   '    ]',      'failed at #355')
  call g:assert.equals(getline(7),   '    }',      'failed at #355')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #355')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #355')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #355')
  call g:assert.equals(&l:autoindent,  1,          'failed at #355')
  call g:assert.equals(&l:smartindent, 1,          'failed at #355')
  call g:assert.equals(&l:cindent,     1,          'failed at #355')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #355')

  %delete

  " #356
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',          'failed at #356')
  call g:assert.equals(getline(2),   '    [',          'failed at #356')
  call g:assert.equals(getline(3),   '',               'failed at #356')
  call g:assert.equals(getline(4),   '    foo',        'failed at #356')
  call g:assert.equals(getline(5),   '',               'failed at #356')
  call g:assert.equals(getline(6),   '    ]',          'failed at #356')
  call g:assert.equals(getline(7),   '    }',          'failed at #356')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #356')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #356')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #356')
  call g:assert.equals(&l:autoindent,  1,              'failed at #356')
  call g:assert.equals(&l:smartindent, 1,              'failed at #356')
  call g:assert.equals(&l:cindent,     1,              'failed at #356')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #356')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #357
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #357')
  call g:assert.equals(getline(2),   '    [',       'failed at #357')
  call g:assert.equals(getline(3),   '',            'failed at #357')
  call g:assert.equals(getline(4),   '    foo',     'failed at #357')
  call g:assert.equals(getline(5),   '',            'failed at #357')
  call g:assert.equals(getline(6),   '    ]',       'failed at #357')
  call g:assert.equals(getline(7),   '}',           'failed at #357')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #357')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #357')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #357')
  call g:assert.equals(&l:autoindent,  0,           'failed at #357')
  call g:assert.equals(&l:smartindent, 0,           'failed at #357')
  call g:assert.equals(&l:cindent,     0,           'failed at #357')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #357')

  %delete

  " #358
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #358')
  call g:assert.equals(getline(2),   '    [',       'failed at #358')
  call g:assert.equals(getline(3),   '',            'failed at #358')
  call g:assert.equals(getline(4),   '    foo',     'failed at #358')
  call g:assert.equals(getline(5),   '',            'failed at #358')
  call g:assert.equals(getline(6),   '    ]',       'failed at #358')
  call g:assert.equals(getline(7),   '}',           'failed at #358')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #358')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #358')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #358')
  call g:assert.equals(&l:autoindent,  1,           'failed at #358')
  call g:assert.equals(&l:smartindent, 0,           'failed at #358')
  call g:assert.equals(&l:cindent,     0,           'failed at #358')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #358')

  %delete

  " #359
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #359')
  call g:assert.equals(getline(2),   '    [',       'failed at #359')
  call g:assert.equals(getline(3),   '',            'failed at #359')
  call g:assert.equals(getline(4),   '    foo',     'failed at #359')
  call g:assert.equals(getline(5),   '',            'failed at #359')
  call g:assert.equals(getline(6),   '    ]',       'failed at #359')
  call g:assert.equals(getline(7),   '}',           'failed at #359')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #359')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #359')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #359')
  call g:assert.equals(&l:autoindent,  1,           'failed at #359')
  call g:assert.equals(&l:smartindent, 1,           'failed at #359')
  call g:assert.equals(&l:cindent,     0,           'failed at #359')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #359')

  %delete

  " #360
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #360')
  call g:assert.equals(getline(2),   '    [',       'failed at #360')
  call g:assert.equals(getline(3),   '',            'failed at #360')
  call g:assert.equals(getline(4),   '    foo',     'failed at #360')
  call g:assert.equals(getline(5),   '',            'failed at #360')
  call g:assert.equals(getline(6),   '    ]',       'failed at #360')
  call g:assert.equals(getline(7),   '}',           'failed at #360')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #360')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #360')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #360')
  call g:assert.equals(&l:autoindent,  1,           'failed at #360')
  call g:assert.equals(&l:smartindent, 1,           'failed at #360')
  call g:assert.equals(&l:cindent,     1,           'failed at #360')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #360')

  %delete

  " #361
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #361')
  call g:assert.equals(getline(2),   '    [',          'failed at #361')
  call g:assert.equals(getline(3),   '',               'failed at #361')
  call g:assert.equals(getline(4),   '    foo',        'failed at #361')
  call g:assert.equals(getline(5),   '',               'failed at #361')
  call g:assert.equals(getline(6),   '    ]',          'failed at #361')
  call g:assert.equals(getline(7),   '}',              'failed at #361')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #361')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #361')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #361')
  call g:assert.equals(&l:autoindent,  1,              'failed at #361')
  call g:assert.equals(&l:smartindent, 1,              'failed at #361')
  call g:assert.equals(&l:cindent,     1,              'failed at #361')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #361')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #362
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #362')
  call g:assert.equals(getline(2),   '    [',       'failed at #362')
  call g:assert.equals(getline(3),   '',            'failed at #362')
  call g:assert.equals(getline(4),   '    foo',     'failed at #362')
  call g:assert.equals(getline(5),   '',            'failed at #362')
  call g:assert.equals(getline(6),   '    ]',       'failed at #362')
  call g:assert.equals(getline(7),   '    }',       'failed at #362')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #362')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #362')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #362')
  call g:assert.equals(&l:autoindent,  0,           'failed at #362')
  call g:assert.equals(&l:smartindent, 0,           'failed at #362')
  call g:assert.equals(&l:cindent,     0,           'failed at #362')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #362')

  %delete

  " #363
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #363')
  call g:assert.equals(getline(2),   '    [',       'failed at #363')
  call g:assert.equals(getline(3),   '',            'failed at #363')
  call g:assert.equals(getline(4),   '    foo',     'failed at #363')
  call g:assert.equals(getline(5),   '',            'failed at #363')
  call g:assert.equals(getline(6),   '    ]',       'failed at #363')
  call g:assert.equals(getline(7),   '    }',       'failed at #363')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #363')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #363')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #363')
  call g:assert.equals(&l:autoindent,  1,           'failed at #363')
  call g:assert.equals(&l:smartindent, 0,           'failed at #363')
  call g:assert.equals(&l:cindent,     0,           'failed at #363')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #363')

  %delete

  " #364
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #364')
  call g:assert.equals(getline(2),   '    [',       'failed at #364')
  call g:assert.equals(getline(3),   '',            'failed at #364')
  call g:assert.equals(getline(4),   '    foo',     'failed at #364')
  call g:assert.equals(getline(5),   '',            'failed at #364')
  call g:assert.equals(getline(6),   '    ]',       'failed at #364')
  call g:assert.equals(getline(7),   '    }',       'failed at #364')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #364')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #364')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #364')
  call g:assert.equals(&l:autoindent,  1,           'failed at #364')
  call g:assert.equals(&l:smartindent, 1,           'failed at #364')
  call g:assert.equals(&l:cindent,     0,           'failed at #364')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #364')

  %delete

  " #365
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #365')
  call g:assert.equals(getline(2),   '    [',       'failed at #365')
  call g:assert.equals(getline(3),   '',            'failed at #365')
  call g:assert.equals(getline(4),   '    foo',     'failed at #365')
  call g:assert.equals(getline(5),   '',            'failed at #365')
  call g:assert.equals(getline(6),   '    ]',       'failed at #365')
  call g:assert.equals(getline(7),   '    }',       'failed at #365')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #365')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #365')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #365')
  call g:assert.equals(&l:autoindent,  1,           'failed at #365')
  call g:assert.equals(&l:smartindent, 1,           'failed at #365')
  call g:assert.equals(&l:cindent,     1,           'failed at #365')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #365')

  %delete

  " #366
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #366')
  call g:assert.equals(getline(2),   '    [',          'failed at #366')
  call g:assert.equals(getline(3),   '',               'failed at #366')
  call g:assert.equals(getline(4),   '    foo',        'failed at #366')
  call g:assert.equals(getline(5),   '',               'failed at #366')
  call g:assert.equals(getline(6),   '    ]',          'failed at #366')
  call g:assert.equals(getline(7),   '    }',          'failed at #366')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #366')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #366')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #366')
  call g:assert.equals(&l:autoindent,  1,              'failed at #366')
  call g:assert.equals(&l:smartindent, 1,              'failed at #366')
  call g:assert.equals(&l:cindent,     1,              'failed at #366')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #366')
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

  """ cinkeys
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #367
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #367')
  call g:assert.equals(getline(2),   '',           'failed at #367')
  call g:assert.equals(getline(3),   '    foo',    'failed at #367')
  call g:assert.equals(getline(4),   '',           'failed at #367')
  call g:assert.equals(getline(5),   '    }',      'failed at #367')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #367')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #367')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #367')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #367')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #368
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #368')
  call g:assert.equals(getline(2),   '',           'failed at #368')
  call g:assert.equals(getline(3),   '    foo',    'failed at #368')
  call g:assert.equals(getline(4),   '',           'failed at #368')
  call g:assert.equals(getline(5),   '    }',      'failed at #368')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #368')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #368')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #368')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #368')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #369
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #369')
  call g:assert.equals(getline(2),   '',           'failed at #369')
  call g:assert.equals(getline(3),   '    foo',    'failed at #369')
  call g:assert.equals(getline(4),   '',           'failed at #369')
  call g:assert.equals(getline(5),   '    }',      'failed at #369')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #369')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #369')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #369')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #369')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #369')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #370
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #370')
  call g:assert.equals(getline(2),   '',              'failed at #370')
  call g:assert.equals(getline(3),   '    foo',       'failed at #370')
  call g:assert.equals(getline(4),   '',              'failed at #370')
  call g:assert.equals(getline(5),   '    }',         'failed at #370')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #370')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #370')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #370')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #370')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #370')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #371
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',      'failed at #371')
  call g:assert.equals(getline(2),   '',              'failed at #371')
  call g:assert.equals(getline(3),   '    foo',       'failed at #371')
  call g:assert.equals(getline(4),   '',              'failed at #371')
  call g:assert.equals(getline(5),   '            }', 'failed at #371')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #371')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #371')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #371')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #371')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #371')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #372
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #372')
  call g:assert.equals(getline(2),   '',              'failed at #372')
  call g:assert.equals(getline(3),   '    foo',       'failed at #372')
  call g:assert.equals(getline(4),   '',              'failed at #372')
  call g:assert.equals(getline(5),   '    }',         'failed at #372')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #372')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #372')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #372')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #372')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #372')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #373
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #373')
  call g:assert.equals(getline(2),   'foo',        'failed at #373')
  call g:assert.equals(getline(3),   ')',          'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #373')

  %delete

  " #374
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #374')
  call g:assert.equals(getline(2),   'foo',        'failed at #374')
  call g:assert.equals(getline(3),   ')',          'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #374')

  %delete

  " #375
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #375')
  call g:assert.equals(getline(2),   'foo',        'failed at #375')
  call g:assert.equals(getline(3),   ']',          'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #375')

  %delete

  " #376
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #376')
  call g:assert.equals(getline(2),   'foo',        'failed at #376')
  call g:assert.equals(getline(3),   ']',          'failed at #376')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #376')

  %delete

  " #377
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #377')
  call g:assert.equals(getline(2),   'foo',        'failed at #377')
  call g:assert.equals(getline(3),   '}',          'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #377')

  %delete

  " #378
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #378')
  call g:assert.equals(getline(2),   'foo',        'failed at #378')
  call g:assert.equals(getline(3),   '}',          'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #378')

  %delete

  " #379
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #379')
  call g:assert.equals(getline(2),   'foo',        'failed at #379')
  call g:assert.equals(getline(3),   '>',          'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #379')

  %delete

  " #380
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #380')
  call g:assert.equals(getline(2),   'foo',        'failed at #380')
  call g:assert.equals(getline(3),   '>',          'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #380')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #380')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #380')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #381
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #381')
  call g:assert.equals(getline(2), 'foo',          'failed at #381')
  call g:assert.equals(getline(3), 'a',            'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #381')

  %delete

  " #382
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #382')
  call g:assert.equals(getline(2), 'foo',          'failed at #382')
  call g:assert.equals(getline(3), '*',            'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #382')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #383
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #383')
  call g:assert.equals(getline(2),   'foo',        'failed at #383')
  call g:assert.equals(getline(3),   'bar',        'failed at #383')
  call g:assert.equals(getline(4),   'baz',        'failed at #383')
  call g:assert.equals(getline(5),   ')',          'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #383')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #384
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #384')
  call g:assert.equals(getline(2),   'a',          'failed at #384')
  call g:assert.equals(getline(3),   ')',          'failed at #384')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #384')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  " #385
  call append(0, ['', 'foo'])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #385')
  call g:assert.equals(getline(2), '',             'failed at #385')
  call g:assert.equals(getline(3), 'foo',          'failed at #385')
  call g:assert.equals(getline(4), ')',            'failed at #385')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #385')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #385')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #385')

  %delete

  " #386
  call append(0, ['foo', ''])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #386')
  call g:assert.equals(getline(2), 'foo',          'failed at #386')
  call g:assert.equals(getline(3), '',             'failed at #386')
  call g:assert.equals(getline(4), ')',            'failed at #386')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #386')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #386')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #386')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #387
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #387')
  call g:assert.equals(getline(2),   'aaa',        'failed at #387')
  call g:assert.equals(getline(3),   'foo',        'failed at #387')
  call g:assert.equals(getline(4),   'aaa',        'failed at #387')
  call g:assert.equals(getline(5),   'aa',         'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #387')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #387')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #387')

  %delete

  " #388
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #388')
  call g:assert.equals(getline(2),   'bbb',        'failed at #388')
  call g:assert.equals(getline(3),   'bb',         'failed at #388')
  call g:assert.equals(getline(4),   'foo',        'failed at #388')
  call g:assert.equals(getline(5),   'bb',         'failed at #388')
  call g:assert.equals(getline(6),   'bbb',        'failed at #388')
  call g:assert.equals(getline(7),   'bb',         'failed at #388')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #388')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #388')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #388')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #389
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #389')
  call g:assert.equals(getline(2),   '(',          'failed at #389')
  call g:assert.equals(getline(3),   'foo',        'failed at #389')
  call g:assert.equals(getline(4),   ')',          'failed at #389')
  call g:assert.equals(getline(5),   ']',          'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #389')

  %delete

  " #390
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #390')
  call g:assert.equals(getline(2),   '[',          'failed at #390')
  call g:assert.equals(getline(3),   '(',          'failed at #390')
  call g:assert.equals(getline(4),   'foo',        'failed at #390')
  call g:assert.equals(getline(5),   ')',          'failed at #390')
  call g:assert.equals(getline(6),   ']',          'failed at #390')
  call g:assert.equals(getline(7),   '}',          'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #390')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #390')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #390')
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #298
  call setline('.', 'α')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',            'failed at #298')
  call g:assert.equals(getline(2), 'α',           'failed at #298')
  call g:assert.equals(getline(3), ')',            'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #298')

  %delete

  " #299
  call setline('.', 'aα')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',            'failed at #299')
  call g:assert.equals(getline(2), 'aα',          'failed at #299')
  call g:assert.equals(getline(3), ')',            'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #299')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #300
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α', 'failed at #300')
  call g:assert.equals(getline(2), 'a',  'failed at #300')
  call g:assert.equals(getline(3), 'α', 'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #300')

  %delete

  " #301
  call setline('.', 'α')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α', 'failed at #301')
  call g:assert.equals(getline(2), 'α', 'failed at #301')
  call g:assert.equals(getline(3), 'α', 'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #301')

  %delete

  " #302
  call setline('.', 'aα')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α',  'failed at #302')
  call g:assert.equals(getline(2), 'aα', 'failed at #302')
  call g:assert.equals(getline(3), 'α',  'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #302')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #303
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #303')
  call g:assert.equals(getline(2), 'a',   'failed at #303')
  call g:assert.equals(getline(3), 'aα', 'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #303')

  %delete

  " #304
  call setline('.', 'α')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #304')
  call g:assert.equals(getline(2), 'α',  'failed at #304')
  call g:assert.equals(getline(3), 'aα', 'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #304')

  %delete

  " #305
  call setline('.', 'aα')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #305')
  call g:assert.equals(getline(2), 'aα', 'failed at #305')
  call g:assert.equals(getline(3), 'aα', 'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #305')

  %delete
  unlet g:operator#sandwich#recipes

  " #306
  call setline('.', '“')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',  'failed at #306')
  call g:assert.equals(getline(2), '“', 'failed at #306')
  call g:assert.equals(getline(3), ')',  'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #306')

  %delete

  " #307
  call setline('.', 'a“')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',   'failed at #307')
  call g:assert.equals(getline(2), 'a“', 'failed at #307')
  call g:assert.equals(getline(3), ')',   'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #307')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #308
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“', 'failed at #308')
  call g:assert.equals(getline(2), 'a',  'failed at #308')
  call g:assert.equals(getline(3), '“', 'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #308')

  %delete

  " #309
  call setline('.', '“')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“', 'failed at #309')
  call g:assert.equals(getline(2), '“', 'failed at #309')
  call g:assert.equals(getline(3), '“', 'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #309')

  %delete

  " #310
  call setline('.', 'a“')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“',  'failed at #310')
  call g:assert.equals(getline(2), 'a“', 'failed at #310')
  call g:assert.equals(getline(3), '“',  'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #310')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #311
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #311')
  call g:assert.equals(getline(2), 'a',   'failed at #311')
  call g:assert.equals(getline(3), 'a“', 'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #311')

  %delete

  " #312
  call setline('.', '“')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #312')
  call g:assert.equals(getline(2), '“',  'failed at #312')
  call g:assert.equals(getline(3), 'a“', 'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #312')

  %delete

  " #313
  call setline('.', 'a“')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #313')
  call g:assert.equals(getline(2), 'a“', 'failed at #313')
  call g:assert.equals(getline(3), 'a“', 'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #313')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #391
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #391')
  call g:assert.equals(getline(2),   '(',          'failed at #391')
  call g:assert.equals(getline(3),   'foo',        'failed at #391')
  call g:assert.equals(getline(4),   ')',          'failed at #391')
  call g:assert.equals(getline(5),   ')',          'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #391')

  " #392
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #392')
  call g:assert.equals(getline(2),   '(',          'failed at #392')
  call g:assert.equals(getline(3),   '(',          'failed at #392')
  call g:assert.equals(getline(4),   'foo',        'failed at #392')
  call g:assert.equals(getline(5),   ')',          'failed at #392')
  call g:assert.equals(getline(6),   ')',          'failed at #392')
  call g:assert.equals(getline(7),   ')',          'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #392')

  %delete

  """ keep
  " #393
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #393')
  call g:assert.equals(getline(2),   '(',          'failed at #393')
  call g:assert.equals(getline(3),   'foo',        'failed at #393')
  call g:assert.equals(getline(4),   ')',          'failed at #393')
  call g:assert.equals(getline(5),   ')',          'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #393')

  " #394
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #394')
  call g:assert.equals(getline(2),   '(',          'failed at #394')
  call g:assert.equals(getline(3),   '(',          'failed at #394')
  call g:assert.equals(getline(4),   'foo',        'failed at #394')
  call g:assert.equals(getline(5),   ')',          'failed at #394')
  call g:assert.equals(getline(6),   ')',          'failed at #394')
  call g:assert.equals(getline(7),   ')',          'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #394')

  %delete

  """ inner_tail
  " #395
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #395')
  call g:assert.equals(getline(2),   '(',          'failed at #395')
  call g:assert.equals(getline(3),   'foo',        'failed at #395')
  call g:assert.equals(getline(4),   ')',          'failed at #395')
  call g:assert.equals(getline(5),   ')',          'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #395')

  " #396
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #396')
  call g:assert.equals(getline(2),   '(',          'failed at #396')
  call g:assert.equals(getline(3),   '(',          'failed at #396')
  call g:assert.equals(getline(4),   'foo',        'failed at #396')
  call g:assert.equals(getline(5),   ')',          'failed at #396')
  call g:assert.equals(getline(6),   ')',          'failed at #396')
  call g:assert.equals(getline(7),   ')',          'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #396')

  %delete

  """ head
  " #397
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #397')
  call g:assert.equals(getline(2),   '(',          'failed at #397')
  call g:assert.equals(getline(3),   'foo',        'failed at #397')
  call g:assert.equals(getline(4),   ')',          'failed at #397')
  call g:assert.equals(getline(5),   ')',          'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #397')

  " #398
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #398')
  call g:assert.equals(getline(2),   '(',          'failed at #398')
  call g:assert.equals(getline(3),   '(',          'failed at #398')
  call g:assert.equals(getline(4),   'foo',        'failed at #398')
  call g:assert.equals(getline(5),   ')',          'failed at #398')
  call g:assert.equals(getline(6),   ')',          'failed at #398')
  call g:assert.equals(getline(7),   ')',          'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #398')

  %delete

  """ tail
  " #399
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #399')
  call g:assert.equals(getline(2),   '(',          'failed at #399')
  call g:assert.equals(getline(3),   'foo',        'failed at #399')
  call g:assert.equals(getline(4),   ')',          'failed at #399')
  call g:assert.equals(getline(5),   ')',          'failed at #399')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #399')

  " #400
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #400')
  call g:assert.equals(getline(2),   '(',          'failed at #400')
  call g:assert.equals(getline(3),   '(',          'failed at #400')
  call g:assert.equals(getline(4),   'foo',        'failed at #400')
  call g:assert.equals(getline(5),   ')',          'failed at #400')
  call g:assert.equals(getline(6),   ')',          'failed at #400')
  call g:assert.equals(getline(7),   ')',          'failed at #400')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #400')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #401
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #401')
  call g:assert.equals(getline(2), '[',   'failed at #401')
  call g:assert.equals(getline(3), '(',   'failed at #401')
  call g:assert.equals(getline(4), 'foo', 'failed at #401')
  call g:assert.equals(getline(5), ')',   'failed at #401')
  call g:assert.equals(getline(6), ']',   'failed at #401')
  call g:assert.equals(getline(7), '}',   'failed at #401')

  %delete

  """ on
  " #402
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #402')
  call g:assert.equals(getline(2), '(',   'failed at #402')
  call g:assert.equals(getline(3), '(',   'failed at #402')
  call g:assert.equals(getline(4), 'foo', 'failed at #402')
  call g:assert.equals(getline(5), ')',   'failed at #402')
  call g:assert.equals(getline(6), ')',   'failed at #402')
  call g:assert.equals(getline(7), ')',   'failed at #402')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #403
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #403')
  call g:assert.equals(getline(2), 'foo', 'failed at #403')
  call g:assert.equals(getline(3), '1+2', 'failed at #403')

  %delete

  """ 1
  " #404
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #404')
  call g:assert.equals(getline(2), 'foo', 'failed at #404')
  call g:assert.equals(getline(3), '3',   'failed at #404')

  %delete

  " #405
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1), 'foo',   'failed at #405')
  call g:assert.equals(exists(s:object), 0, 'failed at #405')

  %delete

  " #406
  call setline('.', 'foo')
  normal Vsac
  call g:assert.equals(getline(1), 'foo',   'failed at #406')
  call g:assert.equals(exists(s:object), 0, 'failed at #406')

  %delete

  " #407
  call setline('.', 'foo')
  normal V2saab
  call g:assert.equals(getline(1), '2',     'failed at #407')
  call g:assert.equals(getline(2), 'foo',   'failed at #407')
  call g:assert.equals(getline(3), '3',     'failed at #407')
  call g:assert.equals(exists(s:object), 0, 'failed at #407')

  %delete

  " #408
  call setline('.', 'foo')
  normal V2saac
  call g:assert.equals(getline(1), '2',     'failed at #408')
  call g:assert.equals(getline(2), 'foo',   'failed at #408')
  call g:assert.equals(getline(3), '3',     'failed at #408')
  call g:assert.equals(exists(s:object), 0, 'failed at #408')

  %delete

  " #409
  call setline('.', 'foo')
  normal V2saba
  call g:assert.equals(getline(1), 'foo',   'failed at #409')
  call g:assert.equals(exists(s:object), 0, 'failed at #409')

  %delete

  " #410
  call setline('.', 'foo')
  normal V2saca
  call g:assert.equals(getline(1), 'foo',   'failed at #410')
  call g:assert.equals(exists(s:object), 0, 'failed at #410')

  %delete

  " #411
  call setline('.', 'foo')
  normal Vsad
  call g:assert.equals(getline(1), 'head', 'failed at #411')
  call g:assert.equals(getline(2), 'foo',  'failed at #411')
  call g:assert.equals(getline(3), 'tail', 'failed at #411')

  %delete

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'line', 'expr', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #412
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #412')
  call g:assert.equals(getline(2), 'foo', 'failed at #412')
  call g:assert.equals(getline(3), ']]',  'failed at #412')

  %delete

  """ off
  " #413
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #413')
  call g:assert.equals(getline(2), 'foo', 'failed at #413')
  call g:assert.equals(getline(3), '}}',  'failed at #413')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #414
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #414')
  call g:assert.equals(getline(2), 'foo ', 'failed at #414')
  call g:assert.equals(getline(3), ')',    'failed at #414')

  %delete

  """ off
  " #415
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #415')
  call g:assert.equals(getline(2), 'foo ', 'failed at #415')
  call g:assert.equals(getline(3), ')',    'failed at #415')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #416
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjVsa(
  call g:assert.equals(getline(1), '[', 'failed at #416')
  call g:assert.equals(getline(2), ']', 'failed at #416')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #417
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #417')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #418
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #418')
  call g:assert.equals(getline(2),   '    foo',    'failed at #418')
  call g:assert.equals(getline(3),   '    )',      'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #418')

  set autoindent&
endfunction
"}}}
function! s:suite.linewise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']}
        \ ]

  """ -1
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #419
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #419')
  call g:assert.equals(getline(2),   '[',          'failed at #419')
  call g:assert.equals(getline(3),   '',           'failed at #419')
  call g:assert.equals(getline(4),   '    foo',    'failed at #419')
  call g:assert.equals(getline(5),   '',           'failed at #419')
  call g:assert.equals(getline(6),   ']',          'failed at #419')
  call g:assert.equals(getline(7),   '}',          'failed at #419')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #419')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #419')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #419')
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
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #420')
  call g:assert.equals(getline(2),   '    [',      'failed at #420')
  call g:assert.equals(getline(3),   '',           'failed at #420')
  call g:assert.equals(getline(4),   '    foo',    'failed at #420')
  call g:assert.equals(getline(5),   '',           'failed at #420')
  call g:assert.equals(getline(6),   '    ]',      'failed at #420')
  call g:assert.equals(getline(7),   '    }',      'failed at #420')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #420')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #420')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #420')
  call g:assert.equals(&l:autoindent,  1,          'failed at #420')
  call g:assert.equals(&l:smartindent, 0,          'failed at #420')
  call g:assert.equals(&l:cindent,     0,          'failed at #420')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #420')

  %delete

  " #421
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #421')
  call g:assert.equals(getline(2),   '    [',       'failed at #421')
  call g:assert.equals(getline(3),   '',            'failed at #421')
  call g:assert.equals(getline(4),   '    foo',     'failed at #421')
  call g:assert.equals(getline(5),   '',            'failed at #421')
  call g:assert.equals(getline(6),   '    ]',       'failed at #421')
  call g:assert.equals(getline(7),   '}',           'failed at #421')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #421')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #421')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #421')
  call g:assert.equals(&l:autoindent,  1,           'failed at #421')
  call g:assert.equals(&l:smartindent, 1,           'failed at #421')
  call g:assert.equals(&l:cindent,     0,           'failed at #421')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #421')

  %delete

  " #422
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #422')
  call g:assert.equals(getline(2),   '    [',       'failed at #422')
  call g:assert.equals(getline(3),   '',            'failed at #422')
  call g:assert.equals(getline(4),   '    foo',     'failed at #422')
  call g:assert.equals(getline(5),   '',            'failed at #422')
  call g:assert.equals(getline(6),   '    ]',       'failed at #422')
  call g:assert.equals(getline(7),   '    }',       'failed at #422')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #422')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #422')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #422')
  call g:assert.equals(&l:autoindent,  1,           'failed at #422')
  call g:assert.equals(&l:smartindent, 1,           'failed at #422')
  call g:assert.equals(&l:cindent,     1,           'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #422')

  %delete

  " #423
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',            'failed at #423')
  call g:assert.equals(getline(2),   '           [',        'failed at #423')
  call g:assert.equals(getline(3),   '',                    'failed at #423')
  call g:assert.equals(getline(4),   '    foo',             'failed at #423')
  call g:assert.equals(getline(5),   '',                    'failed at #423')
  call g:assert.equals(getline(6),   '        ]',           'failed at #423')
  call g:assert.equals(getline(7),   '                }',   'failed at #423')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #423')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #423')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #423')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #423')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #423')
  call g:assert.equals(&l:cindent,     1,                   'failed at #423')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #423')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #424
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #424')
  call g:assert.equals(getline(2),   '[',          'failed at #424')
  call g:assert.equals(getline(3),   '',           'failed at #424')
  call g:assert.equals(getline(4),   '    foo',    'failed at #424')
  call g:assert.equals(getline(5),   '',           'failed at #424')
  call g:assert.equals(getline(6),   ']',          'failed at #424')
  call g:assert.equals(getline(7),   '}',          'failed at #424')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #424')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #424')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #424')
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
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #425')
  call g:assert.equals(getline(2),   '[',          'failed at #425')
  call g:assert.equals(getline(3),   '',           'failed at #425')
  call g:assert.equals(getline(4),   '    foo',    'failed at #425')
  call g:assert.equals(getline(5),   '',           'failed at #425')
  call g:assert.equals(getline(6),   ']',          'failed at #425')
  call g:assert.equals(getline(7),   '}',          'failed at #425')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #425')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #425')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #425')
  call g:assert.equals(&l:autoindent,  1,          'failed at #425')
  call g:assert.equals(&l:smartindent, 0,          'failed at #425')
  call g:assert.equals(&l:cindent,     0,          'failed at #425')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #425')

  %delete

  " #426
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:autoindent,  1,          'failed at #426')
  call g:assert.equals(&l:smartindent, 1,          'failed at #426')
  call g:assert.equals(&l:cindent,     0,          'failed at #426')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #426')

  %delete

  " #427
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:smartindent, 1,          'failed at #427')
  call g:assert.equals(&l:cindent,     1,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #428')
  call g:assert.equals(getline(2),   '[',              'failed at #428')
  call g:assert.equals(getline(3),   '',               'failed at #428')
  call g:assert.equals(getline(4),   '    foo',        'failed at #428')
  call g:assert.equals(getline(5),   '',               'failed at #428')
  call g:assert.equals(getline(6),   ']',              'failed at #428')
  call g:assert.equals(getline(7),   '}',              'failed at #428')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #428')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #428')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #428')
  call g:assert.equals(&l:autoindent,  1,              'failed at #428')
  call g:assert.equals(&l:smartindent, 1,              'failed at #428')
  call g:assert.equals(&l:cindent,     1,              'failed at #428')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #428')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #429
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #429')
  call g:assert.equals(getline(2),   '    [',      'failed at #429')
  call g:assert.equals(getline(3),   '',           'failed at #429')
  call g:assert.equals(getline(4),   '    foo',    'failed at #429')
  call g:assert.equals(getline(5),   '',           'failed at #429')
  call g:assert.equals(getline(6),   '    ]',      'failed at #429')
  call g:assert.equals(getline(7),   '    }',      'failed at #429')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #429')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #429')
  call g:assert.equals(&l:autoindent,  0,          'failed at #429')
  call g:assert.equals(&l:smartindent, 0,          'failed at #429')
  call g:assert.equals(&l:cindent,     0,          'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #429')

  %delete

  " #430
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #430')
  call g:assert.equals(getline(2),   '    [',      'failed at #430')
  call g:assert.equals(getline(3),   '',           'failed at #430')
  call g:assert.equals(getline(4),   '    foo',    'failed at #430')
  call g:assert.equals(getline(5),   '',           'failed at #430')
  call g:assert.equals(getline(6),   '    ]',      'failed at #430')
  call g:assert.equals(getline(7),   '    }',      'failed at #430')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #430')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #430')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #430')
  call g:assert.equals(&l:autoindent,  1,          'failed at #430')
  call g:assert.equals(&l:smartindent, 0,          'failed at #430')
  call g:assert.equals(&l:cindent,     0,          'failed at #430')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #430')

  %delete

  " #431
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:autoindent,  1,          'failed at #431')
  call g:assert.equals(&l:smartindent, 1,          'failed at #431')
  call g:assert.equals(&l:cindent,     0,          'failed at #431')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #431')

  %delete

  " #432
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:smartindent, 1,          'failed at #432')
  call g:assert.equals(&l:cindent,     1,          'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #432')

  %delete

  " #433
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #433')
  call g:assert.equals(getline(2),   '    [',          'failed at #433')
  call g:assert.equals(getline(3),   '',               'failed at #433')
  call g:assert.equals(getline(4),   '    foo',        'failed at #433')
  call g:assert.equals(getline(5),   '',               'failed at #433')
  call g:assert.equals(getline(6),   '    ]',          'failed at #433')
  call g:assert.equals(getline(7),   '    }',          'failed at #433')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #433')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #433')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #433')
  call g:assert.equals(&l:autoindent,  1,              'failed at #433')
  call g:assert.equals(&l:smartindent, 1,              'failed at #433')
  call g:assert.equals(&l:cindent,     1,              'failed at #433')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #433')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #434
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #434')
  call g:assert.equals(getline(2),   '    [',       'failed at #434')
  call g:assert.equals(getline(3),   '',            'failed at #434')
  call g:assert.equals(getline(4),   '    foo',     'failed at #434')
  call g:assert.equals(getline(5),   '',            'failed at #434')
  call g:assert.equals(getline(6),   '    ]',       'failed at #434')
  call g:assert.equals(getline(7),   '}',           'failed at #434')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #434')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #434')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #434')
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
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #435')
  call g:assert.equals(getline(2),   '    [',       'failed at #435')
  call g:assert.equals(getline(3),   '',            'failed at #435')
  call g:assert.equals(getline(4),   '    foo',     'failed at #435')
  call g:assert.equals(getline(5),   '',            'failed at #435')
  call g:assert.equals(getline(6),   '    ]',       'failed at #435')
  call g:assert.equals(getline(7),   '}',           'failed at #435')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #435')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #435')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #435')
  call g:assert.equals(&l:autoindent,  1,           'failed at #435')
  call g:assert.equals(&l:smartindent, 0,           'failed at #435')
  call g:assert.equals(&l:cindent,     0,           'failed at #435')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #435')

  %delete

  " #436
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:autoindent,  1,           'failed at #436')
  call g:assert.equals(&l:smartindent, 1,           'failed at #436')
  call g:assert.equals(&l:cindent,     0,           'failed at #436')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #436')

  %delete

  " #437
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:smartindent, 1,           'failed at #437')
  call g:assert.equals(&l:cindent,     1,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #438')
  call g:assert.equals(getline(2),   '    [',          'failed at #438')
  call g:assert.equals(getline(3),   '',               'failed at #438')
  call g:assert.equals(getline(4),   '    foo',        'failed at #438')
  call g:assert.equals(getline(5),   '',               'failed at #438')
  call g:assert.equals(getline(6),   '    ]',          'failed at #438')
  call g:assert.equals(getline(7),   '}',              'failed at #438')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #438')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #438')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #438')
  call g:assert.equals(&l:autoindent,  1,              'failed at #438')
  call g:assert.equals(&l:smartindent, 1,              'failed at #438')
  call g:assert.equals(&l:cindent,     1,              'failed at #438')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #438')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #439
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #439')
  call g:assert.equals(getline(2),   '    [',       'failed at #439')
  call g:assert.equals(getline(3),   '',            'failed at #439')
  call g:assert.equals(getline(4),   '    foo',     'failed at #439')
  call g:assert.equals(getline(5),   '',            'failed at #439')
  call g:assert.equals(getline(6),   '    ]',       'failed at #439')
  call g:assert.equals(getline(7),   '    }',       'failed at #439')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #439')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #439')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #439')
  call g:assert.equals(&l:autoindent,  0,           'failed at #439')
  call g:assert.equals(&l:smartindent, 0,           'failed at #439')
  call g:assert.equals(&l:cindent,     0,           'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #439')

  %delete

  " #440
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #440')
  call g:assert.equals(getline(2),   '    [',       'failed at #440')
  call g:assert.equals(getline(3),   '',            'failed at #440')
  call g:assert.equals(getline(4),   '    foo',     'failed at #440')
  call g:assert.equals(getline(5),   '',            'failed at #440')
  call g:assert.equals(getline(6),   '    ]',       'failed at #440')
  call g:assert.equals(getline(7),   '    }',       'failed at #440')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #440')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #440')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #440')
  call g:assert.equals(&l:autoindent,  1,           'failed at #440')
  call g:assert.equals(&l:smartindent, 0,           'failed at #440')
  call g:assert.equals(&l:cindent,     0,           'failed at #440')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #440')

  %delete

  " #441
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:autoindent,  1,           'failed at #441')
  call g:assert.equals(&l:smartindent, 1,           'failed at #441')
  call g:assert.equals(&l:cindent,     0,           'failed at #441')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #441')

  %delete

  " #442
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
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
  call g:assert.equals(&l:smartindent, 1,           'failed at #442')
  call g:assert.equals(&l:cindent,     1,           'failed at #442')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #442')

  %delete

  " #443
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #443')
  call g:assert.equals(getline(2),   '    [',          'failed at #443')
  call g:assert.equals(getline(3),   '',               'failed at #443')
  call g:assert.equals(getline(4),   '    foo',        'failed at #443')
  call g:assert.equals(getline(5),   '',               'failed at #443')
  call g:assert.equals(getline(6),   '    ]',          'failed at #443')
  call g:assert.equals(getline(7),   '    }',          'failed at #443')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #443')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #443')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #443')
  call g:assert.equals(&l:autoindent,  1,              'failed at #443')
  call g:assert.equals(&l:smartindent, 1,              'failed at #443')
  call g:assert.equals(&l:cindent,     1,              'failed at #443')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #443')
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

  """ cinkeys
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #444
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #444')
  call g:assert.equals(getline(2),   '',           'failed at #444')
  call g:assert.equals(getline(3),   '    foo',    'failed at #444')
  call g:assert.equals(getline(4),   '',           'failed at #444')
  call g:assert.equals(getline(5),   '    }',      'failed at #444')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #444')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #444')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #444')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #444')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #444')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #445
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #445')
  call g:assert.equals(getline(2),   '',           'failed at #445')
  call g:assert.equals(getline(3),   '    foo',    'failed at #445')
  call g:assert.equals(getline(4),   '',           'failed at #445')
  call g:assert.equals(getline(5),   '    }',      'failed at #445')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #445')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #445')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #445')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #445')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #445')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #446
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #446')
  call g:assert.equals(getline(2),   '',           'failed at #446')
  call g:assert.equals(getline(3),   '    foo',    'failed at #446')
  call g:assert.equals(getline(4),   '',           'failed at #446')
  call g:assert.equals(getline(5),   '    }',      'failed at #446')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #446')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #446')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #446')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #446')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #446')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #447
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #447')
  call g:assert.equals(getline(2),   '',              'failed at #447')
  call g:assert.equals(getline(3),   '    foo',       'failed at #447')
  call g:assert.equals(getline(4),   '',              'failed at #447')
  call g:assert.equals(getline(5),   '    }',         'failed at #447')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #447')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #447')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #447')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #447')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #447')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #448
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',      'failed at #448')
  call g:assert.equals(getline(2),   '',              'failed at #448')
  call g:assert.equals(getline(3),   '    foo',       'failed at #448')
  call g:assert.equals(getline(4),   '',              'failed at #448')
  call g:assert.equals(getline(5),   '            }', 'failed at #448')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #448')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #448')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #448')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #448')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #448')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #449
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #449')
  call g:assert.equals(getline(2),   '',              'failed at #449')
  call g:assert.equals(getline(3),   '    foo',       'failed at #449')
  call g:assert.equals(getline(4),   '',              'failed at #449')
  call g:assert.equals(getline(5),   '    }',         'failed at #449')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #449')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #449')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #449')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #449')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #449')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #450
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #450')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #450')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #450')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #450')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #450')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #450')

  %delete

  " #451
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #451')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #451')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #451')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #451')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #451')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #451')

  %delete

  " #452
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #452')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #452')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #452')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #452')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #452')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #452')

  %delete

  " #453
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #453')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #453')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #453')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #453')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #453')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #453')

  %delete

  " #454
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #454')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #454')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #454')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #454')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #454')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #454')

  %delete

  " #455
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #455')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #455')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #455')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #455')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #455')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #455')

  %delete

  " #456
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #456')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #456')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #456')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #456')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #456')

  %delete

  " #457
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #457')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #457')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #457')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #457')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #457')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #458
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #458')
  call g:assert.equals(getline(2),   'abara',      'failed at #458')
  call g:assert.equals(getline(3),   'abaza',      'failed at #458')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #458')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #458')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #458')

  %delete

  " #459
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #459')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #459')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #459')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #459')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #459')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #460
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #460')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #460')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #460')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #460')

  %delete

  " #461
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #461')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #461')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #461')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #461')

  %delete

  " #462
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #462')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #462')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #462')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #462')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #462')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #462')

  %delete

  " #463
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #463')
  call g:assert.equals(getline(2),   '',           'failed at #463')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #463')

  %delete

  " #464
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #464')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #464')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #464')

  %delete

  " #465
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #465')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #465')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #465')

  %delete

  " #466
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #466')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #466')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #466')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #467
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #467')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #467')

  %delete

  " #468
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #468')
  call g:assert.equals(getline(2),   '(a)',        'failed at #468')
  call g:assert.equals(getline(3),   '(a)',        'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #468')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #468')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #469
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #469')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #469')
  call g:assert.equals(getline(3),   'aa',         'failed at #469')
  call g:assert.equals(getline(4),   'aa',         'failed at #469')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #469')
  call g:assert.equals(getline(6),   'aa',         'failed at #469')
  call g:assert.equals(getline(7),   'aa',         'failed at #469')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #469')
  call g:assert.equals(getline(9),   'aa',         'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #469')

  %delete

  " #470
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #470')
  call g:assert.equals(getline(2),   'bbb',         'failed at #470')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #470')
  call g:assert.equals(getline(4),   'bbb',         'failed at #470')
  call g:assert.equals(getline(5),   'bb',          'failed at #470')
  call g:assert.equals(getline(6),   'bb',          'failed at #470')
  call g:assert.equals(getline(7),   'bbb',         'failed at #470')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #470')
  call g:assert.equals(getline(9),   'bbb',         'failed at #470')
  call g:assert.equals(getline(10),  'bb',          'failed at #470')
  call g:assert.equals(getline(11),  'bb',          'failed at #470')
  call g:assert.equals(getline(12),  'bbb',         'failed at #470')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #470')
  call g:assert.equals(getline(14),  'bbb',         'failed at #470')
  call g:assert.equals(getline(15),  'bb',          'failed at #470')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #470')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #471
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #471')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #471')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #471')

  %delete

  " #472
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #472')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #472')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #472')

  %delete

  " #473
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #473')

  %delete

  " #474
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #474')

  %delete

  " #475
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #475')
  %delete

  " #476
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #476')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #476')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #476')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #476')
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #477
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5l("
  call g:assert.equals(getline(1), '(α)',         'failed at #477')
  call g:assert.equals(getline(2), '(β)',         'failed at #477')
  call g:assert.equals(getline(3), '(γ)',         'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #477')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #477')

  %delete

  " #478
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1), '(aα)',        'failed at #478')
  call g:assert.equals(getline(2), '(bβ)',        'failed at #478')
  call g:assert.equals(getline(3), '(cγ)',        'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #478')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #479
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'αaα', 'failed at #479')
  call g:assert.equals(getline(2), 'αbα', 'failed at #479')
  call g:assert.equals(getline(3), 'αcα', 'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #479')

  %delete

  " #480
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'ααα', 'failed at #480')
  call g:assert.equals(getline(2), 'αβα', 'failed at #480')
  call g:assert.equals(getline(3), 'αγα', 'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #480')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #480')

  %delete

  " #481
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'αaαα', 'failed at #481')
  call g:assert.equals(getline(2), 'αbβα', 'failed at #481')
  call g:assert.equals(getline(3), 'αcγα', 'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #481')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #481')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #482
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'aαaaα', 'failed at #482')
  call g:assert.equals(getline(2), 'aαbaα', 'failed at #482')
  call g:assert.equals(getline(3), 'aαcaα', 'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #482')

  %delete

  " #483
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'aααaα', 'failed at #483')
  call g:assert.equals(getline(2), 'aαβaα',  'failed at #483')
  call g:assert.equals(getline(3), 'aαγaα', 'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #483')

  %delete

  " #484
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'aαaαaα', 'failed at #484')
  call g:assert.equals(getline(2), 'aαbβaα', 'failed at #484')
  call g:assert.equals(getline(3), 'aαcγaα', 'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #484')

  %delete
  unlet g:operator#sandwich#recipes

  " #485
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5l("
  call g:assert.equals(getline(1), '(“)', 'failed at #485')
  call g:assert.equals(getline(2), '(“)', 'failed at #485')
  call g:assert.equals(getline(3), '(“)', 'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #485')

  %delete

  " #486
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1), '(a“)', 'failed at #486')
  call g:assert.equals(getline(2), '(b“)', 'failed at #486')
  call g:assert.equals(getline(3), '(c“)', 'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #486')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #486')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #487
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), '“a“', 'failed at #487')
  call g:assert.equals(getline(2), '“b“', 'failed at #487')
  call g:assert.equals(getline(3), '“c“', 'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #487')

  %delete

  " #488
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), '“““', 'failed at #488')
  call g:assert.equals(getline(2), '“““', 'failed at #488')
  call g:assert.equals(getline(3), '“““', 'failed at #488')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #488')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #488')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #488')

  %delete

  " #489
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), '“a““', 'failed at #489')
  call g:assert.equals(getline(2), '“b““', 'failed at #489')
  call g:assert.equals(getline(3), '“c““', 'failed at #489')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #489')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #489')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #490
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'a“aa“', 'failed at #490')
  call g:assert.equals(getline(2), 'a“ba“', 'failed at #490')
  call g:assert.equals(getline(3), 'a“ca“', 'failed at #490')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #490')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #490')

  %delete

  " #491
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'a““a“', 'failed at #491')
  call g:assert.equals(getline(2), 'a““a“',  'failed at #491')
  call g:assert.equals(getline(3), 'a““a“', 'failed at #491')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #491')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #491')

  %delete

  " #492
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'a“a“a“', 'failed at #492')
  call g:assert.equals(getline(2), 'a“b“a“', 'failed at #492')
  call g:assert.equals(getline(3), 'a“c“a“', 'failed at #492')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #492')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #492')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #493
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #493')

  " #494
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #494')

  """ keep
  " #495
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #495')

  " #496
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #496')

  """ inner_tail
  " #497
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #497')

  " #498
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #498')

  """ head
  " #499
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #499')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #499')

  " #500
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #500')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #500')

  """ tail
  " #501
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #501')

  " #502
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #502')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #502')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #503
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #503')

  %delete

  """ on
  " #504
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #504')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  set whichwrap=h,l

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #505
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #505')

  """ 1
  " #506
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #506')

  %delete

  " #507
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1), 'foo', 'failed at #507')
  call g:assert.equals(getline(2), 'bar', 'failed at #507')
  call g:assert.equals(getline(3), 'baz', 'failed at #507')
  call g:assert.equals(exists(s:object), 0, 'failed at #507')

  %delete

  " #508
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lc"
  call g:assert.equals(getline(1), 'foo', 'failed at #508')
  call g:assert.equals(getline(2), 'bar', 'failed at #508')
  call g:assert.equals(getline(3), 'baz', 'failed at #508')
  call g:assert.equals(exists(s:object), 0, 'failed at #508')

  %delete

  " #509
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #509')
  call g:assert.equals(getline(2), '2bar3', 'failed at #509')
  call g:assert.equals(getline(3), '2baz3', 'failed at #509')
  call g:assert.equals(exists(s:object), 0, 'failed at #509')

  %delete

  " #510
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #510')
  call g:assert.equals(getline(2), '2bar3', 'failed at #510')
  call g:assert.equals(getline(3), '2baz3', 'failed at #510')
  call g:assert.equals(exists(s:object), 0, 'failed at #510')

  %delete

  " #511
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lba"
  call g:assert.equals(getline(1), 'foo', 'failed at #511')
  call g:assert.equals(getline(2), 'bar', 'failed at #511')
  call g:assert.equals(getline(3), 'baz', 'failed at #511')
  call g:assert.equals(exists(s:object), 0, 'failed at #511')

  %delete

  " #512
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lca"
  call g:assert.equals(getline(1), 'foo', 'failed at #512')
  call g:assert.equals(getline(2), 'bar', 'failed at #512')
  call g:assert.equals(getline(3), 'baz', 'failed at #512')
  call g:assert.equals(exists(s:object), 0, 'failed at #512')

  %delete

  " #513
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11ld"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #513')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #513')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #513')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'block', 'expr', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #514
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #514')

  """ off
  " #515
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #515')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #516
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #516')

  """ off
  " #517
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #517')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #518
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ffsa\<C-v>iw("
  call g:assert.equals(getline('.'), '""',  'failed at #518')
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #519
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #519')
  call g:assert.equals(getline(2), 'foo', 'failed at #519')
  call g:assert.equals(getline(3), ')',   'failed at #519')

  %delete

  " #520
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #520')
  call g:assert.equals(getline(2),   '    foo',    'failed at #520')
  call g:assert.equals(getline(3),   '    )',      'failed at #520')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #520')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #520')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #520')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
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
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #521
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #521')
  call g:assert.equals(getline(2),   '[',          'failed at #521')
  call g:assert.equals(getline(3),   'foo',        'failed at #521')
  call g:assert.equals(getline(4),   ']',          'failed at #521')
  call g:assert.equals(getline(5),   '}',          'failed at #521')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #521')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #521')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #521')
  call g:assert.equals(&l:autoindent,  0,          'failed at #521')
  call g:assert.equals(&l:smartindent, 0,          'failed at #521')
  call g:assert.equals(&l:cindent,     0,          'failed at #521')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #521')

  %delete

  " #522
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #522')
  call g:assert.equals(getline(2),   '    [',      'failed at #522')
  call g:assert.equals(getline(3),   '    foo',    'failed at #522')
  call g:assert.equals(getline(4),   '    ]',      'failed at #522')
  call g:assert.equals(getline(5),   '    }',      'failed at #522')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #522')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #522')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #522')
  call g:assert.equals(&l:autoindent,  1,          'failed at #522')
  call g:assert.equals(&l:smartindent, 0,          'failed at #522')
  call g:assert.equals(&l:cindent,     0,          'failed at #522')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #522')

  %delete

  " #523
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #523')
  call g:assert.equals(getline(2),   '        [',   'failed at #523')
  call g:assert.equals(getline(3),   '        foo', 'failed at #523')
  call g:assert.equals(getline(4),   '    ]',       'failed at #523')
  call g:assert.equals(getline(5),   '}',           'failed at #523')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #523')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #523')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #523')
  call g:assert.equals(&l:autoindent,  1,           'failed at #523')
  call g:assert.equals(&l:smartindent, 1,           'failed at #523')
  call g:assert.equals(&l:cindent,     0,           'failed at #523')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #523')

  %delete

  " #524
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #524')
  call g:assert.equals(getline(2),   '    [',       'failed at #524')
  call g:assert.equals(getline(3),   '        foo', 'failed at #524')
  call g:assert.equals(getline(4),   '    ]',       'failed at #524')
  call g:assert.equals(getline(5),   '    }',       'failed at #524')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #524')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #524')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #524')
  call g:assert.equals(&l:autoindent,  1,           'failed at #524')
  call g:assert.equals(&l:smartindent, 1,           'failed at #524')
  call g:assert.equals(&l:cindent,     1,           'failed at #524')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #524')

  %delete

  " #525
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',           'failed at #525')
  call g:assert.equals(getline(2),   '            [',       'failed at #525')
  call g:assert.equals(getline(3),   '                foo', 'failed at #525')
  call g:assert.equals(getline(4),   '        ]',           'failed at #525')
  call g:assert.equals(getline(5),   '                }',   'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #525')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #525')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #525')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #525')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #525')
  call g:assert.equals(&l:cindent,     1,                   'failed at #525')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #525')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #526
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #526')
  call g:assert.equals(getline(2),   '[',          'failed at #526')
  call g:assert.equals(getline(3),   'foo',        'failed at #526')
  call g:assert.equals(getline(4),   ']',          'failed at #526')
  call g:assert.equals(getline(5),   '}',          'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #526')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #526')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #526')
  call g:assert.equals(&l:autoindent,  0,          'failed at #526')
  call g:assert.equals(&l:smartindent, 0,          'failed at #526')
  call g:assert.equals(&l:cindent,     0,          'failed at #526')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #526')

  %delete

  " #527
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #527')
  call g:assert.equals(getline(2),   '[',          'failed at #527')
  call g:assert.equals(getline(3),   'foo',        'failed at #527')
  call g:assert.equals(getline(4),   ']',          'failed at #527')
  call g:assert.equals(getline(5),   '}',          'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #527')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #527')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #527')
  call g:assert.equals(&l:autoindent,  1,          'failed at #527')
  call g:assert.equals(&l:smartindent, 0,          'failed at #527')
  call g:assert.equals(&l:cindent,     0,          'failed at #527')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #527')

  %delete

  " #528
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #528')
  call g:assert.equals(getline(2),   '[',          'failed at #528')
  call g:assert.equals(getline(3),   'foo',        'failed at #528')
  call g:assert.equals(getline(4),   ']',          'failed at #528')
  call g:assert.equals(getline(5),   '}',          'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #528')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #528')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #528')
  call g:assert.equals(&l:autoindent,  1,          'failed at #528')
  call g:assert.equals(&l:smartindent, 1,          'failed at #528')
  call g:assert.equals(&l:cindent,     0,          'failed at #528')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #528')

  %delete

  " #529
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #529')
  call g:assert.equals(getline(2),   '[',          'failed at #529')
  call g:assert.equals(getline(3),   'foo',        'failed at #529')
  call g:assert.equals(getline(4),   ']',          'failed at #529')
  call g:assert.equals(getline(5),   '}',          'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #529')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #529')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #529')
  call g:assert.equals(&l:autoindent,  1,          'failed at #529')
  call g:assert.equals(&l:smartindent, 1,          'failed at #529')
  call g:assert.equals(&l:cindent,     1,          'failed at #529')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #529')

  %delete

  " #530
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #530')
  call g:assert.equals(getline(2),   '[',              'failed at #530')
  call g:assert.equals(getline(3),   'foo',            'failed at #530')
  call g:assert.equals(getline(4),   ']',              'failed at #530')
  call g:assert.equals(getline(5),   '}',              'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #530')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #530')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #530')
  call g:assert.equals(&l:autoindent,  1,              'failed at #530')
  call g:assert.equals(&l:smartindent, 1,              'failed at #530')
  call g:assert.equals(&l:cindent,     1,              'failed at #530')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #530')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #531
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #531')
  call g:assert.equals(getline(2),   '    [',      'failed at #531')
  call g:assert.equals(getline(3),   '    foo',    'failed at #531')
  call g:assert.equals(getline(4),   '    ]',      'failed at #531')
  call g:assert.equals(getline(5),   '    }',      'failed at #531')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #531')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #531')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #531')
  call g:assert.equals(&l:autoindent,  0,          'failed at #531')
  call g:assert.equals(&l:smartindent, 0,          'failed at #531')
  call g:assert.equals(&l:cindent,     0,          'failed at #531')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #531')

  %delete

  " #532
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #532')
  call g:assert.equals(getline(2),   '    [',      'failed at #532')
  call g:assert.equals(getline(3),   '    foo',    'failed at #532')
  call g:assert.equals(getline(4),   '    ]',      'failed at #532')
  call g:assert.equals(getline(5),   '    }',      'failed at #532')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #532')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #532')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #532')
  call g:assert.equals(&l:autoindent,  1,          'failed at #532')
  call g:assert.equals(&l:smartindent, 0,          'failed at #532')
  call g:assert.equals(&l:cindent,     0,          'failed at #532')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #532')

  %delete

  " #533
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #533')
  call g:assert.equals(getline(2),   '    [',      'failed at #533')
  call g:assert.equals(getline(3),   '    foo',    'failed at #533')
  call g:assert.equals(getline(4),   '    ]',      'failed at #533')
  call g:assert.equals(getline(5),   '    }',      'failed at #533')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #533')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #533')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #533')
  call g:assert.equals(&l:autoindent,  1,          'failed at #533')
  call g:assert.equals(&l:smartindent, 1,          'failed at #533')
  call g:assert.equals(&l:cindent,     0,          'failed at #533')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #533')

  %delete

  " #534
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #534')
  call g:assert.equals(getline(2),   '    [',      'failed at #534')
  call g:assert.equals(getline(3),   '    foo',    'failed at #534')
  call g:assert.equals(getline(4),   '    ]',      'failed at #534')
  call g:assert.equals(getline(5),   '    }',      'failed at #534')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #534')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #534')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #534')
  call g:assert.equals(&l:autoindent,  1,          'failed at #534')
  call g:assert.equals(&l:smartindent, 1,          'failed at #534')
  call g:assert.equals(&l:cindent,     1,          'failed at #534')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #534')

  %delete

  " #535
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #535')
  call g:assert.equals(getline(2),   '    [',          'failed at #535')
  call g:assert.equals(getline(3),   '    foo',        'failed at #535')
  call g:assert.equals(getline(4),   '    ]',          'failed at #535')
  call g:assert.equals(getline(5),   '    }',          'failed at #535')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #535')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #535')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #535')
  call g:assert.equals(&l:autoindent,  1,              'failed at #535')
  call g:assert.equals(&l:smartindent, 1,              'failed at #535')
  call g:assert.equals(&l:cindent,     1,              'failed at #535')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #535')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #536
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #536')
  call g:assert.equals(getline(2),   '        [',   'failed at #536')
  call g:assert.equals(getline(3),   '        foo', 'failed at #536')
  call g:assert.equals(getline(4),   '    ]',       'failed at #536')
  call g:assert.equals(getline(5),   '}',           'failed at #536')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #536')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #536')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #536')
  call g:assert.equals(&l:autoindent,  0,           'failed at #536')
  call g:assert.equals(&l:smartindent, 0,           'failed at #536')
  call g:assert.equals(&l:cindent,     0,           'failed at #536')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #536')

  %delete

  " #537
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #537')
  call g:assert.equals(getline(2),   '        [',   'failed at #537')
  call g:assert.equals(getline(3),   '        foo', 'failed at #537')
  call g:assert.equals(getline(4),   '    ]',       'failed at #537')
  call g:assert.equals(getline(5),   '}',           'failed at #537')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #537')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #537')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #537')
  call g:assert.equals(&l:autoindent,  1,           'failed at #537')
  call g:assert.equals(&l:smartindent, 0,           'failed at #537')
  call g:assert.equals(&l:cindent,     0,           'failed at #537')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #537')

  %delete

  " #538
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #538')
  call g:assert.equals(getline(2),   '        [',   'failed at #538')
  call g:assert.equals(getline(3),   '        foo', 'failed at #538')
  call g:assert.equals(getline(4),   '    ]',       'failed at #538')
  call g:assert.equals(getline(5),   '}',           'failed at #538')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #538')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #538')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #538')
  call g:assert.equals(&l:autoindent,  1,           'failed at #538')
  call g:assert.equals(&l:smartindent, 1,           'failed at #538')
  call g:assert.equals(&l:cindent,     0,           'failed at #538')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #538')

  %delete

  " #539
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #539')
  call g:assert.equals(getline(2),   '        [',   'failed at #539')
  call g:assert.equals(getline(3),   '        foo', 'failed at #539')
  call g:assert.equals(getline(4),   '    ]',       'failed at #539')
  call g:assert.equals(getline(5),   '}',           'failed at #539')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #539')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #539')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #539')
  call g:assert.equals(&l:autoindent,  1,           'failed at #539')
  call g:assert.equals(&l:smartindent, 1,           'failed at #539')
  call g:assert.equals(&l:cindent,     1,           'failed at #539')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #539')

  %delete

  " #540
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #540')
  call g:assert.equals(getline(2),   '        [',      'failed at #540')
  call g:assert.equals(getline(3),   '        foo',    'failed at #540')
  call g:assert.equals(getline(4),   '    ]',          'failed at #540')
  call g:assert.equals(getline(5),   '}',              'failed at #540')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #540')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #540')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #540')
  call g:assert.equals(&l:autoindent,  1,              'failed at #540')
  call g:assert.equals(&l:smartindent, 1,              'failed at #540')
  call g:assert.equals(&l:cindent,     1,              'failed at #540')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #540')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #541
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #541')
  call g:assert.equals(getline(2),   '    [',       'failed at #541')
  call g:assert.equals(getline(3),   '        foo', 'failed at #541')
  call g:assert.equals(getline(4),   '    ]',       'failed at #541')
  call g:assert.equals(getline(5),   '    }',       'failed at #541')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #541')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #541')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #541')
  call g:assert.equals(&l:autoindent,  0,           'failed at #541')
  call g:assert.equals(&l:smartindent, 0,           'failed at #541')
  call g:assert.equals(&l:cindent,     0,           'failed at #541')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #541')

  %delete

  " #542
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #542')
  call g:assert.equals(getline(2),   '    [',       'failed at #542')
  call g:assert.equals(getline(3),   '        foo', 'failed at #542')
  call g:assert.equals(getline(4),   '    ]',       'failed at #542')
  call g:assert.equals(getline(5),   '    }',       'failed at #542')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #542')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #542')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #542')
  call g:assert.equals(&l:autoindent,  1,           'failed at #542')
  call g:assert.equals(&l:smartindent, 0,           'failed at #542')
  call g:assert.equals(&l:cindent,     0,           'failed at #542')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #542')

  %delete

  " #543
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #543')
  call g:assert.equals(getline(2),   '    [',       'failed at #543')
  call g:assert.equals(getline(3),   '        foo', 'failed at #543')
  call g:assert.equals(getline(4),   '    ]',       'failed at #543')
  call g:assert.equals(getline(5),   '    }',       'failed at #543')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #543')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #543')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #543')
  call g:assert.equals(&l:autoindent,  1,           'failed at #543')
  call g:assert.equals(&l:smartindent, 1,           'failed at #543')
  call g:assert.equals(&l:cindent,     0,           'failed at #543')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #543')

  %delete

  " #544
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #544')
  call g:assert.equals(getline(2),   '    [',       'failed at #544')
  call g:assert.equals(getline(3),   '        foo', 'failed at #544')
  call g:assert.equals(getline(4),   '    ]',       'failed at #544')
  call g:assert.equals(getline(5),   '    }',       'failed at #544')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #544')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #544')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #544')
  call g:assert.equals(&l:autoindent,  1,           'failed at #544')
  call g:assert.equals(&l:smartindent, 1,           'failed at #544')
  call g:assert.equals(&l:cindent,     1,           'failed at #544')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #544')

  %delete

  " #545
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',              'failed at #545')
  call g:assert.equals(getline(2),   '    [',          'failed at #545')
  call g:assert.equals(getline(3),   '        foo',    'failed at #545')
  call g:assert.equals(getline(4),   '    ]',          'failed at #545')
  call g:assert.equals(getline(5),   '    }',          'failed at #545')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #545')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #545')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #545')
  call g:assert.equals(&l:autoindent,  1,              'failed at #545')
  call g:assert.equals(&l:smartindent, 1,              'failed at #545')
  call g:assert.equals(&l:cindent,     1,              'failed at #545')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #545')
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
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #546
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #546')
  call g:assert.equals(getline(2),   'foo',        'failed at #546')
  call g:assert.equals(getline(3),   '    }',      'failed at #546')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #546')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #546')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #546')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #546')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #546')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #547
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #547')
  call g:assert.equals(getline(2),   '    foo',    'failed at #547')
  call g:assert.equals(getline(3),   '    }',      'failed at #547')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #547')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #547')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #547')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #547')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #547')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #548
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #548')
  call g:assert.equals(getline(2),   'foo',        'failed at #548')
  call g:assert.equals(getline(3),   '    }',      'failed at #548')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #548')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #548')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #548')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #548')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #548')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #549
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #549')
  call g:assert.equals(getline(2),   'foo',        'failed at #549')
  call g:assert.equals(getline(3),   '    }',      'failed at #549')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #549')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #549')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #549')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #549')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #549')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #550
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',     'failed at #550')
  call g:assert.equals(getline(2),   '    foo',       'failed at #550')
  call g:assert.equals(getline(3),   '            }', 'failed at #550')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #550')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #550')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #550')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #550')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #550')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #551
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #551')
  call g:assert.equals(getline(2),   'foo',        'failed at #551')
  call g:assert.equals(getline(3),   '    }',      'failed at #551')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #551')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #551')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #551')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #551')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #551')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #521
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #521')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #521')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #521')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #521')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #521')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #521')

  " #522
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #522')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #522')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #522')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #522')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #522')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #522')

  " #523
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #523')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #523')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #523')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #523')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #523')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #523')

  " #524
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #524')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #524')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #524')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #524')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #524')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #524')

  " #525
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #525')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #525')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #525')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #525')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #525')

  " #526
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #526')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #526')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #526')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #526')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #526')

  " #527
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #527')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #527')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #527')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #527')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #527')

  " #528
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #528')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #528')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #528')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #528')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #528')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #529
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #529')
  call g:assert.equals(getline(2),   'abara',      'failed at #529')
  call g:assert.equals(getline(3),   'abaza',      'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #529')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #529')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #529')

  %delete

  " #530
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #530')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #530')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #530')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #530')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #530')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #531
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #531')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #531')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #531')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #531')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #531')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #531')

  %delete

  " #532
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #532')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #532')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #532')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #532')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #532')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #532')

  %delete

  " #533
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #533')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #533')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #533')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #533')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #533')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #533')

  %delete

  " #534
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #534')
  call g:assert.equals(getline(2),   '',           'failed at #534')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #534')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #534')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #534')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #534')

  %delete

  " #535
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #535')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #535')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #535')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #535')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #535')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #535')

  %delete

  " #536
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #536')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #536')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #536')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #536')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #536')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #536')

  %delete

  " #537
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #537')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #537')
  call g:assert.equals(getline(3),   '(ba)',       'failed at #537')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #537')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #537')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #537')

  %delete

  " #538
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #538')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #538')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #538')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #538')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #538')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #538')

  %delete

  """ terminal-extended block-wise visual mode
  " #539
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #539')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #539')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #539')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #539')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #539')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #539')

  %delete

  " #540
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #540')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #540')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #540')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #540')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #540')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #540')

  %delete

  " #541
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #541')
  call g:assert.equals(getline(2),   '',           'failed at #541')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #541')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #541')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #541')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #541')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #542
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #542')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #542')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #542')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #542')

  %delete

  " #543
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #543')
  call g:assert.equals(getline(2),   '(a)',        'failed at #543')
  call g:assert.equals(getline(3),   '(a)',        'failed at #543')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #543')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #543')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #543')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  " #544
  call append(0, ['', 'foo'])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '',           'failed at #544')
  call g:assert.equals(getline(2),   '(foo)',      'failed at #544')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #544')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #544')
  " call g:assert.equals(getpos("']"), [0, 2, 5, 0], 'failed at #544')

  %delete

  " #545
  call append(0, ['foo', ''])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #545')
  call g:assert.equals(getline(2),   '',           'failed at #545')
  " call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #545')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #545')
  " call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #545')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #546
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #546')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #546')
  call g:assert.equals(getline(3),   'aa',         'failed at #546')
  call g:assert.equals(getline(4),   'aa',         'failed at #546')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #546')
  call g:assert.equals(getline(6),   'aa',         'failed at #546')
  call g:assert.equals(getline(7),   'aa',         'failed at #546')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #546')
  call g:assert.equals(getline(9),   'aa',         'failed at #546')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #546')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #546')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #546')

  %delete

  " #547
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #547')
  call g:assert.equals(getline(2),   'bbb',         'failed at #547')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #547')
  call g:assert.equals(getline(4),   'bbb',         'failed at #547')
  call g:assert.equals(getline(5),   'bb',          'failed at #547')
  call g:assert.equals(getline(6),   'bb',          'failed at #547')
  call g:assert.equals(getline(7),   'bbb',         'failed at #547')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #547')
  call g:assert.equals(getline(9),   'bbb',         'failed at #547')
  call g:assert.equals(getline(10),  'bb',          'failed at #547')
  call g:assert.equals(getline(11),  'bb',          'failed at #547')
  call g:assert.equals(getline(12),  'bbb',         'failed at #547')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #547')
  call g:assert.equals(getline(14),  'bbb',         'failed at #547')
  call g:assert.equals(getline(15),  'bb',          'failed at #547')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #547')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #547')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #547')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #548
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #548')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #548')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #548')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #548')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #548')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #548')

  %delete

  " #549
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #549')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #549')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #549')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #549')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #549')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #549')
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #550
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(α)',          'failed at #550')
  call g:assert.equals(getline(2), '(β)',          'failed at #550')
  call g:assert.equals(getline(3), '(γ)',          'failed at #550')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #550')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #550')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #550')

  %delete

  " #551
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsa("
  call g:assert.equals(getline(1), '(aα)',         'failed at #551')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #551')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #551')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #551')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #551')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #551')

  %delete
  set ambiwidth=double

  " #552
  call append(0, ['a', 'α', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(a)',          'failed at #552')
  call g:assert.equals(getline(2), '(α)',          'failed at #552')
  call g:assert.equals(getline(3), '(a)',          'failed at #552')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #552')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #552')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #552')

  %delete

  " #553
  call append(0, ['a', 'a', 'α'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(a)',          'failed at #553')
  call g:assert.equals(getline(2), '(a)',          'failed at #553')
  call g:assert.equals(getline(3), '(α)',          'failed at #553')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #553')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #553')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(α)')+1, 0], 'failed at #553')

  %delete

  " #554
  call append(0, ['abc', 'αβγ', 'abc'])
  execute "normal ggl\<C-v>2jsa("
  call g:assert.equals(getline(1), 'a(b)c',        'failed at #554')
  call g:assert.equals(getline(2), '(α)βγ',        'failed at #554')
  call g:assert.equals(getline(3), 'a(b)c',        'failed at #554')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #554')
  call g:assert.equals(getpos("'["), [0, 1, 2, 0], 'failed at #554')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #554')

  %delete
  set ambiwidth=single

  " #555
  call append(0, ['abc', 'αβγ', 'abc'])
  execute "normal ggl\<C-v>2jsa("
  call g:assert.equals(getline(1), 'a(b)c',        'failed at #555')
  call g:assert.equals(getline(2), 'α(β)γ',        'failed at #555')
  call g:assert.equals(getline(3), 'a(b)c',        'failed at #555')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #555')
  call g:assert.equals(getpos("'["), [0, 1, 2, 0], 'failed at #555')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #555')

  set ambiwidth&
  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #556
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'αaα', 'failed at #556')
  call g:assert.equals(getline(2), 'αbα', 'failed at #556')
  call g:assert.equals(getline(3), 'αcα', 'failed at #556')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #556')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #556')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #556')

  %delete

  " #557
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'ααα', 'failed at #557')
  call g:assert.equals(getline(2), 'αβα', 'failed at #557')
  call g:assert.equals(getline(3), 'αγα', 'failed at #557')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #557')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #557')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #557')

  %delete

  " #558
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'αaαα', 'failed at #558')
  call g:assert.equals(getline(2), 'αbβα', 'failed at #558')
  call g:assert.equals(getline(3), 'αcγα', 'failed at #558')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #558')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #558')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #558')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #559
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'aαaaα', 'failed at #559')
  call g:assert.equals(getline(2), 'aαbaα', 'failed at #559')
  call g:assert.equals(getline(3), 'aαcaα', 'failed at #559')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #559')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #559')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #559')

  %delete

  " #560
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'aααaα', 'failed at #560')
  call g:assert.equals(getline(2), 'aαβaα',  'failed at #560')
  call g:assert.equals(getline(3), 'aαγaα', 'failed at #560')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #560')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #560')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #560')

  %delete

  " #561
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'aαaαaα', 'failed at #561')
  call g:assert.equals(getline(2), 'aαbβaα', 'failed at #561')
  call g:assert.equals(getline(3), 'aαcγaα', 'failed at #561')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #561')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #561')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #561')

  %delete
  unlet g:operator#sandwich#recipes

  " #562
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(“)', 'failed at #562')
  call g:assert.equals(getline(2), '(“)', 'failed at #562')
  call g:assert.equals(getline(3), '(“)', 'failed at #562')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #562')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #562')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #562')

  %delete

  " #563
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsa("
  call g:assert.equals(getline(1), '(a“)', 'failed at #563')
  call g:assert.equals(getline(2), '(b“)', 'failed at #563')
  call g:assert.equals(getline(3), '(c“)', 'failed at #563')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #563')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #563')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #563')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #564
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), '“a“', 'failed at #564')
  call g:assert.equals(getline(2), '“b“', 'failed at #564')
  call g:assert.equals(getline(3), '“c“', 'failed at #564')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #564')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #564')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #564')

  %delete

  " #565
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), '“““', 'failed at #565')
  call g:assert.equals(getline(2), '“““', 'failed at #565')
  call g:assert.equals(getline(3), '“““', 'failed at #565')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #565')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #565')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #565')

  %delete

  " #566
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), '“a““', 'failed at #566')
  call g:assert.equals(getline(2), '“b““', 'failed at #566')
  call g:assert.equals(getline(3), '“c““', 'failed at #566')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #566')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #566')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #566')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #567
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'a“aa“', 'failed at #567')
  call g:assert.equals(getline(2), 'a“ba“', 'failed at #567')
  call g:assert.equals(getline(3), 'a“ca“', 'failed at #567')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #567')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #567')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #567')

  %delete

  " #568
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'a““a“', 'failed at #568')
  call g:assert.equals(getline(2), 'a““a“',  'failed at #568')
  call g:assert.equals(getline(3), 'a““a“', 'failed at #568')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #568')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #568')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #568')

  %delete

  " #569
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'a“a“a“', 'failed at #569')
  call g:assert.equals(getline(2), 'a“b“a“', 'failed at #569')
  call g:assert.equals(getline(3), 'a“c“a“', 'failed at #569')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #569')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #569')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #569')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #570
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #570')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #570')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #570')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #570')

  " #571
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #571')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #571')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #571')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #571')

  %delete

  """ keep
  " #572
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #572')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #572')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #572')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #572')

  " #573
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #573')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #573')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #573')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #573')

  %delete

  """ inner_tail
  " #574
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #574')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #574')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #574')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #574')

  " #575
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #575')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #575')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #575')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #575')

  %delete

  """ head
  " #576
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #576')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #576')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #576')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #576')

  " #577
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #577')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #577')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #577')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #577')

  %delete

  """ tail
  " #578
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #578')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #578')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #578')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #578')

  " #579
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #579')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #579')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #579')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #579')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #580
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #580')

  %delete

  """ on
  " #581
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #581')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'input': ['d']},
        \ ]

  """ 0
  " #582
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #582')

  """ 1
  " #583
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #583')

  %delete

  " #584
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1), 'foo', 'failed at #584')
  call g:assert.equals(getline(2), 'bar', 'failed at #584')
  call g:assert.equals(getline(3), 'baz', 'failed at #584')
  call g:assert.equals(exists(s:object), 0, 'failed at #584')

  %delete

  " #585
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsac"
  call g:assert.equals(getline(1), 'foo', 'failed at #585')
  call g:assert.equals(getline(2), 'bar', 'failed at #585')
  call g:assert.equals(getline(3), 'baz', 'failed at #585')
  call g:assert.equals(exists(s:object), 0, 'failed at #585')

  %delete

  " #586
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #586')
  call g:assert.equals(getline(2), '2bar3', 'failed at #586')
  call g:assert.equals(getline(3), '2baz3', 'failed at #586')
  call g:assert.equals(exists(s:object), 0, 'failed at #586')

  %delete

  " #587
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #587')
  call g:assert.equals(getline(2), '2bar3', 'failed at #587')
  call g:assert.equals(getline(3), '2baz3', 'failed at #587')
  call g:assert.equals(exists(s:object), 0, 'failed at #587')

  %delete

  " #588
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saba"
  call g:assert.equals(getline(1), 'foo', 'failed at #588')
  call g:assert.equals(getline(2), 'bar', 'failed at #588')
  call g:assert.equals(getline(3), 'baz', 'failed at #588')
  call g:assert.equals(exists(s:object), 0, 'failed at #588')

  %delete

  " #589
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saca"
  call g:assert.equals(getline(1), 'foo', 'failed at #589')
  call g:assert.equals(getline(2), 'bar', 'failed at #589')
  call g:assert.equals(getline(3), 'baz', 'failed at #589')
  call g:assert.equals(exists(s:object), 0, 'failed at #589')

  %delete

  " #590
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsad"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #590')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #590')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #590')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'block', 'expr', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #591
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #591')

  """ off
  " #592
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #592')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #593
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #593')

  """ off
  " #594
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #594')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #595
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ff\<C-v>iwsa("
  call g:assert.equals(getline('.'), '""',  'failed at #595')
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #596
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #596')
  call g:assert.equals(getline(2), 'foo', 'failed at #596')
  call g:assert.equals(getline(3), ')',   'failed at #596')

  %delete

  " #597
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #597')
  call g:assert.equals(getline(2),   '    foo',    'failed at #597')
  call g:assert.equals(getline(3),   '    )',      'failed at #597')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #597')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #597')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #597')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
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
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #598
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #598')
  call g:assert.equals(getline(2),   '[',          'failed at #598')
  call g:assert.equals(getline(3),   'foo',        'failed at #598')
  call g:assert.equals(getline(4),   ']',          'failed at #598')
  call g:assert.equals(getline(5),   '}',          'failed at #598')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #598')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #598')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #598')
  call g:assert.equals(&l:autoindent,  0,          'failed at #598')
  call g:assert.equals(&l:smartindent, 0,          'failed at #598')
  call g:assert.equals(&l:cindent,     0,          'failed at #598')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #598')

  %delete

  " #599
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #599')
  call g:assert.equals(getline(2),   '    [',      'failed at #599')
  call g:assert.equals(getline(3),   '    foo',    'failed at #599')
  call g:assert.equals(getline(4),   '    ]',      'failed at #599')
  call g:assert.equals(getline(5),   '    }',      'failed at #599')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #599')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #599')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #599')
  call g:assert.equals(&l:autoindent,  1,          'failed at #599')
  call g:assert.equals(&l:smartindent, 0,          'failed at #599')
  call g:assert.equals(&l:cindent,     0,          'failed at #599')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #599')

  %delete

  " #600
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #600')
  call g:assert.equals(getline(2),   '        [',   'failed at #600')
  call g:assert.equals(getline(3),   '        foo', 'failed at #600')
  call g:assert.equals(getline(4),   '    ]',       'failed at #600')
  call g:assert.equals(getline(5),   '}',           'failed at #600')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #600')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #600')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #600')
  call g:assert.equals(&l:autoindent,  1,           'failed at #600')
  call g:assert.equals(&l:smartindent, 1,           'failed at #600')
  call g:assert.equals(&l:cindent,     0,           'failed at #600')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #600')

  %delete

  " #601
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #601')
  call g:assert.equals(getline(2),   '    [',       'failed at #601')
  call g:assert.equals(getline(3),   '        foo', 'failed at #601')
  call g:assert.equals(getline(4),   '    ]',       'failed at #601')
  call g:assert.equals(getline(5),   '    }',       'failed at #601')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #601')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #601')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #601')
  call g:assert.equals(&l:autoindent,  1,           'failed at #601')
  call g:assert.equals(&l:smartindent, 1,           'failed at #601')
  call g:assert.equals(&l:cindent,     1,           'failed at #601')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #601')

  %delete

  " #602
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',           'failed at #602')
  call g:assert.equals(getline(2),   '            [',       'failed at #602')
  call g:assert.equals(getline(3),   '                foo', 'failed at #602')
  call g:assert.equals(getline(4),   '        ]',           'failed at #602')
  call g:assert.equals(getline(5),   '                }',   'failed at #602')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #602')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #602')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #602')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #602')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #602')
  call g:assert.equals(&l:cindent,     1,                   'failed at #602')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #602')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #603
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #603')
  call g:assert.equals(getline(2),   '[',          'failed at #603')
  call g:assert.equals(getline(3),   'foo',        'failed at #603')
  call g:assert.equals(getline(4),   ']',          'failed at #603')
  call g:assert.equals(getline(5),   '}',          'failed at #603')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #603')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #603')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #603')
  call g:assert.equals(&l:autoindent,  0,          'failed at #603')
  call g:assert.equals(&l:smartindent, 0,          'failed at #603')
  call g:assert.equals(&l:cindent,     0,          'failed at #603')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #603')

  %delete

  " #604
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #604')
  call g:assert.equals(getline(2),   '[',          'failed at #604')
  call g:assert.equals(getline(3),   'foo',        'failed at #604')
  call g:assert.equals(getline(4),   ']',          'failed at #604')
  call g:assert.equals(getline(5),   '}',          'failed at #604')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #604')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #604')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #604')
  call g:assert.equals(&l:autoindent,  1,          'failed at #604')
  call g:assert.equals(&l:smartindent, 0,          'failed at #604')
  call g:assert.equals(&l:cindent,     0,          'failed at #604')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #604')

  %delete

  " #605
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #605')
  call g:assert.equals(getline(2),   '[',          'failed at #605')
  call g:assert.equals(getline(3),   'foo',        'failed at #605')
  call g:assert.equals(getline(4),   ']',          'failed at #605')
  call g:assert.equals(getline(5),   '}',          'failed at #605')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #605')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #605')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #605')
  call g:assert.equals(&l:autoindent,  1,          'failed at #605')
  call g:assert.equals(&l:smartindent, 1,          'failed at #605')
  call g:assert.equals(&l:cindent,     0,          'failed at #605')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #605')

  %delete

  " #606
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #606')
  call g:assert.equals(getline(2),   '[',          'failed at #606')
  call g:assert.equals(getline(3),   'foo',        'failed at #606')
  call g:assert.equals(getline(4),   ']',          'failed at #606')
  call g:assert.equals(getline(5),   '}',          'failed at #606')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #606')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #606')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #606')
  call g:assert.equals(&l:autoindent,  1,          'failed at #606')
  call g:assert.equals(&l:smartindent, 1,          'failed at #606')
  call g:assert.equals(&l:cindent,     1,          'failed at #606')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #606')

  %delete

  " #607
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #607')
  call g:assert.equals(getline(2),   '[',              'failed at #607')
  call g:assert.equals(getline(3),   'foo',            'failed at #607')
  call g:assert.equals(getline(4),   ']',              'failed at #607')
  call g:assert.equals(getline(5),   '}',              'failed at #607')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #607')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #607')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #607')
  call g:assert.equals(&l:autoindent,  1,              'failed at #607')
  call g:assert.equals(&l:smartindent, 1,              'failed at #607')
  call g:assert.equals(&l:cindent,     1,              'failed at #607')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #607')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #608
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #608')
  call g:assert.equals(getline(2),   '    [',      'failed at #608')
  call g:assert.equals(getline(3),   '    foo',    'failed at #608')
  call g:assert.equals(getline(4),   '    ]',      'failed at #608')
  call g:assert.equals(getline(5),   '    }',      'failed at #608')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #608')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #608')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #608')
  call g:assert.equals(&l:autoindent,  0,          'failed at #608')
  call g:assert.equals(&l:smartindent, 0,          'failed at #608')
  call g:assert.equals(&l:cindent,     0,          'failed at #608')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #608')

  %delete

  " #609
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #609')
  call g:assert.equals(getline(2),   '    [',      'failed at #609')
  call g:assert.equals(getline(3),   '    foo',    'failed at #609')
  call g:assert.equals(getline(4),   '    ]',      'failed at #609')
  call g:assert.equals(getline(5),   '    }',      'failed at #609')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #609')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #609')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #609')
  call g:assert.equals(&l:autoindent,  1,          'failed at #609')
  call g:assert.equals(&l:smartindent, 0,          'failed at #609')
  call g:assert.equals(&l:cindent,     0,          'failed at #609')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #609')

  %delete

  " #610
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #610')
  call g:assert.equals(getline(2),   '    [',      'failed at #610')
  call g:assert.equals(getline(3),   '    foo',    'failed at #610')
  call g:assert.equals(getline(4),   '    ]',      'failed at #610')
  call g:assert.equals(getline(5),   '    }',      'failed at #610')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #610')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #610')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #610')
  call g:assert.equals(&l:autoindent,  1,          'failed at #610')
  call g:assert.equals(&l:smartindent, 1,          'failed at #610')
  call g:assert.equals(&l:cindent,     0,          'failed at #610')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #610')

  %delete

  " #611
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #611')
  call g:assert.equals(getline(2),   '    [',      'failed at #611')
  call g:assert.equals(getline(3),   '    foo',    'failed at #611')
  call g:assert.equals(getline(4),   '    ]',      'failed at #611')
  call g:assert.equals(getline(5),   '    }',      'failed at #611')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #611')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #611')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #611')
  call g:assert.equals(&l:autoindent,  1,          'failed at #611')
  call g:assert.equals(&l:smartindent, 1,          'failed at #611')
  call g:assert.equals(&l:cindent,     1,          'failed at #611')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #611')

  %delete

  " #612
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #612')
  call g:assert.equals(getline(2),   '    [',          'failed at #612')
  call g:assert.equals(getline(3),   '    foo',        'failed at #612')
  call g:assert.equals(getline(4),   '    ]',          'failed at #612')
  call g:assert.equals(getline(5),   '    }',          'failed at #612')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #612')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #612')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #612')
  call g:assert.equals(&l:autoindent,  1,              'failed at #612')
  call g:assert.equals(&l:smartindent, 1,              'failed at #612')
  call g:assert.equals(&l:cindent,     1,              'failed at #612')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #612')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #613
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #613')
  call g:assert.equals(getline(2),   '        [',   'failed at #613')
  call g:assert.equals(getline(3),   '        foo', 'failed at #613')
  call g:assert.equals(getline(4),   '    ]',       'failed at #613')
  call g:assert.equals(getline(5),   '}',           'failed at #613')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #613')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #613')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #613')
  call g:assert.equals(&l:autoindent,  0,           'failed at #613')
  call g:assert.equals(&l:smartindent, 0,           'failed at #613')
  call g:assert.equals(&l:cindent,     0,           'failed at #613')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #613')

  %delete

  " #614
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #614')
  call g:assert.equals(getline(2),   '        [',   'failed at #614')
  call g:assert.equals(getline(3),   '        foo', 'failed at #614')
  call g:assert.equals(getline(4),   '    ]',       'failed at #614')
  call g:assert.equals(getline(5),   '}',           'failed at #614')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #614')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #614')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #614')
  call g:assert.equals(&l:autoindent,  1,           'failed at #614')
  call g:assert.equals(&l:smartindent, 0,           'failed at #614')
  call g:assert.equals(&l:cindent,     0,           'failed at #614')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #614')

  %delete

  " #615
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #615')
  call g:assert.equals(getline(2),   '        [',   'failed at #615')
  call g:assert.equals(getline(3),   '        foo', 'failed at #615')
  call g:assert.equals(getline(4),   '    ]',       'failed at #615')
  call g:assert.equals(getline(5),   '}',           'failed at #615')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #615')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #615')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #615')
  call g:assert.equals(&l:autoindent,  1,           'failed at #615')
  call g:assert.equals(&l:smartindent, 1,           'failed at #615')
  call g:assert.equals(&l:cindent,     0,           'failed at #615')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #615')

  %delete

  " #616
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #616')
  call g:assert.equals(getline(2),   '        [',   'failed at #616')
  call g:assert.equals(getline(3),   '        foo', 'failed at #616')
  call g:assert.equals(getline(4),   '    ]',       'failed at #616')
  call g:assert.equals(getline(5),   '}',           'failed at #616')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #616')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #616')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #616')
  call g:assert.equals(&l:autoindent,  1,           'failed at #616')
  call g:assert.equals(&l:smartindent, 1,           'failed at #616')
  call g:assert.equals(&l:cindent,     1,           'failed at #616')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #616')

  %delete

  " #617
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #617')
  call g:assert.equals(getline(2),   '        [',      'failed at #617')
  call g:assert.equals(getline(3),   '        foo',    'failed at #617')
  call g:assert.equals(getline(4),   '    ]',          'failed at #617')
  call g:assert.equals(getline(5),   '}',              'failed at #617')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #617')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #617')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #617')
  call g:assert.equals(&l:autoindent,  1,              'failed at #617')
  call g:assert.equals(&l:smartindent, 1,              'failed at #617')
  call g:assert.equals(&l:cindent,     1,              'failed at #617')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #617')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #618
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #618')
  call g:assert.equals(getline(2),   '    [',       'failed at #618')
  call g:assert.equals(getline(3),   '        foo', 'failed at #618')
  call g:assert.equals(getline(4),   '    ]',       'failed at #618')
  call g:assert.equals(getline(5),   '    }',       'failed at #618')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #618')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #618')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #618')
  call g:assert.equals(&l:autoindent,  0,           'failed at #618')
  call g:assert.equals(&l:smartindent, 0,           'failed at #618')
  call g:assert.equals(&l:cindent,     0,           'failed at #618')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #618')

  %delete

  " #619
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #619')
  call g:assert.equals(getline(2),   '    [',       'failed at #619')
  call g:assert.equals(getline(3),   '        foo', 'failed at #619')
  call g:assert.equals(getline(4),   '    ]',       'failed at #619')
  call g:assert.equals(getline(5),   '    }',       'failed at #619')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #619')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #619')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #619')
  call g:assert.equals(&l:autoindent,  1,           'failed at #619')
  call g:assert.equals(&l:smartindent, 0,           'failed at #619')
  call g:assert.equals(&l:cindent,     0,           'failed at #619')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #619')

  %delete

  " #620
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #620')
  call g:assert.equals(getline(2),   '    [',       'failed at #620')
  call g:assert.equals(getline(3),   '        foo', 'failed at #620')
  call g:assert.equals(getline(4),   '    ]',       'failed at #620')
  call g:assert.equals(getline(5),   '    }',       'failed at #620')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #620')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #620')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #620')
  call g:assert.equals(&l:autoindent,  1,           'failed at #620')
  call g:assert.equals(&l:smartindent, 1,           'failed at #620')
  call g:assert.equals(&l:cindent,     0,           'failed at #620')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #620')

  %delete

  " #621
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #621')
  call g:assert.equals(getline(2),   '    [',       'failed at #621')
  call g:assert.equals(getline(3),   '        foo', 'failed at #621')
  call g:assert.equals(getline(4),   '    ]',       'failed at #621')
  call g:assert.equals(getline(5),   '    }',       'failed at #621')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #621')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #621')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #621')
  call g:assert.equals(&l:autoindent,  1,           'failed at #621')
  call g:assert.equals(&l:smartindent, 1,           'failed at #621')
  call g:assert.equals(&l:cindent,     1,           'failed at #621')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #621')

  %delete

  " #622
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',              'failed at #622')
  call g:assert.equals(getline(2),   '    [',          'failed at #622')
  call g:assert.equals(getline(3),   '        foo',    'failed at #622')
  call g:assert.equals(getline(4),   '    ]',          'failed at #622')
  call g:assert.equals(getline(5),   '    }',          'failed at #622')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #622')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #622')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #622')
  call g:assert.equals(&l:autoindent,  1,              'failed at #622')
  call g:assert.equals(&l:smartindent, 1,              'failed at #622')
  call g:assert.equals(&l:cindent,     1,              'failed at #622')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #622')
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
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #623
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #623')
  call g:assert.equals(getline(2),   'foo',        'failed at #623')
  call g:assert.equals(getline(3),   '    }',      'failed at #623')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #623')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #623')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #623')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #623')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #623')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #624
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #624')
  call g:assert.equals(getline(2),   '    foo',    'failed at #624')
  call g:assert.equals(getline(3),   '    }',      'failed at #624')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #624')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #624')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #624')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #624')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #624')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #625
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #625')
  call g:assert.equals(getline(2),   'foo',        'failed at #625')
  call g:assert.equals(getline(3),   '    }',      'failed at #625')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #625')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #625')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #625')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #625')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #625')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #626
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #626')
  call g:assert.equals(getline(2),   'foo',        'failed at #626')
  call g:assert.equals(getline(3),   '    }',      'failed at #626')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #626')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #626')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #626')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #626')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #626')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #627
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',     'failed at #627')
  call g:assert.equals(getline(2),   '    foo',       'failed at #627')
  call g:assert.equals(getline(3),   '            }', 'failed at #627')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #627')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #627')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #627')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #627')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #627')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #628
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #628')
  call g:assert.equals(getline(2),   'foo',        'failed at #628')
  call g:assert.equals(getline(3),   '    }',      'failed at #628')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #628')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #628')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #628')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #628')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #628')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssa <Esc>:call operator#sandwich#prerequisite('add', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #629
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #629')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #629')

  " #630
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #630')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #630')

  " #631
  call setline('.', 'foo')
  normal 0ssaiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #631')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #631')

  " #632
  call setline('.', 'foo')
  normal 0ssaiw[
  call g:assert.equals(getline('.'), '[foo[',      'failed at #632')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #632')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #633
  call setline('.', 'foo')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0saiw(
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #633')

  " #634
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 02saiw((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #634')

  " #635
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 03saiw(((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #635')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
