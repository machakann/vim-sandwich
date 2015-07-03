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
        \ {'buns': ['(', ')']},
        \ {'buns': ['[', ']'], 'filetype': ['vim']},
        \ {'buns': ['{', '}'], 'filetype': ['all']},
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

  set filetype=vim

  " #4
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #7
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['add']},
        \ ]

  " #8
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['delete']},
        \ ]

  " #9
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['replace']},
        \ ]

  " #10
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['operator']},
        \ ]

  " #11
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['all']},
        \ ]

  " #12
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #12')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #13
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #13')

  " #14
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #14')

  " #15
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #15')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['all']},
        \ ]

  " #16
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #16')

  " #17
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #17')

  " #18
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #18')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['char']},
        \ ]

  " #19
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #19')

  " #20
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #20')

  " #21
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #21')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['line']},
        \ ]

  " #22
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #22')

  " #23
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #23')

  " #24
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #24')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['block']},
        \ ]

  " #25
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #25')

  " #26
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #26')

  " #27
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #27')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #28
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #28')

  " #29
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #29')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['n']},
        \ ]

  " #30
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #30')

  " #31
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #31')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['x']},
        \ ]

  " #32
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #32')

  " #33
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #33')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #34
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #34')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['all']},
        \ ]

  " #35
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #35')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['add']},
        \ ]

  " #36
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #36')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['delete']},
        \ ]

  " #37
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #37')
endfunction
"}}}
function! s:suite.filter_user() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'user_filter': ['FilterValid()']},
        \   {'buns': ['{', '}'], 'user_filter': ['FilterInvalid()']},
        \ ]

  function! FilterValid() abort
    return 1
  endfunction

  function! FilterInvalid() abort
    return 0
  endfunction

  " #38
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #38')

  " #39
  call setline('.', '[foo]')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #39')

  " #40
  call setline('.', '{foo}')
  normal 0sd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #40')
