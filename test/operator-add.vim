let s:suite = themis#suite('operator-sandwich: add:')

function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
  set autoindent&
  silent! mapc!
  silent! ounmap ii
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

  " #5
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  set filetype=vim

  " #7
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #8')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #9
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \ ]

  " #10
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['delete'], 'input': ['(', ')']},
        \ ]

  " #11
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #11')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['replace'], 'input': ['(', ')']},
        \ ]

  " #12
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #12')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['operator'], 'input': ['(', ')']},
        \ ]

  " #13
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #14
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #14')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #15
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #15')

  " #16
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #16')

  " #17
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #17')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['(', ')']},
        \ ]

  " #18
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #18')

  " #19
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #19')

  " #20
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['(', ')']},
        \ ]

  " #21
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #21')

  " #22
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #22')

  " #23
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #23')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['(', ')']},
        \ ]

  " #24
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #24')

  " #25
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #25')

  " #26
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['(', ')']},
        \ ]

  " #27
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #27')

  " #28
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #28')

  " #29
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #29')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #30
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #30')

  " #31
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #31')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['(', ')']},
        \ ]

  " #32
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #32')

  " #33
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #33')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #34
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #34')

  " #35
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #35')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #36
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #36')

  " #37
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #37')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['(', ')']},
        \ ]

  " #38
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #38')

  " #39
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #39')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['(', ')']},
        \ ]

  " #40
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #40')

  " #41
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #41')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['(', ')']},
        \ ]

  " #42
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #42')

  " #43
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #43')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #44
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #44')

  " #45
  call setline('.', 'foo')
  normal 0saiw)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #45')

  " #46
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #46')

  " #47
  call setline('.', 'foo')
  normal 0saiw]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #47')

  " #48
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #48')

  " #49
  call setline('.', 'foo')
  normal 0saiw}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #49')

  " #50
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #50')

  " #51
  call setline('.', 'foo')
  normal 0saiw>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #51')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #52
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #52')

  " #53
  call setline('.', 'foo')
  normal 0saiw*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #53')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #54
  call setline('.', 'foobar')
  normal 0sa3l(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #54')

  " #55
  call setline('.', 'foobar')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #55')

  " #56
  call setline('.', 'foobarbaz')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #56')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #56')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #57
  call setline('.', 'foobarbaz')
  normal 0saii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #57')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #57')

  " #58
  call setline('.', 'foobarbaz')
  normal 02lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #58')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #58')

  " #59
  call setline('.', 'foobarbaz')
  normal 03lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #59')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #59')

  " #60
  call setline('.', 'foobarbaz')
  normal 05lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #60')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #60')

  " #61
  call setline('.', 'foobarbaz')
  normal 06lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #61')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #61')

  " #62
  call setline('.', 'foobarbaz')
  normal 08lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #62')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  %delete

  " #63
  set whichwrap=h,l
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa11l(
  call g:assert.equals(getline(1),   '(foo',       'failed at #63')
  call g:assert.equals(getline(2),   'bar',        'failed at #63')
  call g:assert.equals(getline(3),   'baz)',       'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #63')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #64
  call setline('.', 'a')
  normal 0sal(
  call g:assert.equals(getline('.'), '(a)',        'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #64')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \   {'buns': ["cc\n cc", "ccc\n  "], 'input':['c']},
        \ ]

  " #65
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1),   'aa',         'failed at #65')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #65')
  call g:assert.equals(getline(3),   'aa',         'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #65')

  %delete

  " #66
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline(1),   'bb',         'failed at #66')
  call g:assert.equals(getline(2),   'bbb',        'failed at #66')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #66')
  call g:assert.equals(getline(4),   'bbb',        'failed at #66')
  call g:assert.equals(getline(5),   'bb',         'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #66')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #67
  call setline('.', 'foobarbaz')
  normal ggsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #67')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #67')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #67')

  %delete

  " #68
  call setline('.', 'foobarbaz')
  normal gg2lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #68')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #68')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #68')

  %delete

  " #69
  call setline('.', 'foobarbaz')
  normal gg3lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #69')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #69')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #69')

  %delete

  " #70
  call setline('.', 'foobarbaz')
  normal gg5lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #70')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #70')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #70')

  %delete

  " #71
  call setline('.', 'foobarbaz')
  normal gg6lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #71')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #71')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #71')

  %delete

  " #72
  call setline('.', 'foobarbaz')
  normal gg$saiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #72')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #72')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #72')

  %delete

  set autoindent
  onoremap ii :<C-u>call TextobjCoord(1, 8, 1, 10)<CR>

  " #73
  call setline('.', '    foobarbaz')
  normal ggsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #73')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #73')
  call g:assert.equals(getline(3),   '      baz',     'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],    'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #73')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #73')

  %delete

  " #74
  call setline('.', '    foobarbaz')
  normal gg2lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #74')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #74')
  call g:assert.equals(getline(3),   '      baz',     'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],    'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #74')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #74')

  %delete

  " #75
  call setline('.', '    foobarbaz')
  normal gg3lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #75')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #75')
  call g:assert.equals(getline(3),   '      baz',     'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0],    'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #75')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #75')

  %delete

  " #76
  call setline('.', '    foobarbaz')
  normal gg5lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #76')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #76')
  call g:assert.equals(getline(3),   '      baz',     'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 2, 10, 0],   'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #76')
  call g:assert.equals(getpos("']"), [0, 3,  7, 0],   'failed at #76')

  %delete

  " #77
  call setline('.', '    foobarbaz')
  normal gg6lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #77')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #77')
  call g:assert.equals(getline(3),   '      baz',     'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0],    'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #77')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #77')

  %delete

  " #78
  call setline('.', '    foobarbaz')
  normal gg$saiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #78')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #78')
  call g:assert.equals(getline(3),   '      baz',     'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #78')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #78')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #79
  call setline('.', 'foo')
  normal 02saiw([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #79')

  " #80
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #80')

  " #81
  call setline('.', 'foo bar')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #81')

  " #82
  call setline('.', 'foo bar')
  normal 0sa3iw(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #82')

  " #83
  call setline('.', 'foo bar')
  normal 02sa3iw([
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #83')

  " #84
  call setline('.', 'foobarbaz')
  normal 03l2sa3l([
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #84')

  " #85
  call setline('.', 'foobarbaz')
  normal 03l3sa3l([{
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #85')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #86
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #86')

  " #87
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #87')

  """ keep
  " #88
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #88')

  " #89
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #89')

  """ inner_tail
  " #90
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #90')

  " #91
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #91')

  """ front
  " #92
  call operator#sandwich#set('add', 'char', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #92')

  " #93
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #93')

  """ end
  " #94
  call operator#sandwich#set('add', 'char', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #94')

  " #95
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #95')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #96
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #96')

  %delete

  """ on
  " #97
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #97')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #98
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #98')

  """ 1
  " #99
  call operator#sandwich#set('add', 'char', 'eval', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #99')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'char', 'eval', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #100
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #100')

  """ off
  " #101
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #101')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #102
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #102')

  """ on
  " #103
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #103')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  """"" command
  " #104
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '()',  'failed at #104')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #105
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #105')
  call g:assert.equals(getline(2), 'foo', 'failed at #105')
  call g:assert.equals(getline(3), ')',   'failed at #105')

  %delete

  " #106
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #106')
  call g:assert.equals(getline(2),   '    foo',    'failed at #106')
  call g:assert.equals(getline(3),   '    )',      'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #106')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #107
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #107')

  " #108
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #108')

  " #109
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #109')

  " #110
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #110')

  " #111
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #111')

  " #112
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #112')

  " #113
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #113')

  " #114
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #114')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #115
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #115')

  " #116
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #116')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #117
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #117')

  " #118
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #118')

  " #119
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #119')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #119')

  " #120
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #120')
  call g:assert.equals(getline(2),   'bar',        'failed at #120')
  call g:assert.equals(getline(3),   'baz)',       'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #120')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #121
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #121')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #122
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #122')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #122')
  call g:assert.equals(getline(3), 'aa',           'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #122')

  %delete

  " #123
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #123')
  call g:assert.equals(getline(2),   'bbb',        'failed at #123')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #123')
  call g:assert.equals(getline(4),   'bbb',        'failed at #123')
  call g:assert.equals(getline(5),   'bb',         'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #123')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #124
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #124')

  " #125
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #125')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #126
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #126')

  " #127
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #127')

  """ keep
  " #128
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #128')

  " #129
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #129')

  """ inner_tail
  " #130
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #130')

  " #131
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #131')

  """ front
  " #132
  call operator#sandwich#set('add', 'char', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')

  " #133
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #133')

  """ end
  " #134
  call operator#sandwich#set('add', 'char', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #134')

  " #135
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #135')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #136
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #136')

  """ on
  " #137
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #137')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #138
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #138')

  """ 1
  " #139
  call operator#sandwich#set('add', 'char', 'eval', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #139')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'char', 'eval', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #140
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #140')

  """ off
  " #141
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #141')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #142
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #142')

  """ on
  " #143
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #143')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #144
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '()',  'failed at #144')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #145
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #145')
  call g:assert.equals(getline(2), 'foo', 'failed at #145')
  call g:assert.equals(getline(3), ')',   'failed at #145')

  %delete

  " #146
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #105')
  call g:assert.equals(getline(2),   '    foo',    'failed at #105')
  call g:assert.equals(getline(3),   '    )',      'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #105')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #147
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #147')
  call g:assert.equals(getline(2),   'foo',        'failed at #147')
  call g:assert.equals(getline(3),   ')',          'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #147')

  %delete

  " #148
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #148')
  call g:assert.equals(getline(2),   'foo',        'failed at #148')
  call g:assert.equals(getline(3),   ')',          'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #148')

  %delete

  " #149
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #149')
  call g:assert.equals(getline(2),   'foo',        'failed at #149')
  call g:assert.equals(getline(3),   ']',          'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #149')

  %delete

  " #150
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #150')
  call g:assert.equals(getline(2),   'foo',        'failed at #150')
  call g:assert.equals(getline(3),   ']',          'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #150')

  %delete

  " #151
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #151')
  call g:assert.equals(getline(2),   'foo',        'failed at #151')
  call g:assert.equals(getline(3),   '}',          'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #151')

  %delete

  " #152
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #152')
  call g:assert.equals(getline(2),   'foo',        'failed at #152')
  call g:assert.equals(getline(3),   '}',          'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #152')

  %delete

  " #153
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #153')
  call g:assert.equals(getline(2),   'foo',        'failed at #153')
  call g:assert.equals(getline(3),   '>',          'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #153')

  %delete

  " #154
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #154')
  call g:assert.equals(getline(2),   'foo',        'failed at #154')
  call g:assert.equals(getline(3),   '>',          'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #154')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #155
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #155')
  call g:assert.equals(getline(2),   'foo',        'failed at #155')
  call g:assert.equals(getline(3),   'a',          'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #155')

  %delete

  " #156
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #156')
  call g:assert.equals(getline(2),   'foo',        'failed at #156')
  call g:assert.equals(getline(3),   '*',          'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #156')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #157
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #157')
  call g:assert.equals(getline(2),   'foo',        'failed at #157')
  call g:assert.equals(getline(3),   'bar',        'failed at #157')
  call g:assert.equals(getline(4),   'baz',        'failed at #157')
  call g:assert.equals(getline(5),   ')',          'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #157')

  " #158
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #158')
  call g:assert.equals(getline(2),   '(',          'failed at #158')
  call g:assert.equals(getline(3),   'bar',        'failed at #158')
  call g:assert.equals(getline(4),   ')',          'failed at #158')
  call g:assert.equals(getline(5),   'baz',        'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #158')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #159
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #159')
  call g:assert.equals(getline(2),   'a',          'failed at #159')
  call g:assert.equals(getline(3),   ')',          'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #159')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #160
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #160')
  call g:assert.equals(getline(2),   'aaa',        'failed at #160')
  call g:assert.equals(getline(3),   'foo',        'failed at #160')
  call g:assert.equals(getline(4),   'aaa',        'failed at #160')
  call g:assert.equals(getline(5),   'aa',         'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #160')

  %delete

  " #161
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #161')
  call g:assert.equals(getline(2),   'bbb',        'failed at #161')
  call g:assert.equals(getline(3),   'bb',         'failed at #161')
  call g:assert.equals(getline(4),   'foo',        'failed at #161')
  call g:assert.equals(getline(5),   'bb',         'failed at #161')
  call g:assert.equals(getline(6),   'bbb',        'failed at #161')
  call g:assert.equals(getline(7),   'bb',         'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #161')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #162
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #162')
  call g:assert.equals(getline(2),   '(',          'failed at #162')
  call g:assert.equals(getline(3),   'foo',        'failed at #162')
  call g:assert.equals(getline(4),   ')',          'failed at #162')
  call g:assert.equals(getline(5),   ']',          'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #162')

  %delete

  " #163
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #163')
  call g:assert.equals(getline(2),   '[',          'failed at #163')
  call g:assert.equals(getline(3),   '(',          'failed at #163')
  call g:assert.equals(getline(4),   'foo',        'failed at #163')
  call g:assert.equals(getline(5),   ')',          'failed at #163')
  call g:assert.equals(getline(6),   ']',          'failed at #163')
  call g:assert.equals(getline(7),   '}',          'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #163')

  %delete

  " #164
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #164')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #164')
  call g:assert.equals(getline(3), ')',            'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #164')

  %delete

  " #165
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #165')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #165')
  call g:assert.equals(getline(3), ')',            'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #165')

  %delete

  " #166
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #166')
  call g:assert.equals(getline(2), '(',            'failed at #166')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #166')
  call g:assert.equals(getline(4), ')',            'failed at #166')
  call g:assert.equals(getline(5), ']',            'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #166')

  %delete

  " #167
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #167')
  call g:assert.equals(getline(2), '[',            'failed at #167')
  call g:assert.equals(getline(3), '(',            'failed at #167')
  call g:assert.equals(getline(4), 'foo',          'failed at #167')
  call g:assert.equals(getline(5), ')',            'failed at #167')
  call g:assert.equals(getline(6), ']',            'failed at #167')
  call g:assert.equals(getline(7), 'aa',           'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #167')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #168
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #168')
  call g:assert.equals(getline(2),   '(',          'failed at #168')
  call g:assert.equals(getline(3),   'foo',        'failed at #168')
  call g:assert.equals(getline(4),   ')',          'failed at #168')
  call g:assert.equals(getline(5),   ')',          'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #168')

  " #169
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #169')
  call g:assert.equals(getline(2),   '(',          'failed at #169')
  call g:assert.equals(getline(3),   '(',          'failed at #169')
  call g:assert.equals(getline(4),   'foo',        'failed at #169')
  call g:assert.equals(getline(5),   ')',          'failed at #169')
  call g:assert.equals(getline(6),   ')',          'failed at #169')
  call g:assert.equals(getline(7),   ')',          'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #169')

  %delete

  """ keep
  " #170
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #170')
  call g:assert.equals(getline(2),   '(',          'failed at #170')
  call g:assert.equals(getline(3),   'foo',        'failed at #170')
  call g:assert.equals(getline(4),   ')',          'failed at #170')
  call g:assert.equals(getline(5),   ')',          'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #170')

  " #171
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #171')
  call g:assert.equals(getline(2),   '(',          'failed at #171')
  call g:assert.equals(getline(3),   '(',          'failed at #171')
  call g:assert.equals(getline(4),   'foo',        'failed at #171')
  call g:assert.equals(getline(5),   ')',          'failed at #171')
  call g:assert.equals(getline(6),   ')',          'failed at #171')
  call g:assert.equals(getline(7),   ')',          'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #171')

  %delete

  """ inner_tail
  " #172
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #172')
  call g:assert.equals(getline(2),   '(',          'failed at #172')
  call g:assert.equals(getline(3),   'foo',        'failed at #172')
  call g:assert.equals(getline(4),   ')',          'failed at #172')
  call g:assert.equals(getline(5),   ')',          'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #172')

  " #173
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #173')
  call g:assert.equals(getline(2),   '(',          'failed at #173')
  call g:assert.equals(getline(3),   '(',          'failed at #173')
  call g:assert.equals(getline(4),   'foo',        'failed at #173')
  call g:assert.equals(getline(5),   ')',          'failed at #173')
  call g:assert.equals(getline(6),   ')',          'failed at #173')
  call g:assert.equals(getline(7),   ')',          'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #173')

  %delete

  """ front
  " #174
  call operator#sandwich#set('add', 'line', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #174')
  call g:assert.equals(getline(2),   '(',          'failed at #174')
  call g:assert.equals(getline(3),   'foo',        'failed at #174')
  call g:assert.equals(getline(4),   ')',          'failed at #174')
  call g:assert.equals(getline(5),   ')',          'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #174')

  " #175
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #175')
  call g:assert.equals(getline(2),   '(',          'failed at #175')
  call g:assert.equals(getline(3),   '(',          'failed at #175')
  call g:assert.equals(getline(4),   'foo',        'failed at #175')
  call g:assert.equals(getline(5),   ')',          'failed at #175')
  call g:assert.equals(getline(6),   ')',          'failed at #175')
  call g:assert.equals(getline(7),   ')',          'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #175')

  %delete

  """ end
  " #176
  call operator#sandwich#set('add', 'line', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #176')
  call g:assert.equals(getline(2),   '(',          'failed at #176')
  call g:assert.equals(getline(3),   'foo',        'failed at #176')
  call g:assert.equals(getline(4),   ')',          'failed at #176')
  call g:assert.equals(getline(5),   ')',          'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #176')

  " #177
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #177')
  call g:assert.equals(getline(2),   '(',          'failed at #177')
  call g:assert.equals(getline(3),   '(',          'failed at #177')
  call g:assert.equals(getline(4),   'foo',        'failed at #177')
  call g:assert.equals(getline(5),   ')',          'failed at #177')
  call g:assert.equals(getline(6),   ')',          'failed at #177')
  call g:assert.equals(getline(7),   ')',          'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #177')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #178
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #178')
  call g:assert.equals(getline(2), '[',   'failed at #178')
  call g:assert.equals(getline(3), '(',   'failed at #178')
  call g:assert.equals(getline(4), 'foo', 'failed at #178')
  call g:assert.equals(getline(5), ')',   'failed at #178')
  call g:assert.equals(getline(6), ']',   'failed at #178')
  call g:assert.equals(getline(7), '}',   'failed at #178')

  %delete

  """ on
  " #179
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #179')
  call g:assert.equals(getline(2), '(',   'failed at #179')
  call g:assert.equals(getline(3), '(',   'failed at #179')
  call g:assert.equals(getline(4), 'foo', 'failed at #179')
  call g:assert.equals(getline(5), ')',   'failed at #179')
  call g:assert.equals(getline(6), ')',   'failed at #179')
  call g:assert.equals(getline(7), ')',   'failed at #179')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #180
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #180')
  call g:assert.equals(getline(2), 'foo', 'failed at #180')
  call g:assert.equals(getline(3), '1+2', 'failed at #180')

  %delete

  """ 1
  " #181
  call operator#sandwich#set('add', 'line', 'eval', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #181')
  call g:assert.equals(getline(2), 'foo', 'failed at #181')
  call g:assert.equals(getline(3), '3',   'failed at #181')

  %delete

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'line', 'eval', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #182
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #182')
  call g:assert.equals(getline(2), 'foo', 'failed at #182')
  call g:assert.equals(getline(3), ']]',  'failed at #182')

  %delete

  """ off
  " #183
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #183')
  call g:assert.equals(getline(2), 'foo', 'failed at #183')
  call g:assert.equals(getline(3), '}}',  'failed at #183')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #184
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #184')
  call g:assert.equals(getline(2), 'foo ', 'failed at #184')
  call g:assert.equals(getline(3), ')',    'failed at #184')

  %delete

  """ off
  " #185
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #185')
  call g:assert.equals(getline(2), 'foo ', 'failed at #185')
  call g:assert.equals(getline(3), ')',    'failed at #185')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #186
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(', 'failed at #186')
  call g:assert.equals(getline(2), '',  'failed at #186')
  call g:assert.equals(getline(3), ')', 'failed at #186')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #187
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #187')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #188
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #188')
  call g:assert.equals(getline(2),   '    foo',    'failed at #188')
  call g:assert.equals(getline(3),   '    )',      'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #188')

  set autoindent&
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #189
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #189')
  call g:assert.equals(getline(2),   'foo',        'failed at #189')
  call g:assert.equals(getline(3),   ')',          'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #189')

  %delete

  " #190
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #190')
  call g:assert.equals(getline(2),   'foo',        'failed at #190')
  call g:assert.equals(getline(3),   ')',          'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #190')

  %delete

  " #191
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #191')
  call g:assert.equals(getline(2),   'foo',        'failed at #191')
  call g:assert.equals(getline(3),   ']',          'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #191')

  %delete

  " #192
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #192')
  call g:assert.equals(getline(2),   'foo',        'failed at #192')
  call g:assert.equals(getline(3),   ']',          'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #192')

  %delete

  " #193
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #193')
  call g:assert.equals(getline(2),   'foo',        'failed at #193')
  call g:assert.equals(getline(3),   '}',          'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #193')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #193')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #193')

  %delete

  " #194
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #194')
  call g:assert.equals(getline(2),   'foo',        'failed at #194')
  call g:assert.equals(getline(3),   '}',          'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #194')

  %delete

  " #195
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #195')
  call g:assert.equals(getline(2),   'foo',        'failed at #195')
  call g:assert.equals(getline(3),   '>',          'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #195')

  %delete

  " #196
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #196')
  call g:assert.equals(getline(2),   'foo',        'failed at #196')
  call g:assert.equals(getline(3),   '>',          'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #196')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #197
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #197')
  call g:assert.equals(getline(2), 'foo',          'failed at #197')
  call g:assert.equals(getline(3), 'a',            'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #197')

  %delete

  " #198
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #198')
  call g:assert.equals(getline(2), 'foo',          'failed at #198')
  call g:assert.equals(getline(3), '*',            'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #198')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #199
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #199')
  call g:assert.equals(getline(2),   'foo',        'failed at #199')
  call g:assert.equals(getline(3),   'bar',        'failed at #199')
  call g:assert.equals(getline(4),   'baz',        'failed at #199')
  call g:assert.equals(getline(5),   ')',          'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #199')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #200
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #200')
  call g:assert.equals(getline(2),   'a',          'failed at #200')
  call g:assert.equals(getline(3),   ')',          'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #200')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #201
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #201')
  call g:assert.equals(getline(2),   'aaa',        'failed at #201')
  call g:assert.equals(getline(3),   'foo',        'failed at #201')
  call g:assert.equals(getline(4),   'aaa',        'failed at #201')
  call g:assert.equals(getline(5),   'aa',         'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #201')

  %delete

  " #202
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #202')
  call g:assert.equals(getline(2),   'bbb',        'failed at #202')
  call g:assert.equals(getline(3),   'bb',         'failed at #202')
  call g:assert.equals(getline(4),   'foo',        'failed at #202')
  call g:assert.equals(getline(5),   'bb',         'failed at #202')
  call g:assert.equals(getline(6),   'bbb',        'failed at #202')
  call g:assert.equals(getline(7),   'bb',         'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #202')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #203
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #203')
  call g:assert.equals(getline(2),   '(',          'failed at #203')
  call g:assert.equals(getline(3),   'foo',        'failed at #203')
  call g:assert.equals(getline(4),   ')',          'failed at #203')
  call g:assert.equals(getline(5),   ']',          'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #203')

  %delete

  " #204
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #204')
  call g:assert.equals(getline(2),   '[',          'failed at #204')
  call g:assert.equals(getline(3),   '(',          'failed at #204')
  call g:assert.equals(getline(4),   'foo',        'failed at #204')
  call g:assert.equals(getline(5),   ')',          'failed at #204')
  call g:assert.equals(getline(6),   ']',          'failed at #204')
  call g:assert.equals(getline(7),   '}',          'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #204')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #205
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #205')
  call g:assert.equals(getline(2),   '(',          'failed at #205')
  call g:assert.equals(getline(3),   'foo',        'failed at #205')
  call g:assert.equals(getline(4),   ')',          'failed at #205')
  call g:assert.equals(getline(5),   ')',          'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #205')

  " #206
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #206')
  call g:assert.equals(getline(2),   '(',          'failed at #206')
  call g:assert.equals(getline(3),   '(',          'failed at #206')
  call g:assert.equals(getline(4),   'foo',        'failed at #206')
  call g:assert.equals(getline(5),   ')',          'failed at #206')
  call g:assert.equals(getline(6),   ')',          'failed at #206')
  call g:assert.equals(getline(7),   ')',          'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #206')

  %delete

  """ keep
  " #207
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #207')
  call g:assert.equals(getline(2),   '(',          'failed at #207')
  call g:assert.equals(getline(3),   'foo',        'failed at #207')
  call g:assert.equals(getline(4),   ')',          'failed at #207')
  call g:assert.equals(getline(5),   ')',          'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #207')

  " #208
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #208')
  call g:assert.equals(getline(2),   '(',          'failed at #208')
  call g:assert.equals(getline(3),   '(',          'failed at #208')
  call g:assert.equals(getline(4),   'foo',        'failed at #208')
  call g:assert.equals(getline(5),   ')',          'failed at #208')
  call g:assert.equals(getline(6),   ')',          'failed at #208')
  call g:assert.equals(getline(7),   ')',          'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #208')

  %delete

  """ inner_tail
  " #209
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #209')
  call g:assert.equals(getline(2),   '(',          'failed at #209')
  call g:assert.equals(getline(3),   'foo',        'failed at #209')
  call g:assert.equals(getline(4),   ')',          'failed at #209')
  call g:assert.equals(getline(5),   ')',          'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #209')

  " #210
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #210')
  call g:assert.equals(getline(2),   '(',          'failed at #210')
  call g:assert.equals(getline(3),   '(',          'failed at #210')
  call g:assert.equals(getline(4),   'foo',        'failed at #210')
  call g:assert.equals(getline(5),   ')',          'failed at #210')
  call g:assert.equals(getline(6),   ')',          'failed at #210')
  call g:assert.equals(getline(7),   ')',          'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #210')

  %delete

  """ front
  " #211
  call operator#sandwich#set('add', 'line', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #211')
  call g:assert.equals(getline(2),   '(',          'failed at #211')
  call g:assert.equals(getline(3),   'foo',        'failed at #211')
  call g:assert.equals(getline(4),   ')',          'failed at #211')
  call g:assert.equals(getline(5),   ')',          'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #211')

  " #212
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #212')
  call g:assert.equals(getline(2),   '(',          'failed at #212')
  call g:assert.equals(getline(3),   '(',          'failed at #212')
  call g:assert.equals(getline(4),   'foo',        'failed at #212')
  call g:assert.equals(getline(5),   ')',          'failed at #212')
  call g:assert.equals(getline(6),   ')',          'failed at #212')
  call g:assert.equals(getline(7),   ')',          'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #212')

  %delete

  """ end
  " #213
  call operator#sandwich#set('add', 'line', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #213')
  call g:assert.equals(getline(2),   '(',          'failed at #213')
  call g:assert.equals(getline(3),   'foo',        'failed at #213')
  call g:assert.equals(getline(4),   ')',          'failed at #213')
  call g:assert.equals(getline(5),   ')',          'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #213')

  " #214
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #214')
  call g:assert.equals(getline(2),   '(',          'failed at #214')
  call g:assert.equals(getline(3),   '(',          'failed at #214')
  call g:assert.equals(getline(4),   'foo',        'failed at #214')
  call g:assert.equals(getline(5),   ')',          'failed at #214')
  call g:assert.equals(getline(6),   ')',          'failed at #214')
  call g:assert.equals(getline(7),   ')',          'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #214')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #215
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #215')
  call g:assert.equals(getline(2), '[',   'failed at #215')
  call g:assert.equals(getline(3), '(',   'failed at #215')
  call g:assert.equals(getline(4), 'foo', 'failed at #215')
  call g:assert.equals(getline(5), ')',   'failed at #215')
  call g:assert.equals(getline(6), ']',   'failed at #215')
  call g:assert.equals(getline(7), '}',   'failed at #215')

  %delete

  """ on
  " #216
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #216')
  call g:assert.equals(getline(2), '(',   'failed at #216')
  call g:assert.equals(getline(3), '(',   'failed at #216')
  call g:assert.equals(getline(4), 'foo', 'failed at #216')
  call g:assert.equals(getline(5), ')',   'failed at #216')
  call g:assert.equals(getline(6), ')',   'failed at #216')
  call g:assert.equals(getline(7), ')',   'failed at #216')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #217
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #217')
  call g:assert.equals(getline(2), 'foo', 'failed at #217')
  call g:assert.equals(getline(3), '1+2', 'failed at #217')

  %delete

  """ 1
  " #218
  call operator#sandwich#set('add', 'line', 'eval', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #218')
  call g:assert.equals(getline(2), 'foo', 'failed at #218')
  call g:assert.equals(getline(3), '3',   'failed at #218')

  %delete

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'line', 'eval', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #219
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #219')
  call g:assert.equals(getline(2), 'foo', 'failed at #219')
  call g:assert.equals(getline(3), ']]',  'failed at #219')

  %delete

  """ off
  " #220
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #220')
  call g:assert.equals(getline(2), 'foo', 'failed at #220')
  call g:assert.equals(getline(3), '}}',  'failed at #220')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #221
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #221')
  call g:assert.equals(getline(2), 'foo ', 'failed at #221')
  call g:assert.equals(getline(3), ')',    'failed at #221')

  %delete

  """ off
  " #222
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #222')
  call g:assert.equals(getline(2), 'foo ', 'failed at #222')
  call g:assert.equals(getline(3), ')',    'failed at #222')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #223
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(', 'failed at #223')
  call g:assert.equals(getline(2), '',  'failed at #223')
  call g:assert.equals(getline(3), ')', 'failed at #223')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #224
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #224')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #225
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #225')
  call g:assert.equals(getline(2),   '    foo',    'failed at #225')
  call g:assert.equals(getline(3),   '    )',      'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #225')

  set autoindent&
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #226
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #226')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #226')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #226')

  %delete

  " #227
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #227')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #227')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #227')

  %delete

  " #228
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #228')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #228')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #228')

  %delete

  " #229
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #229')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #229')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #229')

  %delete

  " #230
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #230')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #230')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #230')

  %delete

  " #231
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #231')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #231')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #231')

  %delete

  " #232
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #232')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #232')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #232')

  %delete

  " #233
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #233')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #233')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #233')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #234
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #234')
  call g:assert.equals(getline(2),   'abara',      'failed at #234')
  call g:assert.equals(getline(3),   'abaza',      'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #234')

  %delete

  " #235
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #235')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #235')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #235')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #236
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #236')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #236')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #236')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #236')

  %delete

  " #237
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #237')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #237')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #237')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #237')

  %delete

  " #238
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #238')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #238')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #238')

  %delete

  " #239
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #239')
  call g:assert.equals(getline(2),   '',           'failed at #239')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #239')

  %delete

  " #240
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #240')
  call g:assert.equals(getline(2),   'ba',         'failed at #240')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #240')

  %delete

  " #241
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   'fo',         'failed at #241')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #241')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #241')

  %delete

  " #242
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #242')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #242')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #242')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #243
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #244')
  call g:assert.equals(getline(2),   '(a)',        'failed at #244')
  call g:assert.equals(getline(3),   '(a)',        'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #244')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #245
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #245')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #245')
  call g:assert.equals(getline(3),   'aa',         'failed at #245')
  call g:assert.equals(getline(4),   'aa',         'failed at #245')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #245')
  call g:assert.equals(getline(6),   'aa',         'failed at #245')
  call g:assert.equals(getline(7),   'aa',         'failed at #245')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #245')
  call g:assert.equals(getline(9),   'aa',         'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #246')
  call g:assert.equals(getline(2),   'bbb',         'failed at #246')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #246')
  call g:assert.equals(getline(4),   'bbb',         'failed at #246')
  call g:assert.equals(getline(5),   'bb',          'failed at #246')
  call g:assert.equals(getline(6),   'bb',          'failed at #246')
  call g:assert.equals(getline(7),   'bbb',         'failed at #246')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #246')
  call g:assert.equals(getline(9),   'bbb',         'failed at #246')
  call g:assert.equals(getline(10),  'bb',          'failed at #246')
  call g:assert.equals(getline(11),  'bb',          'failed at #246')
  call g:assert.equals(getline(12),  'bbb',         'failed at #246')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #246')
  call g:assert.equals(getline(14),  'bbb',         'failed at #246')
  call g:assert.equals(getline(15),  'bb',          'failed at #246')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #246')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #247
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #247')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #247')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #247')

  %delete

  " #248
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #248')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #248')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #248')

  %delete

  " #249
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #249')

  %delete

  " #250
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #250')

  %delete

  " #251
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #251')
  %delete

  " #252
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #252')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #252')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #252')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #252')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #253
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #253')

  " #254
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #254')

  """ keep
  " #255
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #255')

  " #256
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #256')

  """ inner_tail
  " #257
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #257')

  " #258
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #258')

  """ front
  " #259
  call operator#sandwich#set('add', 'block', 'cursor', 'front')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #259')

  " #260
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #260')

  """ end
  " #261
  call operator#sandwich#set('add', 'block', 'cursor', 'end')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #261')

  " #262
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #262')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #263
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #263')

  %delete

  """ on
  " #264
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #264')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #265
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #265')

  """ 1
  " #266
  call operator#sandwich#set('add', 'block', 'eval', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #266')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'block', 'eval', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #267
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #267')

  """ off
  " #268
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #268')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #269
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #269')

  """ off
  " #270
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #270')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #271
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '()',  'failed at #271')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #272
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #272')
  call g:assert.equals(getline(2), 'foo', 'failed at #272')
  call g:assert.equals(getline(3), ')',   'failed at #272')

  %delete

  " #273
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #273')
  call g:assert.equals(getline(2),   '    foo',    'failed at #273')
  call g:assert.equals(getline(3),   '    )',      'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #273')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #274
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #274')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #274')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #274')

  " #275
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #275')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #275')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #275')

  " #276
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #276')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #276')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #276')

  " #277
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #277')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #277')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #277')

  " #278
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #278')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #278')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #278')

  " #279
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #279')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #279')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #279')

  " #280
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #280')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #280')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #280')

  " #281
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #281')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #281')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #281')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #282
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #282')
  call g:assert.equals(getline(2),   'abara',      'failed at #282')
  call g:assert.equals(getline(3),   'abaza',      'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #283')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #283')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #283')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #284
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #284')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #284')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #284')

  %delete

  " #285
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #285')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #285')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #285')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #285')

  %delete

  " #286
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #286')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #286')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #286')

  %delete

  " #287
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #287')
  call g:assert.equals(getline(2),   '',           'failed at #287')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #287')

  %delete

  " #288
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #288')
  call g:assert.equals(getline(2),   'ba',         'failed at #288')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #288')

  %delete

  " #289
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'fo',         'failed at #289')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #289')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #289')

  %delete

  " #290
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #290')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #290')
  call g:assert.equals(getline(3),   'ba',         'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #290')

  %delete

  " #291
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #291')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #291')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #291')

  %delete

  """ terminal-extended block-wise visual mode
  " #292
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #292')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #292')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #292')

  %delete

  " #293
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #293')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #293')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #293')

  %delete

  " #294
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #294')
  call g:assert.equals(getline(2),   '',           'failed at #294')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #294')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #295
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #295')

  %delete

  " #296
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #296')
  call g:assert.equals(getline(2),   '(a)',        'failed at #296')
  call g:assert.equals(getline(3),   '(a)',        'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #296')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #297
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #297')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #297')
  call g:assert.equals(getline(3),   'aa',         'failed at #297')
  call g:assert.equals(getline(4),   'aa',         'failed at #297')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #297')
  call g:assert.equals(getline(6),   'aa',         'failed at #297')
  call g:assert.equals(getline(7),   'aa',         'failed at #297')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #297')
  call g:assert.equals(getline(9),   'aa',         'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #297')

  %delete

  " #298
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #298')
  call g:assert.equals(getline(2),   'bbb',         'failed at #298')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #298')
  call g:assert.equals(getline(4),   'bbb',         'failed at #298')
  call g:assert.equals(getline(5),   'bb',          'failed at #298')
  call g:assert.equals(getline(6),   'bb',          'failed at #298')
  call g:assert.equals(getline(7),   'bbb',         'failed at #298')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #298')
  call g:assert.equals(getline(9),   'bbb',         'failed at #298')
  call g:assert.equals(getline(10),  'bb',          'failed at #298')
  call g:assert.equals(getline(11),  'bb',          'failed at #298')
  call g:assert.equals(getline(12),  'bbb',         'failed at #298')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #298')
  call g:assert.equals(getline(14),  'bbb',         'failed at #298')
  call g:assert.equals(getline(15),  'bb',          'failed at #298')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #298')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #299
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #299')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #299')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #299')

  %delete

  " #300
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #300')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #300')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #300')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #301
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #301')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #301')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #301')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #301')

  " #302
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #302')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #302')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #302')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #302')

  %delete

  """ keep
  " #303
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #303')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #303')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #303')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #303')

  " #304
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #304')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #304')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #304')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #304')

  %delete

  """ inner_tail
  " #305
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #305')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #305')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #305')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #305')

  " #306
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #306')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #306')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #306')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #306')

  %delete

  """ front
  " #307
  call operator#sandwich#set('add', 'block', 'cursor', 'front')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #307')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #307')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #307')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #307')

  " #308
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #308')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #308')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #308')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #308')

  %delete

  """ end
  " #309
  call operator#sandwich#set('add', 'block', 'cursor', 'end')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #309')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #309')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #309')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #309')

  " #310
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #310')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #310')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #310')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #310')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #311
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #311')

  %delete

  """ on
  " #312
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #312')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #313
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #313')

  """ 1
  " #314
  call operator#sandwich#set('add', 'block', 'eval', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #314')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('add', 'block', 'eval', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [{'buns': ['[[', ']]'], 'input':['(']}]
  inoremap [ {
  inoremap ] }

  """ on
  " #315
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #315')

  """ off
  " #316
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #316')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #317
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #317')

  """ off
  " #318
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #318')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #319
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '()',  'failed at #319')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #320
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #320')
  call g:assert.equals(getline(2), 'foo', 'failed at #320')
  call g:assert.equals(getline(3), ')',   'failed at #320')

  %delete

  " #321
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #321')
  call g:assert.equals(getline(2),   '    foo',    'failed at #321')
  call g:assert.equals(getline(3),   '    )',      'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #321')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #321')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #321')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
