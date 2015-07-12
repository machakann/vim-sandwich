let s:suite = themis#suite('operator-sandwich: add:')

function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
  set autoindent&
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

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #125
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #125')

  " #126
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #126')

  " #127
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #127')

  " #128
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #128')

  " #129
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #129')

  " #130
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #130')

  " #131
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #131')

  " #132
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #132')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #133
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #133')

  " #134
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #134')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #135
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #135')

  " #136
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #136')

  " #137
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #137')

  " #138
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #138')
  call g:assert.equals(getline(2),   'bar',        'failed at #138')
  call g:assert.equals(getline(3),   'baz)',       'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #138')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #139
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #139')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #140
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #140')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #140')
  call g:assert.equals(getline(3), 'aa',           'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #140')

  %delete

  " #141
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #141')
  call g:assert.equals(getline(2),   'bbb',        'failed at #141')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #141')
  call g:assert.equals(getline(4),   'bbb',        'failed at #141')
  call g:assert.equals(getline(5),   'bb',         'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #141')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #142
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #142')

  " #143
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #143')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #144
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #144')

  " #145
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #145')

  """ keep
  " #146
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #146')

  " #147
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #147')

  """ inner_tail
  " #148
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #148')

  " #149
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #149')

  """ head
  " #150
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')

  " #151
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #151')

  """ tail
  " #152
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #152')

  " #153
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #153')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #154
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #154')

  """ on
  " #155
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #155')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #156
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #156')

  """ 1
  " #157
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #157')

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
  " #158
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #158')

  """ off
  " #159
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #159')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #160
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #160')

  """ on
  " #161
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #161')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #162
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '()',  'failed at #162')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #163
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #163')
  call g:assert.equals(getline(2), 'foo', 'failed at #163')
  call g:assert.equals(getline(3), ')',   'failed at #163')

  %delete

  " #164
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #123')
  call g:assert.equals(getline(2),   '    foo',    'failed at #123')
  call g:assert.equals(getline(3),   '    )',      'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #123')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #165
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #165')
  call g:assert.equals(getline(2),   'foo',        'failed at #165')
  call g:assert.equals(getline(3),   ')',          'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #165')

  %delete

  " #166
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #166')
  call g:assert.equals(getline(2),   'foo',        'failed at #166')
  call g:assert.equals(getline(3),   ')',          'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #166')

  %delete

  " #167
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #167')
  call g:assert.equals(getline(2),   'foo',        'failed at #167')
  call g:assert.equals(getline(3),   ']',          'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #167')

  %delete

  " #168
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #168')
  call g:assert.equals(getline(2),   'foo',        'failed at #168')
  call g:assert.equals(getline(3),   ']',          'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #168')

  %delete

  " #169
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #169')
  call g:assert.equals(getline(2),   'foo',        'failed at #169')
  call g:assert.equals(getline(3),   '}',          'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #169')

  %delete

  " #170
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #170')
  call g:assert.equals(getline(2),   'foo',        'failed at #170')
  call g:assert.equals(getline(3),   '}',          'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #170')

  %delete

  " #171
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #171')
  call g:assert.equals(getline(2),   'foo',        'failed at #171')
  call g:assert.equals(getline(3),   '>',          'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #171')

  %delete

  " #172
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #172')
  call g:assert.equals(getline(2),   'foo',        'failed at #172')
  call g:assert.equals(getline(3),   '>',          'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #172')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #173
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #173')
  call g:assert.equals(getline(2),   'foo',        'failed at #173')
  call g:assert.equals(getline(3),   'a',          'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #173')

  %delete

  " #174
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #174')
  call g:assert.equals(getline(2),   'foo',        'failed at #174')
  call g:assert.equals(getline(3),   '*',          'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #174')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #175
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #175')
  call g:assert.equals(getline(2),   'foo',        'failed at #175')
  call g:assert.equals(getline(3),   'bar',        'failed at #175')
  call g:assert.equals(getline(4),   'baz',        'failed at #175')
  call g:assert.equals(getline(5),   ')',          'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #175')

  " #176
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #176')
  call g:assert.equals(getline(2),   '(',          'failed at #176')
  call g:assert.equals(getline(3),   'bar',        'failed at #176')
  call g:assert.equals(getline(4),   ')',          'failed at #176')
  call g:assert.equals(getline(5),   'baz',        'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #176')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #176')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #176')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #177
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #177')
  call g:assert.equals(getline(2),   'a',          'failed at #177')
  call g:assert.equals(getline(3),   ')',          'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #177')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #178
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #178')
  call g:assert.equals(getline(2),   'aaa',        'failed at #178')
  call g:assert.equals(getline(3),   'foo',        'failed at #178')
  call g:assert.equals(getline(4),   'aaa',        'failed at #178')
  call g:assert.equals(getline(5),   'aa',         'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #178')

  %delete

  " #179
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #179')
  call g:assert.equals(getline(2),   'bbb',        'failed at #179')
  call g:assert.equals(getline(3),   'bb',         'failed at #179')
  call g:assert.equals(getline(4),   'foo',        'failed at #179')
  call g:assert.equals(getline(5),   'bb',         'failed at #179')
  call g:assert.equals(getline(6),   'bbb',        'failed at #179')
  call g:assert.equals(getline(7),   'bb',         'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #179')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #180
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #180')
  call g:assert.equals(getline(2),   '(',          'failed at #180')
  call g:assert.equals(getline(3),   'foo',        'failed at #180')
  call g:assert.equals(getline(4),   ')',          'failed at #180')
  call g:assert.equals(getline(5),   ']',          'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #180')

  %delete

  " #181
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #181')
  call g:assert.equals(getline(2),   '[',          'failed at #181')
  call g:assert.equals(getline(3),   '(',          'failed at #181')
  call g:assert.equals(getline(4),   'foo',        'failed at #181')
  call g:assert.equals(getline(5),   ')',          'failed at #181')
  call g:assert.equals(getline(6),   ']',          'failed at #181')
  call g:assert.equals(getline(7),   '}',          'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #181')

  %delete

  " #182
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #182')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #182')
  call g:assert.equals(getline(3), ')',            'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #182')

  %delete

  " #183
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #183')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #183')
  call g:assert.equals(getline(3), ')',            'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #183')

  %delete

  " #184
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #184')
  call g:assert.equals(getline(2), '(',            'failed at #184')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #184')
  call g:assert.equals(getline(4), ')',            'failed at #184')
  call g:assert.equals(getline(5), ']',            'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #184')

  %delete

  " #185
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #185')
  call g:assert.equals(getline(2), '[',            'failed at #185')
  call g:assert.equals(getline(3), '(',            'failed at #185')
  call g:assert.equals(getline(4), 'foo',          'failed at #185')
  call g:assert.equals(getline(5), ')',            'failed at #185')
  call g:assert.equals(getline(6), ']',            'failed at #185')
  call g:assert.equals(getline(7), 'aa',           'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #185')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #186
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #186')
  call g:assert.equals(getline(2),   '(',          'failed at #186')
  call g:assert.equals(getline(3),   'foo',        'failed at #186')
  call g:assert.equals(getline(4),   ')',          'failed at #186')
  call g:assert.equals(getline(5),   ')',          'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #186')

  " #187
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #187')
  call g:assert.equals(getline(2),   '(',          'failed at #187')
  call g:assert.equals(getline(3),   '(',          'failed at #187')
  call g:assert.equals(getline(4),   'foo',        'failed at #187')
  call g:assert.equals(getline(5),   ')',          'failed at #187')
  call g:assert.equals(getline(6),   ')',          'failed at #187')
  call g:assert.equals(getline(7),   ')',          'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #187')

  %delete

  """ keep
  " #188
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #188')
  call g:assert.equals(getline(2),   '(',          'failed at #188')
  call g:assert.equals(getline(3),   'foo',        'failed at #188')
  call g:assert.equals(getline(4),   ')',          'failed at #188')
  call g:assert.equals(getline(5),   ')',          'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #188')

  " #189
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #189')
  call g:assert.equals(getline(2),   '(',          'failed at #189')
  call g:assert.equals(getline(3),   '(',          'failed at #189')
  call g:assert.equals(getline(4),   'foo',        'failed at #189')
  call g:assert.equals(getline(5),   ')',          'failed at #189')
  call g:assert.equals(getline(6),   ')',          'failed at #189')
  call g:assert.equals(getline(7),   ')',          'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #189')

  %delete

  """ inner_tail
  " #190
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #190')
  call g:assert.equals(getline(2),   '(',          'failed at #190')
  call g:assert.equals(getline(3),   'foo',        'failed at #190')
  call g:assert.equals(getline(4),   ')',          'failed at #190')
  call g:assert.equals(getline(5),   ')',          'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #190')

  " #191
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #191')
  call g:assert.equals(getline(2),   '(',          'failed at #191')
  call g:assert.equals(getline(3),   '(',          'failed at #191')
  call g:assert.equals(getline(4),   'foo',        'failed at #191')
  call g:assert.equals(getline(5),   ')',          'failed at #191')
  call g:assert.equals(getline(6),   ')',          'failed at #191')
  call g:assert.equals(getline(7),   ')',          'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #191')

  %delete

  """ head
  " #192
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #192')
  call g:assert.equals(getline(2),   '(',          'failed at #192')
  call g:assert.equals(getline(3),   'foo',        'failed at #192')
  call g:assert.equals(getline(4),   ')',          'failed at #192')
  call g:assert.equals(getline(5),   ')',          'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #192')

  " #193
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #193')
  call g:assert.equals(getline(2),   '(',          'failed at #193')
  call g:assert.equals(getline(3),   '(',          'failed at #193')
  call g:assert.equals(getline(4),   'foo',        'failed at #193')
  call g:assert.equals(getline(5),   ')',          'failed at #193')
  call g:assert.equals(getline(6),   ')',          'failed at #193')
  call g:assert.equals(getline(7),   ')',          'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #193')

  %delete

  """ tail
  " #194
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #194')
  call g:assert.equals(getline(2),   '(',          'failed at #194')
  call g:assert.equals(getline(3),   'foo',        'failed at #194')
  call g:assert.equals(getline(4),   ')',          'failed at #194')
  call g:assert.equals(getline(5),   ')',          'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #194')

  " #195
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #195')
  call g:assert.equals(getline(2),   '(',          'failed at #195')
  call g:assert.equals(getline(3),   '(',          'failed at #195')
  call g:assert.equals(getline(4),   'foo',        'failed at #195')
  call g:assert.equals(getline(5),   ')',          'failed at #195')
  call g:assert.equals(getline(6),   ')',          'failed at #195')
  call g:assert.equals(getline(7),   ')',          'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #195')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #196
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #196')
  call g:assert.equals(getline(2), '[',   'failed at #196')
  call g:assert.equals(getline(3), '(',   'failed at #196')
  call g:assert.equals(getline(4), 'foo', 'failed at #196')
  call g:assert.equals(getline(5), ')',   'failed at #196')
  call g:assert.equals(getline(6), ']',   'failed at #196')
  call g:assert.equals(getline(7), '}',   'failed at #196')

  %delete

  """ on
  " #197
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #197')
  call g:assert.equals(getline(2), '(',   'failed at #197')
  call g:assert.equals(getline(3), '(',   'failed at #197')
  call g:assert.equals(getline(4), 'foo', 'failed at #197')
  call g:assert.equals(getline(5), ')',   'failed at #197')
  call g:assert.equals(getline(6), ')',   'failed at #197')
  call g:assert.equals(getline(7), ')',   'failed at #197')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #198
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #198')
  call g:assert.equals(getline(2), 'foo', 'failed at #198')
  call g:assert.equals(getline(3), '1+2', 'failed at #198')

  %delete

  """ 1
  " #199
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #199')
  call g:assert.equals(getline(2), 'foo', 'failed at #199')
  call g:assert.equals(getline(3), '3',   'failed at #199')

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
  " #200
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #200')
  call g:assert.equals(getline(2), 'foo', 'failed at #200')
  call g:assert.equals(getline(3), ']]',  'failed at #200')

  %delete

  """ off
  " #201
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #201')
  call g:assert.equals(getline(2), 'foo', 'failed at #201')
  call g:assert.equals(getline(3), '}}',  'failed at #201')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #202
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #202')
  call g:assert.equals(getline(2), 'foo ', 'failed at #202')
  call g:assert.equals(getline(3), ')',    'failed at #202')

  %delete

  """ off
  " #203
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #203')
  call g:assert.equals(getline(2), 'foo ', 'failed at #203')
  call g:assert.equals(getline(3), ')',    'failed at #203')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #204
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(', 'failed at #204')
  call g:assert.equals(getline(2), '',  'failed at #204')
  call g:assert.equals(getline(3), ')', 'failed at #204')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #205
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #205')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #206
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #206')
  call g:assert.equals(getline(2),   '    foo',    'failed at #206')
  call g:assert.equals(getline(3),   '    )',      'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #206')

  set autoindent&
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #207
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #207')
  call g:assert.equals(getline(2),   'foo',        'failed at #207')
  call g:assert.equals(getline(3),   ')',          'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #207')

  %delete

  " #208
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #208')
  call g:assert.equals(getline(2),   'foo',        'failed at #208')
  call g:assert.equals(getline(3),   ')',          'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #208')

  %delete

  " #209
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #209')
  call g:assert.equals(getline(2),   'foo',        'failed at #209')
  call g:assert.equals(getline(3),   ']',          'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #209')

  %delete

  " #210
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #210')
  call g:assert.equals(getline(2),   'foo',        'failed at #210')
  call g:assert.equals(getline(3),   ']',          'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #210')

  %delete

  " #211
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #211')
  call g:assert.equals(getline(2),   'foo',        'failed at #211')
  call g:assert.equals(getline(3),   '}',          'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #211')

  %delete

  " #212
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #212')
  call g:assert.equals(getline(2),   'foo',        'failed at #212')
  call g:assert.equals(getline(3),   '}',          'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #212')

  %delete

  " #213
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #213')
  call g:assert.equals(getline(2),   'foo',        'failed at #213')
  call g:assert.equals(getline(3),   '>',          'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #213')

  %delete

  " #214
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #214')
  call g:assert.equals(getline(2),   'foo',        'failed at #214')
  call g:assert.equals(getline(3),   '>',          'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #214')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #215
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #215')
  call g:assert.equals(getline(2), 'foo',          'failed at #215')
  call g:assert.equals(getline(3), 'a',            'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #215')

  %delete

  " #216
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #216')
  call g:assert.equals(getline(2), 'foo',          'failed at #216')
  call g:assert.equals(getline(3), '*',            'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #216')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #217
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #217')
  call g:assert.equals(getline(2),   'foo',        'failed at #217')
  call g:assert.equals(getline(3),   'bar',        'failed at #217')
  call g:assert.equals(getline(4),   'baz',        'failed at #217')
  call g:assert.equals(getline(5),   ')',          'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #217')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #218
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #218')
  call g:assert.equals(getline(2),   'a',          'failed at #218')
  call g:assert.equals(getline(3),   ')',          'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #218')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #219
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #219')
  call g:assert.equals(getline(2),   'aaa',        'failed at #219')
  call g:assert.equals(getline(3),   'foo',        'failed at #219')
  call g:assert.equals(getline(4),   'aaa',        'failed at #219')
  call g:assert.equals(getline(5),   'aa',         'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #219')

  %delete

  " #220
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #220')
  call g:assert.equals(getline(2),   'bbb',        'failed at #220')
  call g:assert.equals(getline(3),   'bb',         'failed at #220')
  call g:assert.equals(getline(4),   'foo',        'failed at #220')
  call g:assert.equals(getline(5),   'bb',         'failed at #220')
  call g:assert.equals(getline(6),   'bbb',        'failed at #220')
  call g:assert.equals(getline(7),   'bb',         'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #220')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #221
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #221')
  call g:assert.equals(getline(2),   '(',          'failed at #221')
  call g:assert.equals(getline(3),   'foo',        'failed at #221')
  call g:assert.equals(getline(4),   ')',          'failed at #221')
  call g:assert.equals(getline(5),   ']',          'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #221')

  %delete

  " #222
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #222')
  call g:assert.equals(getline(2),   '[',          'failed at #222')
  call g:assert.equals(getline(3),   '(',          'failed at #222')
  call g:assert.equals(getline(4),   'foo',        'failed at #222')
  call g:assert.equals(getline(5),   ')',          'failed at #222')
  call g:assert.equals(getline(6),   ']',          'failed at #222')
  call g:assert.equals(getline(7),   '}',          'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #222')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #223
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #223')
  call g:assert.equals(getline(2),   '(',          'failed at #223')
  call g:assert.equals(getline(3),   'foo',        'failed at #223')
  call g:assert.equals(getline(4),   ')',          'failed at #223')
  call g:assert.equals(getline(5),   ')',          'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #223')

  " #224
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #224')
  call g:assert.equals(getline(2),   '(',          'failed at #224')
  call g:assert.equals(getline(3),   '(',          'failed at #224')
  call g:assert.equals(getline(4),   'foo',        'failed at #224')
  call g:assert.equals(getline(5),   ')',          'failed at #224')
  call g:assert.equals(getline(6),   ')',          'failed at #224')
  call g:assert.equals(getline(7),   ')',          'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #224')

  %delete

  """ keep
  " #225
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #225')
  call g:assert.equals(getline(2),   '(',          'failed at #225')
  call g:assert.equals(getline(3),   'foo',        'failed at #225')
  call g:assert.equals(getline(4),   ')',          'failed at #225')
  call g:assert.equals(getline(5),   ')',          'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #225')

  " #226
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #226')
  call g:assert.equals(getline(2),   '(',          'failed at #226')
  call g:assert.equals(getline(3),   '(',          'failed at #226')
  call g:assert.equals(getline(4),   'foo',        'failed at #226')
  call g:assert.equals(getline(5),   ')',          'failed at #226')
  call g:assert.equals(getline(6),   ')',          'failed at #226')
  call g:assert.equals(getline(7),   ')',          'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #226')

  %delete

  """ inner_tail
  " #227
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #227')
  call g:assert.equals(getline(2),   '(',          'failed at #227')
  call g:assert.equals(getline(3),   'foo',        'failed at #227')
  call g:assert.equals(getline(4),   ')',          'failed at #227')
  call g:assert.equals(getline(5),   ')',          'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #227')

  " #228
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #228')
  call g:assert.equals(getline(2),   '(',          'failed at #228')
  call g:assert.equals(getline(3),   '(',          'failed at #228')
  call g:assert.equals(getline(4),   'foo',        'failed at #228')
  call g:assert.equals(getline(5),   ')',          'failed at #228')
  call g:assert.equals(getline(6),   ')',          'failed at #228')
  call g:assert.equals(getline(7),   ')',          'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #228')

  %delete

  """ head
  " #229
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #229')
  call g:assert.equals(getline(2),   '(',          'failed at #229')
  call g:assert.equals(getline(3),   'foo',        'failed at #229')
  call g:assert.equals(getline(4),   ')',          'failed at #229')
  call g:assert.equals(getline(5),   ')',          'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')

  " #230
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #230')
  call g:assert.equals(getline(2),   '(',          'failed at #230')
  call g:assert.equals(getline(3),   '(',          'failed at #230')
  call g:assert.equals(getline(4),   'foo',        'failed at #230')
  call g:assert.equals(getline(5),   ')',          'failed at #230')
  call g:assert.equals(getline(6),   ')',          'failed at #230')
  call g:assert.equals(getline(7),   ')',          'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #230')

  %delete

  """ tail
  " #231
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #231')
  call g:assert.equals(getline(2),   '(',          'failed at #231')
  call g:assert.equals(getline(3),   'foo',        'failed at #231')
  call g:assert.equals(getline(4),   ')',          'failed at #231')
  call g:assert.equals(getline(5),   ')',          'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #231')

  " #232
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #232')
  call g:assert.equals(getline(2),   '(',          'failed at #232')
  call g:assert.equals(getline(3),   '(',          'failed at #232')
  call g:assert.equals(getline(4),   'foo',        'failed at #232')
  call g:assert.equals(getline(5),   ')',          'failed at #232')
  call g:assert.equals(getline(6),   ')',          'failed at #232')
  call g:assert.equals(getline(7),   ')',          'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #232')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #233
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #233')
  call g:assert.equals(getline(2), '[',   'failed at #233')
  call g:assert.equals(getline(3), '(',   'failed at #233')
  call g:assert.equals(getline(4), 'foo', 'failed at #233')
  call g:assert.equals(getline(5), ')',   'failed at #233')
  call g:assert.equals(getline(6), ']',   'failed at #233')
  call g:assert.equals(getline(7), '}',   'failed at #233')

  %delete

  """ on
  " #234
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #234')
  call g:assert.equals(getline(2), '(',   'failed at #234')
  call g:assert.equals(getline(3), '(',   'failed at #234')
  call g:assert.equals(getline(4), 'foo', 'failed at #234')
  call g:assert.equals(getline(5), ')',   'failed at #234')
  call g:assert.equals(getline(6), ')',   'failed at #234')
  call g:assert.equals(getline(7), ')',   'failed at #234')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #235
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #235')
  call g:assert.equals(getline(2), 'foo', 'failed at #235')
  call g:assert.equals(getline(3), '1+2', 'failed at #235')

  %delete

  """ 1
  " #236
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #236')
  call g:assert.equals(getline(2), 'foo', 'failed at #236')
  call g:assert.equals(getline(3), '3',   'failed at #236')

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
  " #237
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #237')
  call g:assert.equals(getline(2), 'foo', 'failed at #237')
  call g:assert.equals(getline(3), ']]',  'failed at #237')

  %delete

  """ off
  " #238
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #238')
  call g:assert.equals(getline(2), 'foo', 'failed at #238')
  call g:assert.equals(getline(3), '}}',  'failed at #238')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #239
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #239')
  call g:assert.equals(getline(2), 'foo ', 'failed at #239')
  call g:assert.equals(getline(3), ')',    'failed at #239')

  %delete

  """ off
  " #240
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #240')
  call g:assert.equals(getline(2), 'foo ', 'failed at #240')
  call g:assert.equals(getline(3), ')',    'failed at #240')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #241
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(', 'failed at #241')
  call g:assert.equals(getline(2), '',  'failed at #241')
  call g:assert.equals(getline(3), ')', 'failed at #241')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #242
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #242')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #243
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #243')
  call g:assert.equals(getline(2),   '    foo',    'failed at #243')
  call g:assert.equals(getline(3),   '    )',      'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #243')

  set autoindent&
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #244
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #244')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #244')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #244')

  %delete

  " #245
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #245')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #245')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #246')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #246')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #247')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #247')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #247')

  %delete

  " #248
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #248')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #248')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #248')

  %delete

  " #249
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #249')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #249')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #249')

  %delete

  " #250
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #250')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #250')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #250')

  %delete

  " #251
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #251')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #251')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #251')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #252
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #252')
  call g:assert.equals(getline(2),   'abara',      'failed at #252')
  call g:assert.equals(getline(3),   'abaza',      'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #252')

  %delete

  " #253
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #253')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #253')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #253')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #254
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #254')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #254')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #254')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #254')

  %delete

  " #255
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #255')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #255')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #255')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #255')

  %delete

  " #256
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #256')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #256')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #256')

  %delete

  " #257
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #257')
  call g:assert.equals(getline(2),   '',           'failed at #257')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #257')

  %delete

  " #258
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #258')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #258')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #258')

  %delete

  " #259
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #259')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #259')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #259')

  %delete

  " #260
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #260')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #260')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #260')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #261
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #261')

  %delete

  " #262
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #262')
  call g:assert.equals(getline(2),   '(a)',        'failed at #262')
  call g:assert.equals(getline(3),   '(a)',        'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #262')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #263
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #263')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #263')
  call g:assert.equals(getline(3),   'aa',         'failed at #263')
  call g:assert.equals(getline(4),   'aa',         'failed at #263')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #263')
  call g:assert.equals(getline(6),   'aa',         'failed at #263')
  call g:assert.equals(getline(7),   'aa',         'failed at #263')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #263')
  call g:assert.equals(getline(9),   'aa',         'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #263')

  %delete

  " #264
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #264')
  call g:assert.equals(getline(2),   'bbb',         'failed at #264')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #264')
  call g:assert.equals(getline(4),   'bbb',         'failed at #264')
  call g:assert.equals(getline(5),   'bb',          'failed at #264')
  call g:assert.equals(getline(6),   'bb',          'failed at #264')
  call g:assert.equals(getline(7),   'bbb',         'failed at #264')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #264')
  call g:assert.equals(getline(9),   'bbb',         'failed at #264')
  call g:assert.equals(getline(10),  'bb',          'failed at #264')
  call g:assert.equals(getline(11),  'bb',          'failed at #264')
  call g:assert.equals(getline(12),  'bbb',         'failed at #264')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #264')
  call g:assert.equals(getline(14),  'bbb',         'failed at #264')
  call g:assert.equals(getline(15),  'bb',          'failed at #264')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #264')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #265
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #265')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #265')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #265')

  %delete

  " #266
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #266')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #266')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #266')

  %delete

  " #267
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #267')

  %delete

  " #268
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #268')

  %delete

  " #269
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #269')
  %delete

  " #270
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #270')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #270')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #270')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #270')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #271
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #271')

  " #272
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #272')

  """ keep
  " #273
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #273')

  " #274
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #274')

  """ inner_tail
  " #275
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #275')

  " #276
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #276')

  """ head
  " #277
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #277')

  " #278
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #278')

  """ tail
  " #279
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #279')

  " #280
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #280')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #281
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #281')

  %delete

  """ on
  " #282
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #282')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #283
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #283')

  """ 1
  " #284
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #284')

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
  " #285
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #285')

  """ off
  " #286
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #286')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #287
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #287')

  """ off
  " #288
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #288')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #289
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '()',  'failed at #289')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #290
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #290')
  call g:assert.equals(getline(2), 'foo', 'failed at #290')
  call g:assert.equals(getline(3), ')',   'failed at #290')

  %delete

  " #291
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #291')
  call g:assert.equals(getline(2),   '    foo',    'failed at #291')
  call g:assert.equals(getline(3),   '    )',      'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #291')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #292
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #292')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #292')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #292')

  " #293
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #293')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #293')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #293')

  " #294
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #294')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #294')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #294')

  " #295
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #295')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #295')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #295')

  " #296
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #296')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #296')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #296')

  " #297
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #297')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #297')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #297')

  " #298
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #298')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #298')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #298')

  " #299
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #299')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #299')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #299')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #300
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #300')
  call g:assert.equals(getline(2),   'abara',      'failed at #300')
  call g:assert.equals(getline(3),   'abaza',      'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #300')

  %delete

  " #301
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #301')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #301')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #301')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #302
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #302')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #302')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #302')

  %delete

  " #303
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #303')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #303')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #303')

  %delete

  " #304
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #304')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #304')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #304')

  %delete

  " #305
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #305')
  call g:assert.equals(getline(2),   '',           'failed at #305')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #306')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #306')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #307')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #307')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #307')

  %delete

  " #308
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #308')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #308')
  call g:assert.equals(getline(3),   '(ba)',       'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #308')

  %delete

  " #309
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #309')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #309')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #309')

  %delete

  """ terminal-extended block-wise visual mode
  " #310
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #310')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #310')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #310')

  %delete

  " #311
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #311')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #311')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #312')
  call g:assert.equals(getline(2),   '',           'failed at #312')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #312')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #313
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #314')
  call g:assert.equals(getline(2),   '(a)',        'failed at #314')
  call g:assert.equals(getline(3),   '(a)',        'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #314')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #315
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #315')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #315')
  call g:assert.equals(getline(3),   'aa',         'failed at #315')
  call g:assert.equals(getline(4),   'aa',         'failed at #315')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #315')
  call g:assert.equals(getline(6),   'aa',         'failed at #315')
  call g:assert.equals(getline(7),   'aa',         'failed at #315')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #315')
  call g:assert.equals(getline(9),   'aa',         'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #315')

  %delete

  " #316
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #316')
  call g:assert.equals(getline(2),   'bbb',         'failed at #316')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #316')
  call g:assert.equals(getline(4),   'bbb',         'failed at #316')
  call g:assert.equals(getline(5),   'bb',          'failed at #316')
  call g:assert.equals(getline(6),   'bb',          'failed at #316')
  call g:assert.equals(getline(7),   'bbb',         'failed at #316')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #316')
  call g:assert.equals(getline(9),   'bbb',         'failed at #316')
  call g:assert.equals(getline(10),  'bb',          'failed at #316')
  call g:assert.equals(getline(11),  'bb',          'failed at #316')
  call g:assert.equals(getline(12),  'bbb',         'failed at #316')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #316')
  call g:assert.equals(getline(14),  'bbb',         'failed at #316')
  call g:assert.equals(getline(15),  'bb',          'failed at #316')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #316')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #317
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #317')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #317')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #317')

  %delete

  " #318
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #318')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #318')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #318')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #319
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #319')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #319')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #319')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #319')

  " #320
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #320')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #320')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #320')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #320')

  %delete

  """ keep
  " #321
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #321')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #321')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #321')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #321')

  " #322
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #322')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #322')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #322')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #322')

  %delete

  """ inner_tail
  " #323
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #323')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #323')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #323')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #323')

  " #324
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #324')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #324')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #324')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #324')

  %delete

  """ head
  " #325
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #325')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #325')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #325')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #325')

  " #326
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #326')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #326')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #326')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #326')

  %delete

  """ tail
  " #327
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #327')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #327')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #327')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #327')

  " #328
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #328')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #328')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #328')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #328')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #329
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #329')

  %delete

  """ on
  " #330
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #330')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #331
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #331')

  """ 1
  " #332
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #332')

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
  " #333
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #333')

  """ off
  " #334
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #334')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #335
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #335')

  """ off
  " #336
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #336')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #337
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '()',  'failed at #337')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #338
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #338')
  call g:assert.equals(getline(2), 'foo', 'failed at #338')
  call g:assert.equals(getline(3), ')',   'failed at #338')

  %delete

  " #339
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #339')
  call g:assert.equals(getline(2),   '    foo',    'failed at #339')
  call g:assert.equals(getline(3),   '    )',      'failed at #339')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #339')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #339')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssa <Esc>:call operator#sandwich#prerequisite('add', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #340
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #340')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #340')

  " #341
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #341')

  " #342
  call setline('.', 'foo')
  normal 0ssaiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #342')

  " #343
  call setline('.', 'foo')
  normal 0ssaiw[
  call g:assert.equals(getline('.'), '[foo[',      'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #343')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
