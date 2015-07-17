let s:suite = themis#suite('operator-sandwich: add:')

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
        \ ]

  " #20
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #20')

  " #21
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #21')

  set filetype=vim

  " #22
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #22')

  " #23
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #23')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #24
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #24')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \ ]

  " #25
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #25')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['delete'], 'input': ['(', ')']},
        \ ]

  " #26
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['replace'], 'input': ['(', ')']},
        \ ]

  " #27
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #27')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['operator'], 'input': ['(', ')']},
        \ ]

  " #28
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #28')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #29
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #29')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #30
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #30')

  " #31
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #31')

  " #32
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #32')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['(', ')']},
        \ ]

  " #33
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #33')

  " #34
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #34')

  " #35
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #35')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['(', ')']},
        \ ]

  " #36
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #36')

  " #37
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #37')

  " #38
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #38')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['(', ')']},
        \ ]

  " #39
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #39')

  " #40
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #40')

  " #41
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #41')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['(', ')']},
        \ ]

  " #42
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #42')

  " #43
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #43')

  " #44
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #44')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #45
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #45')

  " #46
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #46')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['(', ')']},
        \ ]

  " #47
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #47')

  " #48
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #48')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #49
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #49')

  " #50
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #50')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #51
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #51')

  " #52
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #52')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['(', ')']},
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
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['(', ')']},
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
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['(', ')']},
        \ ]

  " #57
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #57')

  " #58
  call setline('.', 'foo')
  normal 0saiw(
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
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #59')

  " #60
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #60')

  " #61
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #61')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #62
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #62')

  " #63
  call setline('.', 'foo')
  normal 0saiw)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #63')

  " #64
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #64')

  " #65
  call setline('.', 'foo')
  normal 0saiw]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #65')

  " #66
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #66')

  " #67
  call setline('.', 'foo')
  normal 0saiw}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #67')

  " #68
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #68')

  " #69
  call setline('.', 'foo')
  normal 0saiw>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #69')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #70
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #70')

  " #71
  call setline('.', 'foo')
  normal 0saiw*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #71')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #72
  call setline('.', 'foobar')
  normal 0sa3l(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #72')

  " #73
  call setline('.', 'foobar')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #73')

  " #74
  call setline('.', 'foobarbaz')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #74')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #75
  call setline('.', 'foobarbaz')
  normal 0saii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #75')

  " #76
  call setline('.', 'foobarbaz')
  normal 02lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #76')

  " #77
  call setline('.', 'foobarbaz')
  normal 03lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #77')

  " #78
  call setline('.', 'foobarbaz')
  normal 05lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #78')

  " #79
  call setline('.', 'foobarbaz')
  normal 06lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #79')

  " #80
  call setline('.', 'foobarbaz')
  normal 08lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #80')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  %delete

  " #81
  set whichwrap=h,l
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa11l(
  call g:assert.equals(getline(1),   '(foo',       'failed at #81')
  call g:assert.equals(getline(2),   'bar',        'failed at #81')
  call g:assert.equals(getline(3),   'baz)',       'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #81')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #82
  call setline('.', 'a')
  normal 0sal(
  call g:assert.equals(getline('.'), '(a)',        'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #82')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \   {'buns': ["cc\n cc", "ccc\n  "], 'input':['c']},
        \ ]

  " #83
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1),   'aa',         'failed at #83')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #83')
  call g:assert.equals(getline(3),   'aa',         'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #83')

  %delete

  " #84
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline(1),   'bb',         'failed at #84')
  call g:assert.equals(getline(2),   'bbb',        'failed at #84')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #84')
  call g:assert.equals(getline(4),   'bbb',        'failed at #84')
  call g:assert.equals(getline(5),   'bb',         'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #84')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #85
  call setline('.', 'foobarbaz')
  normal ggsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #85')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #85')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #85')

  %delete

  " #86
  call setline('.', 'foobarbaz')
  normal gg2lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #86')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #86')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #86')

  %delete

  " #87
  call setline('.', 'foobarbaz')
  normal gg3lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #87')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #87')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #87')

  %delete

  " #88
  call setline('.', 'foobarbaz')
  normal gg5lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #88')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #88')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #88')

  %delete

  " #89
  call setline('.', 'foobarbaz')
  normal gg6lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #89')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #89')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #89')

  %delete

  " #90
  call setline('.', 'foobarbaz')
  normal gg$saiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #90')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #90')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #90')

  %delete

  set autoindent
  onoremap ii :<C-u>call TextobjCoord(1, 8, 1, 10)<CR>

  " #91
  call setline('.', '    foobarbaz')
  normal ggsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #91')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #91')
  call g:assert.equals(getline(3),   '      baz',     'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],    'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #91')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #91')

  %delete

  " #92
  call setline('.', '    foobarbaz')
  normal gg2lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #92')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #92')
  call g:assert.equals(getline(3),   '      baz',     'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],    'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #92')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #92')

  %delete

  " #93
  call setline('.', '    foobarbaz')
  normal gg3lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #93')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #93')
  call g:assert.equals(getline(3),   '      baz',     'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0],    'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #93')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #93')

  %delete

  " #94
  call setline('.', '    foobarbaz')
  normal gg5lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #94')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #94')
  call g:assert.equals(getline(3),   '      baz',     'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 2, 10, 0],   'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #94')
  call g:assert.equals(getpos("']"), [0, 3,  7, 0],   'failed at #94')

  %delete

  " #95
  call setline('.', '    foobarbaz')
  normal gg6lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #95')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #95')
  call g:assert.equals(getline(3),   '      baz',     'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0],    'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #95')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #95')

  %delete

  " #96
  call setline('.', '    foobarbaz')
  normal gg$saiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #96')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #96')
  call g:assert.equals(getline(3),   '      baz',     'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #96')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #96')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #97
  call setline('.', 'foo')
  normal 02saiw([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #97')

  " #98
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #98')

  " #99
  call setline('.', 'foo bar')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #99')

  " #100
  call setline('.', 'foo bar')
  normal 0sa3iw(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #100')

  " #101
  call setline('.', 'foo bar')
  normal 02sa3iw([
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #101')

  " #102
  call setline('.', 'foobarbaz')
  normal 03l2sa3l([
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #102')

  " #103
  call setline('.', 'foobarbaz')
  normal 03l3sa3l([{
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #103')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #104
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #104')

  " #105
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #105')

  """ keep
  " #106
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #106')

  " #107
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #107')

  """ inner_tail
  " #108
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #108')

  " #109
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #109')

  """ head
  " #110
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #110')

  " #111
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #111')

  """ tail
  " #112
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #112')

  " #113
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #113')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #114
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #114')

  %delete

  """ on
  " #115
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #115')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #116
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #116')

  """ 1
  " #117
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #117')

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
  " #118
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #118')

  """ off
  " #119
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #119')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #120
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #120')

  """ on
  " #121
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #121')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  """"" command
  " #122
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '()',  'failed at #122')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #123
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #123')
  call g:assert.equals(getline(2), 'foo', 'failed at #123')
  call g:assert.equals(getline(3), ')',   'failed at #123')

  %delete

  " #124
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #124')
  call g:assert.equals(getline(2),   '    foo',    'failed at #124')
  call g:assert.equals(getline(3),   '    )',      'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #124')

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

  " #125
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #125')
  call g:assert.equals(getline(2),   '[',          'failed at #125')
  call g:assert.equals(getline(3),   'foo',        'failed at #125')
  call g:assert.equals(getline(4),   ']',          'failed at #125')
  call g:assert.equals(getline(5),   '}',          'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #125')
  call g:assert.equals(&l:autoindent,  0,          'failed at #125')
  call g:assert.equals(&l:smartindent, 0,          'failed at #125')
  call g:assert.equals(&l:cindent,     0,          'failed at #125')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #125')

  %delete

  " #126
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #126')
  call g:assert.equals(getline(2),   '    [',      'failed at #126')
  call g:assert.equals(getline(3),   '    foo',    'failed at #126')
  call g:assert.equals(getline(4),   '    ]',      'failed at #126')
  call g:assert.equals(getline(5),   '    }',      'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #126')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #126')
  call g:assert.equals(&l:autoindent,  1,          'failed at #126')
  call g:assert.equals(&l:smartindent, 0,          'failed at #126')
  call g:assert.equals(&l:cindent,     0,          'failed at #126')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #126')

  %delete

  " #127
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #127')
  call g:assert.equals(getline(2),   '        [',   'failed at #127')
  call g:assert.equals(getline(3),   '        foo', 'failed at #127')
  call g:assert.equals(getline(4),   '    ]',       'failed at #127')
  call g:assert.equals(getline(5),   '}',           'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #127')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #127')
  call g:assert.equals(&l:autoindent,  1,           'failed at #127')
  call g:assert.equals(&l:smartindent, 1,           'failed at #127')
  call g:assert.equals(&l:cindent,     0,           'failed at #127')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #127')

  %delete

  " #128
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #128')
  call g:assert.equals(getline(2),   '    [',       'failed at #128')
  call g:assert.equals(getline(3),   '        foo', 'failed at #128')
  call g:assert.equals(getline(4),   '    ]',       'failed at #128')
  call g:assert.equals(getline(5),   '    }',       'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #128')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #128')
  call g:assert.equals(&l:autoindent,  1,           'failed at #128')
  call g:assert.equals(&l:smartindent, 1,           'failed at #128')
  call g:assert.equals(&l:cindent,     1,           'failed at #128')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #128')

  %delete

  " #129
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',           'failed at #129')
  call g:assert.equals(getline(2),   '            [',       'failed at #129')
  call g:assert.equals(getline(3),   '                foo', 'failed at #129')
  call g:assert.equals(getline(4),   '        ]',           'failed at #129')
  call g:assert.equals(getline(5),   '                }',   'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #129')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #129')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #129')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #129')
  call g:assert.equals(&l:cindent,     1,                   'failed at #129')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #129')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #130
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #130')
  call g:assert.equals(getline(2),   '[',          'failed at #130')
  call g:assert.equals(getline(3),   'foo',        'failed at #130')
  call g:assert.equals(getline(4),   ']',          'failed at #130')
  call g:assert.equals(getline(5),   '}',          'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #130')
  call g:assert.equals(&l:autoindent,  0,          'failed at #130')
  call g:assert.equals(&l:smartindent, 0,          'failed at #130')
  call g:assert.equals(&l:cindent,     0,          'failed at #130')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #130')

  %delete

  " #131
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #131')
  call g:assert.equals(getline(2),   '[',          'failed at #131')
  call g:assert.equals(getline(3),   'foo',        'failed at #131')
  call g:assert.equals(getline(4),   ']',          'failed at #131')
  call g:assert.equals(getline(5),   '}',          'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #131')
  call g:assert.equals(&l:autoindent,  1,          'failed at #131')
  call g:assert.equals(&l:smartindent, 0,          'failed at #131')
  call g:assert.equals(&l:cindent,     0,          'failed at #131')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #131')

  %delete

  " #132
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #132')
  call g:assert.equals(getline(2),   '[',          'failed at #132')
  call g:assert.equals(getline(3),   'foo',        'failed at #132')
  call g:assert.equals(getline(4),   ']',          'failed at #132')
  call g:assert.equals(getline(5),   '}',          'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #132')
  call g:assert.equals(&l:autoindent,  1,          'failed at #132')
  call g:assert.equals(&l:smartindent, 1,          'failed at #132')
  call g:assert.equals(&l:cindent,     0,          'failed at #132')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #132')

  %delete

  " #133
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #133')
  call g:assert.equals(getline(2),   '[',          'failed at #133')
  call g:assert.equals(getline(3),   'foo',        'failed at #133')
  call g:assert.equals(getline(4),   ']',          'failed at #133')
  call g:assert.equals(getline(5),   '}',          'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #133')
  call g:assert.equals(&l:autoindent,  1,          'failed at #133')
  call g:assert.equals(&l:smartindent, 1,          'failed at #133')
  call g:assert.equals(&l:cindent,     1,          'failed at #133')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #133')

  %delete

  " #134
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #134')
  call g:assert.equals(getline(2),   '[',              'failed at #134')
  call g:assert.equals(getline(3),   'foo',            'failed at #134')
  call g:assert.equals(getline(4),   ']',              'failed at #134')
  call g:assert.equals(getline(5),   '}',              'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #134')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #134')
  call g:assert.equals(&l:autoindent,  1,              'failed at #134')
  call g:assert.equals(&l:smartindent, 1,              'failed at #134')
  call g:assert.equals(&l:cindent,     1,              'failed at #134')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #134')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #135
  setlocal noautoindent
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
  call g:assert.equals(&l:autoindent,  0,          'failed at #135')
  call g:assert.equals(&l:smartindent, 0,          'failed at #135')
  call g:assert.equals(&l:cindent,     0,          'failed at #135')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #135')

  %delete

  " #136
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #136')
  call g:assert.equals(getline(2),   '    [',      'failed at #136')
  call g:assert.equals(getline(3),   '    foo',    'failed at #136')
  call g:assert.equals(getline(4),   '    ]',      'failed at #136')
  call g:assert.equals(getline(5),   '    }',      'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #136')
  call g:assert.equals(&l:autoindent,  1,          'failed at #136')
  call g:assert.equals(&l:smartindent, 0,          'failed at #136')
  call g:assert.equals(&l:cindent,     0,          'failed at #136')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #136')

  %delete

  " #137
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #137')
  call g:assert.equals(getline(2),   '    [',      'failed at #137')
  call g:assert.equals(getline(3),   '    foo',    'failed at #137')
  call g:assert.equals(getline(4),   '    ]',      'failed at #137')
  call g:assert.equals(getline(5),   '    }',      'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #137')
  call g:assert.equals(&l:autoindent,  1,          'failed at #137')
  call g:assert.equals(&l:smartindent, 1,          'failed at #137')
  call g:assert.equals(&l:cindent,     0,          'failed at #137')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #137')

  %delete

  " #138
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #138')
  call g:assert.equals(getline(2),   '    [',      'failed at #138')
  call g:assert.equals(getline(3),   '    foo',    'failed at #138')
  call g:assert.equals(getline(4),   '    ]',      'failed at #138')
  call g:assert.equals(getline(5),   '    }',      'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #138')
  call g:assert.equals(&l:autoindent,  1,          'failed at #138')
  call g:assert.equals(&l:smartindent, 1,          'failed at #138')
  call g:assert.equals(&l:cindent,     1,          'failed at #138')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #138')

  %delete

  " #139
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #139')
  call g:assert.equals(getline(2),   '    [',          'failed at #139')
  call g:assert.equals(getline(3),   '    foo',        'failed at #139')
  call g:assert.equals(getline(4),   '    ]',          'failed at #139')
  call g:assert.equals(getline(5),   '    }',          'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #139')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #139')
  call g:assert.equals(&l:autoindent,  1,              'failed at #139')
  call g:assert.equals(&l:smartindent, 1,              'failed at #139')
  call g:assert.equals(&l:cindent,     1,              'failed at #139')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #139')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #140
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #140')
  call g:assert.equals(getline(2),   '        [',   'failed at #140')
  call g:assert.equals(getline(3),   '        foo', 'failed at #140')
  call g:assert.equals(getline(4),   '    ]',       'failed at #140')
  call g:assert.equals(getline(5),   '}',           'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #140')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #140')
  call g:assert.equals(&l:autoindent,  0,           'failed at #140')
  call g:assert.equals(&l:smartindent, 0,           'failed at #140')
  call g:assert.equals(&l:cindent,     0,           'failed at #140')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #140')

  %delete

  " #141
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #141')
  call g:assert.equals(getline(2),   '        [',   'failed at #141')
  call g:assert.equals(getline(3),   '        foo', 'failed at #141')
  call g:assert.equals(getline(4),   '    ]',       'failed at #141')
  call g:assert.equals(getline(5),   '}',           'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #141')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #141')
  call g:assert.equals(&l:autoindent,  1,           'failed at #141')
  call g:assert.equals(&l:smartindent, 0,           'failed at #141')
  call g:assert.equals(&l:cindent,     0,           'failed at #141')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #141')

  %delete

  " #142
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #142')
  call g:assert.equals(getline(2),   '        [',   'failed at #142')
  call g:assert.equals(getline(3),   '        foo', 'failed at #142')
  call g:assert.equals(getline(4),   '    ]',       'failed at #142')
  call g:assert.equals(getline(5),   '}',           'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #142')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #142')
  call g:assert.equals(&l:autoindent,  1,           'failed at #142')
  call g:assert.equals(&l:smartindent, 1,           'failed at #142')
  call g:assert.equals(&l:cindent,     0,           'failed at #142')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #142')

  %delete

  " #143
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #143')
  call g:assert.equals(getline(2),   '        [',   'failed at #143')
  call g:assert.equals(getline(3),   '        foo', 'failed at #143')
  call g:assert.equals(getline(4),   '    ]',       'failed at #143')
  call g:assert.equals(getline(5),   '}',           'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #143')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #143')
  call g:assert.equals(&l:autoindent,  1,           'failed at #143')
  call g:assert.equals(&l:smartindent, 1,           'failed at #143')
  call g:assert.equals(&l:cindent,     1,           'failed at #143')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #143')

  %delete

  " #144
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #144')
  call g:assert.equals(getline(2),   '        [',      'failed at #144')
  call g:assert.equals(getline(3),   '        foo',    'failed at #144')
  call g:assert.equals(getline(4),   '    ]',          'failed at #144')
  call g:assert.equals(getline(5),   '}',              'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #144')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #144')
  call g:assert.equals(&l:autoindent,  1,              'failed at #144')
  call g:assert.equals(&l:smartindent, 1,              'failed at #144')
  call g:assert.equals(&l:cindent,     1,              'failed at #144')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #144')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #145
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #145')
  call g:assert.equals(getline(2),   '    [',       'failed at #145')
  call g:assert.equals(getline(3),   '        foo', 'failed at #145')
  call g:assert.equals(getline(4),   '    ]',       'failed at #145')
  call g:assert.equals(getline(5),   '    }',       'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #145')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #145')
  call g:assert.equals(&l:autoindent,  0,           'failed at #145')
  call g:assert.equals(&l:smartindent, 0,           'failed at #145')
  call g:assert.equals(&l:cindent,     0,           'failed at #145')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #145')

  %delete

  " #146
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #146')
  call g:assert.equals(getline(2),   '    [',       'failed at #146')
  call g:assert.equals(getline(3),   '        foo', 'failed at #146')
  call g:assert.equals(getline(4),   '    ]',       'failed at #146')
  call g:assert.equals(getline(5),   '    }',       'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #146')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #146')
  call g:assert.equals(&l:autoindent,  1,           'failed at #146')
  call g:assert.equals(&l:smartindent, 0,           'failed at #146')
  call g:assert.equals(&l:cindent,     0,           'failed at #146')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #146')

  %delete

  " #147
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #147')
  call g:assert.equals(getline(2),   '    [',       'failed at #147')
  call g:assert.equals(getline(3),   '        foo', 'failed at #147')
  call g:assert.equals(getline(4),   '    ]',       'failed at #147')
  call g:assert.equals(getline(5),   '    }',       'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #147')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #147')
  call g:assert.equals(&l:autoindent,  1,           'failed at #147')
  call g:assert.equals(&l:smartindent, 1,           'failed at #147')
  call g:assert.equals(&l:cindent,     0,           'failed at #147')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #147')

  %delete

  " #148
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',           'failed at #148')
  call g:assert.equals(getline(2),   '    [',       'failed at #148')
  call g:assert.equals(getline(3),   '        foo', 'failed at #148')
  call g:assert.equals(getline(4),   '    ]',       'failed at #148')
  call g:assert.equals(getline(5),   '    }',       'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #148')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #148')
  call g:assert.equals(&l:autoindent,  1,           'failed at #148')
  call g:assert.equals(&l:smartindent, 1,           'failed at #148')
  call g:assert.equals(&l:cindent,     1,           'failed at #148')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #148')

  %delete

  " #149
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',              'failed at #149')
  call g:assert.equals(getline(2),   '    [',          'failed at #149')
  call g:assert.equals(getline(3),   '        foo',    'failed at #149')
  call g:assert.equals(getline(4),   '    ]',          'failed at #149')
  call g:assert.equals(getline(5),   '    }',          'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #149')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #149')
  call g:assert.equals(&l:autoindent,  1,              'failed at #149')
  call g:assert.equals(&l:smartindent, 1,              'failed at #149')
  call g:assert.equals(&l:cindent,     1,              'failed at #149')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #149')
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

  " #150
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #150')
  call g:assert.equals(getline(2),   'foo',        'failed at #150')
  call g:assert.equals(getline(3),   '    }',      'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #150')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #150')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #150')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #151
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #151')
  call g:assert.equals(getline(2),   '    foo',    'failed at #151')
  call g:assert.equals(getline(3),   '    }',      'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #151')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #151')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #151')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #152
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #152')
  call g:assert.equals(getline(2),   'foo',        'failed at #152')
  call g:assert.equals(getline(3),   '    }',      'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #152')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #152')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #152')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #153
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #153')
  call g:assert.equals(getline(2),   'foo',        'failed at #153')
  call g:assert.equals(getline(3),   '    }',      'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #153')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #153')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #153')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #154
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',     'failed at #154')
  call g:assert.equals(getline(2),   '    foo',       'failed at #154')
  call g:assert.equals(getline(3),   '            }', 'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #154')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #154')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #154')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #154')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #155
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #155')
  call g:assert.equals(getline(2),   'foo',        'failed at #155')
  call g:assert.equals(getline(3),   '    }',      'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #155')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #155')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #155')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #156
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'ailed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'ailed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'ailed at #156')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'ailed at #156')

  " #157
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #157')

  " #158
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #158')

  " #159
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #159')

  " #160
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #160')

  " #161
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #161')

  " #162
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #162')

  " #163
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #163')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #164
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #164')

  " #165
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #165')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #166
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #166')

  " #167
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #167')

  " #168
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #168')

  " #169
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #169')
  call g:assert.equals(getline(2),   'bar',        'failed at #169')
  call g:assert.equals(getline(3),   'baz)',       'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #169')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #170
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #170')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #171
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #171')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #171')
  call g:assert.equals(getline(3), 'aa',           'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #171')

  %delete

  " #172
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #172')
  call g:assert.equals(getline(2),   'bbb',        'failed at #172')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #172')
  call g:assert.equals(getline(4),   'bbb',        'failed at #172')
  call g:assert.equals(getline(5),   'bb',         'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #172')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #173
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #173')

  " #174
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #174')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #175
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #175')

  " #176
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #176')

  """ keep
  " #177
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #177')

  " #178
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #178')

  """ inner_tail
  " #179
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #179')

  " #180
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #180')

  """ head
  " #181
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #181')

  " #182
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #182')

  """ tail
  " #183
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #183')

  " #184
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #184')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #185
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #185')

  """ on
  " #186
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #186')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #187
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #187')

  """ 1
  " #188
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #188')

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
  " #189
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #189')

  """ off
  " #190
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #190')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #191
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #191')

  """ on
  " #192
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #192')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #193
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '()',  'failed at #193')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #194
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #194')
  call g:assert.equals(getline(2), 'foo', 'failed at #194')
  call g:assert.equals(getline(3), ')',   'failed at #194')

  %delete

  " #195
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #154')
  call g:assert.equals(getline(2),   '    foo',    'failed at #154')
  call g:assert.equals(getline(3),   '    )',      'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #154')

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

  " #196
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #196')
  call g:assert.equals(getline(2),   '[',          'failed at #196')
  call g:assert.equals(getline(3),   'foo',        'failed at #196')
  call g:assert.equals(getline(4),   ']',          'failed at #196')
  call g:assert.equals(getline(5),   '}',          'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #196')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #196')
  call g:assert.equals(&l:autoindent,  0,          'failed at #196')
  call g:assert.equals(&l:smartindent, 0,          'failed at #196')
  call g:assert.equals(&l:cindent,     0,          'failed at #196')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #196')

  %delete

  " #197
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #197')
  call g:assert.equals(getline(2),   '    [',      'failed at #197')
  call g:assert.equals(getline(3),   '    foo',    'failed at #197')
  call g:assert.equals(getline(4),   '    ]',      'failed at #197')
  call g:assert.equals(getline(5),   '    }',      'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #197')
  call g:assert.equals(&l:autoindent,  1,          'failed at #197')
  call g:assert.equals(&l:smartindent, 0,          'failed at #197')
  call g:assert.equals(&l:cindent,     0,          'failed at #197')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #197')

  %delete

  " #198
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #198')
  call g:assert.equals(getline(2),   '        [',   'failed at #198')
  call g:assert.equals(getline(3),   '        foo', 'failed at #198')
  call g:assert.equals(getline(4),   '    ]',       'failed at #198')
  call g:assert.equals(getline(5),   '}',           'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #198')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #198')
  call g:assert.equals(&l:autoindent,  1,           'failed at #198')
  call g:assert.equals(&l:smartindent, 1,           'failed at #198')
  call g:assert.equals(&l:cindent,     0,           'failed at #198')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #198')

  %delete

  " #199
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #199')
  call g:assert.equals(getline(2),   '    [',       'failed at #199')
  call g:assert.equals(getline(3),   '        foo', 'failed at #199')
  call g:assert.equals(getline(4),   '    ]',       'failed at #199')
  call g:assert.equals(getline(5),   '    }',       'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #199')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #199')
  call g:assert.equals(&l:autoindent,  1,           'failed at #199')
  call g:assert.equals(&l:smartindent, 1,           'failed at #199')
  call g:assert.equals(&l:cindent,     1,           'failed at #199')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #199')

  %delete

  " #200
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',           'failed at #200')
  call g:assert.equals(getline(2),   '            [',       'failed at #200')
  call g:assert.equals(getline(3),   '                foo', 'failed at #200')
  call g:assert.equals(getline(4),   '        ]',           'failed at #200')
  call g:assert.equals(getline(5),   '                }',   'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #200')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #200')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #200')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #200')
  call g:assert.equals(&l:cindent,     1,                   'failed at #200')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #200')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #201
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #201')
  call g:assert.equals(getline(2),   '[',          'failed at #201')
  call g:assert.equals(getline(3),   'foo',        'failed at #201')
  call g:assert.equals(getline(4),   ']',          'failed at #201')
  call g:assert.equals(getline(5),   '}',          'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #201')
  call g:assert.equals(&l:autoindent,  0,          'failed at #201')
  call g:assert.equals(&l:smartindent, 0,          'failed at #201')
  call g:assert.equals(&l:cindent,     0,          'failed at #201')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #201')

  %delete

  " #202
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #202')
  call g:assert.equals(getline(2),   '[',          'failed at #202')
  call g:assert.equals(getline(3),   'foo',        'failed at #202')
  call g:assert.equals(getline(4),   ']',          'failed at #202')
  call g:assert.equals(getline(5),   '}',          'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #202')
  call g:assert.equals(&l:autoindent,  1,          'failed at #202')
  call g:assert.equals(&l:smartindent, 0,          'failed at #202')
  call g:assert.equals(&l:cindent,     0,          'failed at #202')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #202')

  %delete

  " #203
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #203')
  call g:assert.equals(getline(2),   '[',          'failed at #203')
  call g:assert.equals(getline(3),   'foo',        'failed at #203')
  call g:assert.equals(getline(4),   ']',          'failed at #203')
  call g:assert.equals(getline(5),   '}',          'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #203')
  call g:assert.equals(&l:autoindent,  1,          'failed at #203')
  call g:assert.equals(&l:smartindent, 1,          'failed at #203')
  call g:assert.equals(&l:cindent,     0,          'failed at #203')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #203')

  %delete

  " #204
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #204')
  call g:assert.equals(getline(2),   '[',          'failed at #204')
  call g:assert.equals(getline(3),   'foo',        'failed at #204')
  call g:assert.equals(getline(4),   ']',          'failed at #204')
  call g:assert.equals(getline(5),   '}',          'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #204')
  call g:assert.equals(&l:autoindent,  1,          'failed at #204')
  call g:assert.equals(&l:smartindent, 1,          'failed at #204')
  call g:assert.equals(&l:cindent,     1,          'failed at #204')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #204')

  %delete

  " #205
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #205')
  call g:assert.equals(getline(2),   '[',              'failed at #205')
  call g:assert.equals(getline(3),   'foo',            'failed at #205')
  call g:assert.equals(getline(4),   ']',              'failed at #205')
  call g:assert.equals(getline(5),   '}',              'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #205')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #205')
  call g:assert.equals(&l:autoindent,  1,              'failed at #205')
  call g:assert.equals(&l:smartindent, 1,              'failed at #205')
  call g:assert.equals(&l:cindent,     1,              'failed at #205')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #205')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #206
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #206')
  call g:assert.equals(getline(2),   '    [',      'failed at #206')
  call g:assert.equals(getline(3),   '    foo',    'failed at #206')
  call g:assert.equals(getline(4),   '    ]',      'failed at #206')
  call g:assert.equals(getline(5),   '    }',      'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #206')
  call g:assert.equals(&l:autoindent,  0,          'failed at #206')
  call g:assert.equals(&l:smartindent, 0,          'failed at #206')
  call g:assert.equals(&l:cindent,     0,          'failed at #206')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #206')

  %delete

  " #207
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #207')
  call g:assert.equals(getline(2),   '    [',      'failed at #207')
  call g:assert.equals(getline(3),   '    foo',    'failed at #207')
  call g:assert.equals(getline(4),   '    ]',      'failed at #207')
  call g:assert.equals(getline(5),   '    }',      'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #207')
  call g:assert.equals(&l:autoindent,  1,          'failed at #207')
  call g:assert.equals(&l:smartindent, 0,          'failed at #207')
  call g:assert.equals(&l:cindent,     0,          'failed at #207')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #207')

  %delete

  " #208
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #208')
  call g:assert.equals(getline(2),   '    [',      'failed at #208')
  call g:assert.equals(getline(3),   '    foo',    'failed at #208')
  call g:assert.equals(getline(4),   '    ]',      'failed at #208')
  call g:assert.equals(getline(5),   '    }',      'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #208')
  call g:assert.equals(&l:autoindent,  1,          'failed at #208')
  call g:assert.equals(&l:smartindent, 1,          'failed at #208')
  call g:assert.equals(&l:cindent,     0,          'failed at #208')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #208')

  %delete

  " #209
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #209')
  call g:assert.equals(getline(2),   '    [',      'failed at #209')
  call g:assert.equals(getline(3),   '    foo',    'failed at #209')
  call g:assert.equals(getline(4),   '    ]',      'failed at #209')
  call g:assert.equals(getline(5),   '    }',      'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #209')
  call g:assert.equals(&l:autoindent,  1,          'failed at #209')
  call g:assert.equals(&l:smartindent, 1,          'failed at #209')
  call g:assert.equals(&l:cindent,     1,          'failed at #209')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #209')

  %delete

  " #210
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #210')
  call g:assert.equals(getline(2),   '    [',          'failed at #210')
  call g:assert.equals(getline(3),   '    foo',        'failed at #210')
  call g:assert.equals(getline(4),   '    ]',          'failed at #210')
  call g:assert.equals(getline(5),   '    }',          'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #210')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #210')
  call g:assert.equals(&l:autoindent,  1,              'failed at #210')
  call g:assert.equals(&l:smartindent, 1,              'failed at #210')
  call g:assert.equals(&l:cindent,     1,              'failed at #210')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #210')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #211
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #211')
  call g:assert.equals(getline(2),   '        [',   'failed at #211')
  call g:assert.equals(getline(3),   '        foo', 'failed at #211')
  call g:assert.equals(getline(4),   '    ]',       'failed at #211')
  call g:assert.equals(getline(5),   '}',           'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #211')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #211')
  call g:assert.equals(&l:autoindent,  0,           'failed at #211')
  call g:assert.equals(&l:smartindent, 0,           'failed at #211')
  call g:assert.equals(&l:cindent,     0,           'failed at #211')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #211')

  %delete

  " #212
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #212')
  call g:assert.equals(getline(2),   '        [',   'failed at #212')
  call g:assert.equals(getline(3),   '        foo', 'failed at #212')
  call g:assert.equals(getline(4),   '    ]',       'failed at #212')
  call g:assert.equals(getline(5),   '}',           'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #212')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #212')
  call g:assert.equals(&l:autoindent,  1,           'failed at #212')
  call g:assert.equals(&l:smartindent, 0,           'failed at #212')
  call g:assert.equals(&l:cindent,     0,           'failed at #212')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #212')

  %delete

  " #213
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #213')
  call g:assert.equals(getline(2),   '        [',   'failed at #213')
  call g:assert.equals(getline(3),   '        foo', 'failed at #213')
  call g:assert.equals(getline(4),   '    ]',       'failed at #213')
  call g:assert.equals(getline(5),   '}',           'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #213')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #213')
  call g:assert.equals(&l:autoindent,  1,           'failed at #213')
  call g:assert.equals(&l:smartindent, 1,           'failed at #213')
  call g:assert.equals(&l:cindent,     0,           'failed at #213')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #213')

  %delete

  " #214
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #214')
  call g:assert.equals(getline(2),   '        [',   'failed at #214')
  call g:assert.equals(getline(3),   '        foo', 'failed at #214')
  call g:assert.equals(getline(4),   '    ]',       'failed at #214')
  call g:assert.equals(getline(5),   '}',           'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #214')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #214')
  call g:assert.equals(&l:autoindent,  1,           'failed at #214')
  call g:assert.equals(&l:smartindent, 1,           'failed at #214')
  call g:assert.equals(&l:cindent,     1,           'failed at #214')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #214')

  %delete

  " #215
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #215')
  call g:assert.equals(getline(2),   '        [',      'failed at #215')
  call g:assert.equals(getline(3),   '        foo',    'failed at #215')
  call g:assert.equals(getline(4),   '    ]',          'failed at #215')
  call g:assert.equals(getline(5),   '}',              'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #215')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #215')
  call g:assert.equals(&l:autoindent,  1,              'failed at #215')
  call g:assert.equals(&l:smartindent, 1,              'failed at #215')
  call g:assert.equals(&l:cindent,     1,              'failed at #215')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #215')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #216
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #216')
  call g:assert.equals(getline(2),   '    [',       'failed at #216')
  call g:assert.equals(getline(3),   '        foo', 'failed at #216')
  call g:assert.equals(getline(4),   '    ]',       'failed at #216')
  call g:assert.equals(getline(5),   '    }',       'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #216')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #216')
  call g:assert.equals(&l:autoindent,  0,           'failed at #216')
  call g:assert.equals(&l:smartindent, 0,           'failed at #216')
  call g:assert.equals(&l:cindent,     0,           'failed at #216')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #216')

  %delete

  " #217
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
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
  call g:assert.equals(&l:smartindent, 0,           'failed at #217')
  call g:assert.equals(&l:cindent,     0,           'failed at #217')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #217')

  %delete

  " #218
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #218')
  call g:assert.equals(getline(2),   '    [',       'failed at #218')
  call g:assert.equals(getline(3),   '        foo', 'failed at #218')
  call g:assert.equals(getline(4),   '    ]',       'failed at #218')
  call g:assert.equals(getline(5),   '    }',       'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #218')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #218')
  call g:assert.equals(&l:autoindent,  1,           'failed at #218')
  call g:assert.equals(&l:smartindent, 1,           'failed at #218')
  call g:assert.equals(&l:cindent,     0,           'failed at #218')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #218')

  %delete

  " #219
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',           'failed at #219')
  call g:assert.equals(getline(2),   '    [',       'failed at #219')
  call g:assert.equals(getline(3),   '        foo', 'failed at #219')
  call g:assert.equals(getline(4),   '    ]',       'failed at #219')
  call g:assert.equals(getline(5),   '    }',       'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #219')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #219')
  call g:assert.equals(&l:autoindent,  1,           'failed at #219')
  call g:assert.equals(&l:smartindent, 1,           'failed at #219')
  call g:assert.equals(&l:cindent,     1,           'failed at #219')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #219')

  %delete

  " #220
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',              'failed at #220')
  call g:assert.equals(getline(2),   '    [',          'failed at #220')
  call g:assert.equals(getline(3),   '        foo',    'failed at #220')
  call g:assert.equals(getline(4),   '    ]',          'failed at #220')
  call g:assert.equals(getline(5),   '    }',          'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #220')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #220')
  call g:assert.equals(&l:autoindent,  1,              'failed at #220')
  call g:assert.equals(&l:smartindent, 1,              'failed at #220')
  call g:assert.equals(&l:cindent,     1,              'failed at #220')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #220')
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

  " #221
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #221')
  call g:assert.equals(getline(2),   'foo',        'failed at #221')
  call g:assert.equals(getline(3),   '    }',      'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #221')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #221')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #221')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #222
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #222')
  call g:assert.equals(getline(2),   '    foo',    'failed at #222')
  call g:assert.equals(getline(3),   '    }',      'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #222')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #222')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #222')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #223
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #223')
  call g:assert.equals(getline(2),   'foo',        'failed at #223')
  call g:assert.equals(getline(3),   '    }',      'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #223')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #223')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #223')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #224
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #224')
  call g:assert.equals(getline(2),   'foo',        'failed at #224')
  call g:assert.equals(getline(3),   '    }',      'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #224')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #224')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #224')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #225
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',     'failed at #225')
  call g:assert.equals(getline(2),   '    foo',       'failed at #225')
  call g:assert.equals(getline(3),   '            }', 'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #225')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #225')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #225')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #225')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #226
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #226')
  call g:assert.equals(getline(2),   'foo',        'failed at #226')
  call g:assert.equals(getline(3),   '    }',      'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #226')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #226')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #226')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #227
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #227')
  call g:assert.equals(getline(2),   'foo',        'failed at #227')
  call g:assert.equals(getline(3),   ')',          'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #227')

  %delete

  " #228
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #228')
  call g:assert.equals(getline(2),   'foo',        'failed at #228')
  call g:assert.equals(getline(3),   ')',          'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #228')

  %delete

  " #229
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #229')
  call g:assert.equals(getline(2),   'foo',        'failed at #229')
  call g:assert.equals(getline(3),   ']',          'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #229')

  %delete

  " #230
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #230')
  call g:assert.equals(getline(2),   'foo',        'failed at #230')
  call g:assert.equals(getline(3),   ']',          'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #230')

  %delete

  " #231
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #231')
  call g:assert.equals(getline(2),   'foo',        'failed at #231')
  call g:assert.equals(getline(3),   '}',          'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #231')

  %delete

  " #232
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #232')
  call g:assert.equals(getline(2),   'foo',        'failed at #232')
  call g:assert.equals(getline(3),   '}',          'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #232')

  %delete

  " #233
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #233')
  call g:assert.equals(getline(2),   'foo',        'failed at #233')
  call g:assert.equals(getline(3),   '>',          'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #233')

  %delete

  " #234
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #234')
  call g:assert.equals(getline(2),   'foo',        'failed at #234')
  call g:assert.equals(getline(3),   '>',          'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #234')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #235
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #235')
  call g:assert.equals(getline(2),   'foo',        'failed at #235')
  call g:assert.equals(getline(3),   'a',          'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #235')

  %delete

  " #236
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #236')
  call g:assert.equals(getline(2),   'foo',        'failed at #236')
  call g:assert.equals(getline(3),   '*',          'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #236')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #237
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #237')
  call g:assert.equals(getline(2),   'foo',        'failed at #237')
  call g:assert.equals(getline(3),   'bar',        'failed at #237')
  call g:assert.equals(getline(4),   'baz',        'failed at #237')
  call g:assert.equals(getline(5),   ')',          'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #237')

  " #238
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #238')
  call g:assert.equals(getline(2),   '(',          'failed at #238')
  call g:assert.equals(getline(3),   'bar',        'failed at #238')
  call g:assert.equals(getline(4),   ')',          'failed at #238')
  call g:assert.equals(getline(5),   'baz',        'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #238')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #239
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #239')
  call g:assert.equals(getline(2),   'a',          'failed at #239')
  call g:assert.equals(getline(3),   ')',          'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #239')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #240
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #240')
  call g:assert.equals(getline(2),   'aaa',        'failed at #240')
  call g:assert.equals(getline(3),   'foo',        'failed at #240')
  call g:assert.equals(getline(4),   'aaa',        'failed at #240')
  call g:assert.equals(getline(5),   'aa',         'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #240')

  %delete

  " #241
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #241')
  call g:assert.equals(getline(2),   'bbb',        'failed at #241')
  call g:assert.equals(getline(3),   'bb',         'failed at #241')
  call g:assert.equals(getline(4),   'foo',        'failed at #241')
  call g:assert.equals(getline(5),   'bb',         'failed at #241')
  call g:assert.equals(getline(6),   'bbb',        'failed at #241')
  call g:assert.equals(getline(7),   'bb',         'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #241')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #242
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #242')
  call g:assert.equals(getline(2),   '(',          'failed at #242')
  call g:assert.equals(getline(3),   'foo',        'failed at #242')
  call g:assert.equals(getline(4),   ')',          'failed at #242')
  call g:assert.equals(getline(5),   ']',          'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #242')

  %delete

  " #243
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #243')
  call g:assert.equals(getline(2),   '[',          'failed at #243')
  call g:assert.equals(getline(3),   '(',          'failed at #243')
  call g:assert.equals(getline(4),   'foo',        'failed at #243')
  call g:assert.equals(getline(5),   ')',          'failed at #243')
  call g:assert.equals(getline(6),   ']',          'failed at #243')
  call g:assert.equals(getline(7),   '}',          'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #243')

  %delete

  " #244
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #244')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #244')
  call g:assert.equals(getline(3), ')',            'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #244')

  %delete

  " #245
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #245')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #245')
  call g:assert.equals(getline(3), ')',            'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #245')

  %delete

  " #246
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #246')
  call g:assert.equals(getline(2), '(',            'failed at #246')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #246')
  call g:assert.equals(getline(4), ')',            'failed at #246')
  call g:assert.equals(getline(5), ']',            'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #247')
  call g:assert.equals(getline(2), '[',            'failed at #247')
  call g:assert.equals(getline(3), '(',            'failed at #247')
  call g:assert.equals(getline(4), 'foo',          'failed at #247')
  call g:assert.equals(getline(5), ')',            'failed at #247')
  call g:assert.equals(getline(6), ']',            'failed at #247')
  call g:assert.equals(getline(7), 'aa',           'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #247')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #248
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #248')
  call g:assert.equals(getline(2),   '(',          'failed at #248')
  call g:assert.equals(getline(3),   'foo',        'failed at #248')
  call g:assert.equals(getline(4),   ')',          'failed at #248')
  call g:assert.equals(getline(5),   ')',          'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #248')

  " #249
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #249')
  call g:assert.equals(getline(2),   '(',          'failed at #249')
  call g:assert.equals(getline(3),   '(',          'failed at #249')
  call g:assert.equals(getline(4),   'foo',        'failed at #249')
  call g:assert.equals(getline(5),   ')',          'failed at #249')
  call g:assert.equals(getline(6),   ')',          'failed at #249')
  call g:assert.equals(getline(7),   ')',          'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #249')

  %delete

  """ keep
  " #250
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #250')
  call g:assert.equals(getline(2),   '(',          'failed at #250')
  call g:assert.equals(getline(3),   'foo',        'failed at #250')
  call g:assert.equals(getline(4),   ')',          'failed at #250')
  call g:assert.equals(getline(5),   ')',          'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #250')

  " #251
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #251')
  call g:assert.equals(getline(2),   '(',          'failed at #251')
  call g:assert.equals(getline(3),   '(',          'failed at #251')
  call g:assert.equals(getline(4),   'foo',        'failed at #251')
  call g:assert.equals(getline(5),   ')',          'failed at #251')
  call g:assert.equals(getline(6),   ')',          'failed at #251')
  call g:assert.equals(getline(7),   ')',          'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #251')

  %delete

  """ inner_tail
  " #252
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #252')
  call g:assert.equals(getline(2),   '(',          'failed at #252')
  call g:assert.equals(getline(3),   'foo',        'failed at #252')
  call g:assert.equals(getline(4),   ')',          'failed at #252')
  call g:assert.equals(getline(5),   ')',          'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #252')

  " #253
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #253')
  call g:assert.equals(getline(2),   '(',          'failed at #253')
  call g:assert.equals(getline(3),   '(',          'failed at #253')
  call g:assert.equals(getline(4),   'foo',        'failed at #253')
  call g:assert.equals(getline(5),   ')',          'failed at #253')
  call g:assert.equals(getline(6),   ')',          'failed at #253')
  call g:assert.equals(getline(7),   ')',          'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #253')

  %delete

  """ head
  " #254
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #254')
  call g:assert.equals(getline(2),   '(',          'failed at #254')
  call g:assert.equals(getline(3),   'foo',        'failed at #254')
  call g:assert.equals(getline(4),   ')',          'failed at #254')
  call g:assert.equals(getline(5),   ')',          'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #254')

  " #255
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #255')
  call g:assert.equals(getline(2),   '(',          'failed at #255')
  call g:assert.equals(getline(3),   '(',          'failed at #255')
  call g:assert.equals(getline(4),   'foo',        'failed at #255')
  call g:assert.equals(getline(5),   ')',          'failed at #255')
  call g:assert.equals(getline(6),   ')',          'failed at #255')
  call g:assert.equals(getline(7),   ')',          'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #255')

  %delete

  """ tail
  " #256
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #256')
  call g:assert.equals(getline(2),   '(',          'failed at #256')
  call g:assert.equals(getline(3),   'foo',        'failed at #256')
  call g:assert.equals(getline(4),   ')',          'failed at #256')
  call g:assert.equals(getline(5),   ')',          'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #256')

  " #257
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #257')
  call g:assert.equals(getline(2),   '(',          'failed at #257')
  call g:assert.equals(getline(3),   '(',          'failed at #257')
  call g:assert.equals(getline(4),   'foo',        'failed at #257')
  call g:assert.equals(getline(5),   ')',          'failed at #257')
  call g:assert.equals(getline(6),   ')',          'failed at #257')
  call g:assert.equals(getline(7),   ')',          'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #257')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #258
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #258')
  call g:assert.equals(getline(2), '[',   'failed at #258')
  call g:assert.equals(getline(3), '(',   'failed at #258')
  call g:assert.equals(getline(4), 'foo', 'failed at #258')
  call g:assert.equals(getline(5), ')',   'failed at #258')
  call g:assert.equals(getline(6), ']',   'failed at #258')
  call g:assert.equals(getline(7), '}',   'failed at #258')

  %delete

  """ on
  " #259
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #259')
  call g:assert.equals(getline(2), '(',   'failed at #259')
  call g:assert.equals(getline(3), '(',   'failed at #259')
  call g:assert.equals(getline(4), 'foo', 'failed at #259')
  call g:assert.equals(getline(5), ')',   'failed at #259')
  call g:assert.equals(getline(6), ')',   'failed at #259')
  call g:assert.equals(getline(7), ')',   'failed at #259')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #260
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #260')
  call g:assert.equals(getline(2), 'foo', 'failed at #260')
  call g:assert.equals(getline(3), '1+2', 'failed at #260')

  %delete

  """ 1
  " #261
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #261')
  call g:assert.equals(getline(2), 'foo', 'failed at #261')
  call g:assert.equals(getline(3), '3',   'failed at #261')

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
  " #262
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #262')
  call g:assert.equals(getline(2), 'foo', 'failed at #262')
  call g:assert.equals(getline(3), ']]',  'failed at #262')

  %delete

  """ off
  " #263
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #263')
  call g:assert.equals(getline(2), 'foo', 'failed at #263')
  call g:assert.equals(getline(3), '}}',  'failed at #263')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #264
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #264')
  call g:assert.equals(getline(2), 'foo ', 'failed at #264')
  call g:assert.equals(getline(3), ')',    'failed at #264')

  %delete

  """ off
  " #265
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #265')
  call g:assert.equals(getline(2), 'foo ', 'failed at #265')
  call g:assert.equals(getline(3), ')',    'failed at #265')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #266
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(', 'failed at #266')
  call g:assert.equals(getline(2), '',  'failed at #266')
  call g:assert.equals(getline(3), ')', 'failed at #266')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #267
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #267')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #268
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #268')
  call g:assert.equals(getline(2),   '    foo',    'failed at #268')
  call g:assert.equals(getline(3),   '    )',      'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #268')

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

  " #269
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #269')
  call g:assert.equals(getline(2),   '[',          'failed at #269')
  call g:assert.equals(getline(3),   '',           'failed at #269')
  call g:assert.equals(getline(4),   '    foo',    'failed at #269')
  call g:assert.equals(getline(5),   '',           'failed at #269')
  call g:assert.equals(getline(6),   ']',          'failed at #269')
  call g:assert.equals(getline(7),   '}',          'failed at #269')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #269')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #269')
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
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #270')
  call g:assert.equals(getline(2),   '    [',      'failed at #270')
  call g:assert.equals(getline(3),   '',           'failed at #270')
  call g:assert.equals(getline(4),   '    foo',    'failed at #270')
  call g:assert.equals(getline(5),   '',           'failed at #270')
  call g:assert.equals(getline(6),   '    ]',      'failed at #270')
  call g:assert.equals(getline(7),   '    }',      'failed at #270')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #270')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #270')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #270')
  call g:assert.equals(&l:autoindent,  1,          'failed at #270')
  call g:assert.equals(&l:smartindent, 0,          'failed at #270')
  call g:assert.equals(&l:cindent,     0,          'failed at #270')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #270')

  %delete

  " #271
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #271')
  call g:assert.equals(getline(2),   '    [',       'failed at #271')
  call g:assert.equals(getline(3),   '',            'failed at #271')
  call g:assert.equals(getline(4),   '    foo',     'failed at #271')
  call g:assert.equals(getline(5),   '',            'failed at #271')
  call g:assert.equals(getline(6),   '    ]',       'failed at #271')
  call g:assert.equals(getline(7),   '}',           'failed at #271')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #271')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #271')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #271')
  call g:assert.equals(&l:autoindent,  1,           'failed at #271')
  call g:assert.equals(&l:smartindent, 1,           'failed at #271')
  call g:assert.equals(&l:cindent,     0,           'failed at #271')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #271')

  %delete

  " #272
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #272')
  call g:assert.equals(getline(2),   '    [',       'failed at #272')
  call g:assert.equals(getline(3),   '',            'failed at #272')
  call g:assert.equals(getline(4),   '    foo',     'failed at #272')
  call g:assert.equals(getline(5),   '',            'failed at #272')
  call g:assert.equals(getline(6),   '    ]',       'failed at #272')
  call g:assert.equals(getline(7),   '    }',       'failed at #272')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #272')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #272')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #272')
  call g:assert.equals(&l:autoindent,  1,           'failed at #272')
  call g:assert.equals(&l:smartindent, 1,           'failed at #272')
  call g:assert.equals(&l:cindent,     1,           'failed at #272')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #272')

  %delete

  " #273
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',            'failed at #273')
  call g:assert.equals(getline(2),   '           [',        'failed at #273')
  call g:assert.equals(getline(3),   '',                    'failed at #273')
  call g:assert.equals(getline(4),   '    foo',             'failed at #273')
  call g:assert.equals(getline(5),   '',                    'failed at #273')
  call g:assert.equals(getline(6),   '        ]',           'failed at #273')
  call g:assert.equals(getline(7),   '                }',   'failed at #273')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #273')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #273')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #273')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #273')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #273')
  call g:assert.equals(&l:cindent,     1,                   'failed at #273')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #273')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #274
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #274')
  call g:assert.equals(getline(2),   '[',          'failed at #274')
  call g:assert.equals(getline(3),   '',           'failed at #274')
  call g:assert.equals(getline(4),   '    foo',    'failed at #274')
  call g:assert.equals(getline(5),   '',           'failed at #274')
  call g:assert.equals(getline(6),   ']',          'failed at #274')
  call g:assert.equals(getline(7),   '}',          'failed at #274')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #274')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #274')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #274')
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
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #275')
  call g:assert.equals(getline(2),   '[',          'failed at #275')
  call g:assert.equals(getline(3),   '',           'failed at #275')
  call g:assert.equals(getline(4),   '    foo',    'failed at #275')
  call g:assert.equals(getline(5),   '',           'failed at #275')
  call g:assert.equals(getline(6),   ']',          'failed at #275')
  call g:assert.equals(getline(7),   '}',          'failed at #275')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #275')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #275')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #275')
  call g:assert.equals(&l:autoindent,  1,          'failed at #275')
  call g:assert.equals(&l:smartindent, 0,          'failed at #275')
  call g:assert.equals(&l:cindent,     0,          'failed at #275')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #275')

  %delete

  " #276
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #276')
  call g:assert.equals(getline(2),   '[',          'failed at #276')
  call g:assert.equals(getline(3),   '',           'failed at #276')
  call g:assert.equals(getline(4),   '    foo',    'failed at #276')
  call g:assert.equals(getline(5),   '',           'failed at #276')
  call g:assert.equals(getline(6),   ']',          'failed at #276')
  call g:assert.equals(getline(7),   '}',          'failed at #276')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #276')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #276')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #276')
  call g:assert.equals(&l:autoindent,  1,          'failed at #276')
  call g:assert.equals(&l:smartindent, 1,          'failed at #276')
  call g:assert.equals(&l:cindent,     0,          'failed at #276')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #276')

  %delete

  " #277
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #277')
  call g:assert.equals(getline(2),   '[',          'failed at #277')
  call g:assert.equals(getline(3),   '',           'failed at #277')
  call g:assert.equals(getline(4),   '    foo',    'failed at #277')
  call g:assert.equals(getline(5),   '',           'failed at #277')
  call g:assert.equals(getline(6),   ']',          'failed at #277')
  call g:assert.equals(getline(7),   '}',          'failed at #277')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #277')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #277')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #277')
  call g:assert.equals(&l:autoindent,  1,          'failed at #277')
  call g:assert.equals(&l:smartindent, 1,          'failed at #277')
  call g:assert.equals(&l:cindent,     1,          'failed at #277')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #277')

  %delete

  " #278
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #278')
  call g:assert.equals(getline(2),   '[',              'failed at #278')
  call g:assert.equals(getline(3),   '',               'failed at #278')
  call g:assert.equals(getline(4),   '    foo',        'failed at #278')
  call g:assert.equals(getline(5),   '',               'failed at #278')
  call g:assert.equals(getline(6),   ']',              'failed at #278')
  call g:assert.equals(getline(7),   '}',              'failed at #278')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #278')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #278')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #278')
  call g:assert.equals(&l:autoindent,  1,              'failed at #278')
  call g:assert.equals(&l:smartindent, 1,              'failed at #278')
  call g:assert.equals(&l:cindent,     1,              'failed at #278')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #278')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #279
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #279')
  call g:assert.equals(getline(2),   '    [',      'failed at #279')
  call g:assert.equals(getline(3),   '',           'failed at #279')
  call g:assert.equals(getline(4),   '    foo',    'failed at #279')
  call g:assert.equals(getline(5),   '',           'failed at #279')
  call g:assert.equals(getline(6),   '    ]',      'failed at #279')
  call g:assert.equals(getline(7),   '    }',      'failed at #279')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #279')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #279')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #279')
  call g:assert.equals(&l:autoindent,  0,          'failed at #279')
  call g:assert.equals(&l:smartindent, 0,          'failed at #279')
  call g:assert.equals(&l:cindent,     0,          'failed at #279')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #279')

  %delete

  " #280
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #280')
  call g:assert.equals(getline(2),   '    [',      'failed at #280')
  call g:assert.equals(getline(3),   '',           'failed at #280')
  call g:assert.equals(getline(4),   '    foo',    'failed at #280')
  call g:assert.equals(getline(5),   '',           'failed at #280')
  call g:assert.equals(getline(6),   '    ]',      'failed at #280')
  call g:assert.equals(getline(7),   '    }',      'failed at #280')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #280')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #280')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #280')
  call g:assert.equals(&l:autoindent,  1,          'failed at #280')
  call g:assert.equals(&l:smartindent, 0,          'failed at #280')
  call g:assert.equals(&l:cindent,     0,          'failed at #280')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #280')

  %delete

  " #281
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #281')
  call g:assert.equals(getline(2),   '    [',      'failed at #281')
  call g:assert.equals(getline(3),   '',           'failed at #281')
  call g:assert.equals(getline(4),   '    foo',    'failed at #281')
  call g:assert.equals(getline(5),   '',           'failed at #281')
  call g:assert.equals(getline(6),   '    ]',      'failed at #281')
  call g:assert.equals(getline(7),   '    }',      'failed at #281')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #281')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #281')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #281')
  call g:assert.equals(&l:autoindent,  1,          'failed at #281')
  call g:assert.equals(&l:smartindent, 1,          'failed at #281')
  call g:assert.equals(&l:cindent,     0,          'failed at #281')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #281')

  %delete

  " #282
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #282')
  call g:assert.equals(getline(2),   '    [',      'failed at #282')
  call g:assert.equals(getline(3),   '',           'failed at #282')
  call g:assert.equals(getline(4),   '    foo',    'failed at #282')
  call g:assert.equals(getline(5),   '',           'failed at #282')
  call g:assert.equals(getline(6),   '    ]',      'failed at #282')
  call g:assert.equals(getline(7),   '    }',      'failed at #282')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #282')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #282')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #282')
  call g:assert.equals(&l:autoindent,  1,          'failed at #282')
  call g:assert.equals(&l:smartindent, 1,          'failed at #282')
  call g:assert.equals(&l:cindent,     1,          'failed at #282')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #282')

  %delete

  " #283
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',          'failed at #283')
  call g:assert.equals(getline(2),   '    [',          'failed at #283')
  call g:assert.equals(getline(3),   '',               'failed at #283')
  call g:assert.equals(getline(4),   '    foo',        'failed at #283')
  call g:assert.equals(getline(5),   '',               'failed at #283')
  call g:assert.equals(getline(6),   '    ]',          'failed at #283')
  call g:assert.equals(getline(7),   '    }',          'failed at #283')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #283')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #283')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #283')
  call g:assert.equals(&l:autoindent,  1,              'failed at #283')
  call g:assert.equals(&l:smartindent, 1,              'failed at #283')
  call g:assert.equals(&l:cindent,     1,              'failed at #283')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #283')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #284
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #284')
  call g:assert.equals(getline(2),   '    [',       'failed at #284')
  call g:assert.equals(getline(3),   '',            'failed at #284')
  call g:assert.equals(getline(4),   '    foo',     'failed at #284')
  call g:assert.equals(getline(5),   '',            'failed at #284')
  call g:assert.equals(getline(6),   '    ]',       'failed at #284')
  call g:assert.equals(getline(7),   '}',           'failed at #284')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #284')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #284')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #284')
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
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #285')
  call g:assert.equals(getline(2),   '    [',       'failed at #285')
  call g:assert.equals(getline(3),   '',            'failed at #285')
  call g:assert.equals(getline(4),   '    foo',     'failed at #285')
  call g:assert.equals(getline(5),   '',            'failed at #285')
  call g:assert.equals(getline(6),   '    ]',       'failed at #285')
  call g:assert.equals(getline(7),   '}',           'failed at #285')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #285')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #285')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #285')
  call g:assert.equals(&l:autoindent,  1,           'failed at #285')
  call g:assert.equals(&l:smartindent, 0,           'failed at #285')
  call g:assert.equals(&l:cindent,     0,           'failed at #285')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #285')

  %delete

  " #286
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #286')
  call g:assert.equals(getline(2),   '    [',       'failed at #286')
  call g:assert.equals(getline(3),   '',            'failed at #286')
  call g:assert.equals(getline(4),   '    foo',     'failed at #286')
  call g:assert.equals(getline(5),   '',            'failed at #286')
  call g:assert.equals(getline(6),   '    ]',       'failed at #286')
  call g:assert.equals(getline(7),   '}',           'failed at #286')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #286')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #286')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #286')
  call g:assert.equals(&l:autoindent,  1,           'failed at #286')
  call g:assert.equals(&l:smartindent, 1,           'failed at #286')
  call g:assert.equals(&l:cindent,     0,           'failed at #286')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #286')

  %delete

  " #287
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #287')
  call g:assert.equals(getline(2),   '    [',       'failed at #287')
  call g:assert.equals(getline(3),   '',            'failed at #287')
  call g:assert.equals(getline(4),   '    foo',     'failed at #287')
  call g:assert.equals(getline(5),   '',            'failed at #287')
  call g:assert.equals(getline(6),   '    ]',       'failed at #287')
  call g:assert.equals(getline(7),   '}',           'failed at #287')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #287')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #287')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #287')
  call g:assert.equals(&l:autoindent,  1,           'failed at #287')
  call g:assert.equals(&l:smartindent, 1,           'failed at #287')
  call g:assert.equals(&l:cindent,     1,           'failed at #287')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #287')

  %delete

  " #288
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #288')
  call g:assert.equals(getline(2),   '    [',          'failed at #288')
  call g:assert.equals(getline(3),   '',               'failed at #288')
  call g:assert.equals(getline(4),   '    foo',        'failed at #288')
  call g:assert.equals(getline(5),   '',               'failed at #288')
  call g:assert.equals(getline(6),   '    ]',          'failed at #288')
  call g:assert.equals(getline(7),   '}',              'failed at #288')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #288')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #288')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #288')
  call g:assert.equals(&l:autoindent,  1,              'failed at #288')
  call g:assert.equals(&l:smartindent, 1,              'failed at #288')
  call g:assert.equals(&l:cindent,     1,              'failed at #288')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #288')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #289
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #289')
  call g:assert.equals(getline(2),   '    [',       'failed at #289')
  call g:assert.equals(getline(3),   '',            'failed at #289')
  call g:assert.equals(getline(4),   '    foo',     'failed at #289')
  call g:assert.equals(getline(5),   '',            'failed at #289')
  call g:assert.equals(getline(6),   '    ]',       'failed at #289')
  call g:assert.equals(getline(7),   '    }',       'failed at #289')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #289')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #289')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #289')
  call g:assert.equals(&l:autoindent,  0,           'failed at #289')
  call g:assert.equals(&l:smartindent, 0,           'failed at #289')
  call g:assert.equals(&l:cindent,     0,           'failed at #289')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #289')

  %delete

  " #290
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #290')
  call g:assert.equals(getline(2),   '    [',       'failed at #290')
  call g:assert.equals(getline(3),   '',            'failed at #290')
  call g:assert.equals(getline(4),   '    foo',     'failed at #290')
  call g:assert.equals(getline(5),   '',            'failed at #290')
  call g:assert.equals(getline(6),   '    ]',       'failed at #290')
  call g:assert.equals(getline(7),   '    }',       'failed at #290')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #290')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #290')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #290')
  call g:assert.equals(&l:autoindent,  1,           'failed at #290')
  call g:assert.equals(&l:smartindent, 0,           'failed at #290')
  call g:assert.equals(&l:cindent,     0,           'failed at #290')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #290')

  %delete

  " #291
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #291')
  call g:assert.equals(getline(2),   '    [',       'failed at #291')
  call g:assert.equals(getline(3),   '',            'failed at #291')
  call g:assert.equals(getline(4),   '    foo',     'failed at #291')
  call g:assert.equals(getline(5),   '',            'failed at #291')
  call g:assert.equals(getline(6),   '    ]',       'failed at #291')
  call g:assert.equals(getline(7),   '    }',       'failed at #291')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #291')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #291')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #291')
  call g:assert.equals(&l:autoindent,  1,           'failed at #291')
  call g:assert.equals(&l:smartindent, 1,           'failed at #291')
  call g:assert.equals(&l:cindent,     0,           'failed at #291')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #291')

  %delete

  " #292
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #292')
  call g:assert.equals(getline(2),   '    [',       'failed at #292')
  call g:assert.equals(getline(3),   '',            'failed at #292')
  call g:assert.equals(getline(4),   '    foo',     'failed at #292')
  call g:assert.equals(getline(5),   '',            'failed at #292')
  call g:assert.equals(getline(6),   '    ]',       'failed at #292')
  call g:assert.equals(getline(7),   '    }',       'failed at #292')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #292')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #292')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #292')
  call g:assert.equals(&l:autoindent,  1,           'failed at #292')
  call g:assert.equals(&l:smartindent, 1,           'failed at #292')
  call g:assert.equals(&l:cindent,     1,           'failed at #292')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #292')

  %delete

  " #293
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #293')
  call g:assert.equals(getline(2),   '    [',          'failed at #293')
  call g:assert.equals(getline(3),   '',               'failed at #293')
  call g:assert.equals(getline(4),   '    foo',        'failed at #293')
  call g:assert.equals(getline(5),   '',               'failed at #293')
  call g:assert.equals(getline(6),   '    ]',          'failed at #293')
  call g:assert.equals(getline(7),   '    }',          'failed at #293')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #293')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #293')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #293')
  call g:assert.equals(&l:autoindent,  1,              'failed at #293')
  call g:assert.equals(&l:smartindent, 1,              'failed at #293')
  call g:assert.equals(&l:cindent,     1,              'failed at #293')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #293')
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

  " #294
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #294')
  call g:assert.equals(getline(2),   '',           'failed at #294')
  call g:assert.equals(getline(3),   '    foo',    'failed at #294')
  call g:assert.equals(getline(4),   '',           'failed at #294')
  call g:assert.equals(getline(5),   '    }',      'failed at #294')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #294')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #294')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #294')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #294')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #295
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #295')
  call g:assert.equals(getline(2),   '',           'failed at #295')
  call g:assert.equals(getline(3),   '    foo',    'failed at #295')
  call g:assert.equals(getline(4),   '',           'failed at #295')
  call g:assert.equals(getline(5),   '    }',      'failed at #295')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #295')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #295')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #295')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #295')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #296
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #296')
  call g:assert.equals(getline(2),   '',           'failed at #296')
  call g:assert.equals(getline(3),   '    foo',    'failed at #296')
  call g:assert.equals(getline(4),   '',           'failed at #296')
  call g:assert.equals(getline(5),   '    }',      'failed at #296')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #296')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #296')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #296')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #296')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #297
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #297')
  call g:assert.equals(getline(2),   '',              'failed at #297')
  call g:assert.equals(getline(3),   '    foo',       'failed at #297')
  call g:assert.equals(getline(4),   '',              'failed at #297')
  call g:assert.equals(getline(5),   '    }',         'failed at #297')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #297')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #297')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #297')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #297')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #297')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #298
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',      'failed at #298')
  call g:assert.equals(getline(2),   '',              'failed at #298')
  call g:assert.equals(getline(3),   '    foo',       'failed at #298')
  call g:assert.equals(getline(4),   '',              'failed at #298')
  call g:assert.equals(getline(5),   '            }', 'failed at #298')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #298')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #298')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #298')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #298')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #298')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #299
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #299')
  call g:assert.equals(getline(2),   '',              'failed at #299')
  call g:assert.equals(getline(3),   '    foo',       'failed at #299')
  call g:assert.equals(getline(4),   '',              'failed at #299')
  call g:assert.equals(getline(5),   '    }',         'failed at #299')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #299')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #299')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #299')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #299')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #299')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #300
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #300')
  call g:assert.equals(getline(2),   'foo',        'failed at #300')
  call g:assert.equals(getline(3),   ')',          'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #300')

  %delete

  " #301
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #301')
  call g:assert.equals(getline(2),   'foo',        'failed at #301')
  call g:assert.equals(getline(3),   ')',          'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #301')

  %delete

  " #302
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #302')
  call g:assert.equals(getline(2),   'foo',        'failed at #302')
  call g:assert.equals(getline(3),   ']',          'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #302')

  %delete

  " #303
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #303')
  call g:assert.equals(getline(2),   'foo',        'failed at #303')
  call g:assert.equals(getline(3),   ']',          'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #303')

  %delete

  " #304
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #304')
  call g:assert.equals(getline(2),   'foo',        'failed at #304')
  call g:assert.equals(getline(3),   '}',          'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #304')

  %delete

  " #305
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #305')
  call g:assert.equals(getline(2),   'foo',        'failed at #305')
  call g:assert.equals(getline(3),   '}',          'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #305')

  %delete

  " #306
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #306')
  call g:assert.equals(getline(2),   'foo',        'failed at #306')
  call g:assert.equals(getline(3),   '>',          'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #306')

  %delete

  " #307
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #307')
  call g:assert.equals(getline(2),   'foo',        'failed at #307')
  call g:assert.equals(getline(3),   '>',          'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #307')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #308
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #308')
  call g:assert.equals(getline(2), 'foo',          'failed at #308')
  call g:assert.equals(getline(3), 'a',            'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #308')

  %delete

  " #309
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #309')
  call g:assert.equals(getline(2), 'foo',          'failed at #309')
  call g:assert.equals(getline(3), '*',            'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #309')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #310
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #310')
  call g:assert.equals(getline(2),   'foo',        'failed at #310')
  call g:assert.equals(getline(3),   'bar',        'failed at #310')
  call g:assert.equals(getline(4),   'baz',        'failed at #310')
  call g:assert.equals(getline(5),   ')',          'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #310')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #311
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #311')
  call g:assert.equals(getline(2),   'a',          'failed at #311')
  call g:assert.equals(getline(3),   ')',          'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #311')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #312
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #312')
  call g:assert.equals(getline(2),   'aaa',        'failed at #312')
  call g:assert.equals(getline(3),   'foo',        'failed at #312')
  call g:assert.equals(getline(4),   'aaa',        'failed at #312')
  call g:assert.equals(getline(5),   'aa',         'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #312')

  %delete

  " #313
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #313')
  call g:assert.equals(getline(2),   'bbb',        'failed at #313')
  call g:assert.equals(getline(3),   'bb',         'failed at #313')
  call g:assert.equals(getline(4),   'foo',        'failed at #313')
  call g:assert.equals(getline(5),   'bb',         'failed at #313')
  call g:assert.equals(getline(6),   'bbb',        'failed at #313')
  call g:assert.equals(getline(7),   'bb',         'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #313')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #314
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #314')
  call g:assert.equals(getline(2),   '(',          'failed at #314')
  call g:assert.equals(getline(3),   'foo',        'failed at #314')
  call g:assert.equals(getline(4),   ')',          'failed at #314')
  call g:assert.equals(getline(5),   ']',          'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #314')

  %delete

  " #315
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #315')
  call g:assert.equals(getline(2),   '[',          'failed at #315')
  call g:assert.equals(getline(3),   '(',          'failed at #315')
  call g:assert.equals(getline(4),   'foo',        'failed at #315')
  call g:assert.equals(getline(5),   ')',          'failed at #315')
  call g:assert.equals(getline(6),   ']',          'failed at #315')
  call g:assert.equals(getline(7),   '}',          'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #315')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #316
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #316')
  call g:assert.equals(getline(2),   '(',          'failed at #316')
  call g:assert.equals(getline(3),   'foo',        'failed at #316')
  call g:assert.equals(getline(4),   ')',          'failed at #316')
  call g:assert.equals(getline(5),   ')',          'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #316')

  " #317
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #317')
  call g:assert.equals(getline(2),   '(',          'failed at #317')
  call g:assert.equals(getline(3),   '(',          'failed at #317')
  call g:assert.equals(getline(4),   'foo',        'failed at #317')
  call g:assert.equals(getline(5),   ')',          'failed at #317')
  call g:assert.equals(getline(6),   ')',          'failed at #317')
  call g:assert.equals(getline(7),   ')',          'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #317')

  %delete

  """ keep
  " #318
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #318')
  call g:assert.equals(getline(2),   '(',          'failed at #318')
  call g:assert.equals(getline(3),   'foo',        'failed at #318')
  call g:assert.equals(getline(4),   ')',          'failed at #318')
  call g:assert.equals(getline(5),   ')',          'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #318')

  " #319
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #319')
  call g:assert.equals(getline(2),   '(',          'failed at #319')
  call g:assert.equals(getline(3),   '(',          'failed at #319')
  call g:assert.equals(getline(4),   'foo',        'failed at #319')
  call g:assert.equals(getline(5),   ')',          'failed at #319')
  call g:assert.equals(getline(6),   ')',          'failed at #319')
  call g:assert.equals(getline(7),   ')',          'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #319')

  %delete

  """ inner_tail
  " #320
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #320')
  call g:assert.equals(getline(2),   '(',          'failed at #320')
  call g:assert.equals(getline(3),   'foo',        'failed at #320')
  call g:assert.equals(getline(4),   ')',          'failed at #320')
  call g:assert.equals(getline(5),   ')',          'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #320')

  " #321
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #321')
  call g:assert.equals(getline(2),   '(',          'failed at #321')
  call g:assert.equals(getline(3),   '(',          'failed at #321')
  call g:assert.equals(getline(4),   'foo',        'failed at #321')
  call g:assert.equals(getline(5),   ')',          'failed at #321')
  call g:assert.equals(getline(6),   ')',          'failed at #321')
  call g:assert.equals(getline(7),   ')',          'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #321')

  %delete

  """ head
  " #322
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #322')
  call g:assert.equals(getline(2),   '(',          'failed at #322')
  call g:assert.equals(getline(3),   'foo',        'failed at #322')
  call g:assert.equals(getline(4),   ')',          'failed at #322')
  call g:assert.equals(getline(5),   ')',          'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #322')

  " #323
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #323')
  call g:assert.equals(getline(2),   '(',          'failed at #323')
  call g:assert.equals(getline(3),   '(',          'failed at #323')
  call g:assert.equals(getline(4),   'foo',        'failed at #323')
  call g:assert.equals(getline(5),   ')',          'failed at #323')
  call g:assert.equals(getline(6),   ')',          'failed at #323')
  call g:assert.equals(getline(7),   ')',          'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #323')

  %delete

  """ tail
  " #324
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #324')
  call g:assert.equals(getline(2),   '(',          'failed at #324')
  call g:assert.equals(getline(3),   'foo',        'failed at #324')
  call g:assert.equals(getline(4),   ')',          'failed at #324')
  call g:assert.equals(getline(5),   ')',          'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #324')

  " #325
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #325')
  call g:assert.equals(getline(2),   '(',          'failed at #325')
  call g:assert.equals(getline(3),   '(',          'failed at #325')
  call g:assert.equals(getline(4),   'foo',        'failed at #325')
  call g:assert.equals(getline(5),   ')',          'failed at #325')
  call g:assert.equals(getline(6),   ')',          'failed at #325')
  call g:assert.equals(getline(7),   ')',          'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #325')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #326
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #326')
  call g:assert.equals(getline(2), '[',   'failed at #326')
  call g:assert.equals(getline(3), '(',   'failed at #326')
  call g:assert.equals(getline(4), 'foo', 'failed at #326')
  call g:assert.equals(getline(5), ')',   'failed at #326')
  call g:assert.equals(getline(6), ']',   'failed at #326')
  call g:assert.equals(getline(7), '}',   'failed at #326')

  %delete

  """ on
  " #327
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #327')
  call g:assert.equals(getline(2), '(',   'failed at #327')
  call g:assert.equals(getline(3), '(',   'failed at #327')
  call g:assert.equals(getline(4), 'foo', 'failed at #327')
  call g:assert.equals(getline(5), ')',   'failed at #327')
  call g:assert.equals(getline(6), ')',   'failed at #327')
  call g:assert.equals(getline(7), ')',   'failed at #327')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #328
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #328')
  call g:assert.equals(getline(2), 'foo', 'failed at #328')
  call g:assert.equals(getline(3), '1+2', 'failed at #328')

  %delete

  """ 1
  " #329
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #329')
  call g:assert.equals(getline(2), 'foo', 'failed at #329')
  call g:assert.equals(getline(3), '3',   'failed at #329')

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
  " #330
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #330')
  call g:assert.equals(getline(2), 'foo', 'failed at #330')
  call g:assert.equals(getline(3), ']]',  'failed at #330')

  %delete

  """ off
  " #331
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #331')
  call g:assert.equals(getline(2), 'foo', 'failed at #331')
  call g:assert.equals(getline(3), '}}',  'failed at #331')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #332
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #332')
  call g:assert.equals(getline(2), 'foo ', 'failed at #332')
  call g:assert.equals(getline(3), ')',    'failed at #332')

  %delete

  """ off
  " #333
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #333')
  call g:assert.equals(getline(2), 'foo ', 'failed at #333')
  call g:assert.equals(getline(3), ')',    'failed at #333')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #334
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(', 'failed at #334')
  call g:assert.equals(getline(2), '',  'failed at #334')
  call g:assert.equals(getline(3), ')', 'failed at #334')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #335
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #335')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #336
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #336')
  call g:assert.equals(getline(2),   '    foo',    'failed at #336')
  call g:assert.equals(getline(3),   '    )',      'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #336')

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

  " #337
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #337')
  call g:assert.equals(getline(2),   '[',          'failed at #337')
  call g:assert.equals(getline(3),   '',           'failed at #337')
  call g:assert.equals(getline(4),   '    foo',    'failed at #337')
  call g:assert.equals(getline(5),   '',           'failed at #337')
  call g:assert.equals(getline(6),   ']',          'failed at #337')
  call g:assert.equals(getline(7),   '}',          'failed at #337')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #337')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #337')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #337')
  call g:assert.equals(&l:autoindent,  0,          'failed at #337')
  call g:assert.equals(&l:smartindent, 0,          'failed at #337')
  call g:assert.equals(&l:cindent,     0,          'failed at #337')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #337')

  %delete

  " #338
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #338')
  call g:assert.equals(getline(2),   '    [',      'failed at #338')
  call g:assert.equals(getline(3),   '',           'failed at #338')
  call g:assert.equals(getline(4),   '    foo',    'failed at #338')
  call g:assert.equals(getline(5),   '',           'failed at #338')
  call g:assert.equals(getline(6),   '    ]',      'failed at #338')
  call g:assert.equals(getline(7),   '    }',      'failed at #338')
  " call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #338')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #338')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #338')
  call g:assert.equals(&l:autoindent,  1,          'failed at #338')
  call g:assert.equals(&l:smartindent, 0,          'failed at #338')
  call g:assert.equals(&l:cindent,     0,          'failed at #338')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #338')

  %delete

  " #339
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #339')
  call g:assert.equals(getline(2),   '    [',       'failed at #339')
  call g:assert.equals(getline(3),   '',            'failed at #339')
  call g:assert.equals(getline(4),   '    foo',     'failed at #339')
  call g:assert.equals(getline(5),   '',            'failed at #339')
  call g:assert.equals(getline(6),   '    ]',       'failed at #339')
  call g:assert.equals(getline(7),   '}',           'failed at #339')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #339')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #339')
  " call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #339')
  call g:assert.equals(&l:autoindent,  1,           'failed at #339')
  call g:assert.equals(&l:smartindent, 1,           'failed at #339')
  call g:assert.equals(&l:cindent,     0,           'failed at #339')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #339')

  %delete

  " #340
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #340')
  call g:assert.equals(getline(2),   '    [',       'failed at #340')
  call g:assert.equals(getline(3),   '',            'failed at #340')
  call g:assert.equals(getline(4),   '    foo',     'failed at #340')
  call g:assert.equals(getline(5),   '',            'failed at #340')
  call g:assert.equals(getline(6),   '    ]',       'failed at #340')
  call g:assert.equals(getline(7),   '    }',       'failed at #340')
  " call g:assert.equals(getpos('.'),  [0, 4, 9, 0],  'failed at #340')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #340')
  " call g:assert.equals(getpos("']"), [0, 7, 6, 0],  'failed at #340')
  call g:assert.equals(&l:autoindent,  1,           'failed at #340')
  call g:assert.equals(&l:smartindent, 1,           'failed at #340')
  call g:assert.equals(&l:cindent,     1,           'failed at #340')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #340')

  %delete

  " #341
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',            'failed at #341')
  call g:assert.equals(getline(2),   '           [',        'failed at #341')
  call g:assert.equals(getline(3),   '',                    'failed at #341')
  call g:assert.equals(getline(4),   '    foo',             'failed at #341')
  call g:assert.equals(getline(5),   '',                    'failed at #341')
  call g:assert.equals(getline(6),   '        ]',           'failed at #341')
  call g:assert.equals(getline(7),   '                }',   'failed at #341')
  " call g:assert.equals(getpos('.'),  [0, 4, 17, 0],         'failed at #341')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #341')
  " call g:assert.equals(getpos("']"), [0, 7, 18, 0],         'failed at #341')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #341')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #341')
  call g:assert.equals(&l:cindent,     1,                   'failed at #341')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #341')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #342
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #342')
  call g:assert.equals(getline(2),   '[',          'failed at #342')
  call g:assert.equals(getline(3),   '',           'failed at #342')
  call g:assert.equals(getline(4),   '    foo',    'failed at #342')
  call g:assert.equals(getline(5),   '',           'failed at #342')
  call g:assert.equals(getline(6),   ']',          'failed at #342')
  call g:assert.equals(getline(7),   '}',          'failed at #342')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #342')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #342')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #342')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #343')
  call g:assert.equals(getline(2),   '[',          'failed at #343')
  call g:assert.equals(getline(3),   '',           'failed at #343')
  call g:assert.equals(getline(4),   '    foo',    'failed at #343')
  call g:assert.equals(getline(5),   '',           'failed at #343')
  call g:assert.equals(getline(6),   ']',          'failed at #343')
  call g:assert.equals(getline(7),   '}',          'failed at #343')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #343')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #343')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #343')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #344')
  call g:assert.equals(getline(2),   '[',          'failed at #344')
  call g:assert.equals(getline(3),   '',           'failed at #344')
  call g:assert.equals(getline(4),   '    foo',    'failed at #344')
  call g:assert.equals(getline(5),   '',           'failed at #344')
  call g:assert.equals(getline(6),   ']',          'failed at #344')
  call g:assert.equals(getline(7),   '}',          'failed at #344')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #344')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #344')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #344')
  call g:assert.equals(&l:autoindent,  1,          'failed at #344')
  call g:assert.equals(&l:smartindent, 1,          'failed at #344')
  call g:assert.equals(&l:cindent,     0,          'failed at #344')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #344')

  %delete

  " #345
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #345')
  call g:assert.equals(getline(2),   '[',          'failed at #345')
  call g:assert.equals(getline(3),   '',           'failed at #345')
  call g:assert.equals(getline(4),   '    foo',    'failed at #345')
  call g:assert.equals(getline(5),   '',           'failed at #345')
  call g:assert.equals(getline(6),   ']',          'failed at #345')
  call g:assert.equals(getline(7),   '}',          'failed at #345')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #345')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #345')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #345')
  call g:assert.equals(&l:autoindent,  1,          'failed at #345')
  call g:assert.equals(&l:smartindent, 1,          'failed at #345')
  call g:assert.equals(&l:cindent,     1,          'failed at #345')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #345')

  %delete

  " #346
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #346')
  call g:assert.equals(getline(2),   '[',              'failed at #346')
  call g:assert.equals(getline(3),   '',               'failed at #346')
  call g:assert.equals(getline(4),   '    foo',        'failed at #346')
  call g:assert.equals(getline(5),   '',               'failed at #346')
  call g:assert.equals(getline(6),   ']',              'failed at #346')
  call g:assert.equals(getline(7),   '}',              'failed at #346')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #346')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #346')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #346')
  call g:assert.equals(&l:autoindent,  1,              'failed at #346')
  call g:assert.equals(&l:smartindent, 1,              'failed at #346')
  call g:assert.equals(&l:cindent,     1,              'failed at #346')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #346')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #347
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #347')
  call g:assert.equals(getline(2),   '    [',      'failed at #347')
  call g:assert.equals(getline(3),   '',           'failed at #347')
  call g:assert.equals(getline(4),   '    foo',    'failed at #347')
  call g:assert.equals(getline(5),   '',           'failed at #347')
  call g:assert.equals(getline(6),   '    ]',      'failed at #347')
  call g:assert.equals(getline(7),   '    }',      'failed at #347')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #347')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #347')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #347')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #348')
  call g:assert.equals(getline(2),   '    [',      'failed at #348')
  call g:assert.equals(getline(3),   '',           'failed at #348')
  call g:assert.equals(getline(4),   '    foo',    'failed at #348')
  call g:assert.equals(getline(5),   '',           'failed at #348')
  call g:assert.equals(getline(6),   '    ]',      'failed at #348')
  call g:assert.equals(getline(7),   '    }',      'failed at #348')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #348')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #348')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #348')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #349')
  call g:assert.equals(getline(2),   '    [',      'failed at #349')
  call g:assert.equals(getline(3),   '',           'failed at #349')
  call g:assert.equals(getline(4),   '    foo',    'failed at #349')
  call g:assert.equals(getline(5),   '',           'failed at #349')
  call g:assert.equals(getline(6),   '    ]',      'failed at #349')
  call g:assert.equals(getline(7),   '    }',      'failed at #349')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #349')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #349')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #349')
  call g:assert.equals(&l:autoindent,  1,          'failed at #349')
  call g:assert.equals(&l:smartindent, 1,          'failed at #349')
  call g:assert.equals(&l:cindent,     0,          'failed at #349')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #349')

  %delete

  " #350
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #350')
  call g:assert.equals(getline(2),   '    [',      'failed at #350')
  call g:assert.equals(getline(3),   '',           'failed at #350')
  call g:assert.equals(getline(4),   '    foo',    'failed at #350')
  call g:assert.equals(getline(5),   '',           'failed at #350')
  call g:assert.equals(getline(6),   '    ]',      'failed at #350')
  call g:assert.equals(getline(7),   '    }',      'failed at #350')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #350')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #350')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #350')
  call g:assert.equals(&l:autoindent,  1,          'failed at #350')
  call g:assert.equals(&l:smartindent, 1,          'failed at #350')
  call g:assert.equals(&l:cindent,     1,          'failed at #350')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #350')

  %delete

  " #351
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #351')
  call g:assert.equals(getline(2),   '    [',          'failed at #351')
  call g:assert.equals(getline(3),   '',               'failed at #351')
  call g:assert.equals(getline(4),   '    foo',        'failed at #351')
  call g:assert.equals(getline(5),   '',               'failed at #351')
  call g:assert.equals(getline(6),   '    ]',          'failed at #351')
  call g:assert.equals(getline(7),   '    }',          'failed at #351')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #351')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #351')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #351')
  call g:assert.equals(&l:autoindent,  1,              'failed at #351')
  call g:assert.equals(&l:smartindent, 1,              'failed at #351')
  call g:assert.equals(&l:cindent,     1,              'failed at #351')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #351')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #352
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #352')
  call g:assert.equals(getline(2),   '    [',       'failed at #352')
  call g:assert.equals(getline(3),   '',            'failed at #352')
  call g:assert.equals(getline(4),   '    foo',     'failed at #352')
  call g:assert.equals(getline(5),   '',            'failed at #352')
  call g:assert.equals(getline(6),   '    ]',       'failed at #352')
  call g:assert.equals(getline(7),   '}',           'failed at #352')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #352')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #352')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #352')
  call g:assert.equals(&l:autoindent,  0,           'failed at #352')
  call g:assert.equals(&l:smartindent, 0,           'failed at #352')
  call g:assert.equals(&l:cindent,     0,           'failed at #352')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #352')

  %delete

  " #353
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #353')
  call g:assert.equals(getline(2),   '    [',       'failed at #353')
  call g:assert.equals(getline(3),   '',            'failed at #353')
  call g:assert.equals(getline(4),   '    foo',     'failed at #353')
  call g:assert.equals(getline(5),   '',            'failed at #353')
  call g:assert.equals(getline(6),   '    ]',       'failed at #353')
  call g:assert.equals(getline(7),   '}',           'failed at #353')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #353')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #353')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #353')
  call g:assert.equals(&l:autoindent,  1,           'failed at #353')
  call g:assert.equals(&l:smartindent, 0,           'failed at #353')
  call g:assert.equals(&l:cindent,     0,           'failed at #353')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #353')

  %delete

  " #354
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #354')
  call g:assert.equals(getline(2),   '    [',       'failed at #354')
  call g:assert.equals(getline(3),   '',            'failed at #354')
  call g:assert.equals(getline(4),   '    foo',     'failed at #354')
  call g:assert.equals(getline(5),   '',            'failed at #354')
  call g:assert.equals(getline(6),   '    ]',       'failed at #354')
  call g:assert.equals(getline(7),   '}',           'failed at #354')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #354')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #354')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #354')
  call g:assert.equals(&l:autoindent,  1,           'failed at #354')
  call g:assert.equals(&l:smartindent, 1,           'failed at #354')
  call g:assert.equals(&l:cindent,     0,           'failed at #354')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #354')

  %delete

  " #355
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #355')
  call g:assert.equals(getline(2),   '    [',       'failed at #355')
  call g:assert.equals(getline(3),   '',            'failed at #355')
  call g:assert.equals(getline(4),   '    foo',     'failed at #355')
  call g:assert.equals(getline(5),   '',            'failed at #355')
  call g:assert.equals(getline(6),   '    ]',       'failed at #355')
  call g:assert.equals(getline(7),   '}',           'failed at #355')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #355')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #355')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #355')
  call g:assert.equals(&l:autoindent,  1,           'failed at #355')
  call g:assert.equals(&l:smartindent, 1,           'failed at #355')
  call g:assert.equals(&l:cindent,     1,           'failed at #355')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #355')

  %delete

  " #356
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #356')
  call g:assert.equals(getline(2),   '    [',          'failed at #356')
  call g:assert.equals(getline(3),   '',               'failed at #356')
  call g:assert.equals(getline(4),   '    foo',        'failed at #356')
  call g:assert.equals(getline(5),   '',               'failed at #356')
  call g:assert.equals(getline(6),   '    ]',          'failed at #356')
  call g:assert.equals(getline(7),   '}',              'failed at #356')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #356')
  " call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #356')
  " call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #356')
  call g:assert.equals(&l:autoindent,  1,              'failed at #356')
  call g:assert.equals(&l:smartindent, 1,              'failed at #356')
  call g:assert.equals(&l:cindent,     1,              'failed at #356')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #356')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #357
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #357')
  call g:assert.equals(getline(2),   '    [',       'failed at #357')
  call g:assert.equals(getline(3),   '',            'failed at #357')
  call g:assert.equals(getline(4),   '    foo',     'failed at #357')
  call g:assert.equals(getline(5),   '',            'failed at #357')
  call g:assert.equals(getline(6),   '    ]',       'failed at #357')
  call g:assert.equals(getline(7),   '    }',       'failed at #357')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #357')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #357')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #357')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #358')
  call g:assert.equals(getline(2),   '    [',       'failed at #358')
  call g:assert.equals(getline(3),   '',            'failed at #358')
  call g:assert.equals(getline(4),   '    foo',     'failed at #358')
  call g:assert.equals(getline(5),   '',            'failed at #358')
  call g:assert.equals(getline(6),   '    ]',       'failed at #358')
  call g:assert.equals(getline(7),   '    }',       'failed at #358')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #358')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #358')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #358')
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
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #359')
  call g:assert.equals(getline(2),   '    [',       'failed at #359')
  call g:assert.equals(getline(3),   '',            'failed at #359')
  call g:assert.equals(getline(4),   '    foo',     'failed at #359')
  call g:assert.equals(getline(5),   '',            'failed at #359')
  call g:assert.equals(getline(6),   '    ]',       'failed at #359')
  call g:assert.equals(getline(7),   '    }',       'failed at #359')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #359')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #359')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #359')
  call g:assert.equals(&l:autoindent,  1,           'failed at #359')
  call g:assert.equals(&l:smartindent, 1,           'failed at #359')
  call g:assert.equals(&l:cindent,     0,           'failed at #359')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #359')

  %delete

  " #360
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #360')
  call g:assert.equals(getline(2),   '    [',       'failed at #360')
  call g:assert.equals(getline(3),   '',            'failed at #360')
  call g:assert.equals(getline(4),   '    foo',     'failed at #360')
  call g:assert.equals(getline(5),   '',            'failed at #360')
  call g:assert.equals(getline(6),   '    ]',       'failed at #360')
  call g:assert.equals(getline(7),   '    }',       'failed at #360')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #360')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #360')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #360')
  call g:assert.equals(&l:autoindent,  1,           'failed at #360')
  call g:assert.equals(&l:smartindent, 1,           'failed at #360')
  call g:assert.equals(&l:cindent,     1,           'failed at #360')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #360')

  %delete

  " #361
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #361')
  call g:assert.equals(getline(2),   '    [',          'failed at #361')
  call g:assert.equals(getline(3),   '',               'failed at #361')
  call g:assert.equals(getline(4),   '    foo',        'failed at #361')
  call g:assert.equals(getline(5),   '',               'failed at #361')
  call g:assert.equals(getline(6),   '    ]',          'failed at #361')
  call g:assert.equals(getline(7),   '    }',          'failed at #361')
  " call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #361')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #361')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #361')
  call g:assert.equals(&l:autoindent,  1,              'failed at #361')
  call g:assert.equals(&l:smartindent, 1,              'failed at #361')
  call g:assert.equals(&l:cindent,     1,              'failed at #361')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #361')
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

  " #362
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #362')
  call g:assert.equals(getline(2),   '',           'failed at #362')
  call g:assert.equals(getline(3),   '    foo',    'failed at #362')
  call g:assert.equals(getline(4),   '',           'failed at #362')
  call g:assert.equals(getline(5),   '    }',      'failed at #362')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #362')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #362')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #362')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #362')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #362')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #363
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #363')
  call g:assert.equals(getline(2),   '',           'failed at #363')
  call g:assert.equals(getline(3),   '    foo',    'failed at #363')
  call g:assert.equals(getline(4),   '',           'failed at #363')
  call g:assert.equals(getline(5),   '    }',      'failed at #363')
  " call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #363')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #363')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #363')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #363')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #364
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #364')
  call g:assert.equals(getline(2),   '',           'failed at #364')
  call g:assert.equals(getline(3),   '    foo',    'failed at #364')
  call g:assert.equals(getline(4),   '',           'failed at #364')
  call g:assert.equals(getline(5),   '    }',      'failed at #364')
  " call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #364')
  " call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #364')
  " call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #364')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #364')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #364')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #365
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #365')
  call g:assert.equals(getline(2),   '',              'failed at #365')
  call g:assert.equals(getline(3),   '    foo',       'failed at #365')
  call g:assert.equals(getline(4),   '',              'failed at #365')
  call g:assert.equals(getline(5),   '    }',         'failed at #365')
  " call g:assert.equals(getpos('.'),  [0, 3,  1, 0],   'failed at #365')
  " call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #365')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #365')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #365')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #365')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #366
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',      'failed at #366')
  call g:assert.equals(getline(2),   '',              'failed at #366')
  call g:assert.equals(getline(3),   '    foo',       'failed at #366')
  call g:assert.equals(getline(4),   '',              'failed at #366')
  call g:assert.equals(getline(5),   '            }', 'failed at #366')
  " call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #366')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #366')
  " call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #366')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #366')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #366')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #367
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #367')
  call g:assert.equals(getline(2),   '',              'failed at #367')
  call g:assert.equals(getline(3),   '    foo',       'failed at #367')
  call g:assert.equals(getline(4),   '',              'failed at #367')
  call g:assert.equals(getline(5),   '    }',         'failed at #367')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #367')
  " call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #367')
  " call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #367')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #367')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #367')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #368
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #368')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #368')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #368')

  %delete

  " #369
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #369')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #369')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #369')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #369')

  %delete

  " #370
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #370')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #370')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #370')

  %delete

  " #371
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #371')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #371')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #371')

  %delete

  " #372
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #372')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #372')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #372')

  %delete

  " #373
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #373')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #373')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #373')

  %delete

  " #374
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #374')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #374')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #374')

  %delete

  " #375
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #375')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #375')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #375')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #376
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #376')
  call g:assert.equals(getline(2),   'abara',      'failed at #376')
  call g:assert.equals(getline(3),   'abaza',      'failed at #376')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #376')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #376')

  %delete

  " #377
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #377')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #377')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #377')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #378
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #378')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #378')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #378')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #378')

  %delete

  " #379
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #379')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #379')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #379')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #379')

  %delete

  " #380
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #380')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #380')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #380')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #380')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #380')

  %delete

  " #381
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #381')
  call g:assert.equals(getline(2),   '',           'failed at #381')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #381')

  %delete

  " #382
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #382')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #382')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #382')

  %delete

  " #383
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #383')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #383')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #383')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #383')

  %delete

  " #384
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #384')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #384')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #384')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #384')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #384')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #385
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #385')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #385')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #385')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #385')

  %delete

  " #386
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #386')
  call g:assert.equals(getline(2),   '(a)',        'failed at #386')
  call g:assert.equals(getline(3),   '(a)',        'failed at #386')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #386')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #386')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #386')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #387
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #387')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #387')
  call g:assert.equals(getline(3),   'aa',         'failed at #387')
  call g:assert.equals(getline(4),   'aa',         'failed at #387')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #387')
  call g:assert.equals(getline(6),   'aa',         'failed at #387')
  call g:assert.equals(getline(7),   'aa',         'failed at #387')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #387')
  call g:assert.equals(getline(9),   'aa',         'failed at #387')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #387')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #387')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #387')

  %delete

  " #388
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #388')
  call g:assert.equals(getline(2),   'bbb',         'failed at #388')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #388')
  call g:assert.equals(getline(4),   'bbb',         'failed at #388')
  call g:assert.equals(getline(5),   'bb',          'failed at #388')
  call g:assert.equals(getline(6),   'bb',          'failed at #388')
  call g:assert.equals(getline(7),   'bbb',         'failed at #388')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #388')
  call g:assert.equals(getline(9),   'bbb',         'failed at #388')
  call g:assert.equals(getline(10),  'bb',          'failed at #388')
  call g:assert.equals(getline(11),  'bb',          'failed at #388')
  call g:assert.equals(getline(12),  'bbb',         'failed at #388')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #388')
  call g:assert.equals(getline(14),  'bbb',         'failed at #388')
  call g:assert.equals(getline(15),  'bb',          'failed at #388')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #388')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #388')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #388')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #389
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #389')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #389')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #389')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #389')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #389')

  %delete

  " #390
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #390')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #390')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #390')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #390')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #390')

  %delete

  " #391
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #391')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #391')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #391')

  %delete

  " #392
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #392')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #392')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #392')

  %delete

  " #393
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #393')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #393')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #393')
  %delete

  " #394
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #394')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #394')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #394')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #394')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #394')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #395
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #395')

  " #396
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #396')

  """ keep
  " #397
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #397')

  " #398
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #398')

  """ inner_tail
  " #399
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #399')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #399')

  " #400
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #400')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #400')

  """ head
  " #401
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #401')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #401')

  " #402
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #402')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #402')

  """ tail
  " #403
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #403')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #403')

  " #404
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #404')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #404')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #405
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #405')

  %delete

  """ on
  " #406
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #406')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #407
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #407')

  """ 1
  " #408
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #408')

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
  " #409
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #409')

  """ off
  " #410
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #410')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #411
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #411')

  """ off
  " #412
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #412')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #413
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '()',  'failed at #413')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #414
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #414')
  call g:assert.equals(getline(2), 'foo', 'failed at #414')
  call g:assert.equals(getline(3), ')',   'failed at #414')

  %delete

  " #415
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #415')
  call g:assert.equals(getline(2),   '    foo',    'failed at #415')
  call g:assert.equals(getline(3),   '    )',      'failed at #415')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #415')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #415')

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

  " #416
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #416')
  call g:assert.equals(getline(2),   '[',          'failed at #416')
  call g:assert.equals(getline(3),   'foo',        'failed at #416')
  call g:assert.equals(getline(4),   ']',          'failed at #416')
  call g:assert.equals(getline(5),   '}',          'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #416')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #417')
  call g:assert.equals(getline(2),   '    [',      'failed at #417')
  call g:assert.equals(getline(3),   '    foo',    'failed at #417')
  call g:assert.equals(getline(4),   '    ]',      'failed at #417')
  call g:assert.equals(getline(5),   '    }',      'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #417')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #417')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #417')
  call g:assert.equals(&l:autoindent,  1,          'failed at #417')
  call g:assert.equals(&l:smartindent, 0,          'failed at #417')
  call g:assert.equals(&l:cindent,     0,          'failed at #417')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #417')

  %delete

  " #418
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #418')
  call g:assert.equals(getline(2),   '        [',   'failed at #418')
  call g:assert.equals(getline(3),   '        foo', 'failed at #418')
  call g:assert.equals(getline(4),   '    ]',       'failed at #418')
  call g:assert.equals(getline(5),   '}',           'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #418')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #418')
  call g:assert.equals(&l:autoindent,  1,           'failed at #418')
  call g:assert.equals(&l:smartindent, 1,           'failed at #418')
  call g:assert.equals(&l:cindent,     0,           'failed at #418')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #418')

  %delete

  " #419
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #419')
  call g:assert.equals(getline(2),   '    [',       'failed at #419')
  call g:assert.equals(getline(3),   '        foo', 'failed at #419')
  call g:assert.equals(getline(4),   '    ]',       'failed at #419')
  call g:assert.equals(getline(5),   '    }',       'failed at #419')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #419')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #419')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #419')
  call g:assert.equals(&l:autoindent,  1,           'failed at #419')
  call g:assert.equals(&l:smartindent, 1,           'failed at #419')
  call g:assert.equals(&l:cindent,     1,           'failed at #419')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #419')

  %delete

  " #420
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',           'failed at #420')
  call g:assert.equals(getline(2),   '            [',       'failed at #420')
  call g:assert.equals(getline(3),   '                foo', 'failed at #420')
  call g:assert.equals(getline(4),   '        ]',           'failed at #420')
  call g:assert.equals(getline(5),   '                }',   'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #420')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #420')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #420')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #420')
  call g:assert.equals(&l:cindent,     1,                   'failed at #420')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #420')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #421
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #421')
  call g:assert.equals(getline(2),   '[',          'failed at #421')
  call g:assert.equals(getline(3),   'foo',        'failed at #421')
  call g:assert.equals(getline(4),   ']',          'failed at #421')
  call g:assert.equals(getline(5),   '}',          'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #421')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #422')
  call g:assert.equals(getline(2),   '[',          'failed at #422')
  call g:assert.equals(getline(3),   'foo',        'failed at #422')
  call g:assert.equals(getline(4),   ']',          'failed at #422')
  call g:assert.equals(getline(5),   '}',          'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #422')
  call g:assert.equals(&l:autoindent,  1,          'failed at #422')
  call g:assert.equals(&l:smartindent, 0,          'failed at #422')
  call g:assert.equals(&l:cindent,     0,          'failed at #422')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #422')

  %delete

  " #423
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #423')
  call g:assert.equals(getline(2),   '[',          'failed at #423')
  call g:assert.equals(getline(3),   'foo',        'failed at #423')
  call g:assert.equals(getline(4),   ']',          'failed at #423')
  call g:assert.equals(getline(5),   '}',          'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #423')
  call g:assert.equals(&l:autoindent,  1,          'failed at #423')
  call g:assert.equals(&l:smartindent, 1,          'failed at #423')
  call g:assert.equals(&l:cindent,     0,          'failed at #423')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #423')

  %delete

  " #424
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #424')
  call g:assert.equals(getline(2),   '[',          'failed at #424')
  call g:assert.equals(getline(3),   'foo',        'failed at #424')
  call g:assert.equals(getline(4),   ']',          'failed at #424')
  call g:assert.equals(getline(5),   '}',          'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #424')
  call g:assert.equals(&l:autoindent,  1,          'failed at #424')
  call g:assert.equals(&l:smartindent, 1,          'failed at #424')
  call g:assert.equals(&l:cindent,     1,          'failed at #424')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #424')

  %delete

  " #425
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #425')
  call g:assert.equals(getline(2),   '[',              'failed at #425')
  call g:assert.equals(getline(3),   'foo',            'failed at #425')
  call g:assert.equals(getline(4),   ']',              'failed at #425')
  call g:assert.equals(getline(5),   '}',              'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #425')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #425')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #425')
  call g:assert.equals(&l:autoindent,  1,              'failed at #425')
  call g:assert.equals(&l:smartindent, 1,              'failed at #425')
  call g:assert.equals(&l:cindent,     1,              'failed at #425')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #425')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #426
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #426')
  call g:assert.equals(getline(2),   '    [',      'failed at #426')
  call g:assert.equals(getline(3),   '    foo',    'failed at #426')
  call g:assert.equals(getline(4),   '    ]',      'failed at #426')
  call g:assert.equals(getline(5),   '    }',      'failed at #426')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #426')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #426')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #426')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #427')
  call g:assert.equals(getline(2),   '    [',      'failed at #427')
  call g:assert.equals(getline(3),   '    foo',    'failed at #427')
  call g:assert.equals(getline(4),   '    ]',      'failed at #427')
  call g:assert.equals(getline(5),   '    }',      'failed at #427')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #427')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #427')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #427')
  call g:assert.equals(&l:autoindent,  1,          'failed at #427')
  call g:assert.equals(&l:smartindent, 0,          'failed at #427')
  call g:assert.equals(&l:cindent,     0,          'failed at #427')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #427')

  %delete

  " #428
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #428')
  call g:assert.equals(getline(2),   '    [',      'failed at #428')
  call g:assert.equals(getline(3),   '    foo',    'failed at #428')
  call g:assert.equals(getline(4),   '    ]',      'failed at #428')
  call g:assert.equals(getline(5),   '    }',      'failed at #428')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #428')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #428')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #428')
  call g:assert.equals(&l:autoindent,  1,          'failed at #428')
  call g:assert.equals(&l:smartindent, 1,          'failed at #428')
  call g:assert.equals(&l:cindent,     0,          'failed at #428')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #428')

  %delete

  " #429
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #429')
  call g:assert.equals(getline(2),   '    [',      'failed at #429')
  call g:assert.equals(getline(3),   '    foo',    'failed at #429')
  call g:assert.equals(getline(4),   '    ]',      'failed at #429')
  call g:assert.equals(getline(5),   '    }',      'failed at #429')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #429')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #429')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #429')
  call g:assert.equals(&l:autoindent,  1,          'failed at #429')
  call g:assert.equals(&l:smartindent, 1,          'failed at #429')
  call g:assert.equals(&l:cindent,     1,          'failed at #429')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #429')

  %delete

  " #430
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #430')
  call g:assert.equals(getline(2),   '    [',          'failed at #430')
  call g:assert.equals(getline(3),   '    foo',        'failed at #430')
  call g:assert.equals(getline(4),   '    ]',          'failed at #430')
  call g:assert.equals(getline(5),   '    }',          'failed at #430')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #430')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #430')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #430')
  call g:assert.equals(&l:autoindent,  1,              'failed at #430')
  call g:assert.equals(&l:smartindent, 1,              'failed at #430')
  call g:assert.equals(&l:cindent,     1,              'failed at #430')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #430')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #431
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #431')
  call g:assert.equals(getline(2),   '        [',   'failed at #431')
  call g:assert.equals(getline(3),   '        foo', 'failed at #431')
  call g:assert.equals(getline(4),   '    ]',       'failed at #431')
  call g:assert.equals(getline(5),   '}',           'failed at #431')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #431')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #431')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #431')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #432')
  call g:assert.equals(getline(2),   '        [',   'failed at #432')
  call g:assert.equals(getline(3),   '        foo', 'failed at #432')
  call g:assert.equals(getline(4),   '    ]',       'failed at #432')
  call g:assert.equals(getline(5),   '}',           'failed at #432')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #432')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #432')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #432')
  call g:assert.equals(&l:autoindent,  1,           'failed at #432')
  call g:assert.equals(&l:smartindent, 0,           'failed at #432')
  call g:assert.equals(&l:cindent,     0,           'failed at #432')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #432')

  %delete

  " #433
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #433')
  call g:assert.equals(getline(2),   '        [',   'failed at #433')
  call g:assert.equals(getline(3),   '        foo', 'failed at #433')
  call g:assert.equals(getline(4),   '    ]',       'failed at #433')
  call g:assert.equals(getline(5),   '}',           'failed at #433')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #433')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #433')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #433')
  call g:assert.equals(&l:autoindent,  1,           'failed at #433')
  call g:assert.equals(&l:smartindent, 1,           'failed at #433')
  call g:assert.equals(&l:cindent,     0,           'failed at #433')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #433')

  %delete

  " #434
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #434')
  call g:assert.equals(getline(2),   '        [',   'failed at #434')
  call g:assert.equals(getline(3),   '        foo', 'failed at #434')
  call g:assert.equals(getline(4),   '    ]',       'failed at #434')
  call g:assert.equals(getline(5),   '}',           'failed at #434')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #434')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #434')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #434')
  call g:assert.equals(&l:autoindent,  1,           'failed at #434')
  call g:assert.equals(&l:smartindent, 1,           'failed at #434')
  call g:assert.equals(&l:cindent,     1,           'failed at #434')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #434')

  %delete

  " #435
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #435')
  call g:assert.equals(getline(2),   '        [',      'failed at #435')
  call g:assert.equals(getline(3),   '        foo',    'failed at #435')
  call g:assert.equals(getline(4),   '    ]',          'failed at #435')
  call g:assert.equals(getline(5),   '}',              'failed at #435')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #435')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #435')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #435')
  call g:assert.equals(&l:autoindent,  1,              'failed at #435')
  call g:assert.equals(&l:smartindent, 1,              'failed at #435')
  call g:assert.equals(&l:cindent,     1,              'failed at #435')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #435')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #436
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #436')
  call g:assert.equals(getline(2),   '    [',       'failed at #436')
  call g:assert.equals(getline(3),   '        foo', 'failed at #436')
  call g:assert.equals(getline(4),   '    ]',       'failed at #436')
  call g:assert.equals(getline(5),   '    }',       'failed at #436')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #436')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #436')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #436')
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
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #437')
  call g:assert.equals(getline(2),   '    [',       'failed at #437')
  call g:assert.equals(getline(3),   '        foo', 'failed at #437')
  call g:assert.equals(getline(4),   '    ]',       'failed at #437')
  call g:assert.equals(getline(5),   '    }',       'failed at #437')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #437')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #437')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #437')
  call g:assert.equals(&l:autoindent,  1,           'failed at #437')
  call g:assert.equals(&l:smartindent, 0,           'failed at #437')
  call g:assert.equals(&l:cindent,     0,           'failed at #437')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #437')

  %delete

  " #438
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #438')
  call g:assert.equals(getline(2),   '    [',       'failed at #438')
  call g:assert.equals(getline(3),   '        foo', 'failed at #438')
  call g:assert.equals(getline(4),   '    ]',       'failed at #438')
  call g:assert.equals(getline(5),   '    }',       'failed at #438')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #438')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #438')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #438')
  call g:assert.equals(&l:autoindent,  1,           'failed at #438')
  call g:assert.equals(&l:smartindent, 1,           'failed at #438')
  call g:assert.equals(&l:cindent,     0,           'failed at #438')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #438')

  %delete

  " #439
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',           'failed at #439')
  call g:assert.equals(getline(2),   '    [',       'failed at #439')
  call g:assert.equals(getline(3),   '        foo', 'failed at #439')
  call g:assert.equals(getline(4),   '    ]',       'failed at #439')
  call g:assert.equals(getline(5),   '    }',       'failed at #439')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #439')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #439')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #439')
  call g:assert.equals(&l:autoindent,  1,           'failed at #439')
  call g:assert.equals(&l:smartindent, 1,           'failed at #439')
  call g:assert.equals(&l:cindent,     1,           'failed at #439')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #439')

  %delete

  " #440
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',              'failed at #440')
  call g:assert.equals(getline(2),   '    [',          'failed at #440')
  call g:assert.equals(getline(3),   '        foo',    'failed at #440')
  call g:assert.equals(getline(4),   '    ]',          'failed at #440')
  call g:assert.equals(getline(5),   '    }',          'failed at #440')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #440')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #440')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #440')
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
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #441
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #441')
  call g:assert.equals(getline(2),   'foo',        'failed at #441')
  call g:assert.equals(getline(3),   '    }',      'failed at #441')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #441')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #441')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #441')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #441')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #441')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #442
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #442')
  call g:assert.equals(getline(2),   '    foo',    'failed at #442')
  call g:assert.equals(getline(3),   '    }',      'failed at #442')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #442')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #442')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #442')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #442')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #442')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #443
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #443')
  call g:assert.equals(getline(2),   'foo',        'failed at #443')
  call g:assert.equals(getline(3),   '    }',      'failed at #443')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #443')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #443')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #443')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #443')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #443')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #444
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #444')
  call g:assert.equals(getline(2),   'foo',        'failed at #444')
  call g:assert.equals(getline(3),   '    }',      'failed at #444')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #444')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #444')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #444')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #444')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #444')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #445
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',     'failed at #445')
  call g:assert.equals(getline(2),   '    foo',       'failed at #445')
  call g:assert.equals(getline(3),   '            }', 'failed at #445')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #445')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #445')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #445')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #445')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #445')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #446
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #446')
  call g:assert.equals(getline(2),   'foo',        'failed at #446')
  call g:assert.equals(getline(3),   '    }',      'failed at #446')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #446')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #446')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #446')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #446')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #446')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #416
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #416')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #416')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #416')

  " #417
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #417')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #417')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #417')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #417')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #417')

  " #418
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #418')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #418')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #418')

  " #419
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #419')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #419')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #419')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #419')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #419')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #419')

  " #420
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #420')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #420')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #420')

  " #421
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #421')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #421')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #421')

  " #422
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #422')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #422')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #422')

  " #423
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #423')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #423')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #423')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #424
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #424')
  call g:assert.equals(getline(2),   'abara',      'failed at #424')
  call g:assert.equals(getline(3),   'abaza',      'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #424')

  %delete

  " #425
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #425')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #425')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #425')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #425')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #426
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #426')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #426')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #426')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #426')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #426')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #426')

  %delete

  " #427
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #427')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #427')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #427')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #427')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #427')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #427')

  %delete

  " #428
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #428')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #428')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #428')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #428')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #428')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #428')

  %delete

  " #429
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #429')
  call g:assert.equals(getline(2),   '',           'failed at #429')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #429')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #429')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #429')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #429')

  %delete

  " #430
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #430')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #430')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #430')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #430')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #430')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #430')

  %delete

  " #431
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #431')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #431')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #431')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #431')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #431')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #431')

  %delete

  " #432
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #432')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #432')
  call g:assert.equals(getline(3),   '(ba)',       'failed at #432')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #432')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #432')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #432')

  %delete

  " #433
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #433')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #433')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #433')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #433')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #433')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #433')

  %delete

  """ terminal-extended block-wise visual mode
  " #434
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #434')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #434')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #434')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #434')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #434')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #434')

  %delete

  " #435
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #435')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #435')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #435')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #435')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #435')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #435')

  %delete

  " #436
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #436')
  call g:assert.equals(getline(2),   '',           'failed at #436')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #436')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #436')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #436')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #436')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #437
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #437')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #437')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #437')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #437')

  %delete

  " #438
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #438')
  call g:assert.equals(getline(2),   '(a)',        'failed at #438')
  call g:assert.equals(getline(3),   '(a)',        'failed at #438')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #438')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #438')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #438')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #439
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #439')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #439')
  call g:assert.equals(getline(3),   'aa',         'failed at #439')
  call g:assert.equals(getline(4),   'aa',         'failed at #439')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #439')
  call g:assert.equals(getline(6),   'aa',         'failed at #439')
  call g:assert.equals(getline(7),   'aa',         'failed at #439')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #439')
  call g:assert.equals(getline(9),   'aa',         'failed at #439')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #439')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #439')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #439')

  %delete

  " #440
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #440')
  call g:assert.equals(getline(2),   'bbb',         'failed at #440')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #440')
  call g:assert.equals(getline(4),   'bbb',         'failed at #440')
  call g:assert.equals(getline(5),   'bb',          'failed at #440')
  call g:assert.equals(getline(6),   'bb',          'failed at #440')
  call g:assert.equals(getline(7),   'bbb',         'failed at #440')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #440')
  call g:assert.equals(getline(9),   'bbb',         'failed at #440')
  call g:assert.equals(getline(10),  'bb',          'failed at #440')
  call g:assert.equals(getline(11),  'bb',          'failed at #440')
  call g:assert.equals(getline(12),  'bbb',         'failed at #440')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #440')
  call g:assert.equals(getline(14),  'bbb',         'failed at #440')
  call g:assert.equals(getline(15),  'bb',          'failed at #440')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #440')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #440')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #440')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #441
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #441')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #441')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #441')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #441')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #441')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #441')

  %delete

  " #442
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #442')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #442')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #442')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #442')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #442')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #442')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #443
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #443')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #443')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #443')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #443')

  " #444
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #444')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #444')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #444')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #444')

  %delete

  """ keep
  " #445
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #445')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #445')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #445')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #445')

  " #446
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #446')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #446')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #446')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #446')

  %delete

  """ inner_tail
  " #447
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #447')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #447')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #447')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #447')

  " #448
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #448')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #448')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #448')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #448')

  %delete

  """ head
  " #449
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #449')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #449')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #449')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #449')

  " #450
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #450')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #450')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #450')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #450')

  %delete

  """ tail
  " #451
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #451')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #451')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #451')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #451')

  " #452
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #452')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #452')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #452')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #452')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #453
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #453')

  %delete

  """ on
  " #454
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #454')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #455
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #455')

  """ 1
  " #456
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #456')

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
  " #457
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #457')

  """ off
  " #458
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #458')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #459
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #459')

  """ off
  " #460
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #460')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #461
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '()',  'failed at #461')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #462
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #462')
  call g:assert.equals(getline(2), 'foo', 'failed at #462')
  call g:assert.equals(getline(3), ')',   'failed at #462')

  %delete

  " #463
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #463')
  call g:assert.equals(getline(2),   '    foo',    'failed at #463')
  call g:assert.equals(getline(3),   '    )',      'failed at #463')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #463')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #463')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #463')

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

  " #464
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #464')
  call g:assert.equals(getline(2),   '[',          'failed at #464')
  call g:assert.equals(getline(3),   'foo',        'failed at #464')
  call g:assert.equals(getline(4),   ']',          'failed at #464')
  call g:assert.equals(getline(5),   '}',          'failed at #464')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #464')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #464')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #464')
  call g:assert.equals(&l:autoindent,  0,          'failed at #464')
  call g:assert.equals(&l:smartindent, 0,          'failed at #464')
  call g:assert.equals(&l:cindent,     0,          'failed at #464')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #464')

  %delete

  " #465
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #465')
  call g:assert.equals(getline(2),   '    [',      'failed at #465')
  call g:assert.equals(getline(3),   '    foo',    'failed at #465')
  call g:assert.equals(getline(4),   '    ]',      'failed at #465')
  call g:assert.equals(getline(5),   '    }',      'failed at #465')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #465')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #465')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #465')
  call g:assert.equals(&l:autoindent,  1,          'failed at #465')
  call g:assert.equals(&l:smartindent, 0,          'failed at #465')
  call g:assert.equals(&l:cindent,     0,          'failed at #465')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #465')

  %delete

  " #466
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #466')
  call g:assert.equals(getline(2),   '        [',   'failed at #466')
  call g:assert.equals(getline(3),   '        foo', 'failed at #466')
  call g:assert.equals(getline(4),   '    ]',       'failed at #466')
  call g:assert.equals(getline(5),   '}',           'failed at #466')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #466')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #466')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #466')
  call g:assert.equals(&l:autoindent,  1,           'failed at #466')
  call g:assert.equals(&l:smartindent, 1,           'failed at #466')
  call g:assert.equals(&l:cindent,     0,           'failed at #466')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #466')

  %delete

  " #467
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #467')
  call g:assert.equals(getline(2),   '    [',       'failed at #467')
  call g:assert.equals(getline(3),   '        foo', 'failed at #467')
  call g:assert.equals(getline(4),   '    ]',       'failed at #467')
  call g:assert.equals(getline(5),   '    }',       'failed at #467')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #467')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #467')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #467')
  call g:assert.equals(&l:autoindent,  1,           'failed at #467')
  call g:assert.equals(&l:smartindent, 1,           'failed at #467')
  call g:assert.equals(&l:cindent,     1,           'failed at #467')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #467')

  %delete

  " #468
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',           'failed at #468')
  call g:assert.equals(getline(2),   '            [',       'failed at #468')
  call g:assert.equals(getline(3),   '                foo', 'failed at #468')
  call g:assert.equals(getline(4),   '        ]',           'failed at #468')
  call g:assert.equals(getline(5),   '                }',   'failed at #468')
  call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #468')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #468')
  call g:assert.equals(getpos("']"), [0, 5, 18, 0],         'failed at #468')
  call g:assert.equals(&l:autoindent,  1,                   'failed at #468')
  call g:assert.equals(&l:smartindent, 1,                   'failed at #468')
  call g:assert.equals(&l:cindent,     1,                   'failed at #468')
  call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #468')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #469
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #469')
  call g:assert.equals(getline(2),   '[',          'failed at #469')
  call g:assert.equals(getline(3),   'foo',        'failed at #469')
  call g:assert.equals(getline(4),   ']',          'failed at #469')
  call g:assert.equals(getline(5),   '}',          'failed at #469')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #469')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #469')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #469')
  call g:assert.equals(&l:autoindent,  0,          'failed at #469')
  call g:assert.equals(&l:smartindent, 0,          'failed at #469')
  call g:assert.equals(&l:cindent,     0,          'failed at #469')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #469')

  %delete

  " #470
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #470')
  call g:assert.equals(getline(2),   '[',          'failed at #470')
  call g:assert.equals(getline(3),   'foo',        'failed at #470')
  call g:assert.equals(getline(4),   ']',          'failed at #470')
  call g:assert.equals(getline(5),   '}',          'failed at #470')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #470')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #470')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #470')
  call g:assert.equals(&l:autoindent,  1,          'failed at #470')
  call g:assert.equals(&l:smartindent, 0,          'failed at #470')
  call g:assert.equals(&l:cindent,     0,          'failed at #470')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #470')

  %delete

  " #471
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #471')
  call g:assert.equals(getline(2),   '[',          'failed at #471')
  call g:assert.equals(getline(3),   'foo',        'failed at #471')
  call g:assert.equals(getline(4),   ']',          'failed at #471')
  call g:assert.equals(getline(5),   '}',          'failed at #471')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #471')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #471')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #471')
  call g:assert.equals(&l:autoindent,  1,          'failed at #471')
  call g:assert.equals(&l:smartindent, 1,          'failed at #471')
  call g:assert.equals(&l:cindent,     0,          'failed at #471')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #471')

  %delete

  " #472
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #472')
  call g:assert.equals(getline(2),   '[',          'failed at #472')
  call g:assert.equals(getline(3),   'foo',        'failed at #472')
  call g:assert.equals(getline(4),   ']',          'failed at #472')
  call g:assert.equals(getline(5),   '}',          'failed at #472')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #472')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #472')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #472')
  call g:assert.equals(&l:autoindent,  1,          'failed at #472')
  call g:assert.equals(&l:smartindent, 1,          'failed at #472')
  call g:assert.equals(&l:cindent,     1,          'failed at #472')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #472')

  %delete

  " #473
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #473')
  call g:assert.equals(getline(2),   '[',              'failed at #473')
  call g:assert.equals(getline(3),   'foo',            'failed at #473')
  call g:assert.equals(getline(4),   ']',              'failed at #473')
  call g:assert.equals(getline(5),   '}',              'failed at #473')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #473')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #473')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #473')
  call g:assert.equals(&l:autoindent,  1,              'failed at #473')
  call g:assert.equals(&l:smartindent, 1,              'failed at #473')
  call g:assert.equals(&l:cindent,     1,              'failed at #473')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #473')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #474
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #474')
  call g:assert.equals(getline(2),   '    [',      'failed at #474')
  call g:assert.equals(getline(3),   '    foo',    'failed at #474')
  call g:assert.equals(getline(4),   '    ]',      'failed at #474')
  call g:assert.equals(getline(5),   '    }',      'failed at #474')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #474')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #474')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #474')
  call g:assert.equals(&l:autoindent,  0,          'failed at #474')
  call g:assert.equals(&l:smartindent, 0,          'failed at #474')
  call g:assert.equals(&l:cindent,     0,          'failed at #474')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #474')

  %delete

  " #475
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #475')
  call g:assert.equals(getline(2),   '    [',      'failed at #475')
  call g:assert.equals(getline(3),   '    foo',    'failed at #475')
  call g:assert.equals(getline(4),   '    ]',      'failed at #475')
  call g:assert.equals(getline(5),   '    }',      'failed at #475')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #475')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #475')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #475')
  call g:assert.equals(&l:autoindent,  1,          'failed at #475')
  call g:assert.equals(&l:smartindent, 0,          'failed at #475')
  call g:assert.equals(&l:cindent,     0,          'failed at #475')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #475')

  %delete

  " #476
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #476')
  call g:assert.equals(getline(2),   '    [',      'failed at #476')
  call g:assert.equals(getline(3),   '    foo',    'failed at #476')
  call g:assert.equals(getline(4),   '    ]',      'failed at #476')
  call g:assert.equals(getline(5),   '    }',      'failed at #476')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #476')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #476')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #476')
  call g:assert.equals(&l:autoindent,  1,          'failed at #476')
  call g:assert.equals(&l:smartindent, 1,          'failed at #476')
  call g:assert.equals(&l:cindent,     0,          'failed at #476')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #476')

  %delete

  " #477
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #477')
  call g:assert.equals(getline(2),   '    [',      'failed at #477')
  call g:assert.equals(getline(3),   '    foo',    'failed at #477')
  call g:assert.equals(getline(4),   '    ]',      'failed at #477')
  call g:assert.equals(getline(5),   '    }',      'failed at #477')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #477')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #477')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #477')
  call g:assert.equals(&l:autoindent,  1,          'failed at #477')
  call g:assert.equals(&l:smartindent, 1,          'failed at #477')
  call g:assert.equals(&l:cindent,     1,          'failed at #477')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #477')

  %delete

  " #478
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #478')
  call g:assert.equals(getline(2),   '    [',          'failed at #478')
  call g:assert.equals(getline(3),   '    foo',        'failed at #478')
  call g:assert.equals(getline(4),   '    ]',          'failed at #478')
  call g:assert.equals(getline(5),   '    }',          'failed at #478')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #478')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #478')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #478')
  call g:assert.equals(&l:autoindent,  1,              'failed at #478')
  call g:assert.equals(&l:smartindent, 1,              'failed at #478')
  call g:assert.equals(&l:cindent,     1,              'failed at #478')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #478')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #479
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #479')
  call g:assert.equals(getline(2),   '        [',   'failed at #479')
  call g:assert.equals(getline(3),   '        foo', 'failed at #479')
  call g:assert.equals(getline(4),   '    ]',       'failed at #479')
  call g:assert.equals(getline(5),   '}',           'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #479')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #479')
  call g:assert.equals(&l:autoindent,  0,           'failed at #479')
  call g:assert.equals(&l:smartindent, 0,           'failed at #479')
  call g:assert.equals(&l:cindent,     0,           'failed at #479')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #479')

  %delete

  " #480
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #480')
  call g:assert.equals(getline(2),   '        [',   'failed at #480')
  call g:assert.equals(getline(3),   '        foo', 'failed at #480')
  call g:assert.equals(getline(4),   '    ]',       'failed at #480')
  call g:assert.equals(getline(5),   '}',           'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #480')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #480')
  call g:assert.equals(&l:autoindent,  1,           'failed at #480')
  call g:assert.equals(&l:smartindent, 0,           'failed at #480')
  call g:assert.equals(&l:cindent,     0,           'failed at #480')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #480')

  %delete

  " #481
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #481')
  call g:assert.equals(getline(2),   '        [',   'failed at #481')
  call g:assert.equals(getline(3),   '        foo', 'failed at #481')
  call g:assert.equals(getline(4),   '    ]',       'failed at #481')
  call g:assert.equals(getline(5),   '}',           'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #481')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #481')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #481')
  call g:assert.equals(&l:autoindent,  1,           'failed at #481')
  call g:assert.equals(&l:smartindent, 1,           'failed at #481')
  call g:assert.equals(&l:cindent,     0,           'failed at #481')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #481')

  %delete

  " #482
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #482')
  call g:assert.equals(getline(2),   '        [',   'failed at #482')
  call g:assert.equals(getline(3),   '        foo', 'failed at #482')
  call g:assert.equals(getline(4),   '    ]',       'failed at #482')
  call g:assert.equals(getline(5),   '}',           'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #482')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],  'failed at #482')
  call g:assert.equals(&l:autoindent,  1,           'failed at #482')
  call g:assert.equals(&l:smartindent, 1,           'failed at #482')
  call g:assert.equals(&l:cindent,     1,           'failed at #482')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #482')

  %delete

  " #483
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #483')
  call g:assert.equals(getline(2),   '        [',      'failed at #483')
  call g:assert.equals(getline(3),   '        foo',    'failed at #483')
  call g:assert.equals(getline(4),   '    ]',          'failed at #483')
  call g:assert.equals(getline(5),   '}',              'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #483')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #483')
  call g:assert.equals(&l:autoindent,  1,              'failed at #483')
  call g:assert.equals(&l:smartindent, 1,              'failed at #483')
  call g:assert.equals(&l:cindent,     1,              'failed at #483')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #483')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #484
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #484')
  call g:assert.equals(getline(2),   '    [',       'failed at #484')
  call g:assert.equals(getline(3),   '        foo', 'failed at #484')
  call g:assert.equals(getline(4),   '    ]',       'failed at #484')
  call g:assert.equals(getline(5),   '    }',       'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #484')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #484')
  call g:assert.equals(&l:autoindent,  0,           'failed at #484')
  call g:assert.equals(&l:smartindent, 0,           'failed at #484')
  call g:assert.equals(&l:cindent,     0,           'failed at #484')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #484')

  %delete

  " #485
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #485')
  call g:assert.equals(getline(2),   '    [',       'failed at #485')
  call g:assert.equals(getline(3),   '        foo', 'failed at #485')
  call g:assert.equals(getline(4),   '    ]',       'failed at #485')
  call g:assert.equals(getline(5),   '    }',       'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #485')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #485')
  call g:assert.equals(&l:autoindent,  1,           'failed at #485')
  call g:assert.equals(&l:smartindent, 0,           'failed at #485')
  call g:assert.equals(&l:cindent,     0,           'failed at #485')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #485')

  %delete

  " #486
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #486')
  call g:assert.equals(getline(2),   '    [',       'failed at #486')
  call g:assert.equals(getline(3),   '        foo', 'failed at #486')
  call g:assert.equals(getline(4),   '    ]',       'failed at #486')
  call g:assert.equals(getline(5),   '    }',       'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #486')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #486')
  call g:assert.equals(&l:autoindent,  1,           'failed at #486')
  call g:assert.equals(&l:smartindent, 1,           'failed at #486')
  call g:assert.equals(&l:cindent,     0,           'failed at #486')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #486')

  %delete

  " #487
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',           'failed at #487')
  call g:assert.equals(getline(2),   '    [',       'failed at #487')
  call g:assert.equals(getline(3),   '        foo', 'failed at #487')
  call g:assert.equals(getline(4),   '    ]',       'failed at #487')
  call g:assert.equals(getline(5),   '    }',       'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #487')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #487')
  call g:assert.equals(&l:autoindent,  1,           'failed at #487')
  call g:assert.equals(&l:smartindent, 1,           'failed at #487')
  call g:assert.equals(&l:cindent,     1,           'failed at #487')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #487')

  %delete

  " #488
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',              'failed at #488')
  call g:assert.equals(getline(2),   '    [',          'failed at #488')
  call g:assert.equals(getline(3),   '        foo',    'failed at #488')
  call g:assert.equals(getline(4),   '    ]',          'failed at #488')
  call g:assert.equals(getline(5),   '    }',          'failed at #488')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #488')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #488')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #488')
  call g:assert.equals(&l:autoindent,  1,              'failed at #488')
  call g:assert.equals(&l:smartindent, 1,              'failed at #488')
  call g:assert.equals(&l:cindent,     1,              'failed at #488')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #488')
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

  " #489
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #489')
  call g:assert.equals(getline(2),   'foo',        'failed at #489')
  call g:assert.equals(getline(3),   '    }',      'failed at #489')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #489')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #489')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #489')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #490
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #490')
  call g:assert.equals(getline(2),   '    foo',    'failed at #490')
  call g:assert.equals(getline(3),   '    }',      'failed at #490')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #490')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #490')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #490')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #490')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #491
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #491')
  call g:assert.equals(getline(2),   'foo',        'failed at #491')
  call g:assert.equals(getline(3),   '    }',      'failed at #491')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #491')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #491')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #491')

  %delete
  call operator#sandwich#set_default()

  """ indentkeys
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #492
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #492')
  call g:assert.equals(getline(2),   'foo',        'failed at #492')
  call g:assert.equals(getline(3),   '    }',      'failed at #492')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #492')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #492')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #492')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #492')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #493
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',     'failed at #493')
  call g:assert.equals(getline(2),   '    foo',       'failed at #493')
  call g:assert.equals(getline(3),   '            }', 'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #493')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #493')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #493')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #493')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #493')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #494
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #494')
  call g:assert.equals(getline(2),   'foo',        'failed at #494')
  call g:assert.equals(getline(3),   '    }',      'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #494')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #494')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #494')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #494')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssa <Esc>:call operator#sandwich#prerequisite('add', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #495
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #495')

  " #496
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #496')

  " #497
  call setline('.', 'foo')
  normal 0ssaiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #497')

  " #498
  call setline('.', 'foo')
  normal 0ssaiw[
  call g:assert.equals(getline('.'), '[foo[',      'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #498')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
