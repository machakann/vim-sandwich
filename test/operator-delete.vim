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
function! s:suite.charwise_n_external_textobj() abort"{{{
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
function! s:suite.charwise_x_external_textobj() abort"{{{
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
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #102
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #102')

  " #103
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #103')

  """ keep
  " #104
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #104')

  " #105
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #105')

  """ inner_tail
  " #106
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #106')

  " #107
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #107')

  """ head
  " #108
  call operator#sandwich#set('delete', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #108')

  " #109
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #109')

  """ tail
  " #110
  call operator#sandwich#set('delete', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #110')

  " #111
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #111')

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
  " #112
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #112')

  " #113
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #113')

  """ off
  " #114
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #114')

  " #115
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #115')

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
  " #116
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #116')

  " #117
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #117')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #118
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #118')

  " #119
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #119')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ 1
  " #120
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #120')

  " #121
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #121')

  " #122
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #122')

  " #123
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #123')

  """ 2
  call operator#sandwich#set('delete', 'char', 'skip_space', 2)
  " #124
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #124')

  " #125
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #125')

  " #126
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #126')

  " #127
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #127')

  """ 0
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #128
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #128')

  " #129
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #129')

  " #130
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #130')

  " #131
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #131')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #132
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #132')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #133
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #133')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[d`]'])

  " #134
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #134')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #135
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #135')

  %delete

  " #136
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #136')

  %delete

  " #137
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #137')
  call g:assert.equals(getline(2),   'foo',        'failed at #137')
  call g:assert.equals(getline(3),   'aa',         'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #137')

  %delete

  " #138
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #138')
  call g:assert.equals(getline(2),   'foo',        'failed at #138')
  call g:assert.equals(getline(3),   '',           'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #138')

  %delete

  " #139
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #139')
  call g:assert.equals(getline(2),   'aa',         'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #139')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #140
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #141')

  %delete

  " #142
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #142')

  %delete

  " #143
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #143')
  call g:assert.equals(getline(2),   'bb',         'failed at #143')
  call g:assert.equals(getline(3),   '',           'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #143')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #144
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #144')

  " #145
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #145')

  " #146
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #146')

  " #147
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #147')

  %delete

  " #148
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #148')

  %delete

  " #149
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #149')

  %delete

  " #150
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #150')

  %delete

  " #151
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #151')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #152
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #152')

  " #153
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #154')

  %delete

  " #155
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #155')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #156
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #156')
  call g:assert.equals(getline(2),   'bar',        'failed at #156')
  call g:assert.equals(getline(3),   'baz',        'failed at #156')
  call g:assert.equals(getline(4),   '',           'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #156')

  %delete

  " #157
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #157')
  call g:assert.equals(getline(2),   'bar',        'failed at #157')
  call g:assert.equals(getline(3),   'baz',        'failed at #157')
  call g:assert.equals(getline(4),   '',           'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #157')

  %delete

  " #158
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #158')
  call g:assert.equals(getline(2),   'bar',        'failed at #158')
  call g:assert.equals(getline(3),   'baz',        'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #158')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #159
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #159')

  %delete

  " #160
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #160')

  %delete

  " #161
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #161')

  %delete

  " #162
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #162')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #163
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #163')

  %delete

  " #164
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #164')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #165
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #165')

  %delete

  " #166
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #166')

  %delete

  " #167
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #167')

  %delete

  " #168
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #168')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #169
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #169')

  " #170
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #170')

  " #171
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #171')

  " #172
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #172')

  %delete

  " #173
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #173')
  call g:assert.equals(getline(2),   'bar',        'failed at #173')
  call g:assert.equals(getline(3),   'baz',        'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #173')
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

  " #174
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #174')

  " #175
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #175')

  " #176
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #176')

  " #177
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #177')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #178
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #178')

  " #179
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #179')

  """ keep
  " #180
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #180')

  " #181
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #181')

  """ inner_tail
  " #182
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #182')

  " #183
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #183')

  """ head
  " #184
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #184')

  " #185
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #185')

  """ tail
  " #186
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #186')

  " #187
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #187')

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
  " #188
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #188')

  " #189
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #189')

  """ off
  " #190
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #190')

  " #191
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #191')

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
  " #192
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #192')

  " #193
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #193')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #194
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #194')

  " #195
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #195')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ 2
  " #196
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #196')

  " #197
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #197')

  " #198
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #198')

  " #199
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo ', 'failed at #199')

  """ 1
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
  " #200
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #200')

  " #201
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #201')

  " #202
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #202')

  " #203
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #203')

  """ 0
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #204
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #204')

  " #205
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #205')

  " #206
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #206')

  " #207
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #207')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #208
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #208')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #209
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #209')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #210
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #210')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #211
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #211')
  call g:assert.equals(getline(2),   'foo',        'failed at #211')
  call g:assert.equals(getline(3),   '',           'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #211')

  %delete

  " #212
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #212')
  call g:assert.equals(getline(2),   'foo',        'failed at #212')
  call g:assert.equals(getline(3),   '  ',         'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #212')

  %delete

  " #213
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #213')
  call g:assert.equals(getline(2),   'foo',        'failed at #213')
  call g:assert.equals(getline(3),   'aa',         'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #213')

  %delete

  " #214
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #214')
  call g:assert.equals(getline(2),   'foo',        'failed at #214')
  call g:assert.equals(getline(3),   '',           'failed at #214')
  call g:assert.equals(getline(4),   '',           'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #214')

  %delete

  " #215
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #215')
  call g:assert.equals(getline(2),   'foo',        'failed at #215')
  call g:assert.equals(getline(3),   'aa',         'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #215')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #216
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #216')

  %delete

  " #217
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #217')

  %delete

  " #218
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #218')

  %delete

  " #219
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #219')
  call g:assert.equals(getline(2),   'bb',         'failed at #219')
  call g:assert.equals(getline(3),   '',           'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #219')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #220
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #220')

  " #221
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #221')

  " #222
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #222')

  " #223
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #223')

  %delete

  " #224
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #224')

  %delete

  " #225
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #225')

  %delete

  " #226
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #226')

  %delete

  " #227
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #227')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #228
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #228')

  " #229
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #229')

  %delete

  " #230
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #230')

  %delete

  " #231
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #231')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #232
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #232')
  call g:assert.equals(getline(2),   'bar',        'failed at #232')
  call g:assert.equals(getline(3),   'baz',        'failed at #232')
  call g:assert.equals(getline(4),   '',           'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #232')

  %delete

  " #233
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #233')
  call g:assert.equals(getline(2),   'bar',        'failed at #233')
  call g:assert.equals(getline(3),   'baz',        'failed at #233')
  call g:assert.equals(getline(4),   '',           'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #233')

  %delete

  " #234
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #234')
  call g:assert.equals(getline(2),   'bar',        'failed at #234')
  call g:assert.equals(getline(3),   'baz',        'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #234')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #235
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #235')

  %delete

  " #236
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #236')

  %delete

  " #237
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #237')

  %delete

  " #238
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #238')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #167
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #167')

  %delete

  " #168
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #168')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #239
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #239')

  %delete

  " #240
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #240')

  %delete

  " #241
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #241')

  %delete

  " #242
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #242')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #243
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #243')

  " #244
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #244')

  " #245
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #245')

  " #246
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #247')
  call g:assert.equals(getline(2),   'bar',        'failed at #247')
  call g:assert.equals(getline(3),   'baz',        'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #247')
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

  " #248
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #248')

  " #249
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #249')

  " #250
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #250')

  " #251
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #251')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #252
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #252')

  " #253
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #253')

  """ keep
  " #254
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #254')

  " #255
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #255')

  """ inner_tail
  " #256
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #256')

  " #257
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #257')

  """ head
  " #258
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #258')

  " #259
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #259')

  """ tail
  " #260
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #260')

  " #261
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #261')

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
  " #262
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #262')

  " #263
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #263')

  """ off
  " #264
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #264')

  " #265
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #265')

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
  " #266
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #266')

  " #267
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #267')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #268
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #268')

  " #269
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #269')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ 2
  " #270
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #270')

  " #271
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #271')

  " #272
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #272')

  " #273
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #273')

  """ 1
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
  " #274
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #274')

  " #275
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #275')

  " #276
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #276')

  " #277
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #277')

  """ 0
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #278
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #278')

  " #279
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #279')

  " #280
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #280')

  " #281
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #281')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #282
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #282')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #283
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #283')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #284
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #284')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #285
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #285')
  call g:assert.equals(getline(2),   'foo',        'failed at #285')
  call g:assert.equals(getline(3),   '',           'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #285')

  %delete

  " #286
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #286')
  call g:assert.equals(getline(2),   'foo',        'failed at #286')
  call g:assert.equals(getline(3),   '  ',         'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #286')

  %delete

  " #287
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #287')
  call g:assert.equals(getline(2),   'foo',        'failed at #287')
  call g:assert.equals(getline(3),   'aa',         'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #287')

  %delete

  " #288
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #288')
  call g:assert.equals(getline(2),   'foo',        'failed at #288')
  call g:assert.equals(getline(3),   '',           'failed at #288')
  call g:assert.equals(getline(4),   '',           'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #288')

  %delete

  " #289
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #289')
  call g:assert.equals(getline(2),   'foo',        'failed at #289')
  call g:assert.equals(getline(3),   'aa',         'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #289')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #290
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #290')

  %delete

  " #291
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #291')

  %delete

  " #292
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #292')

  %delete

  " #293
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #293')
  call g:assert.equals(getline(2),   'bb',         'failed at #293')
  call g:assert.equals(getline(3),   '',           'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #293')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #294
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #294')
  call g:assert.equals(getline(2),   'bar',        'failed at #294')
  call g:assert.equals(getline(3),   'baz',        'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #294')

  %delete

  " #295
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #295')
  call g:assert.equals(getline(2),   'bar',        'failed at #295')
  call g:assert.equals(getline(3),   'baz',        'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #295')

  %delete

  " #296
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #296')
  call g:assert.equals(getline(2),   'bar',        'failed at #296')
  call g:assert.equals(getline(3),   'baz',        'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #296')

  %delete

  " #297
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #297')
  call g:assert.equals(getline(2),   'bar',        'failed at #297')
  call g:assert.equals(getline(3),   'baz',        'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #297')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #298
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #298')
  call g:assert.equals(getline(2),   'bar',        'failed at #298')
  call g:assert.equals(getline(3),   'baz',        'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #298')

  " #299
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #299')
  call g:assert.equals(getline(2),   'bar',        'failed at #299')
  call g:assert.equals(getline(3),   'baz',        'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #299')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #300
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #300')
  call g:assert.equals(getline(2),   'foobar',     'failed at #300')
  call g:assert.equals(getline(3),   'foobar',     'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #300')

  %delete

  " #301
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #301')
  call g:assert.equals(getline(2),   'foobar',     'failed at #301')
  call g:assert.equals(getline(3),   'foobar',     'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #301')

  %delete

  " #302
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #302')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #302')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #303')
  call g:assert.equals(getline(2),   'bar',        'failed at #303')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #303')

  %delete

  " #304
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #304')
  call g:assert.equals(getline(2),   'barbar',     'failed at #304')
  call g:assert.equals(getline(3),   'baz',        'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #304')

  %delete

  " #305
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #305')
  call g:assert.equals(getline(2),   'bar',        'failed at #305')
  call g:assert.equals(getline(3),   'baz',        'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foo',        'failed at #306')
  call g:assert.equals(getline(2),   'baar',       'failed at #306')
  call g:assert.equals(getline(3),   'baaz',       'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'fooo',       'failed at #307')
  call g:assert.equals(getline(2),   'bar',        'failed at #307')
  call g:assert.equals(getline(3),   'baaz',       'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #307')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #308
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #308')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #309
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #309')
  call g:assert.equals(getline(2),   '',           'failed at #309')
  call g:assert.equals(getline(3),   '',           'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #309')

  %delete

  " #310
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #310')
  call g:assert.equals(getline(2),   'foobar',     'failed at #310')
  call g:assert.equals(getline(3),   'foobar',     'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #310')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #311
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #311')

  " #312
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #312')

  " #313
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #313')

  " #314
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #314')

  " #315
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #315')

  %delete

  " #316
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #316')
  call g:assert.equals(getline(2),   'bar',        'failed at #316')
  call g:assert.equals(getline(3),   'baz',        'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #316')

  %delete

  " #317
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #317')
  call g:assert.equals(getline(2),   'bar',        'failed at #317')
  call g:assert.equals(getline(3),   'baz',        'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #317')

  %delete

  " #318
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #318')
  call g:assert.equals(getline(2),   'abarb',      'failed at #318')
  call g:assert.equals(getline(3),   'baz',        'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #318')

  %delete

  " #319
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #319')
  call g:assert.equals(getline(2),   'bar',        'failed at #319')
  call g:assert.equals(getline(3),   'abazb',      'failed at #319')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #319')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #319')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_external_textobj() abort"{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #320
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #320')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #320')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #320')

  %delete

  " #321
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #321')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #321')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #321')

  %delete

  " #322
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #322')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #322')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #322')

  %delete

  " #323
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #323')
  call g:assert.equals(getline(2), 'bar', 'failed at #323')
  call g:assert.equals(getline(3), 'baz', 'failed at #323')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #324
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #324')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #324')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #324')

  " #325
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #325')
  call g:assert.equals(getline(2),   'bar',        'failed at #325')
  call g:assert.equals(getline(3),   'baz',        'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #325')

  %delete

  """ keep
  " #326
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #326')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #326')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #326')

  " #327
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #327')
  call g:assert.equals(getline(2),   'bar',        'failed at #327')
  call g:assert.equals(getline(3),   'baz',        'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #327')

  %delete

  """ inner_tail
  " #328
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #328')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #328')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #328')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #328')

  " #329
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #329')
  call g:assert.equals(getline(2),   'bar',        'failed at #329')
  call g:assert.equals(getline(3),   'baz',        'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #329')

  %delete

  """ head
  " #330
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #330')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #330')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #330')

  " #331
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #331')
  call g:assert.equals(getline(2),   'bar',        'failed at #331')
  call g:assert.equals(getline(3),   'baz',        'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #331')

  %delete

  """ tail
  " #332
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #332')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #332')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #332')

  " #333
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #333')
  call g:assert.equals(getline(2),   'bar',        'failed at #333')
  call g:assert.equals(getline(3),   'baz',        'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #333')

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
  " #334
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #334')
  call g:assert.equals(getline(2), '(bar)', 'failed at #334')
  call g:assert.equals(getline(3), '(baz)', 'failed at #334')

  %delete

  " #335
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #335')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #335')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #335')

  %delete

  """ off
  " #336
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #336')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #336')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #336')

  %delete

  " #337
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #337')
  call g:assert.equals(getline(2), '{bar}', 'failed at #337')
  call g:assert.equals(getline(3), '{baz}', 'failed at #337')

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
  " #338
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #338')
  call g:assert.equals(getline(2), 'bar', 'failed at #338')
  call g:assert.equals(getline(3), 'baz', 'failed at #338')

  %delete

  " #339
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #339')
  call g:assert.equals(getline(2), '88bar88', 'failed at #339')
  call g:assert.equals(getline(3), '88baz88', 'failed at #339')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #340
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #340')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #340')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #340')

  %delete

  " #341
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #341')
  call g:assert.equals(getline(2), 'bar', 'failed at #341')
  call g:assert.equals(getline(3), 'baz', 'failed at #341')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ 1
  " #342
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #342')
  call g:assert.equals(getline(2), 'bar', 'failed at #342')
  call g:assert.equals(getline(3), 'baz', 'failed at #342')

  %delete

  " #343
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #343')
  call g:assert.equals(getline(2), ' bar', 'failed at #343')
  call g:assert.equals(getline(3), ' baz', 'failed at #343')

  %delete

  " #344
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #344')
  call g:assert.equals(getline(2), 'bar ', 'failed at #344')
  call g:assert.equals(getline(3), 'baz ', 'failed at #344')

  %delete

  " #345
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #345')
  call g:assert.equals(getline(2), '"bar"', 'failed at #345')
  call g:assert.equals(getline(3), '"baz"', 'failed at #345')

  %delete

  """ 2
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)
  " #346
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #346')
  call g:assert.equals(getline(2), 'bar', 'failed at #346')
  call g:assert.equals(getline(3), 'baz', 'failed at #346')

  %delete

  " #347
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #347')
  call g:assert.equals(getline(2), ' bar', 'failed at #347')
  call g:assert.equals(getline(3), ' baz', 'failed at #347')

  %delete

  " #348
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #348')
  call g:assert.equals(getline(2), 'bar ', 'failed at #348')
  call g:assert.equals(getline(3), 'baz ', 'failed at #348')

  %delete

  " #349
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), ' foo ', 'failed at #349')
  call g:assert.equals(getline(2), ' bar ', 'failed at #349')
  call g:assert.equals(getline(3), ' baz ', 'failed at #349')

  %delete

  """ 0
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #350
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #350')
  call g:assert.equals(getline(2), 'bar', 'failed at #350')
  call g:assert.equals(getline(3), 'baz', 'failed at #350')

  %delete

  " #351
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #351')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #351')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #351')

  %delete

  " #352
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #352')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #352')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #352')

  %delete

  " #353
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #353')
  call g:assert.equals(getline(2), '"bar"', 'failed at #353')
  call g:assert.equals(getline(3), '"baz"', 'failed at #353')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #354
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #354')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #354')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #354')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #355
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #355')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #355')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #355')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #356
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #356')
  call g:assert.equals(getline(2), '', 'failed at #356')
  call g:assert.equals(getline(3), '', 'failed at #356')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #357
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #357')
  call g:assert.equals(getline(2),   'bar',        'failed at #357')
  call g:assert.equals(getline(3),   'baz',        'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #357')

  %delete

  " #358
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #358')
  call g:assert.equals(getline(2),   'bar',        'failed at #358')
  call g:assert.equals(getline(3),   'baz',        'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #358')

  %delete

  " #359
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #359')
  call g:assert.equals(getline(2),   'bar',        'failed at #359')
  call g:assert.equals(getline(3),   'baz',        'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #359')

  %delete

  " #360
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #360')
  call g:assert.equals(getline(2),   'bar',        'failed at #360')
  call g:assert.equals(getline(3),   'baz',        'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #360')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #361
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #361')
  call g:assert.equals(getline(2),   'bar',        'failed at #361')
  call g:assert.equals(getline(3),   'baz',        'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #361')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #361')

  " #362
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #362')
  call g:assert.equals(getline(2),   'bar',        'failed at #362')
  call g:assert.equals(getline(3),   'baz',        'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #362')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #362')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #363
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #363')
  call g:assert.equals(getline(2),   'foobar',     'failed at #363')
  call g:assert.equals(getline(3),   'foobar',     'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #363')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #363')

  %delete

  " #364
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #364')
  call g:assert.equals(getline(2),   'foobar',     'failed at #364')
  call g:assert.equals(getline(3),   'foobar',     'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #364')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #364')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #364')

  %delete

  " #365
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #365')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #365')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #365')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #365')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #365')

  %delete

  " #366
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #366')
  call g:assert.equals(getline(2),   'bar',        'failed at #366')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #366')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #366')

  %delete

  " #367
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #367')
  call g:assert.equals(getline(2),   'barbar',     'failed at #367')
  call g:assert.equals(getline(3),   'baz',        'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #367')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #367')

  %delete

  " #368
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #368')
  call g:assert.equals(getline(2),   'bar',        'failed at #368')
  call g:assert.equals(getline(3),   'baz',        'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #368')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #368')

  %delete

  " #369
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #369')
  call g:assert.equals(getline(2),   'baar',       'failed at #369')
  call g:assert.equals(getline(3),   'baaz',       'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #369')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #369')

  %delete

  " #370
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #370')
  call g:assert.equals(getline(2),   'bar',        'failed at #370')
  call g:assert.equals(getline(3),   'baaz',       'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #370')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #370')

  %delete

  " #371
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #371')
  call g:assert.equals(getline(2),   'baar',       'failed at #371')
  call g:assert.equals(getline(3),   'baz',        'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #371')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #371')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #372
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #372')
  call g:assert.equals(getline(2),   'baaar',      'failed at #372')
  call g:assert.equals(getline(3),   'baz',        'failed at #372')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #372')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #372')

  %delete

  " #373
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #373')
  call g:assert.equals(getline(2),   'bar',        'failed at #373')
  call g:assert.equals(getline(3),   'baaz',       'failed at #373')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #373')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #373')

  %delete

  " #374
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #374')
  call g:assert.equals(getline(2),   '',           'failed at #374')
  call g:assert.equals(getline(3),   'baz',        'failed at #374')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #374')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #374')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #375
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #375')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #375')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #375')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #376
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #376')
  call g:assert.equals(getline(2),   '',           'failed at #376')
  call g:assert.equals(getline(3),   '',           'failed at #376')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #376')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #376')

  %delete

  " #377
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #377')
  call g:assert.equals(getline(2),   'foobar',     'failed at #377')
  call g:assert.equals(getline(3),   'foobar',     'failed at #377')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #377')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #377')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #377')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #378
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #378')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #378')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #378')

  " #379
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #379')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #379')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #379')

  " #380
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #380')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #380')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #380')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #380')

  %delete

  " #381
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #381')
  call g:assert.equals(getline(2),   'bar',        'failed at #381')
  call g:assert.equals(getline(3),   'baz',        'failed at #381')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #381')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #381')

  %delete

  " #382
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #382')
  call g:assert.equals(getline(2),   'bar',        'failed at #382')
  call g:assert.equals(getline(3),   'baz',        'failed at #382')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #382')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #382')

  %delete

  " #383
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #383')
  call g:assert.equals(getline(2),   'abarb',      'failed at #383')
  call g:assert.equals(getline(3),   'baz',        'failed at #383')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #383')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #383')

  %delete

  " #384
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #384')
  call g:assert.equals(getline(2),   'bar',        'failed at #384')
  call g:assert.equals(getline(3),   'abazb',      'failed at #384')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #384')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #384')
