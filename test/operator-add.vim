let s:suite = themis#suite('operator-sandwich: add:')
let s:object = 'g:operator#sandwich#object'

function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
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
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #106
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #106')

  " #107
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #107')

  """ keep
  " #108
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #108')

  " #109
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #109')

  """ inner_tail
  " #110
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #110')

  " #111
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #111')

  """ head
  " #112
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #112')

  " #113
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #113')

  """ tail
  " #114
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #114')

  " #115
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #115')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #116
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #116')

  %delete

  """ on
  " #117
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #117')

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
  " #118
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #118')

  """ 1
  " #119
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #119')

  " #120
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline('.'), 'foo',  'failed at #120')
  call g:assert.equals(exists(s:object), 0,  'failed at #120')

  " #121
  call setline('.', 'foo')
  normal 0saiwc
  call g:assert.equals(getline('.'), 'foo',  'failed at #121')
  call g:assert.equals(exists(s:object), 0,  'failed at #121')

  " #122
  call setline('.', 'foo')
  normal 02saiwab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #122')
  call g:assert.equals(exists(s:object), 0,   'failed at #122')

  " #123
  call setline('.', 'foo')
  normal 02saiwac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #123')
  call g:assert.equals(exists(s:object), 0,   'failed at #123')

  " #124
  call setline('.', 'foo')
  normal 02saiwba
  call g:assert.equals(getline('.'), 'foo', 'failed at #124')
  call g:assert.equals(exists(s:object), 0, 'failed at #124')

  " #125
  call setline('.', 'foo')
  normal 02saiwbc
  call g:assert.equals(getline('.'), 'foo', 'failed at #125')
  call g:assert.equals(exists(s:object), 0, 'failed at #125')

  " #126
  call setline('.', 'foo')
  normal 0saiwd
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #126')

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
  " #127
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #127')

  """ off
  " #128
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #128')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #129
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #129')

  """ on
  " #130
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #130')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  """"" command
  " #131
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  normal 0ffsaiw(
  call g:assert.equals(getline('.'), '""',  'failed at #131')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #132
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #132')
  call g:assert.equals(getline(2), 'foo', 'failed at #132')
  call g:assert.equals(getline(3), ')',   'failed at #132')

  %delete

  " #133
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #133')
  call g:assert.equals(getline(2),   '    foo',    'failed at #133')
  call g:assert.equals(getline(3),   '    )',      'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #133')

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

  " #134
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #134')
  call g:assert.equals(getline(2),   '[',          'failed at #134')
  call g:assert.equals(getline(3),   'foo',        'failed at #134')
  call g:assert.equals(getline(4),   ']',          'failed at #134')
  call g:assert.equals(getline(5),   '}',          'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #134')
  call g:assert.equals(&l:autoindent,  0,          'failed at #134')
  call g:assert.equals(&l:smartindent, 0,          'failed at #134')
  call g:assert.equals(&l:cindent,     0,          'failed at #134')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #134')

  %delete

  " #135
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #135')
  call g:assert.equals(getline(2),   '    [',      'failed at #135')
  call g:assert.equals(getline(3),   '    foo',    'failed at #135')
  call g:assert.equals(getline(4),   '    ]',      'failed at #135')
  call g:assert.equals(getline(5),   '    }',      'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #135')
  call g:assert.equals(&l:autoindent,  1,          'failed at #135')
  call g:assert.equals(&l:smartindent, 0,          'failed at #135')
  call g:assert.equals(&l:cindent,     0,          'failed at #135')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #135')

  %delete

  " #136
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #136')
  call g:assert.equals(getline(2),   '        [',   'failed at #136')
  call g:assert.equals(getline(3),   '        foo', 'failed at #136')
  call g:assert.equals(getline(4),   '    ]',       'failed at #136')
  call g:assert.equals(getline(5),   '}',           'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #136')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #136')
  call g:assert.equals(&l:autoindent,  1,           'failed at #136')
  call g:assert.equals(&l:smartindent, 1,           'failed at #136')
  call g:assert.equals(&l:cindent,     0,           'failed at #136')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #136')

  %delete

  " #137
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #137')
  call g:assert.equals(getline(2),   '    [',       'failed at #137')
  call g:assert.equals(getline(3),   '        foo', 'failed at #137')
  call g:assert.equals(getline(4),   '    ]',       'failed at #137')
  call g:assert.equals(getline(5),   '    }',       'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #137')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #137')
  call g:assert.equals(&l:autoindent,  1,           'failed at #137')
  call g:assert.equals(&l:smartindent, 1,           'failed at #137')
  call g:assert.equals(&l:cindent,     1,           'failed at #137')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #137')

  %delete

  " #138
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',           'failed at #138')
  call g:assert.equals(getline(2),   '            [',       'failed at #138')
  call g:assert.equals(getline(3),   '                foo', 'failed at #138')
  call g:assert.equals(getline(4),   '        ]',           'failed at #138')
  call g:assert.equals(getline(5),   '                }',   'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #138')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #138')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #138')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #138')
  call g:assert.equals(&l:cindent,     1,                   'failed at #138')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #138')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #139
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #139')
  call g:assert.equals(getline(2),   '[',          'failed at #139')
  call g:assert.equals(getline(3),   'foo',        'failed at #139')
  call g:assert.equals(getline(4),   ']',          'failed at #139')
  call g:assert.equals(getline(5),   '}',          'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #139')
  call g:assert.equals(&l:autoindent,  0,          'failed at #139')
  call g:assert.equals(&l:smartindent, 0,          'failed at #139')
  call g:assert.equals(&l:cindent,     0,          'failed at #139')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #139')

  %delete

  " #140
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #140')
  call g:assert.equals(getline(2),   '[',          'failed at #140')
  call g:assert.equals(getline(3),   'foo',        'failed at #140')
  call g:assert.equals(getline(4),   ']',          'failed at #140')
  call g:assert.equals(getline(5),   '}',          'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #140')
  call g:assert.equals(&l:autoindent,  1,          'failed at #140')
  call g:assert.equals(&l:smartindent, 0,          'failed at #140')
  call g:assert.equals(&l:cindent,     0,          'failed at #140')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #140')

  %delete

  " #141
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #141')
  call g:assert.equals(getline(2),   '[',          'failed at #141')
  call g:assert.equals(getline(3),   'foo',        'failed at #141')
  call g:assert.equals(getline(4),   ']',          'failed at #141')
  call g:assert.equals(getline(5),   '}',          'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #141')
  call g:assert.equals(&l:autoindent,  1,          'failed at #141')
  call g:assert.equals(&l:smartindent, 1,          'failed at #141')
  call g:assert.equals(&l:cindent,     0,          'failed at #141')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #141')

  %delete

  " #142
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #142')
  call g:assert.equals(getline(2),   '[',          'failed at #142')
  call g:assert.equals(getline(3),   'foo',        'failed at #142')
  call g:assert.equals(getline(4),   ']',          'failed at #142')
  call g:assert.equals(getline(5),   '}',          'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #142')
  call g:assert.equals(&l:autoindent,  1,          'failed at #142')
  call g:assert.equals(&l:smartindent, 1,          'failed at #142')
  call g:assert.equals(&l:cindent,     1,          'failed at #142')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #142')

  %delete

  " #143
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #143')
  call g:assert.equals(getline(2),   '[',              'failed at #143')
  call g:assert.equals(getline(3),   'foo',            'failed at #143')
  call g:assert.equals(getline(4),   ']',              'failed at #143')
  call g:assert.equals(getline(5),   '}',              'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #143')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #143')
  call g:assert.equals(&l:autoindent,  1,              'failed at #143')
  call g:assert.equals(&l:smartindent, 1,              'failed at #143')
  call g:assert.equals(&l:cindent,     1,              'failed at #143')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #143')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #144
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #144')
  call g:assert.equals(getline(2),   '    [',      'failed at #144')
  call g:assert.equals(getline(3),   '    foo',    'failed at #144')
  call g:assert.equals(getline(4),   '    ]',      'failed at #144')
  call g:assert.equals(getline(5),   '    }',      'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #144')
  call g:assert.equals(&l:autoindent,  0,          'failed at #144')
  call g:assert.equals(&l:smartindent, 0,          'failed at #144')
  call g:assert.equals(&l:cindent,     0,          'failed at #144')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #144')

  %delete

  " #145
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #145')
  call g:assert.equals(getline(2),   '    [',      'failed at #145')
  call g:assert.equals(getline(3),   '    foo',    'failed at #145')
  call g:assert.equals(getline(4),   '    ]',      'failed at #145')
  call g:assert.equals(getline(5),   '    }',      'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #145')
  call g:assert.equals(&l:autoindent,  1,          'failed at #145')
  call g:assert.equals(&l:smartindent, 0,          'failed at #145')
  call g:assert.equals(&l:cindent,     0,          'failed at #145')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #145')

  %delete

  " #146
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #146')
  call g:assert.equals(getline(2),   '    [',      'failed at #146')
  call g:assert.equals(getline(3),   '    foo',    'failed at #146')
  call g:assert.equals(getline(4),   '    ]',      'failed at #146')
  call g:assert.equals(getline(5),   '    }',      'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #146')
  call g:assert.equals(&l:autoindent,  1,          'failed at #146')
  call g:assert.equals(&l:smartindent, 1,          'failed at #146')
  call g:assert.equals(&l:cindent,     0,          'failed at #146')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #146')

  %delete

  " #147
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #147')
  call g:assert.equals(getline(2),   '    [',      'failed at #147')
  call g:assert.equals(getline(3),   '    foo',    'failed at #147')
  call g:assert.equals(getline(4),   '    ]',      'failed at #147')
  call g:assert.equals(getline(5),   '    }',      'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #147')
  call g:assert.equals(&l:autoindent,  1,          'failed at #147')
  call g:assert.equals(&l:smartindent, 1,          'failed at #147')
  call g:assert.equals(&l:cindent,     1,          'failed at #147')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #147')

  %delete

  " #148
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #148')
  call g:assert.equals(getline(2),   '    [',          'failed at #148')
  call g:assert.equals(getline(3),   '    foo',        'failed at #148')
  call g:assert.equals(getline(4),   '    ]',          'failed at #148')
  call g:assert.equals(getline(5),   '    }',          'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #148')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #148')
  call g:assert.equals(&l:autoindent,  1,              'failed at #148')
  call g:assert.equals(&l:smartindent, 1,              'failed at #148')
  call g:assert.equals(&l:cindent,     1,              'failed at #148')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #148')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #149
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #149')
  call g:assert.equals(getline(2),   '        [',   'failed at #149')
  call g:assert.equals(getline(3),   '        foo', 'failed at #149')
  call g:assert.equals(getline(4),   '    ]',       'failed at #149')
  call g:assert.equals(getline(5),   '}',           'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #149')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #149')
  call g:assert.equals(&l:autoindent,  0,           'failed at #149')
  call g:assert.equals(&l:smartindent, 0,           'failed at #149')
  call g:assert.equals(&l:cindent,     0,           'failed at #149')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #149')

  %delete

  " #150
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #150')
  call g:assert.equals(getline(2),   '        [',   'failed at #150')
  call g:assert.equals(getline(3),   '        foo', 'failed at #150')
  call g:assert.equals(getline(4),   '    ]',       'failed at #150')
  call g:assert.equals(getline(5),   '}',           'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #150')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #150')
  call g:assert.equals(&l:autoindent,  1,           'failed at #150')
  call g:assert.equals(&l:smartindent, 0,           'failed at #150')
  call g:assert.equals(&l:cindent,     0,           'failed at #150')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #150')

  %delete

  " #151
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #151')
  call g:assert.equals(getline(2),   '        [',   'failed at #151')
  call g:assert.equals(getline(3),   '        foo', 'failed at #151')
  call g:assert.equals(getline(4),   '    ]',       'failed at #151')
  call g:assert.equals(getline(5),   '}',           'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #151')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #151')
  call g:assert.equals(&l:autoindent,  1,           'failed at #151')
  call g:assert.equals(&l:smartindent, 1,           'failed at #151')
  call g:assert.equals(&l:cindent,     0,           'failed at #151')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #151')

  %delete

  " #152
  setlocal cindent
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
  call g:assert.equals(&l:cindent,     1,           'failed at #152')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #152')

  %delete

  " #153
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #153')
  call g:assert.equals(getline(2),   '        [',      'failed at #153')
  call g:assert.equals(getline(3),   '        foo',    'failed at #153')
  call g:assert.equals(getline(4),   '    ]',          'failed at #153')
  call g:assert.equals(getline(5),   '}',              'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #153')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #153')
  call g:assert.equals(&l:autoindent,  1,              'failed at #153')
  call g:assert.equals(&l:smartindent, 1,              'failed at #153')
  call g:assert.equals(&l:cindent,     1,              'failed at #153')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #153')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #154
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #154')
  call g:assert.equals(getline(2),   '    [',       'failed at #154')
  call g:assert.equals(getline(3),   '        foo', 'failed at #154')
  call g:assert.equals(getline(4),   '    ]',       'failed at #154')
  call g:assert.equals(getline(5),   '    }',       'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #154')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #154')
  call g:assert.equals(&l:autoindent,  0,           'failed at #154')
  call g:assert.equals(&l:smartindent, 0,           'failed at #154')
  call g:assert.equals(&l:cindent,     0,           'failed at #154')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #154')

  %delete

  " #155
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #155')
  call g:assert.equals(getline(2),   '    [',       'failed at #155')
  call g:assert.equals(getline(3),   '        foo', 'failed at #155')
  call g:assert.equals(getline(4),   '    ]',       'failed at #155')
  call g:assert.equals(getline(5),   '    }',       'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #155')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #155')
  call g:assert.equals(&l:autoindent,  1,           'failed at #155')
  call g:assert.equals(&l:smartindent, 0,           'failed at #155')
  call g:assert.equals(&l:cindent,     0,           'failed at #155')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #155')

  %delete

  " #156
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #156')
  call g:assert.equals(getline(2),   '    [',       'failed at #156')
  call g:assert.equals(getline(3),   '        foo', 'failed at #156')
  call g:assert.equals(getline(4),   '    ]',       'failed at #156')
  call g:assert.equals(getline(5),   '    }',       'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #156')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #156')
  call g:assert.equals(&l:autoindent,  1,           'failed at #156')
  call g:assert.equals(&l:smartindent, 1,           'failed at #156')
  call g:assert.equals(&l:cindent,     0,           'failed at #156')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #156')

  %delete

  " #157
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #157')
  call g:assert.equals(getline(2),   '    [',       'failed at #157')
  call g:assert.equals(getline(3),   '        foo', 'failed at #157')
  call g:assert.equals(getline(4),   '    ]',       'failed at #157')
  call g:assert.equals(getline(5),   '    }',       'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #157')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #157')
  call g:assert.equals(&l:autoindent,  1,           'failed at #157')
  call g:assert.equals(&l:smartindent, 1,           'failed at #157')
  call g:assert.equals(&l:cindent,     1,           'failed at #157')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #157')

  %delete

  " #158
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',              'failed at #158')
  call g:assert.equals(getline(2),   '    [',          'failed at #158')
  call g:assert.equals(getline(3),   '        foo',    'failed at #158')
  call g:assert.equals(getline(4),   '    ]',          'failed at #158')
  call g:assert.equals(getline(5),   '    }',          'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #158')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #158')
  call g:assert.equals(&l:autoindent,  1,              'failed at #158')
  call g:assert.equals(&l:smartindent, 1,              'failed at #158')
  call g:assert.equals(&l:cindent,     1,              'failed at #158')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #158')
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

  " #159
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #159')
  call g:assert.equals(getline(2),   'foo',        'failed at #159')
  call g:assert.equals(getline(3),   '    }',      'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #159')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #159')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #159')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #160
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #160')
  call g:assert.equals(getline(2),   '    foo',    'failed at #160')
  call g:assert.equals(getline(3),   '    }',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #160')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #160')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #160')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #161
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #161')
  call g:assert.equals(getline(2),   'foo',        'failed at #161')
  call g:assert.equals(getline(3),   '    }',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #161')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #161')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #161')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #162
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #162')
  call g:assert.equals(getline(2),   'foo',        'failed at #162')
  call g:assert.equals(getline(3),   '    }',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #162')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #162')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #162')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #163
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',     'failed at #163')
  call g:assert.equals(getline(2),   '    foo',       'failed at #163')
  call g:assert.equals(getline(3),   '            }', 'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #163')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #163')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #163')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #163')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #164
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #164')
  call g:assert.equals(getline(2),   'foo',        'failed at #164')
  call g:assert.equals(getline(3),   '    }',      'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #164')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #164')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #164')
endfunction
"}}}

" function! s:suite.charwise_n_multibyte() abort  "{{{
"   " #165
"   call setline('.', 'あ')
"   normal 0sal(
"   call g:assert.equals(getline('.'), '(あ)',       'failed at #165')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #165')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
"   call g:assert.equals(getpos("']"), [0, 1, 5, 0], 'failed at #165')
"
"   " #166
"   call setline('.', 'aあ')
"   normal 0sa2l(
"   call g:assert.equals(getline('.'), '(aあ)',      'failed at #166')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #166')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #166')
"
"   let g:operator#sandwich#recipes = [
"         \   {'buns': ['あ', 'あ'], 'input': ['a']}
"         \ ]
"
"   " #167
"   call setline('.', 'a')
"   normal 0sala
"   call g:assert.equals(getline('.'), 'あaあ',      'failed at #167')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #167')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #167')
"
"   " #168
"   call setline('.', 'あ')
"   normal 0sala
"   call g:assert.equals(getline('.'), 'あaあ',      'failed at #168')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #168')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #168')
"
"   " #169
"   call setline('.', 'aあ')
"   normal 0sala
"   call g:assert.equals(getline('.'), 'あaああ',    'failed at #169')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #169')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #169')
"
"   let g:operator#sandwich#recipes = [
"         \   {'buns': ['aあ', 'aあ'], 'input': ['a']}
"         \ ]
"
"   " #170
"   call setline('.', 'a')
"   normal 0sala
"   call g:assert.equals(getline('.'), 'aあaaあ',    'failed at #170')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #170')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #170')
"
"   " #171
"   call setline('.', 'あ')
"   normal 0sala
"   call g:assert.equals(getline('.'), 'aああaあ',   'failed at #171')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #171')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #171')
"
"   " #172
"   call setline('.', 'aあ')
"   normal 0sa2la
"   call g:assert.equals(getline('.'), 'aあaあaあ',  'failed at #172')
"   call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #172')
"   call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
"   call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #172')
" endfunction
" "}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #165
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'ailed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'ailed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'ailed at #165')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'ailed at #165')

  " #166
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #166')

  " #167
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #167')

  " #168
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #168')

  " #169
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #169')

  " #170
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #170')

  " #171
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #171')

  " #172
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #172')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #173
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #173')

  " #174
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #174')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #175
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #175')

  " #176
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #176')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #176')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #176')

  " #177
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #177')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #177')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #177')

  " #178
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #178')
  call g:assert.equals(getline(2),   'bar',        'failed at #178')
  call g:assert.equals(getline(3),   'baz)',       'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #178')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #178')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #179
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #179')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #179')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  " #180
  call append(0, ['', 'foo'])
  normal ggvj$sa(
  call g:assert.equals(getline(1), '(',    'failed at #180')
  call g:assert.equals(getline(2), 'foo)', 'failed at #180')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #180')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #180')
  " call g:assert.equals(getpos("']"), [0, 2, 5, 0], 'failed at #180')

  %delete

  " #181
  call append(0, ['foo', ''])
  normal ggvjsa(
  call g:assert.equals(getline(1), '(foo', 'failed at #181')
  call g:assert.equals(getline(2), ')',    'failed at #181')
  " call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #181')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #181')
  " call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #181')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #182
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #182')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #182')
  call g:assert.equals(getline(3), 'aa',           'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #182')

  %delete

  " #183
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #183')
  call g:assert.equals(getline(2),   'bbb',        'failed at #183')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #183')
  call g:assert.equals(getline(4),   'bbb',        'failed at #183')
  call g:assert.equals(getline(5),   'bb',         'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #183')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #184
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #184')

  " #185
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #185')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #186
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #186')

  " #187
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #187')

  """ keep
  " #188
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #188')

  " #189
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #189')

  """ inner_tail
  " #190
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #190')

  " #191
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #191')

  """ head
  " #192
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #192')

  " #193
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #193')

  """ tail
  " #194
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #194')

  " #195
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #195')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #196
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #196')

  """ on
  " #197
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #197')

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
  " #198
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #198')

  """ 1
  " #199
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #199')

  " #200
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline('.'), 'foo', 'failed at #200')
  call g:assert.equals(exists(s:object), 0, 'failed at #200')

  " #201
  call setline('.', 'foo')
  normal 0viwsac
  call g:assert.equals(getline('.'), 'foo', 'failed at #201')
  call g:assert.equals(exists(s:object), 0, 'failed at #201')

  " #202
  call setline('.', 'foo')
  normal 0viw2saab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #202')
  call g:assert.equals(exists(s:object), 0,   'failed at #202')

  " #203
  call setline('.', 'foo')
  normal 0viw2saac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #203')
  call g:assert.equals(exists(s:object), 0,   'failed at #203')

  " #204
  call setline('.', 'foo')
  normal 0viw2saba
  call g:assert.equals(getline('.'), 'foo', 'failed at #204')
  call g:assert.equals(exists(s:object), 0, 'failed at #204')

  " #205
  call setline('.', 'foo')
  normal 0viw2sabc
  call g:assert.equals(getline('.'), 'foo', 'failed at #205')
  call g:assert.equals(exists(s:object), 0, 'failed at #205')

  " #206
  call setline('.', 'foo')
  normal 0viwsad
  call g:assert.equals(getline('.'), 'headfootail', 'failed at #206')

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
  " #207
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #207')

  """ off
  " #208
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #208')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #209
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #209')

  """ on
  " #210
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #210')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #211
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[d`]"])
  call setline('.', '"foo"')
  normal 0ffviwsa(
  call g:assert.equals(getline('.'), '""',  'failed at #211')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #212
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #212')
  call g:assert.equals(getline(2), 'foo', 'failed at #212')
  call g:assert.equals(getline(3), ')',   'failed at #212')

  %delete

  " #213
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #172')
  call g:assert.equals(getline(2),   '    foo',    'failed at #172')
  call g:assert.equals(getline(3),   '    )',      'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #172')

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

  " #214
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #214')
  call g:assert.equals(getline(2),   '[',          'failed at #214')
  call g:assert.equals(getline(3),   'foo',        'failed at #214')
  call g:assert.equals(getline(4),   ']',          'failed at #214')
  call g:assert.equals(getline(5),   '}',          'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #214')
  call g:assert.equals(&l:autoindent,  0,          'failed at #214')
  call g:assert.equals(&l:smartindent, 0,          'failed at #214')
  call g:assert.equals(&l:cindent,     0,          'failed at #214')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #214')

  %delete

  " #215
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #215')
  call g:assert.equals(getline(2),   '    [',      'failed at #215')
  call g:assert.equals(getline(3),   '    foo',    'failed at #215')
  call g:assert.equals(getline(4),   '    ]',      'failed at #215')
  call g:assert.equals(getline(5),   '    }',      'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #215')
  call g:assert.equals(&l:autoindent,  1,          'failed at #215')
  call g:assert.equals(&l:smartindent, 0,          'failed at #215')
  call g:assert.equals(&l:cindent,     0,          'failed at #215')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #215')

  %delete

  " #216
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #216')
  call g:assert.equals(getline(2),   '        [',   'failed at #216')
  call g:assert.equals(getline(3),   '        foo', 'failed at #216')
  call g:assert.equals(getline(4),   '    ]',       'failed at #216')
  call g:assert.equals(getline(5),   '}',           'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #216')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #216')
  call g:assert.equals(&l:autoindent,  1,           'failed at #216')
  call g:assert.equals(&l:smartindent, 1,           'failed at #216')
  call g:assert.equals(&l:cindent,     0,           'failed at #216')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #216')

  %delete

  " #217
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #217')
  call g:assert.equals(getline(2),   '    [',       'failed at #217')
  call g:assert.equals(getline(3),   '        foo', 'failed at #217')
  call g:assert.equals(getline(4),   '    ]',       'failed at #217')
  call g:assert.equals(getline(5),   '    }',       'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #217')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #217')
  call g:assert.equals(&l:autoindent,  1,           'failed at #217')
  call g:assert.equals(&l:smartindent, 1,           'failed at #217')
  call g:assert.equals(&l:cindent,     1,           'failed at #217')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #217')

  %delete

  " #218
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',           'failed at #218')
  call g:assert.equals(getline(2),   '            [',       'failed at #218')
  call g:assert.equals(getline(3),   '                foo', 'failed at #218')
  call g:assert.equals(getline(4),   '        ]',           'failed at #218')
  call g:assert.equals(getline(5),   '                }',   'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #218')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #218')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #218')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #218')
  call g:assert.equals(&l:cindent,     1,                   'failed at #218')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #218')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #219
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #219')
  call g:assert.equals(getline(2),   '[',          'failed at #219')
  call g:assert.equals(getline(3),   'foo',        'failed at #219')
  call g:assert.equals(getline(4),   ']',          'failed at #219')
  call g:assert.equals(getline(5),   '}',          'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #219')
  call g:assert.equals(&l:autoindent,  0,          'failed at #219')
  call g:assert.equals(&l:smartindent, 0,          'failed at #219')
  call g:assert.equals(&l:cindent,     0,          'failed at #219')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #219')

  %delete

  " #220
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #220')
  call g:assert.equals(getline(2),   '[',          'failed at #220')
  call g:assert.equals(getline(3),   'foo',        'failed at #220')
  call g:assert.equals(getline(4),   ']',          'failed at #220')
  call g:assert.equals(getline(5),   '}',          'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #220')
  call g:assert.equals(&l:autoindent,  1,          'failed at #220')
  call g:assert.equals(&l:smartindent, 0,          'failed at #220')
  call g:assert.equals(&l:cindent,     0,          'failed at #220')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #220')

  %delete

  " #221
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #221')
  call g:assert.equals(getline(2),   '[',          'failed at #221')
  call g:assert.equals(getline(3),   'foo',        'failed at #221')
  call g:assert.equals(getline(4),   ']',          'failed at #221')
  call g:assert.equals(getline(5),   '}',          'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #221')
  call g:assert.equals(&l:autoindent,  1,          'failed at #221')
  call g:assert.equals(&l:smartindent, 1,          'failed at #221')
  call g:assert.equals(&l:cindent,     0,          'failed at #221')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #221')

  %delete

  " #222
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #222')
  call g:assert.equals(getline(2),   '[',          'failed at #222')
  call g:assert.equals(getline(3),   'foo',        'failed at #222')
  call g:assert.equals(getline(4),   ']',          'failed at #222')
  call g:assert.equals(getline(5),   '}',          'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #222')
  call g:assert.equals(&l:autoindent,  1,          'failed at #222')
  call g:assert.equals(&l:smartindent, 1,          'failed at #222')
  call g:assert.equals(&l:cindent,     1,          'failed at #222')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #222')

  %delete

  " #223
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #223')
  call g:assert.equals(getline(2),   '[',              'failed at #223')
  call g:assert.equals(getline(3),   'foo',            'failed at #223')
  call g:assert.equals(getline(4),   ']',              'failed at #223')
  call g:assert.equals(getline(5),   '}',              'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #223')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #223')
  call g:assert.equals(&l:autoindent,  1,              'failed at #223')
  call g:assert.equals(&l:smartindent, 1,              'failed at #223')
  call g:assert.equals(&l:cindent,     1,              'failed at #223')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #223')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #224
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #224')
  call g:assert.equals(getline(2),   '    [',      'failed at #224')
  call g:assert.equals(getline(3),   '    foo',    'failed at #224')
  call g:assert.equals(getline(4),   '    ]',      'failed at #224')
  call g:assert.equals(getline(5),   '    }',      'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #224')
  call g:assert.equals(&l:autoindent,  0,          'failed at #224')
  call g:assert.equals(&l:smartindent, 0,          'failed at #224')
  call g:assert.equals(&l:cindent,     0,          'failed at #224')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #224')

  %delete

  " #225
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #225')
  call g:assert.equals(getline(2),   '    [',      'failed at #225')
  call g:assert.equals(getline(3),   '    foo',    'failed at #225')
  call g:assert.equals(getline(4),   '    ]',      'failed at #225')
  call g:assert.equals(getline(5),   '    }',      'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #225')
  call g:assert.equals(&l:autoindent,  1,          'failed at #225')
  call g:assert.equals(&l:smartindent, 0,          'failed at #225')
  call g:assert.equals(&l:cindent,     0,          'failed at #225')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #225')

  %delete

  " #226
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #226')
  call g:assert.equals(getline(2),   '    [',      'failed at #226')
  call g:assert.equals(getline(3),   '    foo',    'failed at #226')
  call g:assert.equals(getline(4),   '    ]',      'failed at #226')
  call g:assert.equals(getline(5),   '    }',      'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #226')
  call g:assert.equals(&l:autoindent,  1,          'failed at #226')
  call g:assert.equals(&l:smartindent, 1,          'failed at #226')
  call g:assert.equals(&l:cindent,     0,          'failed at #226')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #226')

  %delete

  " #227
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #227')
  call g:assert.equals(getline(2),   '    [',      'failed at #227')
  call g:assert.equals(getline(3),   '    foo',    'failed at #227')
  call g:assert.equals(getline(4),   '    ]',      'failed at #227')
  call g:assert.equals(getline(5),   '    }',      'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #227')
  call g:assert.equals(&l:autoindent,  1,          'failed at #227')
  call g:assert.equals(&l:smartindent, 1,          'failed at #227')
  call g:assert.equals(&l:cindent,     1,          'failed at #227')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #227')

  %delete

  " #228
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #228')
  call g:assert.equals(getline(2),   '    [',          'failed at #228')
  call g:assert.equals(getline(3),   '    foo',        'failed at #228')
  call g:assert.equals(getline(4),   '    ]',          'failed at #228')
  call g:assert.equals(getline(5),   '    }',          'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #228')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #228')
  call g:assert.equals(&l:autoindent,  1,              'failed at #228')
  call g:assert.equals(&l:smartindent, 1,              'failed at #228')
  call g:assert.equals(&l:cindent,     1,              'failed at #228')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #228')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #229
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #229')
  call g:assert.equals(getline(2),   '        [',   'failed at #229')
  call g:assert.equals(getline(3),   '        foo', 'failed at #229')
  call g:assert.equals(getline(4),   '    ]',       'failed at #229')
  call g:assert.equals(getline(5),   '}',           'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #229')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #229')
  call g:assert.equals(&l:autoindent,  0,           'failed at #229')
  call g:assert.equals(&l:smartindent, 0,           'failed at #229')
  call g:assert.equals(&l:cindent,     0,           'failed at #229')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #229')

  %delete

  " #230
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #230')
  call g:assert.equals(getline(2),   '        [',   'failed at #230')
  call g:assert.equals(getline(3),   '        foo', 'failed at #230')
  call g:assert.equals(getline(4),   '    ]',       'failed at #230')
  call g:assert.equals(getline(5),   '}',           'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #230')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #230')
  call g:assert.equals(&l:autoindent,  1,           'failed at #230')
  call g:assert.equals(&l:smartindent, 0,           'failed at #230')
  call g:assert.equals(&l:cindent,     0,           'failed at #230')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #230')

  %delete

  " #231
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #231')
  call g:assert.equals(getline(2),   '        [',   'failed at #231')
  call g:assert.equals(getline(3),   '        foo', 'failed at #231')
  call g:assert.equals(getline(4),   '    ]',       'failed at #231')
  call g:assert.equals(getline(5),   '}',           'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #231')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #231')
  call g:assert.equals(&l:autoindent,  1,           'failed at #231')
  call g:assert.equals(&l:smartindent, 1,           'failed at #231')
  call g:assert.equals(&l:cindent,     0,           'failed at #231')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #231')

  %delete

  " #232
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #232')
  call g:assert.equals(getline(2),   '        [',   'failed at #232')
  call g:assert.equals(getline(3),   '        foo', 'failed at #232')
  call g:assert.equals(getline(4),   '    ]',       'failed at #232')
  call g:assert.equals(getline(5),   '}',           'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #232')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #232')
  call g:assert.equals(&l:autoindent,  1,           'failed at #232')
  call g:assert.equals(&l:smartindent, 1,           'failed at #232')
  call g:assert.equals(&l:cindent,     1,           'failed at #232')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #232')

  %delete

  " #233
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #233')
  call g:assert.equals(getline(2),   '        [',      'failed at #233')
  call g:assert.equals(getline(3),   '        foo',    'failed at #233')
  call g:assert.equals(getline(4),   '    ]',          'failed at #233')
  call g:assert.equals(getline(5),   '}',              'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #233')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #233')
  call g:assert.equals(&l:autoindent,  1,              'failed at #233')
  call g:assert.equals(&l:smartindent, 1,              'failed at #233')
  call g:assert.equals(&l:cindent,     1,              'failed at #233')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #233')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #234
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #234')
  call g:assert.equals(getline(2),   '    [',       'failed at #234')
  call g:assert.equals(getline(3),   '        foo', 'failed at #234')
  call g:assert.equals(getline(4),   '    ]',       'failed at #234')
  call g:assert.equals(getline(5),   '    }',       'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #234')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #234')
  call g:assert.equals(&l:autoindent,  0,           'failed at #234')
  call g:assert.equals(&l:smartindent, 0,           'failed at #234')
  call g:assert.equals(&l:cindent,     0,           'failed at #234')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #234')

  %delete

  " #235
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #235')
  call g:assert.equals(getline(2),   '    [',       'failed at #235')
  call g:assert.equals(getline(3),   '        foo', 'failed at #235')
  call g:assert.equals(getline(4),   '    ]',       'failed at #235')
  call g:assert.equals(getline(5),   '    }',       'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #235')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #235')
  call g:assert.equals(&l:autoindent,  1,           'failed at #235')
  call g:assert.equals(&l:smartindent, 0,           'failed at #235')
  call g:assert.equals(&l:cindent,     0,           'failed at #235')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #235')

  %delete

  " #236
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #236')
  call g:assert.equals(getline(2),   '    [',       'failed at #236')
  call g:assert.equals(getline(3),   '        foo', 'failed at #236')
  call g:assert.equals(getline(4),   '    ]',       'failed at #236')
  call g:assert.equals(getline(5),   '    }',       'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #236')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #236')
  call g:assert.equals(&l:autoindent,  1,           'failed at #236')
  call g:assert.equals(&l:smartindent, 1,           'failed at #236')
  call g:assert.equals(&l:cindent,     0,           'failed at #236')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #236')

  %delete

  " #237
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #237')
  call g:assert.equals(getline(2),   '    [',       'failed at #237')
  call g:assert.equals(getline(3),   '        foo', 'failed at #237')
  call g:assert.equals(getline(4),   '    ]',       'failed at #237')
  call g:assert.equals(getline(5),   '    }',       'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #237')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #237')
  call g:assert.equals(&l:autoindent,  1,           'failed at #237')
  call g:assert.equals(&l:smartindent, 1,           'failed at #237')
  call g:assert.equals(&l:cindent,     1,           'failed at #237')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #237')

  %delete

  " #238
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',              'failed at #238')
  call g:assert.equals(getline(2),   '    [',          'failed at #238')
  call g:assert.equals(getline(3),   '        foo',    'failed at #238')
  call g:assert.equals(getline(4),   '    ]',          'failed at #238')
  call g:assert.equals(getline(5),   '    }',          'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #238')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #238')
  call g:assert.equals(&l:autoindent,  1,              'failed at #238')
  call g:assert.equals(&l:smartindent, 1,              'failed at #238')
  call g:assert.equals(&l:cindent,     1,              'failed at #238')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #238')
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

  " #239
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #239')
  call g:assert.equals(getline(2),   'foo',        'failed at #239')
  call g:assert.equals(getline(3),   '    }',      'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #239')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #239')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #239')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #240
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #240')
  call g:assert.equals(getline(2),   '    foo',    'failed at #240')
  call g:assert.equals(getline(3),   '    }',      'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #240')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #240')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #240')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #241
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #241')
  call g:assert.equals(getline(2),   'foo',        'failed at #241')
  call g:assert.equals(getline(3),   '    }',      'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #241')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #241')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #241')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #242
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #242')
  call g:assert.equals(getline(2),   'foo',        'failed at #242')
  call g:assert.equals(getline(3),   '    }',      'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #242')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #242')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #242')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #243
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',     'failed at #243')
  call g:assert.equals(getline(2),   '    foo',       'failed at #243')
  call g:assert.equals(getline(3),   '            }', 'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #243')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #243')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #243')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #243')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #244
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #244')
  call g:assert.equals(getline(2),   'foo',        'failed at #244')
  call g:assert.equals(getline(3),   '    }',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #244')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #244')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #244')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #245
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #245')
  call g:assert.equals(getline(2),   'foo',        'failed at #245')
  call g:assert.equals(getline(3),   ')',          'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #245')

  %delete

  " #246
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #246')
  call g:assert.equals(getline(2),   'foo',        'failed at #246')
  call g:assert.equals(getline(3),   ')',          'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #246')

  %delete

  " #247
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #247')
  call g:assert.equals(getline(2),   'foo',        'failed at #247')
  call g:assert.equals(getline(3),   ']',          'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #247')

  %delete

  " #248
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #248')
  call g:assert.equals(getline(2),   'foo',        'failed at #248')
  call g:assert.equals(getline(3),   ']',          'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #248')

  %delete

  " #249
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #249')
  call g:assert.equals(getline(2),   'foo',        'failed at #249')
  call g:assert.equals(getline(3),   '}',          'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #249')

  %delete

  " #250
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #250')
  call g:assert.equals(getline(2),   'foo',        'failed at #250')
  call g:assert.equals(getline(3),   '}',          'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #250')

  %delete

  " #251
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #251')
  call g:assert.equals(getline(2),   'foo',        'failed at #251')
  call g:assert.equals(getline(3),   '>',          'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #251')

  %delete

  " #252
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #252')
  call g:assert.equals(getline(2),   'foo',        'failed at #252')
  call g:assert.equals(getline(3),   '>',          'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #252')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #253
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #253')
  call g:assert.equals(getline(2),   'foo',        'failed at #253')
  call g:assert.equals(getline(3),   'a',          'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #253')

  %delete

  " #254
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #254')
  call g:assert.equals(getline(2),   'foo',        'failed at #254')
  call g:assert.equals(getline(3),   '*',          'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #254')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #255
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #255')
  call g:assert.equals(getline(2),   'foo',        'failed at #255')
  call g:assert.equals(getline(3),   'bar',        'failed at #255')
  call g:assert.equals(getline(4),   'baz',        'failed at #255')
  call g:assert.equals(getline(5),   ')',          'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #255')

  " #256
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #256')
  call g:assert.equals(getline(2),   '(',          'failed at #256')
  call g:assert.equals(getline(3),   'bar',        'failed at #256')
  call g:assert.equals(getline(4),   ')',          'failed at #256')
  call g:assert.equals(getline(5),   'baz',        'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #256')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #257
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #257')
  call g:assert.equals(getline(2),   'a',          'failed at #257')
  call g:assert.equals(getline(3),   ')',          'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #257')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #258
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #258')
  call g:assert.equals(getline(2),   'aaa',        'failed at #258')
  call g:assert.equals(getline(3),   'foo',        'failed at #258')
  call g:assert.equals(getline(4),   'aaa',        'failed at #258')
  call g:assert.equals(getline(5),   'aa',         'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #258')

  %delete

  " #259
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #259')
  call g:assert.equals(getline(2),   'bbb',        'failed at #259')
  call g:assert.equals(getline(3),   'bb',         'failed at #259')
  call g:assert.equals(getline(4),   'foo',        'failed at #259')
  call g:assert.equals(getline(5),   'bb',         'failed at #259')
  call g:assert.equals(getline(6),   'bbb',        'failed at #259')
  call g:assert.equals(getline(7),   'bb',         'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #259')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #260
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #260')
  call g:assert.equals(getline(2),   '(',          'failed at #260')
  call g:assert.equals(getline(3),   'foo',        'failed at #260')
  call g:assert.equals(getline(4),   ')',          'failed at #260')
  call g:assert.equals(getline(5),   ']',          'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #260')

  %delete

  " #261
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #261')
  call g:assert.equals(getline(2),   '[',          'failed at #261')
  call g:assert.equals(getline(3),   '(',          'failed at #261')
  call g:assert.equals(getline(4),   'foo',        'failed at #261')
  call g:assert.equals(getline(5),   ')',          'failed at #261')
  call g:assert.equals(getline(6),   ']',          'failed at #261')
  call g:assert.equals(getline(7),   '}',          'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #261')

  %delete

  " #262
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #262')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #262')
  call g:assert.equals(getline(3), ')',            'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #262')

  %delete

  " #263
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #263')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #263')
  call g:assert.equals(getline(3), ')',            'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #263')

  %delete

  " #264
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #264')
  call g:assert.equals(getline(2), '(',            'failed at #264')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #264')
  call g:assert.equals(getline(4), ')',            'failed at #264')
  call g:assert.equals(getline(5), ']',            'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #264')

  %delete

  " #265
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #265')
  call g:assert.equals(getline(2), '[',            'failed at #265')
  call g:assert.equals(getline(3), '(',            'failed at #265')
  call g:assert.equals(getline(4), 'foo',          'failed at #265')
  call g:assert.equals(getline(5), ')',            'failed at #265')
  call g:assert.equals(getline(6), ']',            'failed at #265')
  call g:assert.equals(getline(7), 'aa',           'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #265')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #266
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #266')
  call g:assert.equals(getline(2),   '(',          'failed at #266')
  call g:assert.equals(getline(3),   'foo',        'failed at #266')
  call g:assert.equals(getline(4),   ')',          'failed at #266')
  call g:assert.equals(getline(5),   ')',          'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #266')

  " #267
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #267')
  call g:assert.equals(getline(2),   '(',          'failed at #267')
  call g:assert.equals(getline(3),   '(',          'failed at #267')
  call g:assert.equals(getline(4),   'foo',        'failed at #267')
  call g:assert.equals(getline(5),   ')',          'failed at #267')
  call g:assert.equals(getline(6),   ')',          'failed at #267')
  call g:assert.equals(getline(7),   ')',          'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #267')

  %delete

  """ keep
  " #268
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #268')
  call g:assert.equals(getline(2),   '(',          'failed at #268')
  call g:assert.equals(getline(3),   'foo',        'failed at #268')
  call g:assert.equals(getline(4),   ')',          'failed at #268')
  call g:assert.equals(getline(5),   ')',          'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #268')

  " #269
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #269')
  call g:assert.equals(getline(2),   '(',          'failed at #269')
  call g:assert.equals(getline(3),   '(',          'failed at #269')
  call g:assert.equals(getline(4),   'foo',        'failed at #269')
  call g:assert.equals(getline(5),   ')',          'failed at #269')
  call g:assert.equals(getline(6),   ')',          'failed at #269')
  call g:assert.equals(getline(7),   ')',          'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #269')

  %delete

  """ inner_tail
  " #270
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #270')
  call g:assert.equals(getline(2),   '(',          'failed at #270')
  call g:assert.equals(getline(3),   'foo',        'failed at #270')
  call g:assert.equals(getline(4),   ')',          'failed at #270')
  call g:assert.equals(getline(5),   ')',          'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #270')

  " #271
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #271')
  call g:assert.equals(getline(2),   '(',          'failed at #271')
  call g:assert.equals(getline(3),   '(',          'failed at #271')
  call g:assert.equals(getline(4),   'foo',        'failed at #271')
  call g:assert.equals(getline(5),   ')',          'failed at #271')
  call g:assert.equals(getline(6),   ')',          'failed at #271')
  call g:assert.equals(getline(7),   ')',          'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #271')

  %delete

  """ head
  " #272
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #272')
  call g:assert.equals(getline(2),   '(',          'failed at #272')
  call g:assert.equals(getline(3),   'foo',        'failed at #272')
  call g:assert.equals(getline(4),   ')',          'failed at #272')
  call g:assert.equals(getline(5),   ')',          'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #272')

  " #273
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #273')
  call g:assert.equals(getline(2),   '(',          'failed at #273')
  call g:assert.equals(getline(3),   '(',          'failed at #273')
  call g:assert.equals(getline(4),   'foo',        'failed at #273')
  call g:assert.equals(getline(5),   ')',          'failed at #273')
  call g:assert.equals(getline(6),   ')',          'failed at #273')
  call g:assert.equals(getline(7),   ')',          'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #273')

  %delete

  """ tail
  " #274
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #274')
  call g:assert.equals(getline(2),   '(',          'failed at #274')
  call g:assert.equals(getline(3),   'foo',        'failed at #274')
  call g:assert.equals(getline(4),   ')',          'failed at #274')
  call g:assert.equals(getline(5),   ')',          'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #274')

  " #275
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #275')
  call g:assert.equals(getline(2),   '(',          'failed at #275')
  call g:assert.equals(getline(3),   '(',          'failed at #275')
  call g:assert.equals(getline(4),   'foo',        'failed at #275')
  call g:assert.equals(getline(5),   ')',          'failed at #275')
  call g:assert.equals(getline(6),   ')',          'failed at #275')
  call g:assert.equals(getline(7),   ')',          'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #275')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #276
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #276')
  call g:assert.equals(getline(2), '[',   'failed at #276')
  call g:assert.equals(getline(3), '(',   'failed at #276')
  call g:assert.equals(getline(4), 'foo', 'failed at #276')
  call g:assert.equals(getline(5), ')',   'failed at #276')
  call g:assert.equals(getline(6), ']',   'failed at #276')
  call g:assert.equals(getline(7), '}',   'failed at #276')

  %delete

  """ on
  " #277
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #277')
  call g:assert.equals(getline(2), '(',   'failed at #277')
  call g:assert.equals(getline(3), '(',   'failed at #277')
  call g:assert.equals(getline(4), 'foo', 'failed at #277')
  call g:assert.equals(getline(5), ')',   'failed at #277')
  call g:assert.equals(getline(6), ')',   'failed at #277')
  call g:assert.equals(getline(7), ')',   'failed at #277')

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
  " #278
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #278')
  call g:assert.equals(getline(2), 'foo', 'failed at #278')
  call g:assert.equals(getline(3), '1+2', 'failed at #278')

  %delete

  """ 1
  " #279
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #279')
  call g:assert.equals(getline(2), 'foo', 'failed at #279')
  call g:assert.equals(getline(3), '3',   'failed at #279')

  %delete

  " #280
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1), 'foo',   'failed at #280')
  call g:assert.equals(exists(s:object), 0, 'failed at #280')

  %delete

  " #281
  call setline('.', 'foo')
  normal 0saViwc
  call g:assert.equals(getline(1), 'foo',   'failed at #281')
  call g:assert.equals(exists(s:object), 0, 'failed at #281')

  %delete

  " #282
  call setline('.', 'foo')
  normal 02saViwab
  call g:assert.equals(getline(1), '2',     'failed at #282')
  call g:assert.equals(getline(2), 'foo',   'failed at #282')
  call g:assert.equals(getline(3), '3',     'failed at #282')
  call g:assert.equals(exists(s:object), 0, 'failed at #282')

  %delete

  " #283
  call setline('.', 'foo')
  normal 02saViwac
  call g:assert.equals(getline(1), '2',     'failed at #283')
  call g:assert.equals(getline(2), 'foo',   'failed at #283')
  call g:assert.equals(getline(3), '3',     'failed at #283')
  call g:assert.equals(exists(s:object), 0, 'failed at #283')

  %delete

  " #284
  call setline('.', 'foo')
  normal 02saViwba
  call g:assert.equals(getline(1), 'foo',   'failed at #284')
  call g:assert.equals(exists(s:object), 0, 'failed at #284')

  %delete

  " #285
  call setline('.', 'foo')
  normal 02saViwca
  call g:assert.equals(getline(1), 'foo',   'failed at #285')
  call g:assert.equals(exists(s:object), 0, 'failed at #285')

  %delete

  " #286
  call setline('.', 'foo')
  normal 0saViwd
  call g:assert.equals(getline(1), 'head', 'failed at #286')
  call g:assert.equals(getline(2), 'foo',  'failed at #286')
  call g:assert.equals(getline(3), 'tail', 'failed at #286')

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
  " #287
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #287')
  call g:assert.equals(getline(2), 'foo', 'failed at #287')
  call g:assert.equals(getline(3), ']]',  'failed at #287')

  %delete

  """ off
  " #288
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #288')
  call g:assert.equals(getline(2), 'foo', 'failed at #288')
  call g:assert.equals(getline(3), '}}',  'failed at #288')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #289
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #289')
  call g:assert.equals(getline(2), 'foo ', 'failed at #289')
  call g:assert.equals(getline(3), ')',    'failed at #289')

  %delete

  """ off
  " #290
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #290')
  call g:assert.equals(getline(2), 'foo ', 'failed at #290')
  call g:assert.equals(getline(3), ')',    'failed at #290')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #291
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjsaViw(
  call g:assert.equals(getline(1), '[', 'failed at #291')
  call g:assert.equals(getline(2), ']', 'failed at #291')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #292
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #292')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #293
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #293')
  call g:assert.equals(getline(2),   '    foo',    'failed at #293')
  call g:assert.equals(getline(3),   '    )',      'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #293')

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

  " #294
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #294')
  call g:assert.equals(getline(2),   '[',          'failed at #294')
  call g:assert.equals(getline(3),   '',           'failed at #294')
  call g:assert.equals(getline(4),   '    foo',    'failed at #294')
  call g:assert.equals(getline(5),   '',           'failed at #294')
  call g:assert.equals(getline(6),   ']',          'failed at #294')
  call g:assert.equals(getline(7),   '}',          'failed at #294')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #294')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #294')
  call g:assert.equals(&l:autoindent,  0,          'failed at #294')
  call g:assert.equals(&l:smartindent, 0,          'failed at #294')
  call g:assert.equals(&l:cindent,     0,          'failed at #294')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #294')

  %delete

  " #295
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #295')
  call g:assert.equals(getline(2),   '    [',      'failed at #295')
  call g:assert.equals(getline(3),   '',           'failed at #295')
  call g:assert.equals(getline(4),   '    foo',    'failed at #295')
  call g:assert.equals(getline(5),   '',           'failed at #295')
  call g:assert.equals(getline(6),   '    ]',      'failed at #295')
  call g:assert.equals(getline(7),   '    }',      'failed at #295')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #295')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #295')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #295')
  call g:assert.equals(&l:autoindent,  1,          'failed at #295')
  call g:assert.equals(&l:smartindent, 0,          'failed at #295')
  call g:assert.equals(&l:cindent,     0,          'failed at #295')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #295')

  %delete

  " #296
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #296')
  call g:assert.equals(getline(2),   '    [',       'failed at #296')
  call g:assert.equals(getline(3),   '',            'failed at #296')
  call g:assert.equals(getline(4),   '    foo',     'failed at #296')
  call g:assert.equals(getline(5),   '',            'failed at #296')
  call g:assert.equals(getline(6),   '    ]',       'failed at #296')
  call g:assert.equals(getline(7),   '}',           'failed at #296')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #296')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #296')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #296')
  call g:assert.equals(&l:autoindent,  1,           'failed at #296')
  call g:assert.equals(&l:smartindent, 1,           'failed at #296')
  call g:assert.equals(&l:cindent,     0,           'failed at #296')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #296')

  %delete

  " #297
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #297')
  call g:assert.equals(getline(2),   '    [',       'failed at #297')
  call g:assert.equals(getline(3),   '',            'failed at #297')
  call g:assert.equals(getline(4),   '    foo',     'failed at #297')
  call g:assert.equals(getline(5),   '',            'failed at #297')
  call g:assert.equals(getline(6),   '    ]',       'failed at #297')
  call g:assert.equals(getline(7),   '    }',       'failed at #297')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #297')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #297')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #297')
  call g:assert.equals(&l:autoindent,  1,           'failed at #297')
  call g:assert.equals(&l:smartindent, 1,           'failed at #297')
  call g:assert.equals(&l:cindent,     1,           'failed at #297')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #297')

  %delete

  " #298
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',            'failed at #298')
  call g:assert.equals(getline(2),   '           [',        'failed at #298')
  call g:assert.equals(getline(3),   '',                    'failed at #298')
  call g:assert.equals(getline(4),   '    foo',             'failed at #298')
  call g:assert.equals(getline(5),   '',                    'failed at #298')
  call g:assert.equals(getline(6),   '        ]',           'failed at #298')
  call g:assert.equals(getline(7),   '                }',   'failed at #298')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #298')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #298')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #298')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #298')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #298')
  call g:assert.equals(&l:cindent,     1,                   'failed at #298')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #298')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #299
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #299')
  call g:assert.equals(getline(2),   '[',          'failed at #299')
  call g:assert.equals(getline(3),   '',           'failed at #299')
  call g:assert.equals(getline(4),   '    foo',    'failed at #299')
  call g:assert.equals(getline(5),   '',           'failed at #299')
  call g:assert.equals(getline(6),   ']',          'failed at #299')
  call g:assert.equals(getline(7),   '}',          'failed at #299')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #299')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #299')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #299')
  call g:assert.equals(&l:autoindent,  0,          'failed at #299')
  call g:assert.equals(&l:smartindent, 0,          'failed at #299')
  call g:assert.equals(&l:cindent,     0,          'failed at #299')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #299')

  %delete

  " #300
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #300')
  call g:assert.equals(getline(2),   '[',          'failed at #300')
  call g:assert.equals(getline(3),   '',           'failed at #300')
  call g:assert.equals(getline(4),   '    foo',    'failed at #300')
  call g:assert.equals(getline(5),   '',           'failed at #300')
  call g:assert.equals(getline(6),   ']',          'failed at #300')
  call g:assert.equals(getline(7),   '}',          'failed at #300')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #300')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #300')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #300')
  call g:assert.equals(&l:autoindent,  1,          'failed at #300')
  call g:assert.equals(&l:smartindent, 0,          'failed at #300')
  call g:assert.equals(&l:cindent,     0,          'failed at #300')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #300')

  %delete

  " #301
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #301')
  call g:assert.equals(getline(2),   '[',          'failed at #301')
  call g:assert.equals(getline(3),   '',           'failed at #301')
  call g:assert.equals(getline(4),   '    foo',    'failed at #301')
  call g:assert.equals(getline(5),   '',           'failed at #301')
  call g:assert.equals(getline(6),   ']',          'failed at #301')
  call g:assert.equals(getline(7),   '}',          'failed at #301')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #301')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #301')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #301')
  call g:assert.equals(&l:autoindent,  1,          'failed at #301')
  call g:assert.equals(&l:smartindent, 1,          'failed at #301')
  call g:assert.equals(&l:cindent,     0,          'failed at #301')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #301')

  %delete

  " #302
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #302')
  call g:assert.equals(getline(2),   '[',          'failed at #302')
  call g:assert.equals(getline(3),   '',           'failed at #302')
  call g:assert.equals(getline(4),   '    foo',    'failed at #302')
  call g:assert.equals(getline(5),   '',           'failed at #302')
  call g:assert.equals(getline(6),   ']',          'failed at #302')
  call g:assert.equals(getline(7),   '}',          'failed at #302')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #302')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #302')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #302')
  call g:assert.equals(&l:autoindent,  1,          'failed at #302')
  call g:assert.equals(&l:smartindent, 1,          'failed at #302')
  call g:assert.equals(&l:cindent,     1,          'failed at #302')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #302')

  %delete

  " #303
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #303')
  call g:assert.equals(getline(2),   '[',              'failed at #303')
  call g:assert.equals(getline(3),   '',               'failed at #303')
  call g:assert.equals(getline(4),   '    foo',        'failed at #303')
  call g:assert.equals(getline(5),   '',               'failed at #303')
  call g:assert.equals(getline(6),   ']',              'failed at #303')
  call g:assert.equals(getline(7),   '}',              'failed at #303')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #303')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #303')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #303')
  call g:assert.equals(&l:autoindent,  1,              'failed at #303')
  call g:assert.equals(&l:smartindent, 1,              'failed at #303')
  call g:assert.equals(&l:cindent,     1,              'failed at #303')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #303')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #304
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #304')
  call g:assert.equals(getline(2),   '    [',      'failed at #304')
  call g:assert.equals(getline(3),   '',           'failed at #304')
  call g:assert.equals(getline(4),   '    foo',    'failed at #304')
  call g:assert.equals(getline(5),   '',           'failed at #304')
  call g:assert.equals(getline(6),   '    ]',      'failed at #304')
  call g:assert.equals(getline(7),   '    }',      'failed at #304')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #304')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #304')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #304')
  call g:assert.equals(&l:autoindent,  0,          'failed at #304')
  call g:assert.equals(&l:smartindent, 0,          'failed at #304')
  call g:assert.equals(&l:cindent,     0,          'failed at #304')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #304')

  %delete

  " #305
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #305')
  call g:assert.equals(getline(2),   '    [',      'failed at #305')
  call g:assert.equals(getline(3),   '',           'failed at #305')
  call g:assert.equals(getline(4),   '    foo',    'failed at #305')
  call g:assert.equals(getline(5),   '',           'failed at #305')
  call g:assert.equals(getline(6),   '    ]',      'failed at #305')
  call g:assert.equals(getline(7),   '    }',      'failed at #305')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #305')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #305')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #305')
  call g:assert.equals(&l:autoindent,  1,          'failed at #305')
  call g:assert.equals(&l:smartindent, 0,          'failed at #305')
  call g:assert.equals(&l:cindent,     0,          'failed at #305')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #305')

  %delete

  " #306
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #306')
  call g:assert.equals(getline(2),   '    [',      'failed at #306')
  call g:assert.equals(getline(3),   '',           'failed at #306')
  call g:assert.equals(getline(4),   '    foo',    'failed at #306')
  call g:assert.equals(getline(5),   '',           'failed at #306')
  call g:assert.equals(getline(6),   '    ]',      'failed at #306')
  call g:assert.equals(getline(7),   '    }',      'failed at #306')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #306')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #306')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #306')
  call g:assert.equals(&l:autoindent,  1,          'failed at #306')
  call g:assert.equals(&l:smartindent, 1,          'failed at #306')
  call g:assert.equals(&l:cindent,     0,          'failed at #306')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #306')

  %delete

  " #307
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #307')
  call g:assert.equals(getline(2),   '    [',      'failed at #307')
  call g:assert.equals(getline(3),   '',           'failed at #307')
  call g:assert.equals(getline(4),   '    foo',    'failed at #307')
  call g:assert.equals(getline(5),   '',           'failed at #307')
  call g:assert.equals(getline(6),   '    ]',      'failed at #307')
  call g:assert.equals(getline(7),   '    }',      'failed at #307')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #307')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #307')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #307')
  call g:assert.equals(&l:autoindent,  1,          'failed at #307')
  call g:assert.equals(&l:smartindent, 1,          'failed at #307')
  call g:assert.equals(&l:cindent,     1,          'failed at #307')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #307')

  %delete

  " #308
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',          'failed at #308')
  call g:assert.equals(getline(2),   '    [',          'failed at #308')
  call g:assert.equals(getline(3),   '',               'failed at #308')
  call g:assert.equals(getline(4),   '    foo',        'failed at #308')
  call g:assert.equals(getline(5),   '',               'failed at #308')
  call g:assert.equals(getline(6),   '    ]',          'failed at #308')
  call g:assert.equals(getline(7),   '    }',          'failed at #308')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #308')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #308')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #308')
  call g:assert.equals(&l:autoindent,  1,              'failed at #308')
  call g:assert.equals(&l:smartindent, 1,              'failed at #308')
  call g:assert.equals(&l:cindent,     1,              'failed at #308')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #308')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #309
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #309')
  call g:assert.equals(getline(2),   '    [',       'failed at #309')
  call g:assert.equals(getline(3),   '',            'failed at #309')
  call g:assert.equals(getline(4),   '    foo',     'failed at #309')
  call g:assert.equals(getline(5),   '',            'failed at #309')
  call g:assert.equals(getline(6),   '    ]',       'failed at #309')
  call g:assert.equals(getline(7),   '}',           'failed at #309')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #309')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #309')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #309')
  call g:assert.equals(&l:autoindent,  0,           'failed at #309')
  call g:assert.equals(&l:smartindent, 0,           'failed at #309')
  call g:assert.equals(&l:cindent,     0,           'failed at #309')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #309')

  %delete

  " #310
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #310')
  call g:assert.equals(getline(2),   '    [',       'failed at #310')
  call g:assert.equals(getline(3),   '',            'failed at #310')
  call g:assert.equals(getline(4),   '    foo',     'failed at #310')
  call g:assert.equals(getline(5),   '',            'failed at #310')
  call g:assert.equals(getline(6),   '    ]',       'failed at #310')
  call g:assert.equals(getline(7),   '}',           'failed at #310')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #310')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #310')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #310')
  call g:assert.equals(&l:autoindent,  1,           'failed at #310')
  call g:assert.equals(&l:smartindent, 0,           'failed at #310')
  call g:assert.equals(&l:cindent,     0,           'failed at #310')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #310')

  %delete

  " #311
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #311')
  call g:assert.equals(getline(2),   '    [',       'failed at #311')
  call g:assert.equals(getline(3),   '',            'failed at #311')
  call g:assert.equals(getline(4),   '    foo',     'failed at #311')
  call g:assert.equals(getline(5),   '',            'failed at #311')
  call g:assert.equals(getline(6),   '    ]',       'failed at #311')
  call g:assert.equals(getline(7),   '}',           'failed at #311')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #311')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #311')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #311')
  call g:assert.equals(&l:autoindent,  1,           'failed at #311')
  call g:assert.equals(&l:smartindent, 1,           'failed at #311')
  call g:assert.equals(&l:cindent,     0,           'failed at #311')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #311')

  %delete

  " #312
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #312')
  call g:assert.equals(getline(2),   '    [',       'failed at #312')
  call g:assert.equals(getline(3),   '',            'failed at #312')
  call g:assert.equals(getline(4),   '    foo',     'failed at #312')
  call g:assert.equals(getline(5),   '',            'failed at #312')
  call g:assert.equals(getline(6),   '    ]',       'failed at #312')
  call g:assert.equals(getline(7),   '}',           'failed at #312')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #312')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #312')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #312')
  call g:assert.equals(&l:autoindent,  1,           'failed at #312')
  call g:assert.equals(&l:smartindent, 1,           'failed at #312')
  call g:assert.equals(&l:cindent,     1,           'failed at #312')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #312')

  %delete

  " #313
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #313')
  call g:assert.equals(getline(2),   '    [',          'failed at #313')
  call g:assert.equals(getline(3),   '',               'failed at #313')
  call g:assert.equals(getline(4),   '    foo',        'failed at #313')
  call g:assert.equals(getline(5),   '',               'failed at #313')
  call g:assert.equals(getline(6),   '    ]',          'failed at #313')
  call g:assert.equals(getline(7),   '}',              'failed at #313')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #313')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #313')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #313')
  call g:assert.equals(&l:autoindent,  1,              'failed at #313')
  call g:assert.equals(&l:smartindent, 1,              'failed at #313')
  call g:assert.equals(&l:cindent,     1,              'failed at #313')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #313')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #314
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #314')
  call g:assert.equals(getline(2),   '    [',       'failed at #314')
  call g:assert.equals(getline(3),   '',            'failed at #314')
  call g:assert.equals(getline(4),   '    foo',     'failed at #314')
  call g:assert.equals(getline(5),   '',            'failed at #314')
  call g:assert.equals(getline(6),   '    ]',       'failed at #314')
  call g:assert.equals(getline(7),   '    }',       'failed at #314')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #314')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #314')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #314')
  call g:assert.equals(&l:autoindent,  0,           'failed at #314')
  call g:assert.equals(&l:smartindent, 0,           'failed at #314')
  call g:assert.equals(&l:cindent,     0,           'failed at #314')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #314')

  %delete

  " #315
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #315')
  call g:assert.equals(getline(2),   '    [',       'failed at #315')
  call g:assert.equals(getline(3),   '',            'failed at #315')
  call g:assert.equals(getline(4),   '    foo',     'failed at #315')
  call g:assert.equals(getline(5),   '',            'failed at #315')
  call g:assert.equals(getline(6),   '    ]',       'failed at #315')
  call g:assert.equals(getline(7),   '    }',       'failed at #315')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #315')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #315')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #315')
  call g:assert.equals(&l:autoindent,  1,           'failed at #315')
  call g:assert.equals(&l:smartindent, 0,           'failed at #315')
  call g:assert.equals(&l:cindent,     0,           'failed at #315')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #315')

  %delete

  " #316
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #316')
  call g:assert.equals(getline(2),   '    [',       'failed at #316')
  call g:assert.equals(getline(3),   '',            'failed at #316')
  call g:assert.equals(getline(4),   '    foo',     'failed at #316')
  call g:assert.equals(getline(5),   '',            'failed at #316')
  call g:assert.equals(getline(6),   '    ]',       'failed at #316')
  call g:assert.equals(getline(7),   '    }',       'failed at #316')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #316')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #316')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #316')
  call g:assert.equals(&l:autoindent,  1,           'failed at #316')
  call g:assert.equals(&l:smartindent, 1,           'failed at #316')
  call g:assert.equals(&l:cindent,     0,           'failed at #316')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #316')

  %delete

  " #317
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #317')
  call g:assert.equals(getline(2),   '    [',       'failed at #317')
  call g:assert.equals(getline(3),   '',            'failed at #317')
  call g:assert.equals(getline(4),   '    foo',     'failed at #317')
  call g:assert.equals(getline(5),   '',            'failed at #317')
  call g:assert.equals(getline(6),   '    ]',       'failed at #317')
  call g:assert.equals(getline(7),   '    }',       'failed at #317')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #317')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #317')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #317')
  call g:assert.equals(&l:autoindent,  1,           'failed at #317')
  call g:assert.equals(&l:smartindent, 1,           'failed at #317')
  call g:assert.equals(&l:cindent,     1,           'failed at #317')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #317')

  %delete

  " #318
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #318')
  call g:assert.equals(getline(2),   '    [',          'failed at #318')
  call g:assert.equals(getline(3),   '',               'failed at #318')
  call g:assert.equals(getline(4),   '    foo',        'failed at #318')
  call g:assert.equals(getline(5),   '',               'failed at #318')
  call g:assert.equals(getline(6),   '    ]',          'failed at #318')
  call g:assert.equals(getline(7),   '    }',          'failed at #318')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #318')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #318')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #318')
  call g:assert.equals(&l:autoindent,  1,              'failed at #318')
  call g:assert.equals(&l:smartindent, 1,              'failed at #318')
  call g:assert.equals(&l:cindent,     1,              'failed at #318')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #318')
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

  " #319
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #319')
  call g:assert.equals(getline(2),   '',           'failed at #319')
  call g:assert.equals(getline(3),   '    foo',    'failed at #319')
  call g:assert.equals(getline(4),   '',           'failed at #319')
  call g:assert.equals(getline(5),   '    }',      'failed at #319')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #319')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #319')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #319')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #319')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #319')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #320
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #320')
  call g:assert.equals(getline(2),   '',           'failed at #320')
  call g:assert.equals(getline(3),   '    foo',    'failed at #320')
  call g:assert.equals(getline(4),   '',           'failed at #320')
  call g:assert.equals(getline(5),   '    }',      'failed at #320')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #320')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #320')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #320')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #320')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #320')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #321
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #321')
  call g:assert.equals(getline(2),   '',           'failed at #321')
  call g:assert.equals(getline(3),   '    foo',    'failed at #321')
  call g:assert.equals(getline(4),   '',           'failed at #321')
  call g:assert.equals(getline(5),   '    }',      'failed at #321')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #321')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #321')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #321')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #321')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #321')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #322
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #322')
  call g:assert.equals(getline(2),   '',              'failed at #322')
  call g:assert.equals(getline(3),   '    foo',       'failed at #322')
  call g:assert.equals(getline(4),   '',              'failed at #322')
  call g:assert.equals(getline(5),   '    }',         'failed at #322')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #322')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #322')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #322')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #322')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #322')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #323
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',      'failed at #323')
  call g:assert.equals(getline(2),   '',              'failed at #323')
  call g:assert.equals(getline(3),   '    foo',       'failed at #323')
  call g:assert.equals(getline(4),   '',              'failed at #323')
  call g:assert.equals(getline(5),   '            }', 'failed at #323')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #323')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #323')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #323')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #323')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #323')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #324
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #324')
  call g:assert.equals(getline(2),   '',              'failed at #324')
  call g:assert.equals(getline(3),   '    foo',       'failed at #324')
  call g:assert.equals(getline(4),   '',              'failed at #324')
  call g:assert.equals(getline(5),   '    }',         'failed at #324')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #324')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #324')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #324')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #324')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #324')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #325
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #325')
  call g:assert.equals(getline(2),   'foo',        'failed at #325')
  call g:assert.equals(getline(3),   ')',          'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #325')

  %delete

  " #326
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #326')
  call g:assert.equals(getline(2),   'foo',        'failed at #326')
  call g:assert.equals(getline(3),   ')',          'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #326')

  %delete

  " #327
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #327')
  call g:assert.equals(getline(2),   'foo',        'failed at #327')
  call g:assert.equals(getline(3),   ']',          'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #327')

  %delete

  " #328
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #328')
  call g:assert.equals(getline(2),   'foo',        'failed at #328')
  call g:assert.equals(getline(3),   ']',          'failed at #328')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #328')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #328')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #328')

  %delete

  " #329
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #329')
  call g:assert.equals(getline(2),   'foo',        'failed at #329')
  call g:assert.equals(getline(3),   '}',          'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #329')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #329')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #329')

  %delete

  " #330
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #330')
  call g:assert.equals(getline(2),   'foo',        'failed at #330')
  call g:assert.equals(getline(3),   '}',          'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #330')

  %delete

  " #331
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #331')
  call g:assert.equals(getline(2),   'foo',        'failed at #331')
  call g:assert.equals(getline(3),   '>',          'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #331')

  %delete

  " #332
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #332')
  call g:assert.equals(getline(2),   'foo',        'failed at #332')
  call g:assert.equals(getline(3),   '>',          'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #332')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #333
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #333')
  call g:assert.equals(getline(2), 'foo',          'failed at #333')
  call g:assert.equals(getline(3), 'a',            'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #333')

  %delete

  " #334
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #334')
  call g:assert.equals(getline(2), 'foo',          'failed at #334')
  call g:assert.equals(getline(3), '*',            'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #334')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #335
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #335')
  call g:assert.equals(getline(2),   'foo',        'failed at #335')
  call g:assert.equals(getline(3),   'bar',        'failed at #335')
  call g:assert.equals(getline(4),   'baz',        'failed at #335')
  call g:assert.equals(getline(5),   ')',          'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #335')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #336
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #336')
  call g:assert.equals(getline(2),   'a',          'failed at #336')
  call g:assert.equals(getline(3),   ')',          'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #336')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  " #337
  call append(0, ['', 'foo'])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #337')
  call g:assert.equals(getline(2), '',             'failed at #337')
  call g:assert.equals(getline(3), 'foo',          'failed at #337')
  call g:assert.equals(getline(4), ')',            'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #337')

  %delete

  " #338
  call append(0, ['foo', ''])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #338')
  call g:assert.equals(getline(2), 'foo',          'failed at #338')
  call g:assert.equals(getline(3), '',             'failed at #338')
  call g:assert.equals(getline(4), ')',            'failed at #338')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #338')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #339
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #339')
  call g:assert.equals(getline(2),   'aaa',        'failed at #339')
  call g:assert.equals(getline(3),   'foo',        'failed at #339')
  call g:assert.equals(getline(4),   'aaa',        'failed at #339')
  call g:assert.equals(getline(5),   'aa',         'failed at #339')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #339')

  %delete

  " #340
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #340')
  call g:assert.equals(getline(2),   'bbb',        'failed at #340')
  call g:assert.equals(getline(3),   'bb',         'failed at #340')
  call g:assert.equals(getline(4),   'foo',        'failed at #340')
  call g:assert.equals(getline(5),   'bb',         'failed at #340')
  call g:assert.equals(getline(6),   'bbb',        'failed at #340')
  call g:assert.equals(getline(7),   'bb',         'failed at #340')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #340')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #340')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #340')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #341
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #341')
  call g:assert.equals(getline(2),   '(',          'failed at #341')
  call g:assert.equals(getline(3),   'foo',        'failed at #341')
  call g:assert.equals(getline(4),   ')',          'failed at #341')
  call g:assert.equals(getline(5),   ']',          'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #341')

  %delete

  " #342
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #342')
  call g:assert.equals(getline(2),   '[',          'failed at #342')
  call g:assert.equals(getline(3),   '(',          'failed at #342')
  call g:assert.equals(getline(4),   'foo',        'failed at #342')
  call g:assert.equals(getline(5),   ')',          'failed at #342')
  call g:assert.equals(getline(6),   ']',          'failed at #342')
  call g:assert.equals(getline(7),   '}',          'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #342')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #343
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #343')
  call g:assert.equals(getline(2),   '(',          'failed at #343')
  call g:assert.equals(getline(3),   'foo',        'failed at #343')
  call g:assert.equals(getline(4),   ')',          'failed at #343')
  call g:assert.equals(getline(5),   ')',          'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #343')

  " #344
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #344')
  call g:assert.equals(getline(2),   '(',          'failed at #344')
  call g:assert.equals(getline(3),   '(',          'failed at #344')
  call g:assert.equals(getline(4),   'foo',        'failed at #344')
  call g:assert.equals(getline(5),   ')',          'failed at #344')
  call g:assert.equals(getline(6),   ')',          'failed at #344')
  call g:assert.equals(getline(7),   ')',          'failed at #344')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #344')

  %delete

  """ keep
  " #345
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #345')
  call g:assert.equals(getline(2),   '(',          'failed at #345')
  call g:assert.equals(getline(3),   'foo',        'failed at #345')
  call g:assert.equals(getline(4),   ')',          'failed at #345')
  call g:assert.equals(getline(5),   ')',          'failed at #345')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #345')

  " #346
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #346')
  call g:assert.equals(getline(2),   '(',          'failed at #346')
  call g:assert.equals(getline(3),   '(',          'failed at #346')
  call g:assert.equals(getline(4),   'foo',        'failed at #346')
  call g:assert.equals(getline(5),   ')',          'failed at #346')
  call g:assert.equals(getline(6),   ')',          'failed at #346')
  call g:assert.equals(getline(7),   ')',          'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #346')

  %delete

  """ inner_tail
  " #347
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #347')
  call g:assert.equals(getline(2),   '(',          'failed at #347')
  call g:assert.equals(getline(3),   'foo',        'failed at #347')
  call g:assert.equals(getline(4),   ')',          'failed at #347')
  call g:assert.equals(getline(5),   ')',          'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #347')

  " #348
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #348')
  call g:assert.equals(getline(2),   '(',          'failed at #348')
  call g:assert.equals(getline(3),   '(',          'failed at #348')
  call g:assert.equals(getline(4),   'foo',        'failed at #348')
  call g:assert.equals(getline(5),   ')',          'failed at #348')
  call g:assert.equals(getline(6),   ')',          'failed at #348')
  call g:assert.equals(getline(7),   ')',          'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #348')

  %delete

  """ head
  " #349
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #349')
  call g:assert.equals(getline(2),   '(',          'failed at #349')
  call g:assert.equals(getline(3),   'foo',        'failed at #349')
  call g:assert.equals(getline(4),   ')',          'failed at #349')
  call g:assert.equals(getline(5),   ')',          'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #349')

  " #350
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #350')
  call g:assert.equals(getline(2),   '(',          'failed at #350')
  call g:assert.equals(getline(3),   '(',          'failed at #350')
  call g:assert.equals(getline(4),   'foo',        'failed at #350')
  call g:assert.equals(getline(5),   ')',          'failed at #350')
  call g:assert.equals(getline(6),   ')',          'failed at #350')
  call g:assert.equals(getline(7),   ')',          'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #350')

  %delete

  """ tail
  " #351
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #351')
  call g:assert.equals(getline(2),   '(',          'failed at #351')
  call g:assert.equals(getline(3),   'foo',        'failed at #351')
  call g:assert.equals(getline(4),   ')',          'failed at #351')
  call g:assert.equals(getline(5),   ')',          'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #351')

  " #352
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #352')
  call g:assert.equals(getline(2),   '(',          'failed at #352')
  call g:assert.equals(getline(3),   '(',          'failed at #352')
  call g:assert.equals(getline(4),   'foo',        'failed at #352')
  call g:assert.equals(getline(5),   ')',          'failed at #352')
  call g:assert.equals(getline(6),   ')',          'failed at #352')
  call g:assert.equals(getline(7),   ')',          'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #352')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #353
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #353')
  call g:assert.equals(getline(2), '[',   'failed at #353')
  call g:assert.equals(getline(3), '(',   'failed at #353')
  call g:assert.equals(getline(4), 'foo', 'failed at #353')
  call g:assert.equals(getline(5), ')',   'failed at #353')
  call g:assert.equals(getline(6), ']',   'failed at #353')
  call g:assert.equals(getline(7), '}',   'failed at #353')

  %delete

  """ on
  " #354
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #354')
  call g:assert.equals(getline(2), '(',   'failed at #354')
  call g:assert.equals(getline(3), '(',   'failed at #354')
  call g:assert.equals(getline(4), 'foo', 'failed at #354')
  call g:assert.equals(getline(5), ')',   'failed at #354')
  call g:assert.equals(getline(6), ')',   'failed at #354')
  call g:assert.equals(getline(7), ')',   'failed at #354')

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
  " #355
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #355')
  call g:assert.equals(getline(2), 'foo', 'failed at #355')
  call g:assert.equals(getline(3), '1+2', 'failed at #355')

  %delete

  """ 1
  " #356
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #356')
  call g:assert.equals(getline(2), 'foo', 'failed at #356')
  call g:assert.equals(getline(3), '3',   'failed at #356')

  %delete

  " #357
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1), 'foo',   'failed at #357')
  call g:assert.equals(exists(s:object), 0, 'failed at #357')

  %delete

  " #358
  call setline('.', 'foo')
  normal Vsac
  call g:assert.equals(getline(1), 'foo',   'failed at #358')
  call g:assert.equals(exists(s:object), 0, 'failed at #358')

  %delete

  " #359
  call setline('.', 'foo')
  normal V2saab
  call g:assert.equals(getline(1), '2',     'failed at #359')
  call g:assert.equals(getline(2), 'foo',   'failed at #359')
  call g:assert.equals(getline(3), '3',     'failed at #359')
  call g:assert.equals(exists(s:object), 0, 'failed at #359')

  %delete

  " #360
  call setline('.', 'foo')
  normal V2saac
  call g:assert.equals(getline(1), '2',     'failed at #360')
  call g:assert.equals(getline(2), 'foo',   'failed at #360')
  call g:assert.equals(getline(3), '3',     'failed at #360')
  call g:assert.equals(exists(s:object), 0, 'failed at #360')

  %delete

  " #361
  call setline('.', 'foo')
  normal V2saba
  call g:assert.equals(getline(1), 'foo',   'failed at #361')
  call g:assert.equals(exists(s:object), 0, 'failed at #361')

  %delete

  " #362
  call setline('.', 'foo')
  normal V2saca
  call g:assert.equals(getline(1), 'foo',   'failed at #362')
  call g:assert.equals(exists(s:object), 0, 'failed at #362')

  %delete

  " #363
  call setline('.', 'foo')
  normal Vsad
  call g:assert.equals(getline(1), 'head', 'failed at #363')
  call g:assert.equals(getline(2), 'foo',  'failed at #363')
  call g:assert.equals(getline(3), 'tail', 'failed at #363')

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
  " #364
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #364')
  call g:assert.equals(getline(2), 'foo', 'failed at #364')
  call g:assert.equals(getline(3), ']]',  'failed at #364')

  %delete

  """ off
  " #365
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #365')
  call g:assert.equals(getline(2), 'foo', 'failed at #365')
  call g:assert.equals(getline(3), '}}',  'failed at #365')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #366
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #366')
  call g:assert.equals(getline(2), 'foo ', 'failed at #366')
  call g:assert.equals(getline(3), ')',    'failed at #366')

  %delete

  """ off
  " #367
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #367')
  call g:assert.equals(getline(2), 'foo ', 'failed at #367')
  call g:assert.equals(getline(3), ')',    'failed at #367')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #368
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjVsa(
  call g:assert.equals(getline(1), '[', 'failed at #368')
  call g:assert.equals(getline(2), ']', 'failed at #368')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #369
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #369')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #370
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #370')
  call g:assert.equals(getline(2),   '    foo',    'failed at #370')
  call g:assert.equals(getline(3),   '    )',      'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #370')

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

  " #371
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #371')
  call g:assert.equals(getline(2),   '[',          'failed at #371')
  call g:assert.equals(getline(3),   '',           'failed at #371')
  call g:assert.equals(getline(4),   '    foo',    'failed at #371')
  call g:assert.equals(getline(5),   '',           'failed at #371')
  call g:assert.equals(getline(6),   ']',          'failed at #371')
  call g:assert.equals(getline(7),   '}',          'failed at #371')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #371')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #371')
  call g:assert.equals(&l:autoindent,  0,          'failed at #371')
  call g:assert.equals(&l:smartindent, 0,          'failed at #371')
  call g:assert.equals(&l:cindent,     0,          'failed at #371')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #371')

  %delete

  " #372
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #372')
  call g:assert.equals(getline(2),   '    [',      'failed at #372')
  call g:assert.equals(getline(3),   '',           'failed at #372')
  call g:assert.equals(getline(4),   '    foo',    'failed at #372')
  call g:assert.equals(getline(5),   '',           'failed at #372')
  call g:assert.equals(getline(6),   '    ]',      'failed at #372')
  call g:assert.equals(getline(7),   '    }',      'failed at #372')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #372')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #372')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #372')
  call g:assert.equals(&l:autoindent,  1,          'failed at #372')
  call g:assert.equals(&l:smartindent, 0,          'failed at #372')
  call g:assert.equals(&l:cindent,     0,          'failed at #372')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #372')

  %delete

  " #373
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #373')
  call g:assert.equals(getline(2),   '    [',       'failed at #373')
  call g:assert.equals(getline(3),   '',            'failed at #373')
  call g:assert.equals(getline(4),   '    foo',     'failed at #373')
  call g:assert.equals(getline(5),   '',            'failed at #373')
  call g:assert.equals(getline(6),   '    ]',       'failed at #373')
  call g:assert.equals(getline(7),   '}',           'failed at #373')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #373')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #373')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #373')
  call g:assert.equals(&l:autoindent,  1,           'failed at #373')
  call g:assert.equals(&l:smartindent, 1,           'failed at #373')
  call g:assert.equals(&l:cindent,     0,           'failed at #373')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #373')

  %delete

  " #374
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #374')
  call g:assert.equals(getline(2),   '    [',       'failed at #374')
  call g:assert.equals(getline(3),   '',            'failed at #374')
  call g:assert.equals(getline(4),   '    foo',     'failed at #374')
  call g:assert.equals(getline(5),   '',            'failed at #374')
  call g:assert.equals(getline(6),   '    ]',       'failed at #374')
  call g:assert.equals(getline(7),   '    }',       'failed at #374')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #374')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #374')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #374')
  call g:assert.equals(&l:autoindent,  1,           'failed at #374')
  call g:assert.equals(&l:smartindent, 1,           'failed at #374')
  call g:assert.equals(&l:cindent,     1,           'failed at #374')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #374')

  %delete

  " #375
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',            'failed at #375')
  call g:assert.equals(getline(2),   '           [',        'failed at #375')
  call g:assert.equals(getline(3),   '',                    'failed at #375')
  call g:assert.equals(getline(4),   '    foo',             'failed at #375')
  call g:assert.equals(getline(5),   '',                    'failed at #375')
  call g:assert.equals(getline(6),   '        ]',           'failed at #375')
  call g:assert.equals(getline(7),   '                }',   'failed at #375')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #375')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #375')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #375')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #375')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #375')
  call g:assert.equals(&l:cindent,     1,                   'failed at #375')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #375')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #376
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #376')
  call g:assert.equals(getline(2),   '[',          'failed at #376')
  call g:assert.equals(getline(3),   '',           'failed at #376')
  call g:assert.equals(getline(4),   '    foo',    'failed at #376')
  call g:assert.equals(getline(5),   '',           'failed at #376')
  call g:assert.equals(getline(6),   ']',          'failed at #376')
  call g:assert.equals(getline(7),   '}',          'failed at #376')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #376')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #376')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #376')
  call g:assert.equals(&l:autoindent,  0,          'failed at #376')
  call g:assert.equals(&l:smartindent, 0,          'failed at #376')
  call g:assert.equals(&l:cindent,     0,          'failed at #376')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #376')

  %delete

  " #377
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #377')
  call g:assert.equals(getline(2),   '[',          'failed at #377')
  call g:assert.equals(getline(3),   '',           'failed at #377')
  call g:assert.equals(getline(4),   '    foo',    'failed at #377')
  call g:assert.equals(getline(5),   '',           'failed at #377')
  call g:assert.equals(getline(6),   ']',          'failed at #377')
  call g:assert.equals(getline(7),   '}',          'failed at #377')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #377')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #377')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #377')
  call g:assert.equals(&l:autoindent,  1,          'failed at #377')
  call g:assert.equals(&l:smartindent, 0,          'failed at #377')
  call g:assert.equals(&l:cindent,     0,          'failed at #377')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #377')

  %delete

  " #378
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #378')
  call g:assert.equals(getline(2),   '[',          'failed at #378')
  call g:assert.equals(getline(3),   '',           'failed at #378')
  call g:assert.equals(getline(4),   '    foo',    'failed at #378')
  call g:assert.equals(getline(5),   '',           'failed at #378')
  call g:assert.equals(getline(6),   ']',          'failed at #378')
  call g:assert.equals(getline(7),   '}',          'failed at #378')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #378')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #378')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #378')
  call g:assert.equals(&l:autoindent,  1,          'failed at #378')
  call g:assert.equals(&l:smartindent, 1,          'failed at #378')
  call g:assert.equals(&l:cindent,     0,          'failed at #378')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #378')

  %delete

  " #379
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #379')
  call g:assert.equals(getline(2),   '[',          'failed at #379')
  call g:assert.equals(getline(3),   '',           'failed at #379')
  call g:assert.equals(getline(4),   '    foo',    'failed at #379')
  call g:assert.equals(getline(5),   '',           'failed at #379')
  call g:assert.equals(getline(6),   ']',          'failed at #379')
  call g:assert.equals(getline(7),   '}',          'failed at #379')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #379')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #379')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #379')
  call g:assert.equals(&l:autoindent,  1,          'failed at #379')
  call g:assert.equals(&l:smartindent, 1,          'failed at #379')
  call g:assert.equals(&l:cindent,     1,          'failed at #379')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #379')

  %delete

  " #380
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #380')
  call g:assert.equals(getline(2),   '[',              'failed at #380')
  call g:assert.equals(getline(3),   '',               'failed at #380')
  call g:assert.equals(getline(4),   '    foo',        'failed at #380')
  call g:assert.equals(getline(5),   '',               'failed at #380')
  call g:assert.equals(getline(6),   ']',              'failed at #380')
  call g:assert.equals(getline(7),   '}',              'failed at #380')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #380')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #380')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #380')
  call g:assert.equals(&l:autoindent,  1,              'failed at #380')
  call g:assert.equals(&l:smartindent, 1,              'failed at #380')
  call g:assert.equals(&l:cindent,     1,              'failed at #380')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #380')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #381
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #381')
  call g:assert.equals(getline(2),   '    [',      'failed at #381')
  call g:assert.equals(getline(3),   '',           'failed at #381')
  call g:assert.equals(getline(4),   '    foo',    'failed at #381')
  call g:assert.equals(getline(5),   '',           'failed at #381')
  call g:assert.equals(getline(6),   '    ]',      'failed at #381')
  call g:assert.equals(getline(7),   '    }',      'failed at #381')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #381')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #381')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #381')
  call g:assert.equals(&l:autoindent,  0,          'failed at #381')
  call g:assert.equals(&l:smartindent, 0,          'failed at #381')
  call g:assert.equals(&l:cindent,     0,          'failed at #381')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #381')

  %delete

  " #382
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #382')
  call g:assert.equals(getline(2),   '    [',      'failed at #382')
  call g:assert.equals(getline(3),   '',           'failed at #382')
  call g:assert.equals(getline(4),   '    foo',    'failed at #382')
  call g:assert.equals(getline(5),   '',           'failed at #382')
  call g:assert.equals(getline(6),   '    ]',      'failed at #382')
  call g:assert.equals(getline(7),   '    }',      'failed at #382')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #382')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #382')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #382')
  call g:assert.equals(&l:autoindent,  1,          'failed at #382')
  call g:assert.equals(&l:smartindent, 0,          'failed at #382')
  call g:assert.equals(&l:cindent,     0,          'failed at #382')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #382')

  %delete

  " #383
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #383')
  call g:assert.equals(getline(2),   '    [',      'failed at #383')
  call g:assert.equals(getline(3),   '',           'failed at #383')
  call g:assert.equals(getline(4),   '    foo',    'failed at #383')
  call g:assert.equals(getline(5),   '',           'failed at #383')
  call g:assert.equals(getline(6),   '    ]',      'failed at #383')
  call g:assert.equals(getline(7),   '    }',      'failed at #383')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #383')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #383')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #383')
  call g:assert.equals(&l:autoindent,  1,          'failed at #383')
  call g:assert.equals(&l:smartindent, 1,          'failed at #383')
  call g:assert.equals(&l:cindent,     0,          'failed at #383')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #383')

  %delete

  " #384
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #384')
  call g:assert.equals(getline(2),   '    [',      'failed at #384')
  call g:assert.equals(getline(3),   '',           'failed at #384')
  call g:assert.equals(getline(4),   '    foo',    'failed at #384')
  call g:assert.equals(getline(5),   '',           'failed at #384')
  call g:assert.equals(getline(6),   '    ]',      'failed at #384')
  call g:assert.equals(getline(7),   '    }',      'failed at #384')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #384')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #384')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #384')
  call g:assert.equals(&l:autoindent,  1,          'failed at #384')
  call g:assert.equals(&l:smartindent, 1,          'failed at #384')
  call g:assert.equals(&l:cindent,     1,          'failed at #384')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #384')

  %delete

  " #385
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #385')
  call g:assert.equals(getline(2),   '    [',          'failed at #385')
  call g:assert.equals(getline(3),   '',               'failed at #385')
  call g:assert.equals(getline(4),   '    foo',        'failed at #385')
  call g:assert.equals(getline(5),   '',               'failed at #385')
  call g:assert.equals(getline(6),   '    ]',          'failed at #385')
  call g:assert.equals(getline(7),   '    }',          'failed at #385')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #385')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #385')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #385')
  call g:assert.equals(&l:autoindent,  1,              'failed at #385')
  call g:assert.equals(&l:smartindent, 1,              'failed at #385')
  call g:assert.equals(&l:cindent,     1,              'failed at #385')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #385')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #386
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #386')
  call g:assert.equals(getline(2),   '    [',       'failed at #386')
  call g:assert.equals(getline(3),   '',            'failed at #386')
  call g:assert.equals(getline(4),   '    foo',     'failed at #386')
  call g:assert.equals(getline(5),   '',            'failed at #386')
  call g:assert.equals(getline(6),   '    ]',       'failed at #386')
  call g:assert.equals(getline(7),   '}',           'failed at #386')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #386')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #386')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #386')
  call g:assert.equals(&l:autoindent,  0,           'failed at #386')
  call g:assert.equals(&l:smartindent, 0,           'failed at #386')
  call g:assert.equals(&l:cindent,     0,           'failed at #386')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #386')

  %delete

  " #387
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #387')
  call g:assert.equals(getline(2),   '    [',       'failed at #387')
  call g:assert.equals(getline(3),   '',            'failed at #387')
  call g:assert.equals(getline(4),   '    foo',     'failed at #387')
  call g:assert.equals(getline(5),   '',            'failed at #387')
  call g:assert.equals(getline(6),   '    ]',       'failed at #387')
  call g:assert.equals(getline(7),   '}',           'failed at #387')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #387')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #387')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #387')
  call g:assert.equals(&l:autoindent,  1,           'failed at #387')
  call g:assert.equals(&l:smartindent, 0,           'failed at #387')
  call g:assert.equals(&l:cindent,     0,           'failed at #387')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #387')

  %delete

  " #388
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #388')
  call g:assert.equals(getline(2),   '    [',       'failed at #388')
  call g:assert.equals(getline(3),   '',            'failed at #388')
  call g:assert.equals(getline(4),   '    foo',     'failed at #388')
  call g:assert.equals(getline(5),   '',            'failed at #388')
  call g:assert.equals(getline(6),   '    ]',       'failed at #388')
  call g:assert.equals(getline(7),   '}',           'failed at #388')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #388')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #388')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #388')
  call g:assert.equals(&l:autoindent,  1,           'failed at #388')
  call g:assert.equals(&l:smartindent, 1,           'failed at #388')
  call g:assert.equals(&l:cindent,     0,           'failed at #388')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #388')

  %delete

  " #389
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #389')
  call g:assert.equals(getline(2),   '    [',       'failed at #389')
  call g:assert.equals(getline(3),   '',            'failed at #389')
  call g:assert.equals(getline(4),   '    foo',     'failed at #389')
  call g:assert.equals(getline(5),   '',            'failed at #389')
  call g:assert.equals(getline(6),   '    ]',       'failed at #389')
  call g:assert.equals(getline(7),   '}',           'failed at #389')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #389')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #389')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #389')
  call g:assert.equals(&l:autoindent,  1,           'failed at #389')
  call g:assert.equals(&l:smartindent, 1,           'failed at #389')
  call g:assert.equals(&l:cindent,     1,           'failed at #389')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #389')

  %delete

  " #390
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #390')
  call g:assert.equals(getline(2),   '    [',          'failed at #390')
  call g:assert.equals(getline(3),   '',               'failed at #390')
  call g:assert.equals(getline(4),   '    foo',        'failed at #390')
  call g:assert.equals(getline(5),   '',               'failed at #390')
  call g:assert.equals(getline(6),   '    ]',          'failed at #390')
  call g:assert.equals(getline(7),   '}',              'failed at #390')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #390')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #390')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #390')
  call g:assert.equals(&l:autoindent,  1,              'failed at #390')
  call g:assert.equals(&l:smartindent, 1,              'failed at #390')
  call g:assert.equals(&l:cindent,     1,              'failed at #390')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #390')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #391
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #391')
  call g:assert.equals(getline(2),   '    [',       'failed at #391')
  call g:assert.equals(getline(3),   '',            'failed at #391')
  call g:assert.equals(getline(4),   '    foo',     'failed at #391')
  call g:assert.equals(getline(5),   '',            'failed at #391')
  call g:assert.equals(getline(6),   '    ]',       'failed at #391')
  call g:assert.equals(getline(7),   '    }',       'failed at #391')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #391')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #391')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #391')
  call g:assert.equals(&l:autoindent,  0,           'failed at #391')
  call g:assert.equals(&l:smartindent, 0,           'failed at #391')
  call g:assert.equals(&l:cindent,     0,           'failed at #391')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #391')

  %delete

  " #392
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #392')
  call g:assert.equals(getline(2),   '    [',       'failed at #392')
  call g:assert.equals(getline(3),   '',            'failed at #392')
  call g:assert.equals(getline(4),   '    foo',     'failed at #392')
  call g:assert.equals(getline(5),   '',            'failed at #392')
  call g:assert.equals(getline(6),   '    ]',       'failed at #392')
  call g:assert.equals(getline(7),   '    }',       'failed at #392')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #392')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #392')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #392')
  call g:assert.equals(&l:autoindent,  1,           'failed at #392')
  call g:assert.equals(&l:smartindent, 0,           'failed at #392')
  call g:assert.equals(&l:cindent,     0,           'failed at #392')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #392')

  %delete

  " #393
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #393')
  call g:assert.equals(getline(2),   '    [',       'failed at #393')
  call g:assert.equals(getline(3),   '',            'failed at #393')
  call g:assert.equals(getline(4),   '    foo',     'failed at #393')
  call g:assert.equals(getline(5),   '',            'failed at #393')
  call g:assert.equals(getline(6),   '    ]',       'failed at #393')
  call g:assert.equals(getline(7),   '    }',       'failed at #393')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #393')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #393')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #393')
  call g:assert.equals(&l:autoindent,  1,           'failed at #393')
  call g:assert.equals(&l:smartindent, 1,           'failed at #393')
  call g:assert.equals(&l:cindent,     0,           'failed at #393')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #393')

  %delete

  " #394
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #394')
  call g:assert.equals(getline(2),   '    [',       'failed at #394')
  call g:assert.equals(getline(3),   '',            'failed at #394')
  call g:assert.equals(getline(4),   '    foo',     'failed at #394')
  call g:assert.equals(getline(5),   '',            'failed at #394')
  call g:assert.equals(getline(6),   '    ]',       'failed at #394')
  call g:assert.equals(getline(7),   '    }',       'failed at #394')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #394')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #394')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #394')
  call g:assert.equals(&l:autoindent,  1,           'failed at #394')
  call g:assert.equals(&l:smartindent, 1,           'failed at #394')
  call g:assert.equals(&l:cindent,     1,           'failed at #394')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #394')

  %delete

  " #395
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #395')
  call g:assert.equals(getline(2),   '    [',          'failed at #395')
  call g:assert.equals(getline(3),   '',               'failed at #395')
  call g:assert.equals(getline(4),   '    foo',        'failed at #395')
  call g:assert.equals(getline(5),   '',               'failed at #395')
  call g:assert.equals(getline(6),   '    ]',          'failed at #395')
  call g:assert.equals(getline(7),   '    }',          'failed at #395')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #395')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #395')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #395')
  call g:assert.equals(&l:autoindent,  1,              'failed at #395')
  call g:assert.equals(&l:smartindent, 1,              'failed at #395')
  call g:assert.equals(&l:cindent,     1,              'failed at #395')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #395')
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

  " #396
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #396')
  call g:assert.equals(getline(2),   '',           'failed at #396')
  call g:assert.equals(getline(3),   '    foo',    'failed at #396')
  call g:assert.equals(getline(4),   '',           'failed at #396')
  call g:assert.equals(getline(5),   '    }',      'failed at #396')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #396')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #396')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #396')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #396')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #396')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #397
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #397')
  call g:assert.equals(getline(2),   '',           'failed at #397')
  call g:assert.equals(getline(3),   '    foo',    'failed at #397')
  call g:assert.equals(getline(4),   '',           'failed at #397')
  call g:assert.equals(getline(5),   '    }',      'failed at #397')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #397')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #397')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #397')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #397')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #397')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #398
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #398')
  call g:assert.equals(getline(2),   '',           'failed at #398')
  call g:assert.equals(getline(3),   '    foo',    'failed at #398')
  call g:assert.equals(getline(4),   '',           'failed at #398')
  call g:assert.equals(getline(5),   '    }',      'failed at #398')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #398')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #398')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #398')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #398')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #398')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #399
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #399')
  call g:assert.equals(getline(2),   '',              'failed at #399')
  call g:assert.equals(getline(3),   '    foo',       'failed at #399')
  call g:assert.equals(getline(4),   '',              'failed at #399')
  call g:assert.equals(getline(5),   '    }',         'failed at #399')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #399')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #399')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #399')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #399')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #399')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #400
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',      'failed at #400')
  call g:assert.equals(getline(2),   '',              'failed at #400')
  call g:assert.equals(getline(3),   '    foo',       'failed at #400')
  call g:assert.equals(getline(4),   '',              'failed at #400')
  call g:assert.equals(getline(5),   '            }', 'failed at #400')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #400')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #400')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #400')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #400')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #400')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #401
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #401')
  call g:assert.equals(getline(2),   '',              'failed at #401')
  call g:assert.equals(getline(3),   '    foo',       'failed at #401')
  call g:assert.equals(getline(4),   '',              'failed at #401')
  call g:assert.equals(getline(5),   '    }',         'failed at #401')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #401')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #401')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #401')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #401')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #401')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #402
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #402')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #402')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #402')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #402')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #402')

  %delete

  " #403
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #403')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #403')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #403')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #403')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #403')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #403')

  %delete

  " #404
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #404')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #404')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #404')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #404')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #404')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #404')

  %delete

  " #405
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #405')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #405')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #405')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #405')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #405')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #405')

  %delete

  " #406
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #406')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #406')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #406')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #406')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #406')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #406')

  %delete

  " #407
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #407')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #407')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #407')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #407')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #407')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #407')

  %delete

  " #408
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #408')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #408')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #408')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #408')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #408')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #408')

  %delete

  " #409
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #409')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #409')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #409')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #409')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #409')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #409')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #410
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #410')
  call g:assert.equals(getline(2),   'abara',      'failed at #410')
  call g:assert.equals(getline(3),   'abaza',      'failed at #410')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #410')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #410')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #410')

  %delete

  " #411
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #411')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #411')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #411')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #411')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #411')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #411')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #412
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #412')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #412')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #412')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #412')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #412')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #412')

  %delete

  " #413
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #413')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #413')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #413')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #413')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #413')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #413')

  %delete

  " #414
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #414')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #414')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #414')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #414')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #414')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #414')

  %delete

  " #415
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #415')
  call g:assert.equals(getline(2),   '',           'failed at #415')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #415')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #415')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #415')

  %delete

  " #416
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #416')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #416')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #416')

  %delete

  " #417
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #417')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #417')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #417')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #417')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #417')

  %delete

  " #418
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #418')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #418')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #418')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #419
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #419')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #419')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #419')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #419')

  %delete

  " #420
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #420')
  call g:assert.equals(getline(2),   '(a)',        'failed at #420')
  call g:assert.equals(getline(3),   '(a)',        'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #420')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #421
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #421')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #421')
  call g:assert.equals(getline(3),   'aa',         'failed at #421')
  call g:assert.equals(getline(4),   'aa',         'failed at #421')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #421')
  call g:assert.equals(getline(6),   'aa',         'failed at #421')
  call g:assert.equals(getline(7),   'aa',         'failed at #421')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #421')
  call g:assert.equals(getline(9),   'aa',         'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #421')

  %delete

  " #422
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #422')
  call g:assert.equals(getline(2),   'bbb',         'failed at #422')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #422')
  call g:assert.equals(getline(4),   'bbb',         'failed at #422')
  call g:assert.equals(getline(5),   'bb',          'failed at #422')
  call g:assert.equals(getline(6),   'bb',          'failed at #422')
  call g:assert.equals(getline(7),   'bbb',         'failed at #422')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #422')
  call g:assert.equals(getline(9),   'bbb',         'failed at #422')
  call g:assert.equals(getline(10),  'bb',          'failed at #422')
  call g:assert.equals(getline(11),  'bb',          'failed at #422')
  call g:assert.equals(getline(12),  'bbb',         'failed at #422')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #422')
  call g:assert.equals(getline(14),  'bbb',         'failed at #422')
  call g:assert.equals(getline(15),  'bb',          'failed at #422')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #422')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #423
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #423')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #423')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #423')

  %delete

  " #424
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #424')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #424')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #424')

  %delete

  " #425
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #425')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #425')

  %delete

  " #426
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #426')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #426')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #426')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #426')

  %delete

  " #427
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #427')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #427')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #427')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #427')
  %delete

  " #428
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #428')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #428')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #428')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #428')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #428')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #428')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #429
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #429')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #429')

  " #430
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #430')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #430')

  """ keep
  " #431
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #431')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #431')

  " #432
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #432')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #432')

  """ inner_tail
  " #433
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #433')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #433')

  " #434
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #434')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #434')

  """ head
  " #435
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #435')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #435')

  " #436
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #436')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #436')

  """ tail
  " #437
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #437')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #437')

  " #438
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #438')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #438')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #439
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #439')

  %delete

  """ on
  " #440
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #440')

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
  " #441
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #441')

  """ 1
  " #442
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #442')

  %delete

  " #443
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1), 'foo', 'failed at #443')
  call g:assert.equals(getline(2), 'bar', 'failed at #443')
  call g:assert.equals(getline(3), 'baz', 'failed at #443')
  call g:assert.equals(exists(s:object), 0, 'failed at #443')

  %delete

  " #444
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lc"
  call g:assert.equals(getline(1), 'foo', 'failed at #444')
  call g:assert.equals(getline(2), 'bar', 'failed at #444')
  call g:assert.equals(getline(3), 'baz', 'failed at #444')
  call g:assert.equals(exists(s:object), 0, 'failed at #444')

  %delete

  " #445
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #445')
  call g:assert.equals(getline(2), '2bar3', 'failed at #445')
  call g:assert.equals(getline(3), '2baz3', 'failed at #445')
  call g:assert.equals(exists(s:object), 0, 'failed at #445')

  %delete

  " #446
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #446')
  call g:assert.equals(getline(2), '2bar3', 'failed at #446')
  call g:assert.equals(getline(3), '2baz3', 'failed at #446')
  call g:assert.equals(exists(s:object), 0, 'failed at #446')

  %delete

  " #447
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lba"
  call g:assert.equals(getline(1), 'foo', 'failed at #447')
  call g:assert.equals(getline(2), 'bar', 'failed at #447')
  call g:assert.equals(getline(3), 'baz', 'failed at #447')
  call g:assert.equals(exists(s:object), 0, 'failed at #447')

  %delete

  " #448
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lca"
  call g:assert.equals(getline(1), 'foo', 'failed at #448')
  call g:assert.equals(getline(2), 'bar', 'failed at #448')
  call g:assert.equals(getline(3), 'baz', 'failed at #448')
  call g:assert.equals(exists(s:object), 0, 'failed at #448')

  %delete

  " #449
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11ld"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #449')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #449')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #449')

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
  " #450
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #450')

  """ off
  " #451
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #451')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #452
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #452')

  """ off
  " #453
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #453')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #454
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ffsa\<C-v>iw("
  call g:assert.equals(getline('.'), '""',  'failed at #454')
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #455
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #455')
  call g:assert.equals(getline(2), 'foo', 'failed at #455')
  call g:assert.equals(getline(3), ')',   'failed at #455')

  %delete

  " #456
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #456')
  call g:assert.equals(getline(2),   '    foo',    'failed at #456')
  call g:assert.equals(getline(3),   '    )',      'failed at #456')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #456')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #456')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #456')

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

  " #457
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #457')
  call g:assert.equals(getline(2),   '[',          'failed at #457')
  call g:assert.equals(getline(3),   'foo',        'failed at #457')
  call g:assert.equals(getline(4),   ']',          'failed at #457')
  call g:assert.equals(getline(5),   '}',          'failed at #457')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #457')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #457')
  call g:assert.equals(&l:autoindent,  0,          'failed at #457')
  call g:assert.equals(&l:smartindent, 0,          'failed at #457')
  call g:assert.equals(&l:cindent,     0,          'failed at #457')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #457')

  %delete

  " #458
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #458')
  call g:assert.equals(getline(2),   '    [',      'failed at #458')
  call g:assert.equals(getline(3),   '    foo',    'failed at #458')
  call g:assert.equals(getline(4),   '    ]',      'failed at #458')
  call g:assert.equals(getline(5),   '    }',      'failed at #458')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #458')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #458')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #458')
  call g:assert.equals(&l:autoindent,  1,          'failed at #458')
  call g:assert.equals(&l:smartindent, 0,          'failed at #458')
  call g:assert.equals(&l:cindent,     0,          'failed at #458')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #458')

  %delete

  " #459
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #459')
  call g:assert.equals(getline(2),   '        [',   'failed at #459')
  call g:assert.equals(getline(3),   '        foo', 'failed at #459')
  call g:assert.equals(getline(4),   '    ]',       'failed at #459')
  call g:assert.equals(getline(5),   '}',           'failed at #459')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #459')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #459')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #459')
  call g:assert.equals(&l:autoindent,  1,           'failed at #459')
  call g:assert.equals(&l:smartindent, 1,           'failed at #459')
  call g:assert.equals(&l:cindent,     0,           'failed at #459')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #459')

  %delete

  " #460
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #460')
  call g:assert.equals(getline(2),   '    [',       'failed at #460')
  call g:assert.equals(getline(3),   '        foo', 'failed at #460')
  call g:assert.equals(getline(4),   '    ]',       'failed at #460')
  call g:assert.equals(getline(5),   '    }',       'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #460')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #460')
  call g:assert.equals(&l:autoindent,  1,           'failed at #460')
  call g:assert.equals(&l:smartindent, 1,           'failed at #460')
  call g:assert.equals(&l:cindent,     1,           'failed at #460')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #460')

  %delete

  " #461
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',           'failed at #461')
  call g:assert.equals(getline(2),   '            [',       'failed at #461')
  call g:assert.equals(getline(3),   '                foo', 'failed at #461')
  call g:assert.equals(getline(4),   '        ]',           'failed at #461')
  call g:assert.equals(getline(5),   '                }',   'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #461')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #461')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #461')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #461')
  call g:assert.equals(&l:cindent,     1,                   'failed at #461')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #461')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #462
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #462')
  call g:assert.equals(getline(2),   '[',          'failed at #462')
  call g:assert.equals(getline(3),   'foo',        'failed at #462')
  call g:assert.equals(getline(4),   ']',          'failed at #462')
  call g:assert.equals(getline(5),   '}',          'failed at #462')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #462')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #462')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #463')
  call g:assert.equals(getline(2),   '[',          'failed at #463')
  call g:assert.equals(getline(3),   'foo',        'failed at #463')
  call g:assert.equals(getline(4),   ']',          'failed at #463')
  call g:assert.equals(getline(5),   '}',          'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #463')
  call g:assert.equals(&l:autoindent,  1,          'failed at #463')
  call g:assert.equals(&l:smartindent, 0,          'failed at #463')
  call g:assert.equals(&l:cindent,     0,          'failed at #463')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #463')

  %delete

  " #464
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #464')
  call g:assert.equals(getline(2),   '[',          'failed at #464')
  call g:assert.equals(getline(3),   'foo',        'failed at #464')
  call g:assert.equals(getline(4),   ']',          'failed at #464')
  call g:assert.equals(getline(5),   '}',          'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #464')
  call g:assert.equals(&l:autoindent,  1,          'failed at #464')
  call g:assert.equals(&l:smartindent, 1,          'failed at #464')
  call g:assert.equals(&l:cindent,     0,          'failed at #464')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #464')

  %delete

  " #465
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #465')
  call g:assert.equals(getline(2),   '[',          'failed at #465')
  call g:assert.equals(getline(3),   'foo',        'failed at #465')
  call g:assert.equals(getline(4),   ']',          'failed at #465')
  call g:assert.equals(getline(5),   '}',          'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #465')
  call g:assert.equals(&l:autoindent,  1,          'failed at #465')
  call g:assert.equals(&l:smartindent, 1,          'failed at #465')
  call g:assert.equals(&l:cindent,     1,          'failed at #465')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #465')

  %delete

  " #466
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #466')
  call g:assert.equals(getline(2),   '[',              'failed at #466')
  call g:assert.equals(getline(3),   'foo',            'failed at #466')
  call g:assert.equals(getline(4),   ']',              'failed at #466')
  call g:assert.equals(getline(5),   '}',              'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #466')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #466')
  call g:assert.equals(&l:autoindent,  1,              'failed at #466')
  call g:assert.equals(&l:smartindent, 1,              'failed at #466')
  call g:assert.equals(&l:cindent,     1,              'failed at #466')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #466')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #467
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #467')
  call g:assert.equals(getline(2),   '    [',      'failed at #467')
  call g:assert.equals(getline(3),   '    foo',    'failed at #467')
  call g:assert.equals(getline(4),   '    ]',      'failed at #467')
  call g:assert.equals(getline(5),   '    }',      'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #467')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #467')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #468')
  call g:assert.equals(getline(2),   '    [',      'failed at #468')
  call g:assert.equals(getline(3),   '    foo',    'failed at #468')
  call g:assert.equals(getline(4),   '    ]',      'failed at #468')
  call g:assert.equals(getline(5),   '    }',      'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #468')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #468')
  call g:assert.equals(&l:autoindent,  1,          'failed at #468')
  call g:assert.equals(&l:smartindent, 0,          'failed at #468')
  call g:assert.equals(&l:cindent,     0,          'failed at #468')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #468')

  %delete

  " #469
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #469')
  call g:assert.equals(getline(2),   '    [',      'failed at #469')
  call g:assert.equals(getline(3),   '    foo',    'failed at #469')
  call g:assert.equals(getline(4),   '    ]',      'failed at #469')
  call g:assert.equals(getline(5),   '    }',      'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #469')
  call g:assert.equals(&l:autoindent,  1,          'failed at #469')
  call g:assert.equals(&l:smartindent, 1,          'failed at #469')
  call g:assert.equals(&l:cindent,     0,          'failed at #469')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #469')

  %delete

  " #470
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #470')
  call g:assert.equals(getline(2),   '    [',      'failed at #470')
  call g:assert.equals(getline(3),   '    foo',    'failed at #470')
  call g:assert.equals(getline(4),   '    ]',      'failed at #470')
  call g:assert.equals(getline(5),   '    }',      'failed at #470')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #470')
  call g:assert.equals(&l:autoindent,  1,          'failed at #470')
  call g:assert.equals(&l:smartindent, 1,          'failed at #470')
  call g:assert.equals(&l:cindent,     1,          'failed at #470')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #470')

  %delete

  " #471
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #471')
  call g:assert.equals(getline(2),   '    [',          'failed at #471')
  call g:assert.equals(getline(3),   '    foo',        'failed at #471')
  call g:assert.equals(getline(4),   '    ]',          'failed at #471')
  call g:assert.equals(getline(5),   '    }',          'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #471')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #471')
  call g:assert.equals(&l:autoindent,  1,              'failed at #471')
  call g:assert.equals(&l:smartindent, 1,              'failed at #471')
  call g:assert.equals(&l:cindent,     1,              'failed at #471')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #471')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #472
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #472')
  call g:assert.equals(getline(2),   '        [',   'failed at #472')
  call g:assert.equals(getline(3),   '        foo', 'failed at #472')
  call g:assert.equals(getline(4),   '    ]',       'failed at #472')
  call g:assert.equals(getline(5),   '}',           'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #472')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #472')
  call g:assert.equals(&l:autoindent,  0,           'failed at #472')
  call g:assert.equals(&l:smartindent, 0,           'failed at #472')
  call g:assert.equals(&l:cindent,     0,           'failed at #472')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #472')

  %delete

  " #473
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #473')
  call g:assert.equals(getline(2),   '        [',   'failed at #473')
  call g:assert.equals(getline(3),   '        foo', 'failed at #473')
  call g:assert.equals(getline(4),   '    ]',       'failed at #473')
  call g:assert.equals(getline(5),   '}',           'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #473')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #473')
  call g:assert.equals(&l:autoindent,  1,           'failed at #473')
  call g:assert.equals(&l:smartindent, 0,           'failed at #473')
  call g:assert.equals(&l:cindent,     0,           'failed at #473')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #473')

  %delete

  " #474
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #474')
  call g:assert.equals(getline(2),   '        [',   'failed at #474')
  call g:assert.equals(getline(3),   '        foo', 'failed at #474')
  call g:assert.equals(getline(4),   '    ]',       'failed at #474')
  call g:assert.equals(getline(5),   '}',           'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #474')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #474')
  call g:assert.equals(&l:autoindent,  1,           'failed at #474')
  call g:assert.equals(&l:smartindent, 1,           'failed at #474')
  call g:assert.equals(&l:cindent,     0,           'failed at #474')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #474')

  %delete

  " #475
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #475')
  call g:assert.equals(getline(2),   '        [',   'failed at #475')
  call g:assert.equals(getline(3),   '        foo', 'failed at #475')
  call g:assert.equals(getline(4),   '    ]',       'failed at #475')
  call g:assert.equals(getline(5),   '}',           'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #475')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #475')
  call g:assert.equals(&l:autoindent,  1,           'failed at #475')
  call g:assert.equals(&l:smartindent, 1,           'failed at #475')
  call g:assert.equals(&l:cindent,     1,           'failed at #475')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #475')

  %delete

  " #476
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #476')
  call g:assert.equals(getline(2),   '        [',      'failed at #476')
  call g:assert.equals(getline(3),   '        foo',    'failed at #476')
  call g:assert.equals(getline(4),   '    ]',          'failed at #476')
  call g:assert.equals(getline(5),   '}',              'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #476')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #476')
  call g:assert.equals(&l:autoindent,  1,              'failed at #476')
  call g:assert.equals(&l:smartindent, 1,              'failed at #476')
  call g:assert.equals(&l:cindent,     1,              'failed at #476')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #476')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #477
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #477')
  call g:assert.equals(getline(2),   '    [',       'failed at #477')
  call g:assert.equals(getline(3),   '        foo', 'failed at #477')
  call g:assert.equals(getline(4),   '    ]',       'failed at #477')
  call g:assert.equals(getline(5),   '    }',       'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #477')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #477')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #478')
  call g:assert.equals(getline(2),   '    [',       'failed at #478')
  call g:assert.equals(getline(3),   '        foo', 'failed at #478')
  call g:assert.equals(getline(4),   '    ]',       'failed at #478')
  call g:assert.equals(getline(5),   '    }',       'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #478')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #478')
  call g:assert.equals(&l:autoindent,  1,           'failed at #478')
  call g:assert.equals(&l:smartindent, 0,           'failed at #478')
  call g:assert.equals(&l:cindent,     0,           'failed at #478')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #478')

  %delete

  " #479
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #479')
  call g:assert.equals(getline(2),   '    [',       'failed at #479')
  call g:assert.equals(getline(3),   '        foo', 'failed at #479')
  call g:assert.equals(getline(4),   '    ]',       'failed at #479')
  call g:assert.equals(getline(5),   '    }',       'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #479')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #479')
  call g:assert.equals(&l:autoindent,  1,           'failed at #479')
  call g:assert.equals(&l:smartindent, 1,           'failed at #479')
  call g:assert.equals(&l:cindent,     0,           'failed at #479')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #479')

  %delete

  " #480
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #480')
  call g:assert.equals(getline(2),   '    [',       'failed at #480')
  call g:assert.equals(getline(3),   '        foo', 'failed at #480')
  call g:assert.equals(getline(4),   '    ]',       'failed at #480')
  call g:assert.equals(getline(5),   '    }',       'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #480')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #480')
  call g:assert.equals(&l:autoindent,  1,           'failed at #480')
  call g:assert.equals(&l:smartindent, 1,           'failed at #480')
  call g:assert.equals(&l:cindent,     1,           'failed at #480')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #480')

  %delete

  " #481
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',              'failed at #481')
  call g:assert.equals(getline(2),   '    [',          'failed at #481')
  call g:assert.equals(getline(3),   '        foo',    'failed at #481')
  call g:assert.equals(getline(4),   '    ]',          'failed at #481')
  call g:assert.equals(getline(5),   '    }',          'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #481')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #481')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #481')
  call g:assert.equals(&l:autoindent,  1,              'failed at #481')
  call g:assert.equals(&l:smartindent, 1,              'failed at #481')
  call g:assert.equals(&l:cindent,     1,              'failed at #481')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #481')
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

  " #482
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #482')
  call g:assert.equals(getline(2),   'foo',        'failed at #482')
  call g:assert.equals(getline(3),   '    }',      'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #482')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #482')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #482')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #483
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #483')
  call g:assert.equals(getline(2),   '    foo',    'failed at #483')
  call g:assert.equals(getline(3),   '    }',      'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #483')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #483')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #483')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #484
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #484')
  call g:assert.equals(getline(2),   'foo',        'failed at #484')
  call g:assert.equals(getline(3),   '    }',      'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #484')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #484')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #484')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #485
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #485')
  call g:assert.equals(getline(2),   'foo',        'failed at #485')
  call g:assert.equals(getline(3),   '    }',      'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #485')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #485')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #485')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #486
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',     'failed at #486')
  call g:assert.equals(getline(2),   '    foo',       'failed at #486')
  call g:assert.equals(getline(3),   '            }', 'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #486')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #486')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #486')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #486')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #487
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #487')
  call g:assert.equals(getline(2),   'foo',        'failed at #487')
  call g:assert.equals(getline(3),   '    }',      'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #487')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #487')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #487')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #487')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #457
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #457')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #457')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #457')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #457')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #457')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #457')

  " #458
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #458')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #458')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #458')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #458')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #458')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #458')

  " #459
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #459')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #459')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #459')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #459')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #459')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #459')

  " #460
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #460')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #460')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #460')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #460')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #460')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #460')

  " #461
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #461')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #461')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #461')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #461')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #461')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #461')

  " #462
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #462')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #462')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #462')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #462')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #462')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #462')

  " #463
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #463')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #463')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #463')

  " #464
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #464')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #464')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #464')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #465
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #465')
  call g:assert.equals(getline(2),   'abara',      'failed at #465')
  call g:assert.equals(getline(3),   'abaza',      'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #465')

  %delete

  " #466
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #466')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #466')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #466')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #466')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #467
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #467')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #467')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #467')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #467')

  %delete

  " #468
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #468')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #468')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #468')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #468')

  %delete

  " #469
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #469')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #469')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #469')

  %delete

  " #470
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #470')
  call g:assert.equals(getline(2),   '',           'failed at #470')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #470')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #470')

  %delete

  " #471
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #471')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #471')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #471')

  %delete

  " #472
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #472')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #472')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #472')

  %delete

  " #473
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #473')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #473')
  call g:assert.equals(getline(3),   '(ba)',       'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #473')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #473')

  %delete

  " #474
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #474')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #474')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #474')

  %delete

  """ terminal-extended block-wise visual mode
  " #475
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #475')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #475')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #475')

  %delete

  " #476
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #476')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #476')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #476')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #476')

  %delete

  " #477
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #477')
  call g:assert.equals(getline(2),   '',           'failed at #477')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #477')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #477')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #478
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #478')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #478')

  %delete

  " #479
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #479')
  call g:assert.equals(getline(2),   '(a)',        'failed at #479')
  call g:assert.equals(getline(3),   '(a)',        'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #479')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  " #480
  call append(0, ['', 'foo'])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '',           'failed at #480')
  call g:assert.equals(getline(2),   '(foo)',      'failed at #480')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #480')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #480')
  " call g:assert.equals(getpos("']"), [0, 2, 5, 0], 'failed at #480')

  %delete

  " #481
  call append(0, ['foo', ''])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #481')
  call g:assert.equals(getline(2),   '',           'failed at #481')
  " call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #481')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #481')
  " call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #481')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #482
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #482')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #482')
  call g:assert.equals(getline(3),   'aa',         'failed at #482')
  call g:assert.equals(getline(4),   'aa',         'failed at #482')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #482')
  call g:assert.equals(getline(6),   'aa',         'failed at #482')
  call g:assert.equals(getline(7),   'aa',         'failed at #482')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #482')
  call g:assert.equals(getline(9),   'aa',         'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #482')

  %delete

  " #483
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #483')
  call g:assert.equals(getline(2),   'bbb',         'failed at #483')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #483')
  call g:assert.equals(getline(4),   'bbb',         'failed at #483')
  call g:assert.equals(getline(5),   'bb',          'failed at #483')
  call g:assert.equals(getline(6),   'bb',          'failed at #483')
  call g:assert.equals(getline(7),   'bbb',         'failed at #483')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #483')
  call g:assert.equals(getline(9),   'bbb',         'failed at #483')
  call g:assert.equals(getline(10),  'bb',          'failed at #483')
  call g:assert.equals(getline(11),  'bb',          'failed at #483')
  call g:assert.equals(getline(12),  'bbb',         'failed at #483')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #483')
  call g:assert.equals(getline(14),  'bbb',         'failed at #483')
  call g:assert.equals(getline(15),  'bb',          'failed at #483')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #483')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #484
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #484')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #484')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #484')

  %delete

  " #485
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #485')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #485')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #485')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #486
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #486')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #486')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #486')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #486')

  " #487
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #487')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #487')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #487')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #487')

  %delete

  """ keep
  " #488
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #488')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #488')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #488')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #488')

  " #489
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #489')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #489')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #489')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #489')

  %delete

  """ inner_tail
  " #490
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #490')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #490')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #490')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #490')

  " #491
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #491')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #491')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #491')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #491')

  %delete

  """ head
  " #492
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #492')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #492')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #492')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #492')

  " #493
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #493')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #493')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #493')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #493')

  %delete

  """ tail
  " #494
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #494')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #494')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #494')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #494')

  " #495
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #495')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #495')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #495')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #495')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #496
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #496')

  %delete

  """ on
  " #497
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #497')

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
  " #498
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #498')

  """ 1
  " #499
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #499')

  %delete

  " #500
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1), 'foo', 'failed at #500')
  call g:assert.equals(getline(2), 'bar', 'failed at #500')
  call g:assert.equals(getline(3), 'baz', 'failed at #500')
  call g:assert.equals(exists(s:object), 0, 'failed at #500')

  %delete

  " #501
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsac"
  call g:assert.equals(getline(1), 'foo', 'failed at #501')
  call g:assert.equals(getline(2), 'bar', 'failed at #501')
  call g:assert.equals(getline(3), 'baz', 'failed at #501')
  call g:assert.equals(exists(s:object), 0, 'failed at #501')

  %delete

  " #502
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #502')
  call g:assert.equals(getline(2), '2bar3', 'failed at #502')
  call g:assert.equals(getline(3), '2baz3', 'failed at #502')
  call g:assert.equals(exists(s:object), 0, 'failed at #502')

  %delete

  " #503
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #503')
  call g:assert.equals(getline(2), '2bar3', 'failed at #503')
  call g:assert.equals(getline(3), '2baz3', 'failed at #503')
  call g:assert.equals(exists(s:object), 0, 'failed at #503')

  %delete

  " #504
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saba"
  call g:assert.equals(getline(1), 'foo', 'failed at #504')
  call g:assert.equals(getline(2), 'bar', 'failed at #504')
  call g:assert.equals(getline(3), 'baz', 'failed at #504')
  call g:assert.equals(exists(s:object), 0, 'failed at #504')

  %delete

  " #505
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saca"
  call g:assert.equals(getline(1), 'foo', 'failed at #505')
  call g:assert.equals(getline(2), 'bar', 'failed at #505')
  call g:assert.equals(getline(3), 'baz', 'failed at #505')
  call g:assert.equals(exists(s:object), 0, 'failed at #505')

  %delete

  " #506
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsad"
  call g:assert.equals(getline(1), 'headfootail', 'failed at #506')
  call g:assert.equals(getline(2), 'headbartail', 'failed at #506')
  call g:assert.equals(getline(3), 'headbaztail', 'failed at #506')

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
  " #507
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #507')

  """ off
  " #508
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #508')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #509
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #509')

  """ off
  " #510
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #510')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #511
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ff\<C-v>iwsa("
  call g:assert.equals(getline('.'), '""',  'failed at #511')
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #512
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #512')
  call g:assert.equals(getline(2), 'foo', 'failed at #512')
  call g:assert.equals(getline(3), ')',   'failed at #512')

  %delete

  " #513
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #513')
  call g:assert.equals(getline(2),   '    foo',    'failed at #513')
  call g:assert.equals(getline(3),   '    )',      'failed at #513')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #513')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #513')

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

  " #514
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #514')
  call g:assert.equals(getline(2),   '[',          'failed at #514')
  call g:assert.equals(getline(3),   'foo',        'failed at #514')
  call g:assert.equals(getline(4),   ']',          'failed at #514')
  call g:assert.equals(getline(5),   '}',          'failed at #514')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #514')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #514')
  call g:assert.equals(&l:autoindent,  0,          'failed at #514')
  call g:assert.equals(&l:smartindent, 0,          'failed at #514')
  call g:assert.equals(&l:cindent,     0,          'failed at #514')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #514')

  %delete

  " #515
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #515')
  call g:assert.equals(getline(2),   '    [',      'failed at #515')
  call g:assert.equals(getline(3),   '    foo',    'failed at #515')
  call g:assert.equals(getline(4),   '    ]',      'failed at #515')
  call g:assert.equals(getline(5),   '    }',      'failed at #515')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #515')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #515')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #515')
  call g:assert.equals(&l:autoindent,  1,          'failed at #515')
  call g:assert.equals(&l:smartindent, 0,          'failed at #515')
  call g:assert.equals(&l:cindent,     0,          'failed at #515')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #515')

  %delete

  " #516
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #516')
  call g:assert.equals(getline(2),   '        [',   'failed at #516')
  call g:assert.equals(getline(3),   '        foo', 'failed at #516')
  call g:assert.equals(getline(4),   '    ]',       'failed at #516')
  call g:assert.equals(getline(5),   '}',           'failed at #516')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #516')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #516')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #516')
  call g:assert.equals(&l:autoindent,  1,           'failed at #516')
  call g:assert.equals(&l:smartindent, 1,           'failed at #516')
  call g:assert.equals(&l:cindent,     0,           'failed at #516')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #516')

  %delete

  " #517
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #517')
  call g:assert.equals(getline(2),   '    [',       'failed at #517')
  call g:assert.equals(getline(3),   '        foo', 'failed at #517')
  call g:assert.equals(getline(4),   '    ]',       'failed at #517')
  call g:assert.equals(getline(5),   '    }',       'failed at #517')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #517')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #517')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #517')
  call g:assert.equals(&l:autoindent,  1,           'failed at #517')
  call g:assert.equals(&l:smartindent, 1,           'failed at #517')
  call g:assert.equals(&l:cindent,     1,           'failed at #517')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #517')

  %delete

  " #518
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',           'failed at #518')
  call g:assert.equals(getline(2),   '            [',       'failed at #518')
  call g:assert.equals(getline(3),   '                foo', 'failed at #518')
  call g:assert.equals(getline(4),   '        ]',           'failed at #518')
  call g:assert.equals(getline(5),   '                }',   'failed at #518')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #518')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #518')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #518')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #518')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #518')
  call g:assert.equals(&l:cindent,     1,                   'failed at #518')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #518')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #519
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #519')
  call g:assert.equals(getline(2),   '[',          'failed at #519')
  call g:assert.equals(getline(3),   'foo',        'failed at #519')
  call g:assert.equals(getline(4),   ']',          'failed at #519')
  call g:assert.equals(getline(5),   '}',          'failed at #519')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #519')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #519')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #519')
  call g:assert.equals(&l:autoindent,  0,          'failed at #519')
  call g:assert.equals(&l:smartindent, 0,          'failed at #519')
  call g:assert.equals(&l:cindent,     0,          'failed at #519')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #519')

  %delete

  " #520
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #520')
  call g:assert.equals(getline(2),   '[',          'failed at #520')
  call g:assert.equals(getline(3),   'foo',        'failed at #520')
  call g:assert.equals(getline(4),   ']',          'failed at #520')
  call g:assert.equals(getline(5),   '}',          'failed at #520')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #520')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #520')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #520')
  call g:assert.equals(&l:autoindent,  1,          'failed at #520')
  call g:assert.equals(&l:smartindent, 0,          'failed at #520')
  call g:assert.equals(&l:cindent,     0,          'failed at #520')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #520')

  %delete

  " #521
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #521')
  call g:assert.equals(getline(2),   '[',          'failed at #521')
  call g:assert.equals(getline(3),   'foo',        'failed at #521')
  call g:assert.equals(getline(4),   ']',          'failed at #521')
  call g:assert.equals(getline(5),   '}',          'failed at #521')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #521')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #521')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #521')
  call g:assert.equals(&l:autoindent,  1,          'failed at #521')
  call g:assert.equals(&l:smartindent, 1,          'failed at #521')
  call g:assert.equals(&l:cindent,     0,          'failed at #521')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #521')

  %delete

  " #522
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #522')
  call g:assert.equals(getline(2),   '[',          'failed at #522')
  call g:assert.equals(getline(3),   'foo',        'failed at #522')
  call g:assert.equals(getline(4),   ']',          'failed at #522')
  call g:assert.equals(getline(5),   '}',          'failed at #522')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #522')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #522')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #522')
  call g:assert.equals(&l:autoindent,  1,          'failed at #522')
  call g:assert.equals(&l:smartindent, 1,          'failed at #522')
  call g:assert.equals(&l:cindent,     1,          'failed at #522')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #522')

  %delete

  " #523
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #523')
  call g:assert.equals(getline(2),   '[',              'failed at #523')
  call g:assert.equals(getline(3),   'foo',            'failed at #523')
  call g:assert.equals(getline(4),   ']',              'failed at #523')
  call g:assert.equals(getline(5),   '}',              'failed at #523')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #523')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #523')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #523')
  call g:assert.equals(&l:autoindent,  1,              'failed at #523')
  call g:assert.equals(&l:smartindent, 1,              'failed at #523')
  call g:assert.equals(&l:cindent,     1,              'failed at #523')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #523')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #524
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #524')
  call g:assert.equals(getline(2),   '    [',      'failed at #524')
  call g:assert.equals(getline(3),   '    foo',    'failed at #524')
  call g:assert.equals(getline(4),   '    ]',      'failed at #524')
  call g:assert.equals(getline(5),   '    }',      'failed at #524')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #524')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #524')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #524')
  call g:assert.equals(&l:autoindent,  0,          'failed at #524')
  call g:assert.equals(&l:smartindent, 0,          'failed at #524')
  call g:assert.equals(&l:cindent,     0,          'failed at #524')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #524')

  %delete

  " #525
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #525')
  call g:assert.equals(getline(2),   '    [',      'failed at #525')
  call g:assert.equals(getline(3),   '    foo',    'failed at #525')
  call g:assert.equals(getline(4),   '    ]',      'failed at #525')
  call g:assert.equals(getline(5),   '    }',      'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #525')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #525')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #525')
  call g:assert.equals(&l:autoindent,  1,          'failed at #525')
  call g:assert.equals(&l:smartindent, 0,          'failed at #525')
  call g:assert.equals(&l:cindent,     0,          'failed at #525')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #525')

  %delete

  " #526
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #526')
  call g:assert.equals(getline(2),   '    [',      'failed at #526')
  call g:assert.equals(getline(3),   '    foo',    'failed at #526')
  call g:assert.equals(getline(4),   '    ]',      'failed at #526')
  call g:assert.equals(getline(5),   '    }',      'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #526')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #526')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #526')
  call g:assert.equals(&l:autoindent,  1,          'failed at #526')
  call g:assert.equals(&l:smartindent, 1,          'failed at #526')
  call g:assert.equals(&l:cindent,     0,          'failed at #526')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #526')

  %delete

  " #527
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #527')
  call g:assert.equals(getline(2),   '    [',      'failed at #527')
  call g:assert.equals(getline(3),   '    foo',    'failed at #527')
  call g:assert.equals(getline(4),   '    ]',      'failed at #527')
  call g:assert.equals(getline(5),   '    }',      'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #527')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #527')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #527')
  call g:assert.equals(&l:autoindent,  1,          'failed at #527')
  call g:assert.equals(&l:smartindent, 1,          'failed at #527')
  call g:assert.equals(&l:cindent,     1,          'failed at #527')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #527')

  %delete

  " #528
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #528')
  call g:assert.equals(getline(2),   '    [',          'failed at #528')
  call g:assert.equals(getline(3),   '    foo',        'failed at #528')
  call g:assert.equals(getline(4),   '    ]',          'failed at #528')
  call g:assert.equals(getline(5),   '    }',          'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #528')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #528')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #528')
  call g:assert.equals(&l:autoindent,  1,              'failed at #528')
  call g:assert.equals(&l:smartindent, 1,              'failed at #528')
  call g:assert.equals(&l:cindent,     1,              'failed at #528')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #528')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #529
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #529')
  call g:assert.equals(getline(2),   '        [',   'failed at #529')
  call g:assert.equals(getline(3),   '        foo', 'failed at #529')
  call g:assert.equals(getline(4),   '    ]',       'failed at #529')
  call g:assert.equals(getline(5),   '}',           'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #529')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #529')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #529')
  call g:assert.equals(&l:autoindent,  0,           'failed at #529')
  call g:assert.equals(&l:smartindent, 0,           'failed at #529')
  call g:assert.equals(&l:cindent,     0,           'failed at #529')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #529')

  %delete

  " #530
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #530')
  call g:assert.equals(getline(2),   '        [',   'failed at #530')
  call g:assert.equals(getline(3),   '        foo', 'failed at #530')
  call g:assert.equals(getline(4),   '    ]',       'failed at #530')
  call g:assert.equals(getline(5),   '}',           'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #530')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #530')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #530')
  call g:assert.equals(&l:autoindent,  1,           'failed at #530')
  call g:assert.equals(&l:smartindent, 0,           'failed at #530')
  call g:assert.equals(&l:cindent,     0,           'failed at #530')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #530')

  %delete

  " #531
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #531')
  call g:assert.equals(getline(2),   '        [',   'failed at #531')
  call g:assert.equals(getline(3),   '        foo', 'failed at #531')
  call g:assert.equals(getline(4),   '    ]',       'failed at #531')
  call g:assert.equals(getline(5),   '}',           'failed at #531')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #531')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #531')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #531')
  call g:assert.equals(&l:autoindent,  1,           'failed at #531')
  call g:assert.equals(&l:smartindent, 1,           'failed at #531')
  call g:assert.equals(&l:cindent,     0,           'failed at #531')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #531')

  %delete

  " #532
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #532')
  call g:assert.equals(getline(2),   '        [',   'failed at #532')
  call g:assert.equals(getline(3),   '        foo', 'failed at #532')
  call g:assert.equals(getline(4),   '    ]',       'failed at #532')
  call g:assert.equals(getline(5),   '}',           'failed at #532')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #532')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #532')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #532')
  call g:assert.equals(&l:autoindent,  1,           'failed at #532')
  call g:assert.equals(&l:smartindent, 1,           'failed at #532')
  call g:assert.equals(&l:cindent,     1,           'failed at #532')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #532')

  %delete

  " #533
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #533')
  call g:assert.equals(getline(2),   '        [',      'failed at #533')
  call g:assert.equals(getline(3),   '        foo',    'failed at #533')
  call g:assert.equals(getline(4),   '    ]',          'failed at #533')
  call g:assert.equals(getline(5),   '}',              'failed at #533')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #533')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #533')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #533')
  call g:assert.equals(&l:autoindent,  1,              'failed at #533')
  call g:assert.equals(&l:smartindent, 1,              'failed at #533')
  call g:assert.equals(&l:cindent,     1,              'failed at #533')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #533')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #534
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #534')
  call g:assert.equals(getline(2),   '    [',       'failed at #534')
  call g:assert.equals(getline(3),   '        foo', 'failed at #534')
  call g:assert.equals(getline(4),   '    ]',       'failed at #534')
  call g:assert.equals(getline(5),   '    }',       'failed at #534')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #534')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #534')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #534')
  call g:assert.equals(&l:autoindent,  0,           'failed at #534')
  call g:assert.equals(&l:smartindent, 0,           'failed at #534')
  call g:assert.equals(&l:cindent,     0,           'failed at #534')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #534')

  %delete

  " #535
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #535')
  call g:assert.equals(getline(2),   '    [',       'failed at #535')
  call g:assert.equals(getline(3),   '        foo', 'failed at #535')
  call g:assert.equals(getline(4),   '    ]',       'failed at #535')
  call g:assert.equals(getline(5),   '    }',       'failed at #535')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #535')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #535')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #535')
  call g:assert.equals(&l:autoindent,  1,           'failed at #535')
  call g:assert.equals(&l:smartindent, 0,           'failed at #535')
  call g:assert.equals(&l:cindent,     0,           'failed at #535')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #535')

  %delete

  " #536
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #536')
  call g:assert.equals(getline(2),   '    [',       'failed at #536')
  call g:assert.equals(getline(3),   '        foo', 'failed at #536')
  call g:assert.equals(getline(4),   '    ]',       'failed at #536')
  call g:assert.equals(getline(5),   '    }',       'failed at #536')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #536')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #536')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #536')
  call g:assert.equals(&l:autoindent,  1,           'failed at #536')
  call g:assert.equals(&l:smartindent, 1,           'failed at #536')
  call g:assert.equals(&l:cindent,     0,           'failed at #536')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #536')

  %delete

  " #537
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #537')
  call g:assert.equals(getline(2),   '    [',       'failed at #537')
  call g:assert.equals(getline(3),   '        foo', 'failed at #537')
  call g:assert.equals(getline(4),   '    ]',       'failed at #537')
  call g:assert.equals(getline(5),   '    }',       'failed at #537')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #537')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #537')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #537')
  call g:assert.equals(&l:autoindent,  1,           'failed at #537')
  call g:assert.equals(&l:smartindent, 1,           'failed at #537')
  call g:assert.equals(&l:cindent,     1,           'failed at #537')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #537')

  %delete

  " #538
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',              'failed at #538')
  call g:assert.equals(getline(2),   '    [',          'failed at #538')
  call g:assert.equals(getline(3),   '        foo',    'failed at #538')
  call g:assert.equals(getline(4),   '    ]',          'failed at #538')
  call g:assert.equals(getline(5),   '    }',          'failed at #538')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #538')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #538')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #538')
  call g:assert.equals(&l:autoindent,  1,              'failed at #538')
  call g:assert.equals(&l:smartindent, 1,              'failed at #538')
  call g:assert.equals(&l:cindent,     1,              'failed at #538')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #538')
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

  " #539
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #539')
  call g:assert.equals(getline(2),   'foo',        'failed at #539')
  call g:assert.equals(getline(3),   '    }',      'failed at #539')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #539')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #539')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #539')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #539')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #539')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #540
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #540')
  call g:assert.equals(getline(2),   '    foo',    'failed at #540')
  call g:assert.equals(getline(3),   '    }',      'failed at #540')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #540')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #540')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #540')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #540')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #540')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #541
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #541')
  call g:assert.equals(getline(2),   'foo',        'failed at #541')
  call g:assert.equals(getline(3),   '    }',      'failed at #541')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #541')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #541')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #541')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #541')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #541')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #542
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #542')
  call g:assert.equals(getline(2),   'foo',        'failed at #542')
  call g:assert.equals(getline(3),   '    }',      'failed at #542')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #542')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #542')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #542')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #542')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #542')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #543
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',     'failed at #543')
  call g:assert.equals(getline(2),   '    foo',       'failed at #543')
  call g:assert.equals(getline(3),   '            }', 'failed at #543')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #543')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #543')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #543')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #543')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #543')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #544
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #544')
  call g:assert.equals(getline(2),   'foo',        'failed at #544')
  call g:assert.equals(getline(3),   '    }',      'failed at #544')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #544')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #544')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #544')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #544')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #544')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssa <Esc>:call operator#sandwich#prerequisite('add', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #545
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #545')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #545')

  " #546
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #546')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #546')

  " #547
  call setline('.', 'foo')
  normal 0ssaiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #547')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #547')

  " #548
  call setline('.', 'foo')
  normal 0ssaiw[
  call g:assert.equals(getline('.'), '[foo[',      'failed at #548')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #548')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #549
  call setline('.', 'foo')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0saiw(
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #549')

  " #550
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 02saiw((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #550')

  " #551
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 03saiw(((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #551')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
