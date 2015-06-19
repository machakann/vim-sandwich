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

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #38
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #38')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #38')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #38')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #38')

  " #39
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #39')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #39')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #39')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #39')

  " #40
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo',        'failed at #40')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #40')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #40')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #40')

  " #41
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), 'foo',        'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #41')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #41')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #42
  call setline('.', 'afooa')
  normal 0sdiw
  call g:assert.equals(getline('.'), 'foo',        'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #42')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #42')

  " #43
  call setline('.', '*foo*')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #43')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #44
  call setline('.', '(foo)bar')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #44')

  " #45
  call setline('.', 'foo(bar)')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #45')

  " #46
  call setline('.', 'foo(bar)baz')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #46')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))']}]

  " #47
  call setline('.', 'foo((bar))baz')
  normal 0sdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #47')

  " #48
  call setline('.', 'foo((bar))baz')
  normal 02lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #48')

  " #49
  call setline('.', 'foo((bar))baz')
  normal 03lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #49')

  " #50
  call setline('.', 'foo((bar))baz')
  normal 04lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #50')

  " #51
  call setline('.', 'foo((bar))baz')
  normal 05lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #51')

  " #52
  call setline('.', 'foo((bar))baz')
  normal 07lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #52')

  " #53
  call setline('.', 'foo((bar))baz')
  normal 08lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #53')

  " #54
  call setline('.', 'foo((bar))baz')
  normal 09lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #54')

  " #55
  call setline('.', 'foo((bar))baz')
  normal 010lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #55')

  " #56
  call setline('.', 'foo((bar))baz')
  normal 012lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #56')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #57
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsd13l
  call g:assert.equals(getline(1),   'foo',        'failed at #57')
  call g:assert.equals(getline(2),   'bar',        'failed at #57')
  call g:assert.equals(getline(3),   'baz',        'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #57')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #57')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #58
  call setline('.', '(a)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'a',          'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #58')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #58')

  %delete

  " #59
  call append(0, ['(', 'a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #59')
  call g:assert.equals(getline(2),   'a',          'failed at #59')
  call g:assert.equals(getline(3),   '',           'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #59')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #59')

  %delete

  " #60
  call append(0, ['(a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   'a',          'failed at #60')
  call g:assert.equals(getline(2),   '',           'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #60')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #60')

  %delete

  " #61
  call append(0, ['(', 'a)'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #61')
  call g:assert.equals(getline(2),   'a',          'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #61')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #61')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #62
  call setline('.', '()')
  normal 0sd2l
  call g:assert.equals(getline('.'), '',           'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #62')

  %delete

  " #63
  call setline('.', 'foo()bar')
  normal 03lsd2l
  call g:assert.equals(getline('.'), 'foobar',     'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #63')

  %delete
  set whichwrap=h,l

  " #64
  call append(0, ['(', ')'])
  normal ggsd3l
  call g:assert.equals(getline(1),   '',           'failed at #64')
  call g:assert.equals(getline(2),   '',           'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #64')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #65
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd15l
  call g:assert.equals(getline(1),   'foo',        'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #65')

  %delete

  " #66
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd21l
  call g:assert.equals(getline(1),   'foo',        'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #66')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')

  " #67
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #67')

  %delete

  " #68
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #68')

  %delete

  " #69
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #69')

  %delete

  " #70
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #70')

  %delete

  " #71
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #71')

  %delete

  " #72
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #72')

  %delete

  " #73
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #73')

  %delete

  " #74
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #74')

  %delete

  " #75
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #75')

  %delete

  " #76
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #76')

  %delete

  " #77
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #77')

  %delete

  " #78
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #78')

  %delete

  " #79
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #79')

  %delete

  " #80
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #80')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #81
  call setline('.', '((foo))')
  normal 02sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #81')

  " #82
  call setline('.', '{[(foo)]}')
  normal 03sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #82')

  " #83
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #83')

  " #84
  call setline('.', '[(foo bar)]')
  normal 02sd11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #84')

  " #85
  call setline('.', 'foo{[(bar)]}baz')
  normal 03l3sd9l
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #85')
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

  " #86
  call setline('.', '{[(foo)]}')
  normal 02lsd5l
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #86')

  " #87
  call setline('.', '{[(foo)]}')
  normal 0lsd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #87')

  " #88
  call setline('.', '{[(foo)]}')
  normal 0sd9l
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #88')

  " #89
  call setline('.', '<title>foo</title>')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #89')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #90
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #90')

  " #91
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #91')

  """ keep
  " #92
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #92')

  " #93
  normal 2lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #93')

  """ inner_tail
  " #94
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #94')

  " #95
  normal hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #95')

  """ front
  " #96
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #96')

  " #97
  normal 3lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #97')

  """ end
  " #98
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #98')

  " #99
  normal 3hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #99')

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
  " #100
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #100')

  " #101
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #101')

  """ off
  " #102
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #102')

  " #103
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #103')

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
  " #104
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #104')

  " #105
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #105')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #106
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #106')

  " #107
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #107')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ on
  " #108
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #108')

  " #109
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #109')

  " #110
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #110')

  " #111
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #111')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #112
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #112')

  " #113
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #113')

  " #114
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #114')

  " #115
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #115')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #116
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #116')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #117
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #117')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #118
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #118')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #119
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #119')

  %delete

  " #120
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #120')

  %delete

  " #121
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'aa',         'failed at #121')
  call g:assert.equals(getline(2),   'foo',        'failed at #121')
  call g:assert.equals(getline(3),   'aa',         'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #121')

  %delete

  " #122
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'aa',         'failed at #122')
  call g:assert.equals(getline(2),   'foo',        'failed at #122')
  call g:assert.equals(getline(3),   '',           'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #122')

  %delete

  " #123
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'foo',        'failed at #123')
  call g:assert.equals(getline(2),   'aa',         'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #123')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #124
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #124')

  %delete

  " #125
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #125')

  %delete

  " #126
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #126')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #126')

  %delete

  " #127
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsd5l
  call g:assert.equals(getline(1),   'aa',         'failed at #127')
  call g:assert.equals(getline(2),   'bb',         'failed at #127')
  call g:assert.equals(getline(3),   '',           'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #127')

  set whichwrap&
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #128
  call setline('.', '(foo)')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #128')

  " #129
  call setline('.', '[foo]')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #129')

  " #130
  call setline('.', '{foo}')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #130')

  " #131
  call setline('.', '<foo>')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #131')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #132
  call setline('.', 'afooa')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #132')

  " #133
  call setline('.', '*foo*')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #133')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #134
  call setline('.', '(foo)bar')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #134')

  " #135
  call setline('.', 'foo(bar)')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #135')

  " #136
  call setline('.', 'foo(bar)baz')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #136')

  %delete

  " #137
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv2j3lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #137')
  call g:assert.equals(getline(2),   'bar',        'failed at #137')
  call g:assert.equals(getline(3),   'baz',        'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #137')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #138
  call setline('.', '(a)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #138')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #139
  call setline('.', '()')
  normal 0vlsd
  call g:assert.equals(getline('.'), '',           'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #139')

  %delete

  " #140
  call setline('.', 'foo()bar')
  normal 03lvlsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['(', ')'])
  normal ggvjsd
  call g:assert.equals(getline(1),   '',           'failed at #141')
  call g:assert.equals(getline(2),   '',           'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #141')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #142
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv2jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #142')

  %delete

  " #143
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv4jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #143')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #144
  call setline('.', '((foo))')
  normal 0v$2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #144')

  " #145
  call setline('.', '{[(foo)]}')
  normal 0v$3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #145')

  " #146
  call setline('.', 'foo{[(bar)]}baz')
  normal 03lv8l3sd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #146')
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

  " #147
  call setline('.', '{[(foo)]}')
  normal 02lv4lsd
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #147')

  " #148
  call setline('.', '{[(foo)]}')
  normal 0lv6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #148')

  " #149
  call setline('.', '{[(foo)]}')
  normal 0v8lsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #149')

  " #150
  call setline('.', '<title>foo</title>')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #150')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #93
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #93')

  " #94
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #94')

  """ keep
  " #95
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #95')

  " #96
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #96')

  """ inner_tail
  " #97
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #97')

  " #98
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #98')

  """ front
  " #99
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #99')

  " #100
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #100')

  """ end
  " #101
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #101')

  " #102
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #102')

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
  " #103
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #103')

  " #104
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #104')

  """ off
  " #105
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #105')

  " #106
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #106')

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
  " #107
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #107')

  " #108
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #108')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #109
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #109')

  " #110
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #110')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #111
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #111')

  " #112
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #112')

  " #113
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #113')

  " #114
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #114')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #115
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #115')

  " #116
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #116')

  " #117
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #117')

  " #118
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #118')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #119
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #119')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #120
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #120')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #121
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #121')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #122
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #122')

  %delete

  " #123
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #123')

  %delete

  " #124
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #124')
  call g:assert.equals(getline(2),   'foo',        'failed at #124')
  call g:assert.equals(getline(3),   'aa',         'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #124')

  %delete

  " #125
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #125')
  call g:assert.equals(getline(2),   'foo',        'failed at #125')
  call g:assert.equals(getline(3),   '',           'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #125')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #125')

  %delete

  " #126
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
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
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #127')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #127')

  %delete

  " #128
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #128')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #128')

  %delete

  " #129
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #129')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #129')

  %delete

  " #130
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #130')
  call g:assert.equals(getline(2),   'bb',         'failed at #130')
  call g:assert.equals(getline(3),   '',           'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #130')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #130')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #131
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #131')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #131')

  " #132
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #132')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #132')

  " #133
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #133')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #133')

  " #134
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #134')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #134')

  %delete

  " #135
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #135')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #135')

  %delete

  " #136
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #136')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #136')

  %delete

  " #137
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #137')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #137')

  %delete

  " #138
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #138')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #138')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #138')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #139
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #139')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #139')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #139')

  " #140
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #141')

  %delete

  " #142
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #142')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #143
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #143')
  call g:assert.equals(getline(2),   'bar',        'failed at #143')
  call g:assert.equals(getline(3),   'baz',        'failed at #143')
  call g:assert.equals(getline(4),   '',           'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #144')
  call g:assert.equals(getline(2),   'bar',        'failed at #144')
  call g:assert.equals(getline(3),   'baz',        'failed at #144')
  call g:assert.equals(getline(4),   '',           'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #144')

  %delete

  " #145
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #145')
  call g:assert.equals(getline(2),   'bar',        'failed at #145')
  call g:assert.equals(getline(3),   'baz',        'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #145')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #146
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #146')

  %delete

  " #147
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #147')

  %delete

  " #148
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #148')

  %delete

  " #149
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #149')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #150
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #150')

  %delete

  " #151
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #151')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #152
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #152')

  %delete

  " #153
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #153')

  %delete

  " #154
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #154')

  %delete

  " #155
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #155')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #156
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #156')

  " #157
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #157')

  " #158
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #158')

  " #159
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #159')

  %delete

  " #160
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #160')
  call g:assert.equals(getline(2),   'bar',        'failed at #160')
  call g:assert.equals(getline(3),   'baz',        'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #160')
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

  " #161
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #161')

  " #162
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #162')

  " #163
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #163')

  " #164
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #164')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #165
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #165')

  " #166
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #166')

  """ keep
  " #167
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #167')

  " #168
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #168')

  """ inner_tail
  " #169
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #169')

  " #170
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #170')

  """ front
  " #171
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #171')

  " #172
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #172')

  """ end
  " #173
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #173')

  " #174
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #174')

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
  " #175
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #175')

  " #176
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #176')

  """ off
  " #177
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #177')

  " #178
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #178')

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
  " #179
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #179')

  " #180
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #180')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #181
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #181')

  " #182
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #182')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ on
  " #183
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #183')

  " #184
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #184')

  " #185
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #185')

  " #186
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #186')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #187
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #187')

  " #188
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #188')

  " #189
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #189')

  " #190
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #190')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #191
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #191')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #192
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #192')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #193
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #193')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #194
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #194')
  call g:assert.equals(getline(2),   'foo',        'failed at #194')
  call g:assert.equals(getline(3),   '',           'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #194')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #194')

  %delete

  " #195
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #195')
  call g:assert.equals(getline(2),   'foo',        'failed at #195')
  call g:assert.equals(getline(3),   '  ',         'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #195')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #195')

  %delete

  " #196
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #196')
  call g:assert.equals(getline(2),   'foo',        'failed at #196')
  call g:assert.equals(getline(3),   'aa',         'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #196')

  %delete

  " #197
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #197')
  call g:assert.equals(getline(2),   'foo',        'failed at #197')
  call g:assert.equals(getline(3),   '',           'failed at #197')
  call g:assert.equals(getline(4),   '',           'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #197')

  %delete

  " #198
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #198')
  call g:assert.equals(getline(2),   'foo',        'failed at #198')
  call g:assert.equals(getline(3),   'aa',         'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #198')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #199
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #199')

  %delete

  " #200
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #200')

  %delete

  " #201
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #201')

  %delete

  " #202
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #202')
  call g:assert.equals(getline(2),   'bb',         'failed at #202')
  call g:assert.equals(getline(3),   '',           'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #202')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #203
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #203')

  " #204
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #204')

  " #205
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #205')

  " #206
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #206')

  %delete

  " #207
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #207')

  %delete

  " #208
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #208')

  %delete

  " #209
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #209')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #209')

  %delete

  " #210
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #210')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #210')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #211
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #211')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #211')

  " #212
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #212')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #212')

  %delete

  " #213
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #213')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #213')

  %delete

  " #214
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #214')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #214')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #215
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #215')
  call g:assert.equals(getline(2),   'bar',        'failed at #215')
  call g:assert.equals(getline(3),   'baz',        'failed at #215')
  call g:assert.equals(getline(4),   '',           'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #215')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #215')

  %delete

  " #216
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #216')
  call g:assert.equals(getline(2),   'bar',        'failed at #216')
  call g:assert.equals(getline(3),   'baz',        'failed at #216')
  call g:assert.equals(getline(4),   '',           'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #216')

  %delete

  " #217
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #217')
  call g:assert.equals(getline(2),   'bar',        'failed at #217')
  call g:assert.equals(getline(3),   'baz',        'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #217')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #218
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #218')

  %delete

  " #219
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #219')

  %delete

  " #220
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #220')

  %delete

  " #221
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #221')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #150
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #150')

  %delete

  " #151
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #151')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #222
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #222')

  %delete

  " #223
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #223')

  %delete

  " #224
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #224')

  %delete

  " #225
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #225')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #226
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #226')

  " #227
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #227')

  " #228
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #228')

  " #229
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #229')

  %delete

  " #230
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #230')
  call g:assert.equals(getline(2),   'bar',        'failed at #230')
  call g:assert.equals(getline(3),   'baz',        'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #230')
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

  " #231
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #231')

  " #232
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #232')

  " #233
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #233')

  " #234
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #234')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #235
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #235')

  " #236
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #236')

  """ keep
  " #237
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #237')

  " #238
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #238')

  """ inner_tail
  " #239
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #239')

  " #240
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #240')

  """ front
  " #241
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #241')

  " #242
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #242')

  """ end
  " #243
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #243')

  " #244
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #244')

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
  " #245
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #245')

  " #246
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #246')

  """ off
  " #247
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #247')

  " #248
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #248')

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
  " #249
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #249')

  " #250
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #250')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #251
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #251')

  " #252
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #252')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ on
  " #253
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #253')

  " #254
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #254')

  " #255
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #255')

  " #256
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #256')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #257
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #257')

  " #258
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #258')

  " #259
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #259')

  " #260
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #260')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #261
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #261')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #262
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #262')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #263
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #263')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #264
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #264')
  call g:assert.equals(getline(2),   'foo',        'failed at #264')
  call g:assert.equals(getline(3),   '',           'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #264')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #264')

  %delete

  " #265
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #265')
  call g:assert.equals(getline(2),   'foo',        'failed at #265')
  call g:assert.equals(getline(3),   '  ',         'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #265')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #265')

  %delete

  " #266
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #266')
  call g:assert.equals(getline(2),   'foo',        'failed at #266')
  call g:assert.equals(getline(3),   'aa',         'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #266')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #266')

  %delete

  " #267
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #267')
  call g:assert.equals(getline(2),   'foo',        'failed at #267')
  call g:assert.equals(getline(3),   '',           'failed at #267')
  call g:assert.equals(getline(4),   '',           'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #267')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #267')

  %delete

  " #268
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #268')
  call g:assert.equals(getline(2),   'foo',        'failed at #268')
  call g:assert.equals(getline(3),   'aa',         'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #268')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #268')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #269
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #269')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #269')

  %delete

  " #270
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #270')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #270')

  %delete

  " #271
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #271')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #271')

  %delete

  " #272
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #272')
  call g:assert.equals(getline(2),   'bb',         'failed at #272')
  call g:assert.equals(getline(3),   '',           'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #272')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #272')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #273
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #273')
  call g:assert.equals(getline(2),   'bar',        'failed at #273')
  call g:assert.equals(getline(3),   'baz',        'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #273')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #273')

  %delete

  " #274
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #274')
  call g:assert.equals(getline(2),   'bar',        'failed at #274')
  call g:assert.equals(getline(3),   'baz',        'failed at #274')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #274')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #274')

  %delete

  " #275
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #275')
  call g:assert.equals(getline(2),   'bar',        'failed at #275')
  call g:assert.equals(getline(3),   'baz',        'failed at #275')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #275')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #275')

  %delete

  " #276
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #276')
  call g:assert.equals(getline(2),   'bar',        'failed at #276')
  call g:assert.equals(getline(3),   'baz',        'failed at #276')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #276')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #276')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #277
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #277')
  call g:assert.equals(getline(2),   'bar',        'failed at #277')
  call g:assert.equals(getline(3),   'baz',        'failed at #277')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #277')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #277')

  " #278
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #278')
  call g:assert.equals(getline(2),   'bar',        'failed at #278')
  call g:assert.equals(getline(3),   'baz',        'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #278')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #279
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #279')
  call g:assert.equals(getline(2),   'foobar',     'failed at #279')
  call g:assert.equals(getline(3),   'foobar',     'failed at #279')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #279')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #279')

  %delete

  " #280
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #280')
  call g:assert.equals(getline(2),   'foobar',     'failed at #280')
  call g:assert.equals(getline(3),   'foobar',     'failed at #280')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #280')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #280')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #280')

  %delete

  " #281
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #281')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #281')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #281')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #281')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #281')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #281')

  %delete

  " #282
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #282')
  call g:assert.equals(getline(2),   'bar',        'failed at #282')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #283')
  call g:assert.equals(getline(2),   'barbar',     'failed at #283')
  call g:assert.equals(getline(3),   'baz',        'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #283')

  %delete

  " #284
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #284')
  call g:assert.equals(getline(2),   'bar',        'failed at #284')
  call g:assert.equals(getline(3),   'baz',        'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #284')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #285
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #285')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #286
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #286')
  call g:assert.equals(getline(2),   '',           'failed at #286')
  call g:assert.equals(getline(3),   '',           'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #286')

  %delete

  " #287
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #287')
  call g:assert.equals(getline(2),   'foobar',     'failed at #287')
  call g:assert.equals(getline(3),   'foobar',     'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #287')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #288
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #288')

  " #289
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #289')

  " #290
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #290')

  " #291
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #291')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #291')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #291')

  " #292
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #292')

  %delete

  " #293
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #293')
  call g:assert.equals(getline(2),   'bar',        'failed at #293')
  call g:assert.equals(getline(3),   'baz',        'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #293')

  %delete

  " #294
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #294')
  call g:assert.equals(getline(2),   'bar',        'failed at #294')
  call g:assert.equals(getline(3),   'baz',        'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #294')

  %delete

  " #295
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #295')
  call g:assert.equals(getline(2),   'abarb',      'failed at #295')
  call g:assert.equals(getline(3),   'baz',        'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #295')

  %delete

  " #296
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #296')
  call g:assert.equals(getline(2),   'bar',        'failed at #296')
  call g:assert.equals(getline(3),   'abazb',      'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #296')

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

  " #297
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #297')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #297')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #297')

  %delete

  " #298
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #298')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #298')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #298')

  %delete

  " #299
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #299')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #299')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #299')

  %delete

  " #300
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #300')
  call g:assert.equals(getline(2), 'bar', 'failed at #300')
  call g:assert.equals(getline(3), 'baz', 'failed at #300')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #301
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #301')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #301')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')

  " #302
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #302')
  call g:assert.equals(getline(2),   'bar',        'failed at #302')
  call g:assert.equals(getline(3),   'baz',        'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #302')

  %delete

  """ keep
  " #303
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #303')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #303')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #303')

  " #304
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #304')
  call g:assert.equals(getline(2),   'bar',        'failed at #304')
  call g:assert.equals(getline(3),   'baz',        'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #304')

  %delete

  """ inner_tail
  " #305
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #305')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #305')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #305')

  " #306
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #306')
  call g:assert.equals(getline(2),   'bar',        'failed at #306')
  call g:assert.equals(getline(3),   'baz',        'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #306')

  %delete

  """ front
  " #307
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #307')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #307')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #307')

  " #308
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #308')
  call g:assert.equals(getline(2),   'bar',        'failed at #308')
  call g:assert.equals(getline(3),   'baz',        'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #308')

  %delete

  """ end
  " #309
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #309')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #309')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #309')

  " #310
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #310')
  call g:assert.equals(getline(2),   'bar',        'failed at #310')
  call g:assert.equals(getline(3),   'baz',        'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #310')

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
  " #311
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #311')
  call g:assert.equals(getline(2), '(bar)', 'failed at #311')
  call g:assert.equals(getline(3), '(baz)', 'failed at #311')

  %delete

  " #312
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #312')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #312')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #312')

  %delete

  """ off
  " #313
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #313')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #313')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #313')

  %delete

  " #314
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #314')
  call g:assert.equals(getline(2), '{bar}', 'failed at #314')
  call g:assert.equals(getline(3), '{baz}', 'failed at #314')

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
  " #315
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #315')
  call g:assert.equals(getline(2), 'bar', 'failed at #315')
  call g:assert.equals(getline(3), 'baz', 'failed at #315')

  %delete

  " #316
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #316')
  call g:assert.equals(getline(2), '88bar88', 'failed at #316')
  call g:assert.equals(getline(3), '88baz88', 'failed at #316')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #317
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #317')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #317')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #317')

  %delete

  " #318
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #318')
  call g:assert.equals(getline(2), 'bar', 'failed at #318')
  call g:assert.equals(getline(3), 'baz', 'failed at #318')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #319
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #319')
  call g:assert.equals(getline(2), 'bar', 'failed at #319')
  call g:assert.equals(getline(3), 'baz', 'failed at #319')

  %delete

  " #320
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #320')
  call g:assert.equals(getline(2), ' bar', 'failed at #320')
  call g:assert.equals(getline(3), ' baz', 'failed at #320')

  %delete

  " #321
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #321')
  call g:assert.equals(getline(2), 'bar ', 'failed at #321')
  call g:assert.equals(getline(3), 'baz ', 'failed at #321')

  %delete

  " #322
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #322')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #323
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #323')
  call g:assert.equals(getline(2), 'bar', 'failed at #323')
  call g:assert.equals(getline(3), 'baz', 'failed at #323')

  %delete

  " #324
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #324')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #324')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #324')

  %delete

  " #325
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #325')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #325')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #325')

  %delete

  " #326
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #326')
  call g:assert.equals(getline(2), '"bar"', 'failed at #326')
  call g:assert.equals(getline(3), '"baz"', 'failed at #326')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #327
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #327')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #327')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #327')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #328
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #328')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #328')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #328')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #329
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #329')
  call g:assert.equals(getline(2), '', 'failed at #329')
  call g:assert.equals(getline(3), '', 'failed at #329')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #330
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #330')
  call g:assert.equals(getline(2),   'bar',        'failed at #330')
  call g:assert.equals(getline(3),   'baz',        'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #330')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #330')

  %delete

  " #331
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #331')
  call g:assert.equals(getline(2),   'bar',        'failed at #331')
  call g:assert.equals(getline(3),   'baz',        'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #331')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #331')

  %delete

  " #332
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #332')
  call g:assert.equals(getline(2),   'bar',        'failed at #332')
  call g:assert.equals(getline(3),   'baz',        'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #332')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #332')

  %delete

  " #333
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #333')
  call g:assert.equals(getline(2),   'bar',        'failed at #333')
  call g:assert.equals(getline(3),   'baz',        'failed at #333')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #333')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #333')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #334
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #334')
  call g:assert.equals(getline(2),   'bar',        'failed at #334')
  call g:assert.equals(getline(3),   'baz',        'failed at #334')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #334')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #334')

  " #335
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #335')
  call g:assert.equals(getline(2),   'bar',        'failed at #335')
  call g:assert.equals(getline(3),   'baz',        'failed at #335')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #335')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #335')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #336
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #336')
  call g:assert.equals(getline(2),   'foobar',     'failed at #336')
  call g:assert.equals(getline(3),   'foobar',     'failed at #336')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #336')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #336')

  %delete

  " #337
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #337')
  call g:assert.equals(getline(2),   'foobar',     'failed at #337')
  call g:assert.equals(getline(3),   'foobar',     'failed at #337')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #337')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #337')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #337')

  %delete

  " #338
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #338')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #338')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #338')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #338')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #338')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #338')

  %delete

  " #339
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #339')
  call g:assert.equals(getline(2),   'bar',        'failed at #339')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #339')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #339')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #339')

  %delete

  " #340
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #340')
  call g:assert.equals(getline(2),   'barbar',     'failed at #340')
  call g:assert.equals(getline(3),   'baz',        'failed at #340')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #340')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #340')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #340')

  %delete

  " #341
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #341')
  call g:assert.equals(getline(2),   'bar',        'failed at #341')
  call g:assert.equals(getline(3),   'baz',        'failed at #341')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #341')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #341')

  %delete

  """ terminal-extended block-wise visual mode
  " #342
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #342')
  call g:assert.equals(getline(2),   'baaar',      'failed at #342')
  call g:assert.equals(getline(3),   'baz',        'failed at #342')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #342')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #342')

  %delete

  " #343
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #343')
  call g:assert.equals(getline(2),   'bar',        'failed at #343')
  call g:assert.equals(getline(3),   'baaz',       'failed at #343')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #343')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #343')

  %delete

  " #344
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #344')
  call g:assert.equals(getline(2),   '',           'failed at #344')
  call g:assert.equals(getline(3),   'baz',        'failed at #344')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #344')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #344')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #345
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #345')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #345')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #345')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #346
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #346')
  call g:assert.equals(getline(2),   '',           'failed at #346')
  call g:assert.equals(getline(3),   '',           'failed at #346')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #346')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #346')

  %delete

  " #347
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #347')
  call g:assert.equals(getline(2),   'foobar',     'failed at #347')
  call g:assert.equals(getline(3),   'foobar',     'failed at #347')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #347')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #347')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #347')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #348
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #348')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #348')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #348')

  " #349
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #349')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #349')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #349')

  " #350
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #350')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #350')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #350')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #350')

  %delete

  " #351
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #351')
  call g:assert.equals(getline(2),   'bar',        'failed at #351')
  call g:assert.equals(getline(3),   'baz',        'failed at #351')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #351')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #351')

  %delete

  " #352
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #352')
  call g:assert.equals(getline(2),   'bar',        'failed at #352')
  call g:assert.equals(getline(3),   'baz',        'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #352')

  %delete

  " #353
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #353')
  call g:assert.equals(getline(2),   'abarb',      'failed at #353')
  call g:assert.equals(getline(3),   'baz',        'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #353')

  %delete

  " #354
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #354')
  call g:assert.equals(getline(2),   'bar',        'failed at #354')
  call g:assert.equals(getline(3),   'abazb',      'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #354')
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

  " #355
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #355')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #355')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #355')

  %delete

  " #356
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #356')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #356')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #356')

  %delete

  " #357
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #357')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #357')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #357')

  %delete

  " #358
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #358')
  call g:assert.equals(getline(2), 'bar', 'failed at #358')
  call g:assert.equals(getline(3), 'baz', 'failed at #358')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #359
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #359')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #359')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #359')

  " #360
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #360')
  call g:assert.equals(getline(2),   'bar',        'failed at #360')
  call g:assert.equals(getline(3),   'baz',        'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #360')

  %delete

  """ keep
  " #361
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #361')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #361')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #361')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #361')

  " #362
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #362')
  call g:assert.equals(getline(2),   'bar',        'failed at #362')
  call g:assert.equals(getline(3),   'baz',        'failed at #362')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #362')

  %delete

  """ inner_tail
  " #363
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #363')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #363')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #363')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #363')

  " #364
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #364')
  call g:assert.equals(getline(2),   'bar',        'failed at #364')
  call g:assert.equals(getline(3),   'baz',        'failed at #364')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #364')

  %delete

  """ front
  " #365
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #365')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #365')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #365')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #365')

  " #366
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #366')
  call g:assert.equals(getline(2),   'bar',        'failed at #366')
  call g:assert.equals(getline(3),   'baz',        'failed at #366')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #366')

  %delete

  """ end
  " #367
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #367')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #367')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #367')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #367')

  " #368
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #368')
  call g:assert.equals(getline(2),   'bar',        'failed at #368')
  call g:assert.equals(getline(3),   'baz',        'failed at #368')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #368')

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
  " #369
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #369')
  call g:assert.equals(getline(2), '(bar)', 'failed at #369')
  call g:assert.equals(getline(3), '(baz)', 'failed at #369')

  %delete

  " #370
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4llsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #370')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #370')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #370')

  %delete

  """ off
  " #371
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #371')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #371')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #371')

  %delete

  " #372
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #372')
  call g:assert.equals(getline(2), '{bar}', 'failed at #372')
  call g:assert.equals(getline(3), '{baz}', 'failed at #372')

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
  " #373
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #373')
  call g:assert.equals(getline(2), 'bar', 'failed at #373')
  call g:assert.equals(getline(3), 'baz', 'failed at #373')

  %delete

  " #374
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #374')
  call g:assert.equals(getline(2), '88bar88', 'failed at #374')
  call g:assert.equals(getline(3), '88baz88', 'failed at #374')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #375
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #375')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #375')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #375')

  %delete

  " #376
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #376')
  call g:assert.equals(getline(2), 'bar', 'failed at #376')
  call g:assert.equals(getline(3), 'baz', 'failed at #376')

  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #377
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #377')
  call g:assert.equals(getline(2), 'bar', 'failed at #377')
  call g:assert.equals(getline(3), 'baz', 'failed at #377')

  %delete

  " #378
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #378')
  call g:assert.equals(getline(2), ' bar', 'failed at #378')
  call g:assert.equals(getline(3), ' baz', 'failed at #378')

  %delete

  " #379
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #379')
  call g:assert.equals(getline(2), 'bar ', 'failed at #379')
  call g:assert.equals(getline(3), 'baz ', 'failed at #379')

  %delete

  " #380
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #380')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #381
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #381')
  call g:assert.equals(getline(2), 'bar', 'failed at #381')
  call g:assert.equals(getline(3), 'baz', 'failed at #381')

  %delete

  " #382
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #382')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #382')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #382')

  %delete

  " #383
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #383')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #383')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #383')

  %delete

  " #384
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #384')
  call g:assert.equals(getline(2), '"bar"', 'failed at #384')
  call g:assert.equals(getline(3), '"baz"', 'failed at #384')

  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #385
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #385')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #385')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #385')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #386
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #386')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #386')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #386')

  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #387
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #387')
  call g:assert.equals(getline(2), '', 'failed at #387')
  call g:assert.equals(getline(3), '', 'failed at #387')

  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