endfunction
"}}}
function! s:suite.blockwise_x_external_textobj() abort"{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #385
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #385')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #385')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #385')

  %delete

  " #386
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #386')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #386')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #386')

  %delete

  " #387
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #387')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #387')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #387')

  %delete

  " #388
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #388')
  call g:assert.equals(getline(2), 'bar', 'failed at #388')
  call g:assert.equals(getline(3), 'baz', 'failed at #388')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #389
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #389')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #389')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #389')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #389')

  " #390
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #390')
  call g:assert.equals(getline(2),   'bar',        'failed at #390')
  call g:assert.equals(getline(3),   'baz',        'failed at #390')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #390')

  %delete

  """ keep
  " #391
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #391')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #391')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #391')

  " #392
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #392')
  call g:assert.equals(getline(2),   'bar',        'failed at #392')
  call g:assert.equals(getline(3),   'baz',        'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #392')

  %delete

  """ inner_tail
  " #393
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #393')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #393')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #393')

  " #394
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #394')
  call g:assert.equals(getline(2),   'bar',        'failed at #394')
  call g:assert.equals(getline(3),   'baz',        'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #394')

  %delete

  """ head
  " #395
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #395')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #395')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #395')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #395')

  " #396
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #396')
  call g:assert.equals(getline(2),   'bar',        'failed at #396')
  call g:assert.equals(getline(3),   'baz',        'failed at #396')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #396')

  %delete

  """ tail
  " #397
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #397')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #397')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #397')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #397')

  " #398
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #398')
  call g:assert.equals(getline(2),   'bar',        'failed at #398')
  call g:assert.equals(getline(3),   'baz',        'failed at #398')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #398')

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
  " #399
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #399')
  call g:assert.equals(getline(2), '(bar)', 'failed at #399')
  call g:assert.equals(getline(3), '(baz)', 'failed at #399')

  %delete

  " #400
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4llsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #400')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #400')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #400')

  %delete

  """ off
  " #401
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #401')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #401')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #401')

  %delete

  " #402
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #402')
  call g:assert.equals(getline(2), '{bar}', 'failed at #402')
  call g:assert.equals(getline(3), '{baz}', 'failed at #402')

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
  " #403
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #403')
  call g:assert.equals(getline(2), 'bar', 'failed at #403')
  call g:assert.equals(getline(3), 'baz', 'failed at #403')

  %delete

  " #404
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #404')
  call g:assert.equals(getline(2), '88bar88', 'failed at #404')
  call g:assert.equals(getline(3), '88baz88', 'failed at #404')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #405
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #405')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #405')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #405')

  %delete

  " #406
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #406')
  call g:assert.equals(getline(2), 'bar', 'failed at #406')
  call g:assert.equals(getline(3), 'baz', 'failed at #406')

  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ 1
  " #407
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #407')
  call g:assert.equals(getline(2), 'bar', 'failed at #407')
  call g:assert.equals(getline(3), 'baz', 'failed at #407')

  %delete

  " #408
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #408')
  call g:assert.equals(getline(2), ' bar', 'failed at #408')
  call g:assert.equals(getline(3), ' baz', 'failed at #408')

  %delete

  " #409
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #409')
  call g:assert.equals(getline(2), 'bar ', 'failed at #409')
  call g:assert.equals(getline(3), 'baz ', 'failed at #409')

  %delete

  " #410
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #410')
  call g:assert.equals(getline(2), '"bar"', 'failed at #410')
  call g:assert.equals(getline(3), '"baz"', 'failed at #410')

  %delete

  """ 2
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)
  " #411
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #411')
  call g:assert.equals(getline(2), 'bar', 'failed at #411')
  call g:assert.equals(getline(3), 'baz', 'failed at #411')

  %delete

  " #412
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #412')
  call g:assert.equals(getline(2), ' bar', 'failed at #412')
  call g:assert.equals(getline(3), ' baz', 'failed at #412')

  %delete

  " #413
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #413')
  call g:assert.equals(getline(2), 'bar ', 'failed at #413')
  call g:assert.equals(getline(3), 'baz ', 'failed at #413')

  %delete

  " #414
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), ' foo ', 'failed at #414')
  call g:assert.equals(getline(2), ' bar ', 'failed at #414')
  call g:assert.equals(getline(3), ' baz ', 'failed at #414')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #415
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #415')
  call g:assert.equals(getline(2), 'bar', 'failed at #415')
  call g:assert.equals(getline(3), 'baz', 'failed at #415')

  %delete

  " #416
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #416')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #416')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #416')

  %delete

  " #417
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #417')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #417')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #417')

  %delete

  " #418
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #418')
  call g:assert.equals(getline(2), '"bar"', 'failed at #418')
  call g:assert.equals(getline(3), '"baz"', 'failed at #418')

  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #419
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #419')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #419')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #419')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #420
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #420')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #420')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #420')

  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #421
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #421')
  call g:assert.equals(getline(2), '', 'failed at #421')
  call g:assert.equals(getline(3), '', 'failed at #421')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssd <Esc>:call operator#sandwich#prerequisite('delete', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #422
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #422')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #422')

  " #423
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #423')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #423')

  " #424
  call setline('.', '(foo)')
  normal 0ssda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #424')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #424')

  " #425
  call setline('.', '[foo]')
  normal 0ssda[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #425')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #425')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #426
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #426')

  " #427
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #427')

  " #428
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #428')
endfunction
"}}}

" When a assigned region is invalid
function! s:suite.invalid_region() abort  "{{{
  nmap sd' <Plug>(operator-sandwich-delete)i'

  " #429
  call setline('.', 'foo')
  normal 0lsd'
  call g:assert.equals(getline('.'), 'foo',        'failed at #429')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #429')

  nunmap sd'
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
