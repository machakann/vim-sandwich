scriptencoding utf-8

let s:suite = themis#suite('operator-sandwich: delete:')

function! s:suite.before() abort  "{{{
  nmap sd <Plug>(operator-sandwich-delete)
  xmap sd <Plug>(operator-sandwich-delete)
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
  silent! ounmap ssd
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

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  set filetype=vim

  " #5
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  " #7
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #8')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #9
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['add']},
        \ ]

  " #10
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['delete']},
        \ ]

  " #11
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['replace']},
        \ ]

  " #12
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #12')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['operator']},
        \ ]

  " #13
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['all']},
        \ ]

  " #14
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #14')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #15
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #15')

  " #16
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #16')

  " #17
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #17')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['all']},
        \ ]

  " #18
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #18')

  " #19
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #19')

  " #20
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #20')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['char']},
        \ ]

  " #21
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #21')

  " #22
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #22')

  " #23
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #23')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['line']},
        \ ]

  " #24
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #24')

  " #25
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #25')

  " #26
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #26')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['block']},
        \ ]

  " #27
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #27')

  " #28
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #28')

  " #29
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #29')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #30
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #30')

  " #31
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #31')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['n']},
        \ ]

  " #32
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #32')

  " #33
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #33')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['x']},
        \ ]

  " #34
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #34')

  " #35
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #35')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #36
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #36')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['all']},
        \ ]

  " #37
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #37')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['add']},
        \ ]

  " #38
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #38')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['delete']},
        \ ]

  " #39
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #39')
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

  " #40
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #40')

  " #41
  call setline('.', '[foo]')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #41')

  " #42
  call setline('.', '{foo}')
  normal 0sd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #42')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #43
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #43')

  " #44
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #44')

  " #45
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo',        'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #45')

  " #46
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), 'foo',        'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #46')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #47
  call setline('.', 'afooa')
  normal 0sdiw
  call g:assert.equals(getline('.'), 'foo',        'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #47')

  " #48
  call setline('.', '*foo*')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #48')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #49
  call setline('.', '(foo)bar')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #49')

  " #50
  call setline('.', 'foo(bar)')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #50')

  " #51
  call setline('.', 'foo(bar)baz')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #51')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))']}]

  " #52
  call setline('.', 'foo((bar))baz')
  normal 0sdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #52')

  " #53
  call setline('.', 'foo((bar))baz')
  normal 02lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #53')

  " #54
  call setline('.', 'foo((bar))baz')
  normal 03lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #54')

  " #55
  call setline('.', 'foo((bar))baz')
  normal 04lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #55')

  " #56
  call setline('.', 'foo((bar))baz')
  normal 05lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #56')

  " #57
  call setline('.', 'foo((bar))baz')
  normal 07lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #57')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #57')

  " #58
  call setline('.', 'foo((bar))baz')
  normal 08lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #58')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #58')

  " #59
  call setline('.', 'foo((bar))baz')
  normal 09lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #59')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #59')

  " #60
  call setline('.', 'foo((bar))baz')
  normal 010lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #60')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #60')

  " #61
  call setline('.', 'foo((bar))baz')
  normal 012lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #61')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #61')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #62
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsd13l
  call g:assert.equals(getline(1),   'foo',        'failed at #62')
  call g:assert.equals(getline(2),   'bar',        'failed at #62')
  call g:assert.equals(getline(3),   'baz',        'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #62')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #63
  call setline('.', '(a)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'a',          'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #63')

  %delete

  " #64
  call append(0, ['(', 'a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #64')
  call g:assert.equals(getline(2),   'a',          'failed at #64')
  call g:assert.equals(getline(3),   '',           'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #64')

  %delete

  " #65
  call append(0, ['(a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   'a',          'failed at #65')
  call g:assert.equals(getline(2),   '',           'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #65')

  %delete

  " #66
  call append(0, ['(', 'a)'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #66')
  call g:assert.equals(getline(2),   'a',          'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #66')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #67
  call setline('.', '()')
  normal 0sd2l
  call g:assert.equals(getline('.'), '',           'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #67')

  %delete

  " #68
  call setline('.', 'foo()bar')
  normal 03lsd2l
  call g:assert.equals(getline('.'), 'foobar',     'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #68')

  %delete
  set whichwrap=h,l

  " #69
  call append(0, ['(', ')'])
  normal ggsd3l
  call g:assert.equals(getline(1),   '',           'failed at #69')
  call g:assert.equals(getline(2),   '',           'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #69')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #70
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd15l
  call g:assert.equals(getline(1),   'foo',        'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #70')

  %delete

  " #71
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd21l
  call g:assert.equals(getline(1),   'foo',        'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #71')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')

  " #72
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #72')

  %delete

  " #73
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #73')

  %delete

  " #74
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #74')

  %delete

  " #75
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #75')

  %delete

  " #76
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #76')

  %delete

  " #77
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #77')

  %delete

  " #78
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #78')

  %delete

  " #79
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #79')

  %delete

  " #80
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #80')

  %delete

  " #81
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #81')

  %delete

  " #82
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #82')

  %delete

  " #83
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #83')

  %delete

  " #84
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #84')

  %delete

  " #85
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #85')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #86
  call setline('.', '((foo))')
  normal 02sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #86')

  " #87
  call setline('.', '{[(foo)]}')
  normal 03sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #87')

  " #88
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #88')

  " #89
  call setline('.', '[(foo bar)]')
  normal 02sd11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #89')

  " #90
  call setline('.', 'foo{[(bar)]}baz')
  normal 03l3sd9l
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #90')
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

  " #91
  call setline('.', '{[(foo)]}')
  normal 02lsd5l
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #91')

  " #92
  call setline('.', '{[(foo)]}')
  normal 0lsd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #92')

  " #93
  call setline('.', '{[(foo)]}')
  normal 0sd9l
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #93')

  " #94
  call setline('.', '<title>foo</title>')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #94')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #106
  call setline('.', '(α)')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'α',          'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #106')

  " #107
  call setline('.', '(aα)')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'aα',         'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #107')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #108
  call setline('.', 'αaα')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'a',          'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #108')

  " #109
  call setline('.', 'ααα')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'α',          'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #109')

  " #110
  call setline('.', 'αaαα')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'aα',         'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #110')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #111
  call setline('.', 'aαaaα')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'a',          'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #111')

  " #112
  call setline('.', 'aααaα')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'α',          'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #112')

  " #113
  call setline('.', 'aαaαaα')
  normal 0sd6l
  call g:assert.equals(getline('.'), 'aα',         'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #113')

  unlet g:operator#sandwich#recipes

  " #114
  call setline('.', '(“)')
  normal 0sd3l
  call g:assert.equals(getline('.'), '“',          'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #114')

  " #115
  call setline('.', '(a“)')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'a“',         'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #115')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #116
  call setline('.', '“a“')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'a',          'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #116')

  " #117
  call setline('.', '“““')
  normal 0sd3l
  call g:assert.equals(getline('.'), '“',          'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #117')

  " #118
  call setline('.', '“a““')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'a“',         'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #118')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #119
  call setline('.', 'a“aa“')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'a',          'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #119')

  " #120
  call setline('.', 'a““a“')
  normal 0sd5l
  call g:assert.equals(getline('.'), '“',          'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #120')

  " #121
  call setline('.', 'a“a“a“')
  normal 0sd6l
  call g:assert.equals(getline('.'), 'a“',         'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #121')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #95
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #95')

  " #96
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #96')

  """ keep
  " #97
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #97')

  " #98
  normal 2lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #98')

  """ inner_tail
  " #99
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #99')

  " #100
  normal hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #100')

  """ head
  " #101
  call operator#sandwich#set('delete', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #101')

  " #102
  normal 3lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #102')

  """ tail
  " #103
  call operator#sandwich#set('delete', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #103')

  " #104
  normal 3hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #104')

  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #105
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #105')

  " #106
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #106')

  """ off
  " #107
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #107')

  " #108
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #108')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #109
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #109')

  " #110
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #110')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #111
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #111')

  " #112
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #112')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ 1
  " #113
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #113')

  " #114
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #114')

  " #115
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #115')

  " #116
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #116')

  """ 2
  call operator#sandwich#set('delete', 'char', 'skip_space', 2)
  " #117
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #117')

  " #118
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #118')

  " #119
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #119')

  " #120
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo ', 'failed at #120')

  """ 0
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #121
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #121')

  " #122
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #122')

  " #123
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #123')

  " #124
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #124')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #125
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #125')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #126
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #126')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[d`]'])

  " #127
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #127')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #128
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #128')

  %delete

  " #129
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #129')

  %delete

  " #130
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'aa',         'failed at #130')
  call g:assert.equals(getline(2),   'foo',        'failed at #130')
  call g:assert.equals(getline(3),   'aa',         'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #130')

  %delete

  " #131
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'aa',         'failed at #131')
  call g:assert.equals(getline(2),   'foo',        'failed at #131')
  call g:assert.equals(getline(3),   '',           'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #131')

  %delete

  " #132
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'foo',        'failed at #132')
  call g:assert.equals(getline(2),   'aa',         'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #132')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #133
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #133')

  %delete

  " #134
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #134')

  %delete

  " #135
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #135')

  %delete

  " #136
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsd5l
  call g:assert.equals(getline(1),   'aa',         'failed at #136')
  call g:assert.equals(getline(2),   'bb',         'failed at #136')
  call g:assert.equals(getline(3),   '',           'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #136')

  set whichwrap&
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #137
  call setline('.', '(foo)')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #137')

  " #138
  call setline('.', '[foo]')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #138')

  " #139
  call setline('.', '{foo}')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #139')

  " #140
  call setline('.', '<foo>')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #140')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #141
  call setline('.', 'afooa')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #141')

  " #142
  call setline('.', '*foo*')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #142')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #143
  call setline('.', '(foo)bar')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #143')

  " #144
  call setline('.', 'foo(bar)')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #144')

  " #145
  call setline('.', 'foo(bar)baz')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #145')

  %delete

  " #146
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv2j3lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #146')
  call g:assert.equals(getline(2),   'bar',        'failed at #146')
  call g:assert.equals(getline(3),   'baz',        'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #146')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #147
  call setline('.', '(a)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #147')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #148
  call setline('.', '()')
  normal 0vlsd
  call g:assert.equals(getline('.'), '',           'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #148')

  %delete

  " #149
  call setline('.', 'foo()bar')
  normal 03lvlsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #149')

  %delete

  " #150
  call append(0, ['(', ')'])
  normal ggvjsd
  call g:assert.equals(getline(1),   '',           'failed at #150')
  call g:assert.equals(getline(2),   '',           'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #150')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #151
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv2jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #151')

  %delete

  " #152
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv4jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #152')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #153
  call setline('.', '((foo))')
  normal 0v$2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #153')

  " #154
  call setline('.', '{[(foo)]}')
  normal 0v$3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #154')

  " #155
  call setline('.', 'foo{[(bar)]}baz')
  normal 03lv8l3sd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #155')
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

  " #156
  call setline('.', '{[(foo)]}')
  normal 02lv4lsd
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #156')

  " #157
  call setline('.', '{[(foo)]}')
  normal 0lv6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #157')

  " #158
  call setline('.', '{[(foo)]}')
  normal 0v8lsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #158')

  " #159
  call setline('.', '<title>foo</title>')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #159')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #160
  call setline('.', '(α)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #160')

  " #161
  call setline('.', '(aα)')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #161')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #162
  call setline('.', 'αaα')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #162')

  " #163
  call setline('.', 'ααα')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #163')

  " #164
  call setline('.', 'αaαα')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #164')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #165
  call setline('.', 'aαaaα')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #165')

  " #166
  call setline('.', 'aααaα')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #166')

  " #167
  call setline('.', 'aαaαaα')
  normal 0v5lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #167')

  unlet g:operator#sandwich#recipes

  " #168
  call setline('.', '(“)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), '“',          'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #168')

  " #169
  call setline('.', '(a“)')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #169')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #170
  call setline('.', '“a“')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #170')

  " #171
  call setline('.', '“““')
  normal 0v2lsd
  call g:assert.equals(getline('.'), '“',          'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #171')

  " #172
  call setline('.', '“a““')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #172')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #173
  call setline('.', 'a“aa“')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #173')

  " #174
  call setline('.', 'a““a“')
  normal 0v4lsd
  call g:assert.equals(getline('.'), '“',          'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #174')

  " #175
  call setline('.', 'a“a“a“')
  normal 0v5lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #175')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #176
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #176')

  " #177
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #177')

  """ keep
  " #178
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #178')

  " #179
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #179')

  """ inner_tail
  " #180
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #180')

  " #181
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #181')

  """ head
  " #182
  call operator#sandwich#set('delete', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #182')

  " #183
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #183')

  """ tail
  " #184
  call operator#sandwich#set('delete', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #184')

  " #185
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #185')

  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #186
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #186')

  " #187
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #187')

  """ off
  " #188
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #188')

  " #189
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #189')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #190
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #190')

  " #191
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #191')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #192
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #192')

  " #193
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #193')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ 1
  " #194
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #194')

  " #195
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #195')

  " #196
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #196')

  " #197
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #197')

  """ 2
  call operator#sandwich#set('delete', 'char', 'skip_space', 2)
  " #198
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #198')

  " #199
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #199')

  " #200
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #200')

  " #201
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #201')

  """ 0
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #202
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #202')

  " #203
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #203')

  " #204
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #204')

  " #205
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #205')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #206
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #206')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #207
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #207')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[d`]'])

  " #208
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #208')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #209
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #209')

  %delete

  " #210
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #210')

  %delete

  " #211
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #211')
  call g:assert.equals(getline(2),   'foo',        'failed at #211')
  call g:assert.equals(getline(3),   'aa',         'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #211')

  %delete

  " #212
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #212')
  call g:assert.equals(getline(2),   'foo',        'failed at #212')
  call g:assert.equals(getline(3),   '',           'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #212')

  %delete

  " #213
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #213')
  call g:assert.equals(getline(2),   'aa',         'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #213')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #214
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #214')

  %delete

  " #215
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #215')

  %delete

  " #216
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #216')

  %delete

  " #217
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #217')
  call g:assert.equals(getline(2),   'bb',         'failed at #217')
  call g:assert.equals(getline(3),   '',           'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #217')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #218
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #218')

  " #219
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #219')

  " #220
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #220')

  " #221
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #221')

  %delete

  " #222
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #222')

  %delete

  " #223
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #223')

  %delete

  " #224
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #224')

  %delete

  " #225
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #225')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #226
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #226')

  " #227
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #227')

  %delete

  " #228
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #228')

  %delete

  " #229
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #229')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #230
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #230')
  call g:assert.equals(getline(2),   'bar',        'failed at #230')
  call g:assert.equals(getline(3),   'baz',        'failed at #230')
  call g:assert.equals(getline(4),   '',           'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #230')

  %delete

  " #231
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #231')
  call g:assert.equals(getline(2),   'bar',        'failed at #231')
  call g:assert.equals(getline(3),   'baz',        'failed at #231')
  call g:assert.equals(getline(4),   '',           'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #231')

  %delete

  " #232
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #232')
  call g:assert.equals(getline(2),   'bar',        'failed at #232')
  call g:assert.equals(getline(3),   'baz',        'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #232')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #233
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #233')

  %delete

  " #234
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #234')

  %delete

  " #235
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #235')

  %delete

  " #236
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #236')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #237
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #237')

  %delete

  " #238
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #238')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #239
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #239')

  %delete

  " #240
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #240')

  %delete

  " #241
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #241')

  %delete

  " #242
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #242')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #243
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #243')

  " #244
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #244')

  " #245
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #245')

  " #246
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #247')
  call g:assert.equals(getline(2),   'bar',        'failed at #247')
  call g:assert.equals(getline(3),   'baz',        'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #247')