endfunction
"}}}

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #41
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #41')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #41')

  " #42
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #42')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #42')

  " #43
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo',        'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #43')

  " #44
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), 'foo',        'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #44')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #45
  call setline('.', 'afooa')
  normal 0sdiw
  call g:assert.equals(getline('.'), 'foo',        'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #45')

  " #46
  call setline('.', '*foo*')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #46')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #47
  call setline('.', '(foo)bar')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #47')

  " #48
  call setline('.', 'foo(bar)')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #48')

  " #49
  call setline('.', 'foo(bar)baz')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #49')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))']}]

  " #50
  call setline('.', 'foo((bar))baz')
  normal 0sdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #50')

  " #51
  call setline('.', 'foo((bar))baz')
  normal 02lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #51')

  " #52
  call setline('.', 'foo((bar))baz')
  normal 03lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #52')

  " #53
  call setline('.', 'foo((bar))baz')
  normal 04lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #53')

  " #54
  call setline('.', 'foo((bar))baz')
  normal 05lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #54')

  " #55
  call setline('.', 'foo((bar))baz')
  normal 07lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #55')

  " #56
  call setline('.', 'foo((bar))baz')
  normal 08lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #56')

  " #57
  call setline('.', 'foo((bar))baz')
  normal 09lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #57')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #57')

  " #58
  call setline('.', 'foo((bar))baz')
  normal 010lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #58')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #58')

  " #59
  call setline('.', 'foo((bar))baz')
  normal 012lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #59')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #59')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #60
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsd13l
  call g:assert.equals(getline(1),   'foo',        'failed at #60')
  call g:assert.equals(getline(2),   'bar',        'failed at #60')
  call g:assert.equals(getline(3),   'baz',        'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #60')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #60')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #61
  call setline('.', '(a)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'a',          'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #61')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #61')

  %delete

  " #62
  call append(0, ['(', 'a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #62')
  call g:assert.equals(getline(2),   'a',          'failed at #62')
  call g:assert.equals(getline(3),   '',           'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #62')

  %delete

  " #63
  call append(0, ['(a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   'a',          'failed at #63')
  call g:assert.equals(getline(2),   '',           'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #63')

  %delete

  " #64
  call append(0, ['(', 'a)'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #64')
  call g:assert.equals(getline(2),   'a',          'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #64')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #65
  call setline('.', '()')
  normal 0sd2l
  call g:assert.equals(getline('.'), '',           'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #65')

  %delete

  " #66
  call setline('.', 'foo()bar')
  normal 03lsd2l
  call g:assert.equals(getline('.'), 'foobar',     'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #66')

  %delete
  set whichwrap=h,l

  " #67
  call append(0, ['(', ')'])
  normal ggsd3l
  call g:assert.equals(getline(1),   '',           'failed at #67')
  call g:assert.equals(getline(2),   '',           'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #67')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #68
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd15l
  call g:assert.equals(getline(1),   'foo',        'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #68')

  %delete

  " #69
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd21l
  call g:assert.equals(getline(1),   'foo',        'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #69')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')

  " #70
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #70')

  %delete

  " #71
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #71')

  %delete

  " #72
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #72')

  %delete

  " #73
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #73')

  %delete

  " #74
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #74')

  %delete

  " #75
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #75')

  %delete

  " #76
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #76')

  %delete

  " #77
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #77')

  %delete

  " #78
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #78')

  %delete

  " #79
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #79')

  %delete

  " #80
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #80')

  %delete

  " #81
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #81')

  %delete

  " #82
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #82')

  %delete

  " #83
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #83')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #84
  call setline('.', '((foo))')
  normal 02sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #84')

  " #85
  call setline('.', '{[(foo)]}')
  normal 03sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #85')

  " #86
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #86')

  " #87
  call setline('.', '[(foo bar)]')
  normal 02sd11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #87')

  " #88
  call setline('.', 'foo{[(bar)]}baz')
  normal 03l3sd9l
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #88')
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

  " #89
  call setline('.', '{[(foo)]}')
  normal 02lsd5l
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #89')

  " #90
  call setline('.', '{[(foo)]}')
  normal 0lsd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #90')

  " #91
  call setline('.', '{[(foo)]}')
  normal 0sd9l
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #91')

  " #92
  call setline('.', '<title>foo</title>')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #92')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #93
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #93')

  " #94
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #94')

  """ keep
  " #95
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #95')

  " #96
  normal 2lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #96')

  """ inner_tail
  " #97
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #97')

  " #98
  normal hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #98')

  """ front
  " #99
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #99')

  " #100
  normal 3lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #100')

  """ end
  " #101
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #101')

  " #102
  normal 3hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #102')

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
  " #103
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #103')

  " #104
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #104')

  """ off
  " #105
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #105')

  " #106
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #106')

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
  " #107
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #107')

  " #108
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #108')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #109
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #109')

  " #110
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #110')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ on
  " #111
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #111')

  " #112
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #112')

  " #113
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #113')

  " #114
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #114')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #115
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #115')

  " #116
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #116')

  " #117
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #117')

  " #118
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #118')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #119
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #119')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #120
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #120')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #121
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #121')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #122
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #122')

  %delete

  " #123
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #123')

  %delete

  " #124
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'aa',         'failed at #124')
  call g:assert.equals(getline(2),   'foo',        'failed at #124')
  call g:assert.equals(getline(3),   'aa',         'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #124')

  %delete

  " #125
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'aa',         'failed at #125')
  call g:assert.equals(getline(2),   'foo',        'failed at #125')
  call g:assert.equals(getline(3),   '',           'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #125')

  %delete

  " #126
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'foo',        'failed at #126')
  call g:assert.equals(getline(2),   'aa',         'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #126')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #127
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #127')

  %delete

  " #128
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #128')

  %delete

  " #129
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #129')

  %delete

  " #130
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsd5l
  call g:assert.equals(getline(1),   'aa',         'failed at #130')
  call g:assert.equals(getline(2),   'bb',         'failed at #130')
  call g:assert.equals(getline(3),   '',           'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #130')

  set whichwrap&
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #131
  call setline('.', '(foo)')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #131')

  " #132
  call setline('.', '[foo]')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #132')

  " #133
  call setline('.', '{foo}')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #133')

  " #134
  call setline('.', '<foo>')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #134')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #135
  call setline('.', 'afooa')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #135')

  " #136
  call setline('.', '*foo*')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #136')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #137
  call setline('.', '(foo)bar')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #137')

  " #138
  call setline('.', 'foo(bar)')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #138')

  " #139
  call setline('.', 'foo(bar)baz')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #139')

  %delete

  " #140
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv2j3lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #140')
  call g:assert.equals(getline(2),   'bar',        'failed at #140')
  call g:assert.equals(getline(3),   'baz',        'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #140')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #141
  call setline('.', '(a)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #141')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #142
  call setline('.', '()')
  normal 0vlsd
  call g:assert.equals(getline('.'), '',           'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #142')

  %delete

  " #143
  call setline('.', 'foo()bar')
  normal 03lvlsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['(', ')'])
  normal ggvjsd
  call g:assert.equals(getline(1),   '',           'failed at #144')
  call g:assert.equals(getline(2),   '',           'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #144')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #145
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv2jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #145')

  %delete

  " #146
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv4jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #146')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #147
  call setline('.', '((foo))')
  normal 0v$2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #147')

  " #148
  call setline('.', '{[(foo)]}')
  normal 0v$3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #148')

  " #149
  call setline('.', 'foo{[(bar)]}baz')
  normal 03lv8l3sd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #149')
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

  " #150
  call setline('.', '{[(foo)]}')
  normal 02lv4lsd
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #150')

  " #151
  call setline('.', '{[(foo)]}')
  normal 0lv6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #151')

  " #152
  call setline('.', '{[(foo)]}')
  normal 0v8lsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #152')

  " #153
  call setline('.', '<title>foo</title>')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #153')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #96
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #96')

  " #97
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #97')

  """ keep
  " #98
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #98')

  " #99
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #99')

  """ inner_tail
  " #100
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #100')

  " #101
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #101')

  """ front
  " #102
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #102')

  " #103
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #103')

  """ end
  " #104
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #104')

  " #105
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #105')

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
  " #106
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #106')

  " #107
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #107')

  """ off
  " #108
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #108')

  " #109
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #109')

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
  " #110
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #110')

  " #111
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #111')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #112
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #112')

  " #113
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #113')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #114
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #114')

  " #115
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #115')

  " #116
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #116')

  " #117
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #117')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #118
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #118')

  " #119
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #119')

  " #120
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #120')

  " #121
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #121')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #122
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #122')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #123
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #123')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #124
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #124')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #125
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #125')

  %delete

  " #126
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #126')

  %delete

  " #127
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #127')
  call g:assert.equals(getline(2),   'foo',        'failed at #127')
  call g:assert.equals(getline(3),   'aa',         'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #127')

  %delete

  " #128
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #128')
  call g:assert.equals(getline(2),   'foo',        'failed at #128')
  call g:assert.equals(getline(3),   '',           'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #128')

  %delete

  " #129
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #129')
  call g:assert.equals(getline(2),   'aa',         'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #129')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #130
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #130')

  %delete

  " #131
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #131')

  %delete

  " #132
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #132')

  %delete

  " #133
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #133')
  call g:assert.equals(getline(2),   'bb',         'failed at #133')
  call g:assert.equals(getline(3),   '',           'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #133')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #134
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #134')

  " #135
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #135')

  " #136
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #136')

  " #137
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #137')

  %delete

  " #138
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #138')

  %delete

  " #139
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #139')

  %delete

  " #140
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #141')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #142
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #142')

  " #143
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #144')

  %delete

  " #145
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #145')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #146
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #146')
  call g:assert.equals(getline(2),   'bar',        'failed at #146')
  call g:assert.equals(getline(3),   'baz',        'failed at #146')
  call g:assert.equals(getline(4),   '',           'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #146')

  %delete

  " #147
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #147')
  call g:assert.equals(getline(2),   'bar',        'failed at #147')
  call g:assert.equals(getline(3),   'baz',        'failed at #147')
  call g:assert.equals(getline(4),   '',           'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #147')

  %delete

  " #148
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #148')
  call g:assert.equals(getline(2),   'bar',        'failed at #148')
  call g:assert.equals(getline(3),   'baz',        'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #148')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #149
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #149')

  %delete

  " #150
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #150')

  %delete

  " #151
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #151')

  %delete

  " #152
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #152')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #153
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #154')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #155
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #155')

  %delete

  " #156
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #156')

  %delete

  " #157
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #157')

  %delete

  " #158
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #158')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #159
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #159')

  " #160
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #160')

  " #161
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #161')

  " #162
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #162')

  %delete

  " #163
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #163')
  call g:assert.equals(getline(2),   'bar',        'failed at #163')
  call g:assert.equals(getline(3),   'baz',        'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #163')
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

  " #164
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #164')

  " #165
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #165')

  " #166
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #166')

  " #167
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #167')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #168
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')

  " #169
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #169')

  """ keep
  " #170
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #170')

  " #171
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #171')

  """ inner_tail
  " #172
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #172')

  " #173
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #173')

  """ front
  " #174
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #174')

  " #175
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #175')

  """ end
  " #176
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #176')

  " #177
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #177')

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
  " #178
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #178')

  " #179
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #179')

  """ off
  " #180
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #180')

  " #181
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #181')

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
  " #182
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #182')

  " #183
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #183')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #184
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #184')

  " #185
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #185')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ on
  " #186
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #186')

  " #187
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #187')

  " #188
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #188')

  " #189
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #189')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #190
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #190')

  " #191
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #191')

  " #192
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #192')

  " #193
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #193')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #194
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #194')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #195
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #195')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #196
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #196')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #197
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #197')
  call g:assert.equals(getline(2),   'foo',        'failed at #197')
  call g:assert.equals(getline(3),   '',           'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #197')

  %delete

  " #198
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #198')
  call g:assert.equals(getline(2),   'foo',        'failed at #198')
  call g:assert.equals(getline(3),   '  ',         'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #198')

  %delete

  " #199
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #199')
  call g:assert.equals(getline(2),   'foo',        'failed at #199')
  call g:assert.equals(getline(3),   'aa',         'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #199')

  %delete

  " #200
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #200')
  call g:assert.equals(getline(2),   'foo',        'failed at #200')
  call g:assert.equals(getline(3),   '',           'failed at #200')
  call g:assert.equals(getline(4),   '',           'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #200')

  %delete

  " #201
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #201')
  call g:assert.equals(getline(2),   'foo',        'failed at #201')
  call g:assert.equals(getline(3),   'aa',         'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #201')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #202
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #202')

  %delete

  " #203
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #203')

  %delete

  " #204
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #204')

  %delete

  " #205
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #205')
  call g:assert.equals(getline(2),   'bb',         'failed at #205')
  call g:assert.equals(getline(3),   '',           'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #205')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #206
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #206')

  " #207
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #207')

  " #208
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #208')

  " #209
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #209')

  %delete

  " #210
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #210')

  %delete

  " #211
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #211')

  %delete

  " #212
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #212')

  %delete

  " #213
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #213')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #214
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #214')

  " #215
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #215')

  %delete

  " #216
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #216')

  %delete

  " #217
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #217')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #218
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #218')
  call g:assert.equals(getline(2),   'bar',        'failed at #218')
  call g:assert.equals(getline(3),   'baz',        'failed at #218')
  call g:assert.equals(getline(4),   '',           'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #218')

  %delete

  " #219
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #219')
  call g:assert.equals(getline(2),   'bar',        'failed at #219')
  call g:assert.equals(getline(3),   'baz',        'failed at #219')
  call g:assert.equals(getline(4),   '',           'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #219')

  %delete

  " #220
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #220')
  call g:assert.equals(getline(2),   'bar',        'failed at #220')
  call g:assert.equals(getline(3),   'baz',        'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #220')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #221
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #221')

  %delete

  " #222
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #222')

  %delete

  " #223
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #223')

  %delete

  " #224
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #224')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #153
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #154')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #225
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #225')

  %delete

  " #226
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #226')

  %delete

  " #227
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #227')

  %delete

  " #228
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #228')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #229
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #229')

  " #230
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #230')

  " #231
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #231')

  " #232
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #232')

  %delete

  " #233
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #233')
  call g:assert.equals(getline(2),   'bar',        'failed at #233')
  call g:assert.equals(getline(3),   'baz',        'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #233')
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

  " #234
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #234')

  " #235
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #235')

  " #236
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #236')

  " #237
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #237')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #238
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #238')

  " #239
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #239')

  """ keep
  " #240
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #240')

  " #241
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #241')

  """ inner_tail
  " #242
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #242')

  " #243
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #243')

  """ front
  " #244
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #244')

  " #245
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #245')

  """ end
  " #246
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #246')

  " #247
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #247')

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
  " #248
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #248')

  " #249
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #249')

  """ off
  " #250
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #250')

  " #251
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #251')

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
  " #252
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #252')

  " #253
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #253')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #254
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #254')

  " #255
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #255')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ on
  " #256
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #256')

  " #257
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #257')

  " #258
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #258')

  " #259
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #259')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #260
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #260')

  " #261
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #261')

  " #262
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #262')

  " #263
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #263')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #264
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #264')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #265
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #265')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #266
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #266')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #267
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #267')
  call g:assert.equals(getline(2),   'foo',        'failed at #267')
  call g:assert.equals(getline(3),   '',           'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #267')

  %delete

  " #268
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #268')
  call g:assert.equals(getline(2),   'foo',        'failed at #268')
  call g:assert.equals(getline(3),   '  ',         'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #268')

  %delete

  " #269
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #269')
  call g:assert.equals(getline(2),   'foo',        'failed at #269')
  call g:assert.equals(getline(3),   'aa',         'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #269')

  %delete

  " #270
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #270')
  call g:assert.equals(getline(2),   'foo',        'failed at #270')
  call g:assert.equals(getline(3),   '',           'failed at #270')
  call g:assert.equals(getline(4),   '',           'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #270')

  %delete

  " #271
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #271')
  call g:assert.equals(getline(2),   'foo',        'failed at #271')
  call g:assert.equals(getline(3),   'aa',         'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #271')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #272
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #272')

  %delete

  " #273
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #273')

  %delete

  " #274
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #274')

  %delete

  " #275
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #275')
  call g:assert.equals(getline(2),   'bb',         'failed at #275')
  call g:assert.equals(getline(3),   '',           'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #275')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #276
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #276')
  call g:assert.equals(getline(2),   'bar',        'failed at #276')
  call g:assert.equals(getline(3),   'baz',        'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #276')

  %delete

  " #277
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #277')
  call g:assert.equals(getline(2),   'bar',        'failed at #277')
  call g:assert.equals(getline(3),   'baz',        'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #277')

  %delete

  " #278
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #278')
  call g:assert.equals(getline(2),   'bar',        'failed at #278')
  call g:assert.equals(getline(3),   'baz',        'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #278')

  %delete

  " #279
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #279')
  call g:assert.equals(getline(2),   'bar',        'failed at #279')
  call g:assert.equals(getline(3),   'baz',        'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #279')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #280
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #280')
  call g:assert.equals(getline(2),   'bar',        'failed at #280')
  call g:assert.equals(getline(3),   'baz',        'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #280')

  " #281
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #281')
  call g:assert.equals(getline(2),   'bar',        'failed at #281')
  call g:assert.equals(getline(3),   'baz',        'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #281')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #282
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #282')
  call g:assert.equals(getline(2),   'foobar',     'failed at #282')
  call g:assert.equals(getline(3),   'foobar',     'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #283')
  call g:assert.equals(getline(2),   'foobar',     'failed at #283')
  call g:assert.equals(getline(3),   'foobar',     'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #283')

  %delete

  " #284
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #284')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #284')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #284')

  %delete

  " #285
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #285')
  call g:assert.equals(getline(2),   'bar',        'failed at #285')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #285')

  %delete

  " #286
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #286')
  call g:assert.equals(getline(2),   'barbar',     'failed at #286')
  call g:assert.equals(getline(3),   'baz',        'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #286')

  %delete

  " #287
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #287')
  call g:assert.equals(getline(2),   'bar',        'failed at #287')
  call g:assert.equals(getline(3),   'baz',        'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #287')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #288
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #288')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #289
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #289')
  call g:assert.equals(getline(2),   '',           'failed at #289')
  call g:assert.equals(getline(3),   '',           'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #289')

  %delete

  " #290
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #290')
  call g:assert.equals(getline(2),   'foobar',     'failed at #290')
  call g:assert.equals(getline(3),   'foobar',     'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #290')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #291
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #291')

  " #292
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #292')

  " #293
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #293')

  " #294
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #294')

  " #295
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #295')

  %delete

  " #296
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #296')
  call g:assert.equals(getline(2),   'bar',        'failed at #296')
  call g:assert.equals(getline(3),   'baz',        'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #296')

  %delete

  " #297
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #297')
  call g:assert.equals(getline(2),   'bar',        'failed at #297')
  call g:assert.equals(getline(3),   'baz',        'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #297')

  %delete

  " #298
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #298')
  call g:assert.equals(getline(2),   'abarb',      'failed at #298')
  call g:assert.equals(getline(3),   'baz',        'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #298')

  %delete

  " #299
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #299')
  call g:assert.equals(getline(2),   'bar',        'failed at #299')
  call g:assert.equals(getline(3),   'abazb',      'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #299')

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

  " #300
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #300')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #300')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #300')

  %delete

  " #301
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #301')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #301')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #301')

  %delete

  " #302
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #302')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #302')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #302')

  %delete

  " #303
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #303')
  call g:assert.equals(getline(2), 'bar', 'failed at #303')
  call g:assert.equals(getline(3), 'baz', 'failed at #303')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #304
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #304')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #304')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #304')

  " #305
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #305')
  call g:assert.equals(getline(2),   'bar',        'failed at #305')
  call g:assert.equals(getline(3),   'baz',        'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #305')

  %delete

  """ keep
  " #306
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #306')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #306')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #306')

  " #307
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #307')
  call g:assert.equals(getline(2),   'bar',        'failed at #307')
  call g:assert.equals(getline(3),   'baz',        'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #307')

  %delete

  """ inner_tail
  " #308
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #308')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #308')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #308')

  " #309
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #309')
  call g:assert.equals(getline(2),   'bar',        'failed at #309')
  call g:assert.equals(getline(3),   'baz',        'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #309')

  %delete

  """ front
  " #310
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #310')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #310')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #310')

  " #311
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #311')
  call g:assert.equals(getline(2),   'bar',        'failed at #311')
  call g:assert.equals(getline(3),   'baz',        'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #311')

  %delete

  """ end
  " #312
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #312')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #312')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #312')

  " #313
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #313')
  call g:assert.equals(getline(2),   'bar',        'failed at #313')
  call g:assert.equals(getline(3),   'baz',        'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #313')

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
  " #314
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #314')
  call g:assert.equals(getline(2), '(bar)', 'failed at #314')
  call g:assert.equals(getline(3), '(baz)', 'failed at #314')

  %delete

  " #315
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #315')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #315')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #315')

  %delete

  """ off
  " #316
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #316')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #316')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #316')

  %delete

  " #317
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #317')
  call g:assert.equals(getline(2), '{bar}', 'failed at #317')
  call g:assert.equals(getline(3), '{baz}', 'failed at #317')

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
  " #318
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #318')
  call g:assert.equals(getline(2), 'bar', 'failed at #318')
  call g:assert.equals(getline(3), 'baz', 'failed at #318')

  %delete

  " #319
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #319')
  call g:assert.equals(getline(2), '88bar88', 'failed at #319')
  call g:assert.equals(getline(3), '88baz88', 'failed at #319')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #320
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #320')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #320')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #320')

  %delete

  " #321
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #321')
  call g:assert.equals(getline(2), 'bar', 'failed at #321')
  call g:assert.equals(getline(3), 'baz', 'failed at #321')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #322
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #322')
  call g:assert.equals(getline(2), 'bar', 'failed at #322')
  call g:assert.equals(getline(3), 'baz', 'failed at #322')

  %delete

  " #323
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #323')
  call g:assert.equals(getline(2), ' bar', 'failed at #323')
  call g:assert.equals(getline(3), ' baz', 'failed at #323')

  %delete

  " #324
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #324')
  call g:assert.equals(getline(2), 'bar ', 'failed at #324')
  call g:assert.equals(getline(3), 'baz ', 'failed at #324')

  %delete

  " #325
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #325')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #326
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #326')
  call g:assert.equals(getline(2), 'bar', 'failed at #326')
  call g:assert.equals(getline(3), 'baz', 'failed at #326')

  %delete

  " #327
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #327')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #327')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #327')

  %delete

  " #328
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #328')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #328')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #328')

  %delete

  " #329
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #329')
  call g:assert.equals(getline(2), '"bar"', 'failed at #329')
  call g:assert.equals(getline(3), '"baz"', 'failed at #329')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #330
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #330')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #330')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #330')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #331
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #331')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #331')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #331')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #332
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #332')
  call g:assert.equals(getline(2), '', 'failed at #332')
  call g:assert.equals(getline(3), '', 'failed at #332')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #333
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #333')
  call g:assert.equals(getline(2),   'bar',        'failed at #333')
  call g:assert.equals(getline(3),   'baz',        'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #333')

  %delete

  " #334
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #334')
  call g:assert.equals(getline(2),   'bar',        'failed at #334')
  call g:assert.equals(getline(3),   'baz',        'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #334')

  %delete

  " #335
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #335')
  call g:assert.equals(getline(2),   'bar',        'failed at #335')
  call g:assert.equals(getline(3),   'baz',        'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #335')

  %delete

  " #336
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #336')
  call g:assert.equals(getline(2),   'bar',        'failed at #336')
  call g:assert.equals(getline(3),   'baz',        'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #336')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #337
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #337')
  call g:assert.equals(getline(2),   'bar',        'failed at #337')
  call g:assert.equals(getline(3),   'baz',        'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #337')

  " #338
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #338')
  call g:assert.equals(getline(2),   'bar',        'failed at #338')
  call g:assert.equals(getline(3),   'baz',        'failed at #338')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #338')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #338')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #339
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #339')
  call g:assert.equals(getline(2),   'foobar',     'failed at #339')
  call g:assert.equals(getline(3),   'foobar',     'failed at #339')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #339')

  %delete

  " #340
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #340')
  call g:assert.equals(getline(2),   'foobar',     'failed at #340')
  call g:assert.equals(getline(3),   'foobar',     'failed at #340')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #340')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #340')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #340')

  %delete

  " #341
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #341')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #341')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #341')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #341')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #341')

  %delete

  " #342
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #342')
  call g:assert.equals(getline(2),   'bar',        'failed at #342')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #342')

  %delete

  " #343
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #343')
  call g:assert.equals(getline(2),   'barbar',     'failed at #343')
  call g:assert.equals(getline(3),   'baz',        'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #343')

  %delete

  " #344
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #344')
  call g:assert.equals(getline(2),   'bar',        'failed at #344')
  call g:assert.equals(getline(3),   'baz',        'failed at #344')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #344')

  %delete

  """ terminal-extended block-wise visual mode
  " #345
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #345')
  call g:assert.equals(getline(2),   'baaar',      'failed at #345')
  call g:assert.equals(getline(3),   'baz',        'failed at #345')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #345')

  %delete

  " #346
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #346')
  call g:assert.equals(getline(2),   'bar',        'failed at #346')
  call g:assert.equals(getline(3),   'baaz',       'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #346')

  %delete

  " #347
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #347')
  call g:assert.equals(getline(2),   '',           'failed at #347')
  call g:assert.equals(getline(3),   'baz',        'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #347')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #347')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #348
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #348')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #349
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #349')
  call g:assert.equals(getline(2),   '',           'failed at #349')
  call g:assert.equals(getline(3),   '',           'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #349')

  %delete

  " #350
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #350')
  call g:assert.equals(getline(2),   'foobar',     'failed at #350')
  call g:assert.equals(getline(3),   'foobar',     'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #350')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #350')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #350')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #351
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #351')

  " #352
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #352')

  " #353
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #353')

  %delete

  " #354
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #354')
  call g:assert.equals(getline(2),   'bar',        'failed at #354')
  call g:assert.equals(getline(3),   'baz',        'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #354')

  %delete

  " #355
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #355')
  call g:assert.equals(getline(2),   'bar',        'failed at #355')
  call g:assert.equals(getline(3),   'baz',        'failed at #355')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #355')

  %delete

  " #356
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #356')
  call g:assert.equals(getline(2),   'abarb',      'failed at #356')
  call g:assert.equals(getline(3),   'baz',        'failed at #356')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #356')

  %delete

  " #357
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #357')
  call g:assert.equals(getline(2),   'bar',        'failed at #357')
  call g:assert.equals(getline(3),   'abazb',      'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #357')
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

  " #358
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #358')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #358')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #358')

  %delete

  " #359
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #359')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #359')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #359')

  %delete

  " #360
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #360')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #360')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #360')

  %delete

  " #361
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #361')
  call g:assert.equals(getline(2), 'bar', 'failed at #361')
  call g:assert.equals(getline(3), 'baz', 'failed at #361')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #362
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #362')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #362')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #362')

  " #363
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #363')
  call g:assert.equals(getline(2),   'bar',        'failed at #363')
  call g:assert.equals(getline(3),   'baz',        'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #363')

  %delete

  """ keep
  " #364
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #364')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #364')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #364')

  " #365
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #365')
  call g:assert.equals(getline(2),   'bar',        'failed at #365')
  call g:assert.equals(getline(3),   'baz',        'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #365')

  %delete

  """ inner_tail
  " #366
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #366')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #366')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #366')

  " #367
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #367')
  call g:assert.equals(getline(2),   'bar',        'failed at #367')
  call g:assert.equals(getline(3),   'baz',        'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #367')

  %delete

  """ front
  " #368
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #368')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #368')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #368')

  " #369
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #369')
  call g:assert.equals(getline(2),   'bar',        'failed at #369')
  call g:assert.equals(getline(3),   'baz',        'failed at #369')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #369')

  %delete

  """ end
  " #370
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #370')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #370')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #370')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #370')

  " #371
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #371')
  call g:assert.equals(getline(2),   'bar',        'failed at #371')
  call g:assert.equals(getline(3),   'baz',        'failed at #371')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #371')

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
  " #372
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #372')
  call g:assert.equals(getline(2), '(bar)', 'failed at #372')
  call g:assert.equals(getline(3), '(baz)', 'failed at #372')

  %delete

  " #373
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4llsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #373')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #373')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #373')

  %delete

  """ off
  " #374
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #374')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #374')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #374')

  %delete

  " #375
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #375')
  call g:assert.equals(getline(2), '{bar}', 'failed at #375')
  call g:assert.equals(getline(3), '{baz}', 'failed at #375')

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
  " #376
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #376')
  call g:assert.equals(getline(2), 'bar', 'failed at #376')
  call g:assert.equals(getline(3), 'baz', 'failed at #376')

  %delete

  " #377
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #377')
  call g:assert.equals(getline(2), '88bar88', 'failed at #377')
  call g:assert.equals(getline(3), '88baz88', 'failed at #377')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #378
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #378')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #378')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #378')

  %delete

  " #379
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #379')
  call g:assert.equals(getline(2), 'bar', 'failed at #379')
  call g:assert.equals(getline(3), 'baz', 'failed at #379')

  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #380
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #380')
  call g:assert.equals(getline(2), 'bar', 'failed at #380')
  call g:assert.equals(getline(3), 'baz', 'failed at #380')

  %delete

  " #381
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #381')
  call g:assert.equals(getline(2), ' bar', 'failed at #381')
  call g:assert.equals(getline(3), ' baz', 'failed at #381')

  %delete

  " #382
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #382')
  call g:assert.equals(getline(2), 'bar ', 'failed at #382')
  call g:assert.equals(getline(3), 'baz ', 'failed at #382')

  %delete

  " #383
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #383')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #384
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #384')
  call g:assert.equals(getline(2), 'bar', 'failed at #384')
  call g:assert.equals(getline(3), 'baz', 'failed at #384')

  %delete

  " #385
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #385')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #385')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #385')

  %delete

  " #386
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #386')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #386')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #386')

  %delete

  " #387
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #387')
  call g:assert.equals(getline(2), '"bar"', 'failed at #387')
  call g:assert.equals(getline(3), '"baz"', 'failed at #387')

  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #388
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #388')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #388')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #388')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #389
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #389')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #389')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #389')

  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #390
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #390')
  call g:assert.equals(getline(2), '', 'failed at #390')
  call g:assert.equals(getline(3), '', 'failed at #390')

  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssd <Esc>:call operator#sandwich#prerequisite('delete', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #391
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #391')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #391')

  " #392
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #392')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #392')

  " #393
  call setline('.', '(foo)')
  normal 0ssda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #393')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #393')

  " #394
  call setline('.', '[foo]')
  normal 0ssda[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #394')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #394')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