endfunction
"}}}
function! s:suite.linewise_n_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #248
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #248')

  " #249
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #249')

  " #250
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #250')

  " #251
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #251')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #252
  call append(0, ['(', 'α', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α',            'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #252')

  %delete

  " #253
  call append(0, ['(', 'aα', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα',           'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #253')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #254
  call append(0, ['α', 'a', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #254')

  %delete

  " #255
  call append(0, ['α', 'α', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α', 'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #255')

  %delete

  " #256
  call append(0, ['α', 'aα', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα', 'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #256')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #257
  call append(0, ['aα', 'a', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #257')

  %delete

  " #258
  call append(0, ['aα', 'α', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α', 'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #258')

  %delete

  " #259
  call append(0, ['aα', 'aα', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα', 'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #259')

  %delete
  unlet g:operator#sandwich#recipes

  " #260
  call append(0, ['(', '“', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #260')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #260')

  %delete

  " #261
  call append(0, ['(', 'a“', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #261')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #261')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #262
  call append(0, ['“', 'a', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #262')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #262')

  %delete

  " #263
  call append(0, ['“', '“', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #263')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #263')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #263')

  %delete

  " #264
  call append(0, ['“', 'a“', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #264')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #265
  call append(0, ['a“', 'a', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #265')

  %delete

  " #266
  call append(0, ['a“', '“', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #266')

  %delete

  " #267
  call append(0, ['a“', 'a“', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #267')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #268
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #268')

  " #269
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #269')

  """ keep
  " #270
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #270')

  " #271
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #271')

  """ inner_tail
  " #272
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #272')

  " #273
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #273')

  """ head
  " #274
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #274')

  " #275
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #275')

  """ tail
  " #276
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #276')

  " #277
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #277')

  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #278
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #278')

  " #279
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #279')

  """ off
  " #280
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #280')

  " #281
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #281')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #282
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #282')

  " #283
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #283')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #284
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #284')

  " #285
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #285')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ 2
  " #286
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #286')

  " #287
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #287')

  " #288
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #288')

  " #289
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo ', 'failed at #289')

  """ 1
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
  " #290
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #290')

  " #291
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #291')

  " #292
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #292')

  " #293
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #293')

  """ 0
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #294
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #294')

  " #295
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #295')

  " #296
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #296')

  " #297
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #297')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #298
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #298')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #299
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #299')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #300
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #300')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #301
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #301')
  call g:assert.equals(getline(2),   'foo',        'failed at #301')
  call g:assert.equals(getline(3),   '',           'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #301')

  %delete

  " #302
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #302')
  call g:assert.equals(getline(2),   'foo',        'failed at #302')
  call g:assert.equals(getline(3),   '  ',         'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #303')
  call g:assert.equals(getline(2),   'foo',        'failed at #303')
  call g:assert.equals(getline(3),   'aa',         'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #303')

  %delete

  " #304
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #304')
  call g:assert.equals(getline(2),   'foo',        'failed at #304')
  call g:assert.equals(getline(3),   '',           'failed at #304')
  call g:assert.equals(getline(4),   '',           'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #304')

  %delete

  " #305
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #305')
  call g:assert.equals(getline(2),   'foo',        'failed at #305')
  call g:assert.equals(getline(3),   'aa',         'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #305')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #306
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #307')

  %delete

  " #308
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #308')

  %delete

  " #309
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #309')
  call g:assert.equals(getline(2),   'bb',         'failed at #309')
  call g:assert.equals(getline(3),   '',           'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #309')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #310
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #310')

  " #311
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #311')

  " #312
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #312')

  " #313
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #314')

  %delete

  " #315
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #315')

  %delete

  " #316
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #316')

  %delete

  " #317
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #317')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #318
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #318')

  " #319
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #319')

  %delete

  " #320
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #320')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #320')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #320')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #320')

  %delete

  " #321
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #321')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #321')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #321')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #321')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #322
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #322')
  call g:assert.equals(getline(2),   'bar',        'failed at #322')
  call g:assert.equals(getline(3),   'baz',        'failed at #322')
  call g:assert.equals(getline(4),   '',           'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #322')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #322')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #322')

  %delete

  " #323
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #323')
  call g:assert.equals(getline(2),   'bar',        'failed at #323')
  call g:assert.equals(getline(3),   'baz',        'failed at #323')
  call g:assert.equals(getline(4),   '',           'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #323')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #323')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #323')

  %delete

  " #324
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #324')
  call g:assert.equals(getline(2),   'bar',        'failed at #324')
  call g:assert.equals(getline(3),   'baz',        'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #324')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #324')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #324')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #325
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #325')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #325')

  %delete

  " #326
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #326')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #326')

  %delete

  " #327
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #327')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #327')

  %delete

  " #328
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #328')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #328')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #328')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #328')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #257
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #257')

  %delete

  " #258
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #258')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #329
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #329')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #329')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #329')

  %delete

  " #330
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #330')

  %delete

  " #331
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #331')

  %delete

  " #332
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #332')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #333
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #333')

  " #334
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #334')

  " #335
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #335')

  " #336
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #336')

  %delete

  " #337
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #337')
  call g:assert.equals(getline(2),   'bar',        'failed at #337')
  call g:assert.equals(getline(3),   'baz',        'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #337')
endfunction
"}}}
function! s:suite.linewise_x_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #338
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #338')

  " #339
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #339')

  " #340
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #340')

  " #341
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #341')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #342
  call append(0, ['(', 'α', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α',            'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #342')

  %delete

  " #343
  call append(0, ['(', 'aα', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα',           'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #343')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #344
  call append(0, ['α', 'a', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #344')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #344')

  %delete

  " #345
  call append(0, ['α', 'α', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α', 'failed at #345')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #345')

  %delete

  " #346
  call append(0, ['α', 'aα', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα', 'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #346')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #347
  call append(0, ['aα', 'a', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #347')

  %delete

  " #348
  call append(0, ['aα', 'α', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α', 'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #348')

  %delete

  " #349
  call append(0, ['aα', 'aα', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα', 'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #349')

  %delete
  unlet g:operator#sandwich#recipes

  " #350
  call append(0, ['(', '“', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #350')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #350')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #350')

  %delete

  " #351
  call append(0, ['(', 'a“', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #351')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #352
  call append(0, ['“', 'a', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #352')

  %delete

  " #353
  call append(0, ['“', '“', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #353')

  %delete

  " #354
  call append(0, ['“', 'a“', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #354')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #355
  call append(0, ['a“', 'a', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #355')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #355')

  %delete

  " #356
  call append(0, ['a“', '“', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #356')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #356')

  %delete

  " #357
  call append(0, ['a“', 'a“', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #357')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #358
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #358')

  " #359
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #359')

  """ keep
  " #360
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #360')

  " #361
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #361')

  """ inner_tail
  " #362
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #362')

  " #363
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #363')

  """ head
  " #364
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #364')

  " #365
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #365')

  """ tail
  " #366
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #366')

  " #367
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #367')

  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #368
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #368')

  " #369
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #369')

  """ off
  " #370
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #370')

  " #371
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #371')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #372
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #372')

  " #373
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #373')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #374
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #374')

  " #375
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #375')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ 2
  " #376
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #376')

  " #377
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #377')

  " #378
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #378')

  " #379
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #379')

  """ 1
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
  " #380
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #380')

  " #381
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #381')

  " #382
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #382')

  " #383
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #383')

  """ 0
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #384
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #384')

  " #385
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #385')

  " #386
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #386')

  " #387
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #387')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #388
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #388')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #389
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #389')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #390
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #390')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #391
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #391')
  call g:assert.equals(getline(2),   'foo',        'failed at #391')
  call g:assert.equals(getline(3),   '',           'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #391')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #391')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #391')

  %delete

  " #392
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #392')
  call g:assert.equals(getline(2),   'foo',        'failed at #392')
  call g:assert.equals(getline(3),   '  ',         'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #392')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #392')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #392')

  %delete

  " #393
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #393')
  call g:assert.equals(getline(2),   'foo',        'failed at #393')
  call g:assert.equals(getline(3),   'aa',         'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #393')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #393')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #393')

  %delete

  " #394
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #394')
  call g:assert.equals(getline(2),   'foo',        'failed at #394')
  call g:assert.equals(getline(3),   '',           'failed at #394')
  call g:assert.equals(getline(4),   '',           'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #394')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #394')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #394')

  %delete

  " #395
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #395')
  call g:assert.equals(getline(2),   'foo',        'failed at #395')
  call g:assert.equals(getline(3),   'aa',         'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #395')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #395')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #396
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #396')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #396')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #396')

  %delete

  " #397
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #397')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #397')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #397')

  %delete

  " #398
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #398')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #398')

  %delete

  " #399
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #399')
  call g:assert.equals(getline(2),   'bb',         'failed at #399')
  call g:assert.equals(getline(3),   '',           'failed at #399')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #399')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #399')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #399')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #400
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #400')
  call g:assert.equals(getline(2),   'bar',        'failed at #400')
  call g:assert.equals(getline(3),   'baz',        'failed at #400')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #400')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #400')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #400')

  %delete

  " #401
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #401')
  call g:assert.equals(getline(2),   'bar',        'failed at #401')
  call g:assert.equals(getline(3),   'baz',        'failed at #401')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #401')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #401')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #401')

  %delete

  " #402
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #402')
  call g:assert.equals(getline(2),   'bar',        'failed at #402')
  call g:assert.equals(getline(3),   'baz',        'failed at #402')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #402')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #402')

  %delete

  " #403
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #403')
  call g:assert.equals(getline(2),   'bar',        'failed at #403')
  call g:assert.equals(getline(3),   'baz',        'failed at #403')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #403')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #403')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #403')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #404
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #404')
  call g:assert.equals(getline(2),   'bar',        'failed at #404')
  call g:assert.equals(getline(3),   'baz',        'failed at #404')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #404')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #404')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #404')

  " #405
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #405')
  call g:assert.equals(getline(2),   'bar',        'failed at #405')
  call g:assert.equals(getline(3),   'baz',        'failed at #405')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #405')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #405')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #405')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #406
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #406')
  call g:assert.equals(getline(2),   'foobar',     'failed at #406')
  call g:assert.equals(getline(3),   'foobar',     'failed at #406')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #406')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #406')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #406')

  %delete

  " #407
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #407')
  call g:assert.equals(getline(2),   'foobar',     'failed at #407')
  call g:assert.equals(getline(3),   'foobar',     'failed at #407')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #407')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #407')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #407')

  %delete

  " #408
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #408')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #408')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #408')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #408')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #408')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #408')

  %delete

  " #409
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #409')
  call g:assert.equals(getline(2),   'bar',        'failed at #409')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #409')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #409')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #409')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #409')

  %delete

  " #410
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #410')
  call g:assert.equals(getline(2),   'barbar',     'failed at #410')
  call g:assert.equals(getline(3),   'baz',        'failed at #410')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #410')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #410')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #410')

  %delete

  " #411
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #411')
  call g:assert.equals(getline(2),   'bar',        'failed at #411')
  call g:assert.equals(getline(3),   'baz',        'failed at #411')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #411')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #411')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #411')

  %delete

  " #412
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foo',        'failed at #412')
  call g:assert.equals(getline(2),   'baar',       'failed at #412')
  call g:assert.equals(getline(3),   'baaz',       'failed at #412')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #412')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #412')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #412')

  %delete

  " #413
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'fooo',       'failed at #413')
  call g:assert.equals(getline(2),   'bar',        'failed at #413')
  call g:assert.equals(getline(3),   'baaz',       'failed at #413')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #413')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #413')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #413')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #414
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #414')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #414')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #414')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #414')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #415
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #415')
  call g:assert.equals(getline(2),   '',           'failed at #415')
  call g:assert.equals(getline(3),   '',           'failed at #415')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #415')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #415')

  %delete

  " #416
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #416')
  call g:assert.equals(getline(2),   'foobar',     'failed at #416')
  call g:assert.equals(getline(3),   'foobar',     'failed at #416')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #416')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #416')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #416')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #417
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #417')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #417')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #417')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #417')

  " #418
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #418')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #418')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #418')

  " #419
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #419')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #419')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #419')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #419')

  " #420
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #420')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #420')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #420')

  " #421
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #421')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #421')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #421')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #421')

  %delete

  " #422
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #422')
  call g:assert.equals(getline(2),   'bar',        'failed at #422')
  call g:assert.equals(getline(3),   'baz',        'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #422')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #422')

  %delete

  " #423
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #423')
  call g:assert.equals(getline(2),   'bar',        'failed at #423')
  call g:assert.equals(getline(3),   'baz',        'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #423')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #423')

  %delete

  " #424
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #424')
  call g:assert.equals(getline(2),   'abarb',      'failed at #424')
  call g:assert.equals(getline(3),   'baz',        'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #424')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #424')

  %delete

  " #425
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #425')
  call g:assert.equals(getline(2),   'bar',        'failed at #425')
  call g:assert.equals(getline(3),   'abazb',      'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #425')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #425')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_external_textobj() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #426
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #426')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #426')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #426')

  %delete

  " #427
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #427')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #427')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #427')

  %delete

  " #428
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #428')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #428')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #428')

  %delete

  " #429
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #429')
  call g:assert.equals(getline(2), 'bar', 'failed at #429')
  call g:assert.equals(getline(3), 'baz', 'failed at #429')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #430
  call append(0, ['(α)', '(β)', '(γ)'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'α', 'failed at #430')
  call g:assert.equals(getline(2), 'β', 'failed at #430')
  call g:assert.equals(getline(3), 'γ', 'failed at #430')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #430')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #430')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #430')

  %delete

  " #431
  call append(0, ['(aα)', '(bβ)', '(cγ)'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'aα', 'failed at #431')
  call g:assert.equals(getline(2), 'bβ', 'failed at #431')
  call g:assert.equals(getline(3), 'cγ', 'failed at #431')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #431')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #431')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #431')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #432
  call append(0, ['αaα', 'αbα', 'αcα'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'a', 'failed at #432')
  call g:assert.equals(getline(2), 'b', 'failed at #432')
  call g:assert.equals(getline(3), 'c', 'failed at #432')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #432')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #432')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #432')

  %delete

  " #433
  call append(0, ['ααα', 'αβα', 'αγα'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'α', 'failed at #433')
  call g:assert.equals(getline(2), 'β', 'failed at #433')
  call g:assert.equals(getline(3), 'γ', 'failed at #433')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #433')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #433')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #433')

  %delete

  " #434
  call append(0, ['αaαα', 'αbβα', 'αcγα'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'aα', 'failed at #434')
  call g:assert.equals(getline(2), 'bβ', 'failed at #434')
  call g:assert.equals(getline(3), 'cγ', 'failed at #434')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #434')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #434')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #434')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #435
  call append(0, ['aαaaα', 'aαbaα', 'aαcaα'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'a', 'failed at #435')
  call g:assert.equals(getline(2), 'b', 'failed at #435')
  call g:assert.equals(getline(3), 'c', 'failed at #435')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #435')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #435')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #435')

  %delete

  " #436
  call append(0, ['aααaα', 'aαβaα', 'aαγaα'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'α', 'failed at #436')
  call g:assert.equals(getline(2), 'β',  'failed at #436')
  call g:assert.equals(getline(3), 'γ', 'failed at #436')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #436')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #436')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #436')

  %delete

  " #437
  call append(0, ['aαaαaα', 'aαbβaα', 'aαcγaα'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'aα', 'failed at #437')
  call g:assert.equals(getline(2), 'bβ', 'failed at #437')
  call g:assert.equals(getline(3), 'cγ', 'failed at #437')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #437')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #437')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #437')

  %delete
  unlet g:operator#sandwich#recipes

  " #438
  call append(0, ['(“)', '(“)', '(“)'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), '“', 'failed at #438')
  call g:assert.equals(getline(2), '“', 'failed at #438')
  call g:assert.equals(getline(3), '“', 'failed at #438')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #438')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #438')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #438')

  %delete

  " #439
  call append(0, ['(a“)', '(b“)', '(c“)'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'a“', 'failed at #439')
  call g:assert.equals(getline(2), 'b“', 'failed at #439')
  call g:assert.equals(getline(3), 'c“', 'failed at #439')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #439')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #439')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #439')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #440
  call append(0, ['“a“', '“b“', '“c“'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'a', 'failed at #440')
  call g:assert.equals(getline(2), 'b', 'failed at #440')
  call g:assert.equals(getline(3), 'c', 'failed at #440')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #440')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #440')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #440')

  %delete

  " #441
  call append(0, ['“““', '“““', '“““'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), '“', 'failed at #441')
  call g:assert.equals(getline(2), '“', 'failed at #441')
  call g:assert.equals(getline(3), '“', 'failed at #441')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #441')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #441')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #441')

  %delete

  " #442
  call append(0, ['“a““', '“b““', '“c““'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'a“', 'failed at #442')
  call g:assert.equals(getline(2), 'b“', 'failed at #442')
  call g:assert.equals(getline(3), 'c“', 'failed at #442')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #442')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #442')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #442')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #443
  call append(0, ['a“aa“', 'a“ba“', 'a“ca“'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'a', 'failed at #443')
  call g:assert.equals(getline(2), 'b', 'failed at #443')
  call g:assert.equals(getline(3), 'c', 'failed at #443')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #443')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #443')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #443')

  %delete

  " #444
  call append(0, ['a““a“', 'a““a“', 'a““a“'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '“', 'failed at #444')
  call g:assert.equals(getline(2), '“',  'failed at #444')
  call g:assert.equals(getline(3), '“', 'failed at #444')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #444')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #444')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #444')

  %delete

  " #445
  call append(0, ['a“a“a“', 'a“b“a“', 'a“c“a“'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'a“', 'failed at #445')
  call g:assert.equals(getline(2), 'b“', 'failed at #445')
  call g:assert.equals(getline(3), 'c“', 'failed at #445')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #445')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #445')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #445')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #446
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #446')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #446')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #446')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #446')

  " #447
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #447')
  call g:assert.equals(getline(2),   'bar',        'failed at #447')
  call g:assert.equals(getline(3),   'baz',        'failed at #447')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #447')

  %delete

  """ keep
  " #448
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #448')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #448')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #448')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #448')

  " #449
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #449')
  call g:assert.equals(getline(2),   'bar',        'failed at #449')
  call g:assert.equals(getline(3),   'baz',        'failed at #449')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #449')

  %delete

  """ inner_tail
  " #450
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #450')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #450')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #450')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #450')

  " #451
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #451')
  call g:assert.equals(getline(2),   'bar',        'failed at #451')
  call g:assert.equals(getline(3),   'baz',        'failed at #451')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #451')

  %delete

  """ head
  " #452
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #452')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #452')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #452')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #452')

  " #453
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #453')
  call g:assert.equals(getline(2),   'bar',        'failed at #453')
  call g:assert.equals(getline(3),   'baz',        'failed at #453')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #453')

  %delete

  """ tail
  " #454
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #454')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #454')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #454')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #454')

  " #455
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #455')
  call g:assert.equals(getline(2),   'bar',        'failed at #455')
  call g:assert.equals(getline(3),   'baz',        'failed at #455')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #455')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_head')
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
  " #456
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #456')
  call g:assert.equals(getline(2), '(bar)', 'failed at #456')
  call g:assert.equals(getline(3), '(baz)', 'failed at #456')

  %delete

  " #457
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #457')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #457')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #457')

  %delete

  """ off
  " #458
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #458')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #458')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #458')

  %delete

  " #459
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #459')
  call g:assert.equals(getline(2), '{bar}', 'failed at #459')
  call g:assert.equals(getline(3), '{baz}', 'failed at #459')

  set whichwrap&
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_regex() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #460
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #460')
  call g:assert.equals(getline(2), 'bar', 'failed at #460')
  call g:assert.equals(getline(3), 'baz', 'failed at #460')

  %delete

  " #461
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #461')
  call g:assert.equals(getline(2), '88bar88', 'failed at #461')
  call g:assert.equals(getline(3), '88baz88', 'failed at #461')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #462
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #462')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #462')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #462')

  %delete

  " #463
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #463')
  call g:assert.equals(getline(2), 'bar', 'failed at #463')
  call g:assert.equals(getline(3), 'baz', 'failed at #463')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ 1
  " #464
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #464')
  call g:assert.equals(getline(2), 'bar', 'failed at #464')
  call g:assert.equals(getline(3), 'baz', 'failed at #464')

  %delete

  " #465
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #465')
  call g:assert.equals(getline(2), ' bar', 'failed at #465')
  call g:assert.equals(getline(3), ' baz', 'failed at #465')

  %delete

  " #466
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #466')
  call g:assert.equals(getline(2), 'bar ', 'failed at #466')
  call g:assert.equals(getline(3), 'baz ', 'failed at #466')

  %delete

  " #467
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #467')
  call g:assert.equals(getline(2), '"bar"', 'failed at #467')
  call g:assert.equals(getline(3), '"baz"', 'failed at #467')

  %delete

  """ 2
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)
  " #468
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #468')
  call g:assert.equals(getline(2), 'bar', 'failed at #468')
  call g:assert.equals(getline(3), 'baz', 'failed at #468')

  %delete

  " #469
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #469')
  call g:assert.equals(getline(2), ' bar', 'failed at #469')
  call g:assert.equals(getline(3), ' baz', 'failed at #469')

  %delete

  " #470
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #470')
  call g:assert.equals(getline(2), 'bar ', 'failed at #470')
  call g:assert.equals(getline(3), 'baz ', 'failed at #470')

  %delete

  " #471
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), ' foo ', 'failed at #471')
  call g:assert.equals(getline(2), ' bar ', 'failed at #471')
  call g:assert.equals(getline(3), ' baz ', 'failed at #471')

  %delete

  """ 0
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #472
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #472')
  call g:assert.equals(getline(2), 'bar', 'failed at #472')
  call g:assert.equals(getline(3), 'baz', 'failed at #472')

  %delete

  " #473
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #473')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #473')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #473')

  %delete

  " #474
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #474')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #474')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #474')

  %delete

  " #475
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #475')
  call g:assert.equals(getline(2), '"bar"', 'failed at #475')
  call g:assert.equals(getline(3), '"baz"', 'failed at #475')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #476
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #476')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #476')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #476')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #477
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #477')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #477')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #477')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #478
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #478')
  call g:assert.equals(getline(2), '', 'failed at #478')
  call g:assert.equals(getline(3), '', 'failed at #478')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #479
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #479')
  call g:assert.equals(getline(2),   'bar',        'failed at #479')
  call g:assert.equals(getline(3),   'baz',        'failed at #479')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #479')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #479')

  %delete

  " #480
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #480')
  call g:assert.equals(getline(2),   'bar',        'failed at #480')
  call g:assert.equals(getline(3),   'baz',        'failed at #480')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #480')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #480')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #480')

  %delete

  " #481
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #481')
  call g:assert.equals(getline(2),   'bar',        'failed at #481')
  call g:assert.equals(getline(3),   'baz',        'failed at #481')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #481')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #481')

  %delete

  " #482
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #482')
  call g:assert.equals(getline(2),   'bar',        'failed at #482')
  call g:assert.equals(getline(3),   'baz',        'failed at #482')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #482')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #482')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #483
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #483')
  call g:assert.equals(getline(2),   'bar',        'failed at #483')
  call g:assert.equals(getline(3),   'baz',        'failed at #483')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #483')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #483')

  " #484
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #484')
  call g:assert.equals(getline(2),   'bar',        'failed at #484')
  call g:assert.equals(getline(3),   'baz',        'failed at #484')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #484')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #484')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #485
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #485')
  call g:assert.equals(getline(2),   'foobar',     'failed at #485')
  call g:assert.equals(getline(3),   'foobar',     'failed at #485')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #485')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #485')

  %delete

  " #486
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #486')
  call g:assert.equals(getline(2),   'foobar',     'failed at #486')
  call g:assert.equals(getline(3),   'foobar',     'failed at #486')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #486')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #486')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #486')

  %delete

  " #487
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #487')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #487')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #487')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #487')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #487')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #487')

  %delete

  " #488
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #488')
  call g:assert.equals(getline(2),   'bar',        'failed at #488')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #488')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #488')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #488')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #488')

  %delete

  " #489
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #489')
  call g:assert.equals(getline(2),   'barbar',     'failed at #489')
  call g:assert.equals(getline(3),   'baz',        'failed at #489')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #489')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #489')

  %delete

  " #490
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #490')
  call g:assert.equals(getline(2),   'bar',        'failed at #490')
  call g:assert.equals(getline(3),   'baz',        'failed at #490')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #490')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #490')

  %delete

  " #491
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #491')
  call g:assert.equals(getline(2),   'baar',       'failed at #491')
  call g:assert.equals(getline(3),   'baaz',       'failed at #491')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #491')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #491')

  %delete

  " #492
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #492')
  call g:assert.equals(getline(2),   'bar',        'failed at #492')
  call g:assert.equals(getline(3),   'baaz',       'failed at #492')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #492')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #492')

  %delete

  " #493
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #493')
  call g:assert.equals(getline(2),   'baar',       'failed at #493')
  call g:assert.equals(getline(3),   'baz',        'failed at #493')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #493')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #493')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #493')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #494
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #494')
  call g:assert.equals(getline(2),   'baaar',      'failed at #494')
  call g:assert.equals(getline(3),   'baz',        'failed at #494')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #494')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #494')

  %delete

  " #495
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #495')
  call g:assert.equals(getline(2),   'bar',        'failed at #495')
  call g:assert.equals(getline(3),   'baaz',       'failed at #495')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #495')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #495')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #495')

  %delete

  " #496
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #496')
  call g:assert.equals(getline(2),   '',           'failed at #496')
  call g:assert.equals(getline(3),   'baz',        'failed at #496')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #496')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #496')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #496')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #497
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #497')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #497')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #497')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #498
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #498')
  call g:assert.equals(getline(2),   '',           'failed at #498')
  call g:assert.equals(getline(3),   '',           'failed at #498')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #498')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #498')

  %delete

  " #499
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #499')
  call g:assert.equals(getline(2),   'foobar',     'failed at #499')
  call g:assert.equals(getline(3),   'foobar',     'failed at #499')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #499')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #499')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #499')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #500
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #500')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #500')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #500')

  " #501
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #501')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #501')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #501')

  " #502
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #502')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #502')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #502')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #502')

  %delete

  " #503
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #503')
  call g:assert.equals(getline(2),   'bar',        'failed at #503')
  call g:assert.equals(getline(3),   'baz',        'failed at #503')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #503')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #503')

  %delete

  " #504
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #504')
  call g:assert.equals(getline(2),   'bar',        'failed at #504')
  call g:assert.equals(getline(3),   'baz',        'failed at #504')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #504')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #504')

  %delete

  " #505
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #505')
  call g:assert.equals(getline(2),   'abarb',      'failed at #505')
  call g:assert.equals(getline(3),   'baz',        'failed at #505')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #505')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #505')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #505')

  %delete

  " #506
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #506')
  call g:assert.equals(getline(2),   'bar',        'failed at #506')
  call g:assert.equals(getline(3),   'abazb',      'failed at #506')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #506')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #506')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #506')
endfunction
"}}}
function! s:suite.blockwise_x_external_textobj() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #507
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #507')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #507')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #507')

  %delete

  " #508
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #508')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #508')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #508')

  %delete

  " #509
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #509')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #509')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #509')

  %delete

  " #510
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #510')
  call g:assert.equals(getline(2), 'bar', 'failed at #510')
  call g:assert.equals(getline(3), 'baz', 'failed at #510')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #511
  call append(0, ['(α)', '(β)', '(γ)'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #511')
  call g:assert.equals(getline(2), 'β', 'failed at #511')
  call g:assert.equals(getline(3), 'γ', 'failed at #511')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #511')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #511')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #511')

  %delete

  " #512
  call append(0, ['(aα)', '(bβ)', '(cγ)'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #512')
  call g:assert.equals(getline(2), 'bβ', 'failed at #512')
  call g:assert.equals(getline(3), 'cγ', 'failed at #512')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #512')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #512')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #512')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #513
  call append(0, ['αaα', 'αbα', 'αcα'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #513')
  call g:assert.equals(getline(2), 'b', 'failed at #513')
  call g:assert.equals(getline(3), 'c', 'failed at #513')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #513')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #513')

  %delete

  " #514
  call append(0, ['ααα', 'αβα', 'αγα'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #514')
  call g:assert.equals(getline(2), 'β', 'failed at #514')
  call g:assert.equals(getline(3), 'γ', 'failed at #514')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #514')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #514')

  %delete

  " #515
  call append(0, ['αaαα', 'αbβα', 'αcγα'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #515')
  call g:assert.equals(getline(2), 'bβ', 'failed at #515')
  call g:assert.equals(getline(3), 'cγ', 'failed at #515')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #515')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #515')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #516
  call append(0, ['aαaaα', 'aαbaα', 'aαcaα'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #516')
  call g:assert.equals(getline(2), 'b', 'failed at #516')
  call g:assert.equals(getline(3), 'c', 'failed at #516')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #516')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #516')

  %delete

  " #517
  call append(0, ['aααaα', 'aαβaα', 'aαγaα'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #517')
  call g:assert.equals(getline(2), 'β',  'failed at #517')
  call g:assert.equals(getline(3), 'γ', 'failed at #517')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #517')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #517')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #517')

  %delete

  " #518
  call append(0, ['aαaαaα', 'aαbβaα', 'aαcγaα'])
  execute "normal gg\<C-v>5l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #518')
  call g:assert.equals(getline(2), 'bβ', 'failed at #518')
  call g:assert.equals(getline(3), 'cγ', 'failed at #518')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #518')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #518')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #518')

  %delete
  unlet g:operator#sandwich#recipes

  " #519
  call append(0, ['(“)', '(“)', '(“)'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #519')
  call g:assert.equals(getline(2), '“', 'failed at #519')
  call g:assert.equals(getline(3), '“', 'failed at #519')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #519')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #519')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #519')

  %delete

  " #520
  call append(0, ['(a“)', '(b“)', '(c“)'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #520')
  call g:assert.equals(getline(2), 'b“', 'failed at #520')
  call g:assert.equals(getline(3), 'c“', 'failed at #520')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #520')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #520')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #520')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #521
  call append(0, ['“a“', '“b“', '“c“'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #521')
  call g:assert.equals(getline(2), 'b', 'failed at #521')
  call g:assert.equals(getline(3), 'c', 'failed at #521')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #521')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #521')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #521')

  %delete

  " #522
  call append(0, ['“““', '“““', '“““'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #522')
  call g:assert.equals(getline(2), '“', 'failed at #522')
  call g:assert.equals(getline(3), '“', 'failed at #522')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #522')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #522')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #522')

  %delete

  " #523
  call append(0, ['“a““', '“b““', '“c““'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #523')
  call g:assert.equals(getline(2), 'b“', 'failed at #523')
  call g:assert.equals(getline(3), 'c“', 'failed at #523')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #523')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #523')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #523')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #524
  call append(0, ['a“aa“', 'a“ba“', 'a“ca“'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #524')
  call g:assert.equals(getline(2), 'b', 'failed at #524')
  call g:assert.equals(getline(3), 'c', 'failed at #524')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #524')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #524')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #524')

  %delete

  " #525
  call append(0, ['a““a“', 'a““a“', 'a““a“'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #525')
  call g:assert.equals(getline(2), '“',  'failed at #525')
  call g:assert.equals(getline(3), '“', 'failed at #525')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #525')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #525')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #525')

  %delete

  " #526
  call append(0, ['a“a“a“', 'a“b“a“', 'a“c“a“'])
  execute "normal gg\<C-v>5l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #526')
  call g:assert.equals(getline(2), 'b“', 'failed at #526')
  call g:assert.equals(getline(3), 'c“', 'failed at #526')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #526')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #526')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #526')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #527
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #527')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #527')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #527')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #527')

  " #528
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #528')
  call g:assert.equals(getline(2),   'bar',        'failed at #528')
  call g:assert.equals(getline(3),   'baz',        'failed at #528')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #528')

  %delete

  """ keep
  " #529
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #529')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #529')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #529')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #529')

  " #530
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #530')
  call g:assert.equals(getline(2),   'bar',        'failed at #530')
  call g:assert.equals(getline(3),   'baz',        'failed at #530')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #530')

  %delete

  """ inner_tail
  " #531
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #531')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #531')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #531')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #531')

  " #532
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #532')
  call g:assert.equals(getline(2),   'bar',        'failed at #532')
  call g:assert.equals(getline(3),   'baz',        'failed at #532')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #532')

  %delete

  """ head
  " #533
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #533')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #533')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #533')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #533')

  " #534
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #534')
  call g:assert.equals(getline(2),   'bar',        'failed at #534')
  call g:assert.equals(getline(3),   'baz',        'failed at #534')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #534')

  %delete

  """ tail
  " #535
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #535')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #535')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #535')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #535')

  " #536
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #536')
  call g:assert.equals(getline(2),   'bar',        'failed at #536')
  call g:assert.equals(getline(3),   'baz',        'failed at #536')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #536')

  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #537
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #537')
  call g:assert.equals(getline(2), '(bar)', 'failed at #537')
  call g:assert.equals(getline(3), '(baz)', 'failed at #537')

  %delete

  " #538
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4llsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #538')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #538')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #538')

  %delete

  """ off
  " #539
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #539')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #539')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #539')

  %delete

  " #540
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #540')
  call g:assert.equals(getline(2), '{bar}', 'failed at #540')
  call g:assert.equals(getline(3), '{baz}', 'failed at #540')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('delete', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #541
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #541')
  call g:assert.equals(getline(2), 'bar', 'failed at #541')
  call g:assert.equals(getline(3), 'baz', 'failed at #541')

  %delete

  " #542
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #542')
  call g:assert.equals(getline(2), '88bar88', 'failed at #542')
  call g:assert.equals(getline(3), '88baz88', 'failed at #542')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #543
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #543')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #543')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #543')

  %delete

  " #544
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #544')
  call g:assert.equals(getline(2), 'bar', 'failed at #544')
  call g:assert.equals(getline(3), 'baz', 'failed at #544')

  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ 1
  " #545
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #545')
  call g:assert.equals(getline(2), 'bar', 'failed at #545')
  call g:assert.equals(getline(3), 'baz', 'failed at #545')

  %delete

  " #546
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #546')
  call g:assert.equals(getline(2), ' bar', 'failed at #546')
  call g:assert.equals(getline(3), ' baz', 'failed at #546')

  %delete

  " #547
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #547')
  call g:assert.equals(getline(2), 'bar ', 'failed at #547')
  call g:assert.equals(getline(3), 'baz ', 'failed at #547')

  %delete

  " #548
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #548')
  call g:assert.equals(getline(2), '"bar"', 'failed at #548')
  call g:assert.equals(getline(3), '"baz"', 'failed at #548')

  %delete

  """ 2
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)
  " #549
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #549')
  call g:assert.equals(getline(2), 'bar', 'failed at #549')
  call g:assert.equals(getline(3), 'baz', 'failed at #549')

  %delete

  " #550
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #550')
  call g:assert.equals(getline(2), ' bar', 'failed at #550')
  call g:assert.equals(getline(3), ' baz', 'failed at #550')

  %delete

  " #551
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #551')
  call g:assert.equals(getline(2), 'bar ', 'failed at #551')
  call g:assert.equals(getline(3), 'baz ', 'failed at #551')

  %delete

  " #552
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), ' foo ', 'failed at #552')
  call g:assert.equals(getline(2), ' bar ', 'failed at #552')
  call g:assert.equals(getline(3), ' baz ', 'failed at #552')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #553
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #553')
  call g:assert.equals(getline(2), 'bar', 'failed at #553')
  call g:assert.equals(getline(3), 'baz', 'failed at #553')

  %delete

  " #554
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #554')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #554')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #554')

  %delete

  " #555
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #555')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #555')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #555')

  %delete

  " #556
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #556')
  call g:assert.equals(getline(2), '"bar"', 'failed at #556')
  call g:assert.equals(getline(3), '"baz"', 'failed at #556')

  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #557
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #557')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #557')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #557')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #558
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #558')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #558')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #558')

  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #559
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #559')
  call g:assert.equals(getline(2), '', 'failed at #559')
  call g:assert.equals(getline(3), '', 'failed at #559')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssd <Esc>:call operator#sandwich#prerequisite('delete', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #560
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #560')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #560')

  " #561
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #561')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #561')

  " #562
  call setline('.', '(foo)')
  normal 0ssda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #562')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #562')

  " #563
  call setline('.', '[foo]')
  normal 0ssda[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #563')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #563')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #564
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #564')

  " #565
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #565')

  " #566
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #566')
endfunction
"}}}

" When a assigned region is invalid
function! s:suite.invalid_region() abort  "{{{
  nmap sd' <Plug>(operator-sandwich-delete)i'

  " #567
  call setline('.', 'foo')
  normal 0lsd'
  call g:assert.equals(getline('.'), 'foo',        'failed at #567')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #567')

  nunmap sd'
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
