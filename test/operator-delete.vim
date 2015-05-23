let s:suite = themis#suite('operator-sandwich: delete:')

function! s:suite.before() abort  "{{{
  nmap sd <Plug>(operator-sandwich-delete)
  xmap sd <Plug>(operator-sandwich-delete)
endfunction
"}}}
function! s:suite.before_each() abort "{{{
  %delete
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

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sda{
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0sda<
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #5
  call setline('.', 'afooa')
  normal 0sdiw
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #5')

  " #6
  call setline('.', '*foo*')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #6')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #7
  call setline('.', '(foo)bar')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  " #8
  call setline('.', 'foo(bar)')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #8')

  " #9
  call setline('.', 'foo(bar)baz')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #9')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))']}]

  " #10
  call setline('.', 'foo((bar))baz')
  normal 0sdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #10')

  " #11
  call setline('.', 'foo((bar))baz')
  normal 02lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #11')

  " #12
  call setline('.', 'foo((bar))baz')
  normal 03lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #12')

  " #13
  call setline('.', 'foo((bar))baz')
  normal 04lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #13')

  " #14
  call setline('.', 'foo((bar))baz')
  normal 05lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #14')

  " #15
  call setline('.', 'foo((bar))baz')
  normal 07lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #15')

  " #16
  call setline('.', 'foo((bar))baz')
  normal 08lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #16')

  " #17
  call setline('.', 'foo((bar))baz')
  normal 09lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #17')

  " #18
  call setline('.', 'foo((bar))baz')
  normal 010lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #18')

  " #19
  call setline('.', 'foo((bar))baz')
  normal 012lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #19')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #20
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsd13l
  call g:assert.equals(getline(1),   'foo',        'failed at #20')
  call g:assert.equals(getline(2),   'bar',        'failed at #20')
  call g:assert.equals(getline(3),   'baz',        'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #20')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #21
  call setline('.', '(a)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'a',          'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #21')

  %delete

  " #22
  call append(0, ['(', 'a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #22')
  call g:assert.equals(getline(2),   'a',          'failed at #22')
  call g:assert.equals(getline(3),   '',           'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #22')

  %delete

  " #23
  call append(0, ['(a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   'a',          'failed at #23')
  call g:assert.equals(getline(2),   '',           'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #23')

  %delete

  " #24
  call append(0, ['(', 'a)'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #24')
  call g:assert.equals(getline(2),   'a',          'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #24')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #25
  call setline('.', '()')
  normal 0sd2l
  call g:assert.equals(getline('.'), '',           'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #25')

  %delete

  " #26
  call setline('.', 'foo()bar')
  normal 03lsd2l
  call g:assert.equals(getline('.'), 'foobar',     'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #26')

  %delete
  set whichwrap=h,l

  " #27
  call append(0, ['(', ')'])
  normal ggsd3l
  call g:assert.equals(getline(1),   '',           'failed at #27')
  call g:assert.equals(getline(2),   '',           'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #27')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #28
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd15l
  call g:assert.equals(getline(1),   'foo',        'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #28')

  %delete

  " #29
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd21l
  call g:assert.equals(getline(1),   'foo',        'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #29')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')

  " #30
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #30')

  %delete

  " #31
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #31')

  %delete

  " #32
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #32')

  %delete

  " #33
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #33')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #33')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #33')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #33')

  %delete

  " #34
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #34')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #34')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #34')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #34')

  %delete

  " #35
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #35')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #35')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #35')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #35')

  %delete

  " #36
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #36')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #36')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #36')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #36')

  %delete

  " #37
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #37')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #37')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #37')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #37')

  %delete

  " #38
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #38')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #38')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #38')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #38')

  %delete

  " #39
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #39')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #39')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #39')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #39')

  %delete

  " #40
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #40')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #40')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #40')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #40')

  %delete

  " #41
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #41')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #41')

  %delete

  " #42
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #42')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #42')

  %delete

  " #43
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #43')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #44
  call setline('.', '((foo))')
  normal 02sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #44')

  " #45
  call setline('.', '{[(foo)]}')
  normal 03sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #45')

  " #46
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #46')

  " #47
  call setline('.', '[(foo bar)]')
  normal 02sd11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #47')

  " #48
  call setline('.', 'foo{[(bar)]}baz')
  normal 03l3sd9l
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #48')
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

  " #49
  call setline('.', '{[(foo)]}')
  normal 02lsd5l
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #49')

  " #50
  call setline('.', '{[(foo)]}')
  normal 0lsd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #50')

  " #51
  call setline('.', '{[(foo)]}')
  normal 0sd9l
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #51')

  " #52
  call setline('.', '<title>foo</title>')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #52')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #53
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #53')

  " #54
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #54')

  """ keep
  " #55
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #55')

  " #56
  normal 2lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #56')

  """ inner_tail
  " #57
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #57')

  " #58
  normal hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #58')

  """ front
  " #59
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #59')

  " #60
  normal 3lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #60')

  """ end
  " #61
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #61')

  " #62
  normal 3hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #62')

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
  " #63
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #63')

  " #64
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #64')

  """ off
  " #65
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #65')

  " #66
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #66')

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
  " #67
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #67')

  " #68
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #68')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #69
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #69')

  " #70
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #70')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ on
  " #71
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #71')

  " #72
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #72')

  " #73
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #73')

  " #74
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #74')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #75
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #75')

  " #76
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #76')

  " #77
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #77')

  " #78
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #78')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #79
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #79')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #80
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #80')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #81
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #81')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #82
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #82')

  %delete

  " #83
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #83')

  %delete

  " #84
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'aa',         'failed at #84')
  call g:assert.equals(getline(2),   'foo',        'failed at #84')
  call g:assert.equals(getline(3),   'aa',         'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #84')

  %delete

  " #85
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'aa',         'failed at #85')
  call g:assert.equals(getline(2),   'foo',        'failed at #85')
  call g:assert.equals(getline(3),   '',           'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #85')

  %delete

  " #86
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'foo',        'failed at #86')
  call g:assert.equals(getline(2),   'aa',         'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #86')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #87
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #87')

  %delete

  " #88
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #88')

  %delete

  " #89
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #89')

  %delete

  " #90
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsd5l
  call g:assert.equals(getline(1),   'aa',         'failed at #90')
  call g:assert.equals(getline(2),   'bb',         'failed at #90')
  call g:assert.equals(getline(3),   '',           'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #90')

  set whichwrap&
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #91
  call setline('.', '(foo)')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #91')

  " #92
  call setline('.', '[foo]')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #92')

  " #93
  call setline('.', '{foo}')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #93')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #93')

  " #94
  call setline('.', '<foo>')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #94')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #95
  call setline('.', 'afooa')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #95')

  " #96
  call setline('.', '*foo*')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #96')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #97
  call setline('.', '(foo)bar')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #97')

  " #98
  call setline('.', 'foo(bar)')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #98')

  " #99
  call setline('.', 'foo(bar)baz')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #99')

  %delete

  " #100
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv2j3lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #100')
  call g:assert.equals(getline(2),   'bar',        'failed at #100')
  call g:assert.equals(getline(3),   'baz',        'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #100')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #101
  call setline('.', '(a)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #101')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #102
  call setline('.', '()')
  normal 0vlsd
  call g:assert.equals(getline('.'), '',           'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #102')

  %delete

  " #103
  call setline('.', 'foo()bar')
  normal 03lvlsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #103')

  %delete

  " #104
  call append(0, ['(', ')'])
  normal ggvjsd
  call g:assert.equals(getline(1),   '',           'failed at #104')
  call g:assert.equals(getline(2),   '',           'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #104')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #105
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv2jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #105')

  %delete

  " #106
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv4jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #106')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #107
  call setline('.', '((foo))')
  normal 0v$2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #107')

  " #108
  call setline('.', '{[(foo)]}')
  normal 0v$3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #108')

  " #109
  call setline('.', 'foo{[(bar)]}baz')
  normal 03lv8l3sd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #109')
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

  " #110
  call setline('.', '{[(foo)]}')
  normal 02lv4lsd
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #110')

  " #111
  call setline('.', '{[(foo)]}')
  normal 0lv6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #111')

  " #112
  call setline('.', '{[(foo)]}')
  normal 0v8lsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #112')

  " #113
  call setline('.', '<title>foo</title>')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #113')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #56
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #56')

  " #57
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #57')

  """ keep
  " #58
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #58')

  " #59
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #59')

  """ inner_tail
  " #60
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #60')

  " #61
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #61')

  """ front
  " #62
  call operator#sandwich#set('delete', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #62')

  " #63
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #63')

  """ end
  " #64
  call operator#sandwich#set('delete', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #64')

  " #65
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #65')

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
  " #66
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #66')

  " #67
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #67')

  """ off
  " #68
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #68')

  " #69
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #69')

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
  " #70
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #70')

  " #71
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #71')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #72
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #72')

  " #73
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #73')

  call operator#sandwich#set('delete', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #74
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #74')

  " #75
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #75')

  " #76
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #76')

  " #77
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #77')

  """ off
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)
  " #78
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #78')

  " #79
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #79')

  " #80
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #80')

  " #81
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #81')

  call operator#sandwich#set('delete', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #82
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #82')

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)
  " #83
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #83')

  call operator#sandwich#set('delete', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[dv`]'])

  " #84
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #84')

  call operator#sandwich#set('delete', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #85
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #85')

  %delete

  " #86
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #86')

  %delete

  " #87
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #87')
  call g:assert.equals(getline(2),   'foo',        'failed at #87')
  call g:assert.equals(getline(3),   'aa',         'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #87')

  %delete

  " #88
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #88')
  call g:assert.equals(getline(2),   'foo',        'failed at #88')
  call g:assert.equals(getline(3),   '',           'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #88')

  %delete

  " #89
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #89')
  call g:assert.equals(getline(2),   'aa',         'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #89')

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #90
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #90')

  %delete

  " #91
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #91')

  %delete

  " #92
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #92')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #92')

  %delete

  " #93
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #93')
  call g:assert.equals(getline(2),   'bb',         'failed at #93')
  call g:assert.equals(getline(3),   '',           'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #93')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #93')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #93')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #94
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #94')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #94')

  " #95
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #95')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #95')

  " #96
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #96')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #96')

  " #97
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #97')

  %delete

  " #98
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #98')

  %delete

  " #99
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #99')

  %delete

  " #100
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #100')

  %delete

  " #101
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #101')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #102
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #102')

  " #103
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #103')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #103')

  %delete

  " #104
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #104')

  %delete

  " #105
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #105')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #106
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #106')
  call g:assert.equals(getline(2),   'bar',        'failed at #106')
  call g:assert.equals(getline(3),   'baz',        'failed at #106')
  call g:assert.equals(getline(4),   '',           'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #106')

  %delete

  " #107
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #107')
  call g:assert.equals(getline(2),   'bar',        'failed at #107')
  call g:assert.equals(getline(3),   'baz',        'failed at #107')
  call g:assert.equals(getline(4),   '',           'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #107')

  %delete

  " #108
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #108')
  call g:assert.equals(getline(2),   'bar',        'failed at #108')
  call g:assert.equals(getline(3),   'baz',        'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #108')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #109
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #109')

  %delete

  " #110
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #110')

  %delete

  " #111
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #111')

  %delete

  " #112
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #112')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #113
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #113')

  %delete

  " #114
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #114')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #115
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #115')

  %delete

  " #116
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #116')

  %delete

  " #117
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #117')

  %delete

  " #118
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #118')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #119
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #119')

  " #120
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #120')

  " #121
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #121')

  " #122
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #122')

  %delete

  " #123
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #123')
  call g:assert.equals(getline(2),   'bar',        'failed at #123')
  call g:assert.equals(getline(3),   'baz',        'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #123')
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

  " #124
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #124')

  " #125
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #125')

  " #126
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #126')

  " #127
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #127')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #128
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #128')

  " #129
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #129')

  """ keep
  " #130
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #130')

  " #131
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #131')

  """ inner_tail
  " #132
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #132')

  " #133
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #133')

  """ front
  " #134
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #134')

  " #135
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #135')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #135')

  """ end
  " #136
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #136')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #136')

  " #137
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #137')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #137')

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
  " #138
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #138')

  " #139
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #139')

  """ off
  " #140
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #140')

  " #141
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #141')

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
  " #142
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #142')

  " #143
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #143')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #144
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #144')

  " #145
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #145')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ on
  " #146
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #146')

  " #147
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #147')

  " #148
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #148')

  " #149
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #149')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #150
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #150')

  " #151
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #151')

  " #152
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #152')

  " #153
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #153')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #154
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #154')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #155
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #155')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #156
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #156')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #157
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #157')
  call g:assert.equals(getline(2),   'foo',        'failed at #157')
  call g:assert.equals(getline(3),   '',           'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #157')

  %delete

  " #158
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #158')
  call g:assert.equals(getline(2),   'foo',        'failed at #158')
  call g:assert.equals(getline(3),   '  ',         'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #158')

  %delete

  " #159
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #159')
  call g:assert.equals(getline(2),   'foo',        'failed at #159')
  call g:assert.equals(getline(3),   'aa',         'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #159')

  %delete

  " #160
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #160')
  call g:assert.equals(getline(2),   'foo',        'failed at #160')
  call g:assert.equals(getline(3),   '',           'failed at #160')
  call g:assert.equals(getline(4),   '',           'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #160')

  %delete

  " #161
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #161')
  call g:assert.equals(getline(2),   'foo',        'failed at #161')
  call g:assert.equals(getline(3),   'aa',         'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #161')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #162
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #162')

  %delete

  " #163
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #163')

  %delete

  " #164
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #164')

  %delete

  " #165
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #165')
  call g:assert.equals(getline(2),   'bb',         'failed at #165')
  call g:assert.equals(getline(3),   '',           'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #165')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #165')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #166
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #166')

  " #167
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #167')

  " #168
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #168')

  " #169
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #169')

  %delete

  " #170
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #170')

  %delete

  " #171
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #171')

  %delete

  " #172
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #172')

  %delete

  " #173
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #173')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #174
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #174')

  " #175
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #175')

  %delete

  " #176
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #176')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #176')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #176')

  %delete

  " #177
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #177')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #177')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #178
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #178')
  call g:assert.equals(getline(2),   'bar',        'failed at #178')
  call g:assert.equals(getline(3),   'baz',        'failed at #178')
  call g:assert.equals(getline(4),   '',           'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #178')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #178')

  %delete

  " #179
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #179')
  call g:assert.equals(getline(2),   'bar',        'failed at #179')
  call g:assert.equals(getline(3),   'baz',        'failed at #179')
  call g:assert.equals(getline(4),   '',           'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #179')

  %delete

  " #180
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #180')
  call g:assert.equals(getline(2),   'bar',        'failed at #180')
  call g:assert.equals(getline(3),   'baz',        'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #180')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #181
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #181')

  %delete

  " #182
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #182')

  %delete

  " #183
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #183')

  %delete

  " #184
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #184')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #113
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #113')

  %delete

  " #114
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #114')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #185
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #185')

  %delete

  " #186
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #186')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #186')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #186')

  %delete

  " #187
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #187')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #187')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #187')

  %delete

  " #188
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #188')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #189
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #189')

  " #190
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #190')

  " #191
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #191')

  " #192
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #192')

  %delete

  " #193
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #193')
  call g:assert.equals(getline(2),   'bar',        'failed at #193')
  call g:assert.equals(getline(3),   'baz',        'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #193')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #193')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #193')
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

  " #194
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #194')

  " #195
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #195')

  " #196
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #196')

  " #197
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #197')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #198
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #198')

  " #199
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #199')

  """ keep
  " #200
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #200')

  " #201
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #201')

  """ inner_tail
  " #202
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #202')

  " #203
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #203')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #203')

  """ front
  " #204
  call operator#sandwich#set('delete', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #204')

  " #205
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #205')

  """ end
  " #206
  call operator#sandwich#set('delete', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #206')

  " #207
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #207')

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
  " #208
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #208')

  " #209
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #209')

  """ off
  " #210
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #210')

  " #211
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #211')

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
  " #212
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #212')

  " #213
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #213')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  " #214
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #214')

  " #215
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #215')

  call operator#sandwich#set('delete', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ on
  " #216
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #216')

  " #217
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #217')

  " #218
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #218')

  " #219
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #219')

  """ off
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)
  " #220
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #220')

  " #221
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #221')

  " #222
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #222')

  " #223
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #223')

  call operator#sandwich#set('delete', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #224
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #224')

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)
  " #225
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #225')

  call operator#sandwich#set('delete', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[dv`]'])

  " #226
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #226')

  call operator#sandwich#set('delete', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #227
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #227')
  call g:assert.equals(getline(2),   'foo',        'failed at #227')
  call g:assert.equals(getline(3),   '',           'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #227')

  %delete

  " #228
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #228')
  call g:assert.equals(getline(2),   'foo',        'failed at #228')
  call g:assert.equals(getline(3),   '  ',         'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #228')

  %delete

  " #229
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #229')
  call g:assert.equals(getline(2),   'foo',        'failed at #229')
  call g:assert.equals(getline(3),   'aa',         'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #229')

  %delete

  " #230
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #230')
  call g:assert.equals(getline(2),   'foo',        'failed at #230')
  call g:assert.equals(getline(3),   '',           'failed at #230')
  call g:assert.equals(getline(4),   '',           'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #230')

  %delete

  " #231
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #231')
  call g:assert.equals(getline(2),   'foo',        'failed at #231')
  call g:assert.equals(getline(3),   'aa',         'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #231')

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #232
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #232')

  %delete

  " #233
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #233')

  %delete

  " #234
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #234')

  %delete

  " #235
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #235')
  call g:assert.equals(getline(2),   'bb',         'failed at #235')
  call g:assert.equals(getline(3),   '',           'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #235')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #236
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #236')
  call g:assert.equals(getline(2),   'bar',        'failed at #236')
  call g:assert.equals(getline(3),   'baz',        'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #236')

  %delete

  " #237
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #237')
  call g:assert.equals(getline(2),   'bar',        'failed at #237')
  call g:assert.equals(getline(3),   'baz',        'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #237')

  %delete

  " #238
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #238')
  call g:assert.equals(getline(2),   'bar',        'failed at #238')
  call g:assert.equals(getline(3),   'baz',        'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #238')

  %delete

  " #239
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #239')
  call g:assert.equals(getline(2),   'bar',        'failed at #239')
  call g:assert.equals(getline(3),   'baz',        'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #239')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #240
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #240')
  call g:assert.equals(getline(2),   'bar',        'failed at #240')
  call g:assert.equals(getline(3),   'baz',        'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #240')

  " #241
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #241')
  call g:assert.equals(getline(2),   'bar',        'failed at #241')
  call g:assert.equals(getline(3),   'baz',        'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #241')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #242
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #242')
  call g:assert.equals(getline(2),   'foobar',     'failed at #242')
  call g:assert.equals(getline(3),   'foobar',     'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #242')

  %delete

  " #243
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #243')
  call g:assert.equals(getline(2),   'foobar',     'failed at #243')
  call g:assert.equals(getline(3),   'foobar',     'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #244')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #244')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #244')

  %delete

  " #245
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #245')
  call g:assert.equals(getline(2),   'bar',        'failed at #245')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #246')
  call g:assert.equals(getline(2),   'barbar',     'failed at #246')
  call g:assert.equals(getline(3),   'baz',        'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #247')
  call g:assert.equals(getline(2),   'bar',        'failed at #247')
  call g:assert.equals(getline(3),   'baz',        'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #247')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #248
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #248')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #249
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #249')
  call g:assert.equals(getline(2),   '',           'failed at #249')
  call g:assert.equals(getline(3),   '',           'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #249')

  %delete

  " #250
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #250')
  call g:assert.equals(getline(2),   'foobar',     'failed at #250')
  call g:assert.equals(getline(3),   'foobar',     'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #250')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #251
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #251')

  " #252
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #252')

  " #253
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #253')

  " #254
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #254')

  " #255
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #255')

  %delete

  " #256
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #256')
  call g:assert.equals(getline(2),   'bar',        'failed at #256')
  call g:assert.equals(getline(3),   'baz',        'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #256')

  %delete

  " #257
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #257')
  call g:assert.equals(getline(2),   'bar',        'failed at #257')
  call g:assert.equals(getline(3),   'baz',        'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #257')

  %delete

  " #258
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #258')
  call g:assert.equals(getline(2),   'abarb',      'failed at #258')
  call g:assert.equals(getline(3),   'baz',        'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #258')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #258')

  %delete

  " #259
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #259')
  call g:assert.equals(getline(2),   'bar',        'failed at #259')
  call g:assert.equals(getline(3),   'abazb',      'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #259')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #259')

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

  " #260
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #260')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #260')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #260')

  %delete

  " #261
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #261')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #261')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #261')

  %delete

  " #262
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #262')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #262')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #262')

  %delete

  " #263
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #263')
  call g:assert.equals(getline(2), 'bar', 'failed at #263')
  call g:assert.equals(getline(3), 'baz', 'failed at #263')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #264
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #264')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #264')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #264')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #264')

  " #265
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #265')
  call g:assert.equals(getline(2),   'bar',        'failed at #265')
  call g:assert.equals(getline(3),   'baz',        'failed at #265')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #265')

  %delete

  """ keep
  " #266
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #266')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #266')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #266')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #266')

  " #267
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #267')
  call g:assert.equals(getline(2),   'bar',        'failed at #267')
  call g:assert.equals(getline(3),   'baz',        'failed at #267')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #267')

  %delete

  """ inner_tail
  " #268
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #268')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #268')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #268')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #268')

  " #269
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #269')
  call g:assert.equals(getline(2),   'bar',        'failed at #269')
  call g:assert.equals(getline(3),   'baz',        'failed at #269')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #269')

  %delete

  """ front
  " #270
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #270')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #270')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #270')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #270')

  " #271
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #271')
  call g:assert.equals(getline(2),   'bar',        'failed at #271')
  call g:assert.equals(getline(3),   'baz',        'failed at #271')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #271')

  %delete

  """ end
  " #272
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #272')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #272')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #272')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #272')

  " #273
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #273')
  call g:assert.equals(getline(2),   'bar',        'failed at #273')
  call g:assert.equals(getline(3),   'baz',        'failed at #273')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #273')

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
  " #274
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #274')
  call g:assert.equals(getline(2), '(bar)', 'failed at #274')
  call g:assert.equals(getline(3), '(baz)', 'failed at #274')

  %delete

  " #275
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #275')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #275')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #275')

  %delete

  """ off
  " #276
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #276')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #276')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #276')

  %delete

  " #277
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #277')
  call g:assert.equals(getline(2), '{bar}', 'failed at #277')
  call g:assert.equals(getline(3), '{baz}', 'failed at #277')

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
  " #278
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #278')
  call g:assert.equals(getline(2), 'bar', 'failed at #278')
  call g:assert.equals(getline(3), 'baz', 'failed at #278')

  %delete

  " #279
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #279')
  call g:assert.equals(getline(2), '88bar88', 'failed at #279')
  call g:assert.equals(getline(3), '88baz88', 'failed at #279')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #280
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #280')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #280')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #280')

  %delete

  " #281
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #281')
  call g:assert.equals(getline(2), 'bar', 'failed at #281')
  call g:assert.equals(getline(3), 'baz', 'failed at #281')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #282
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #282')
  call g:assert.equals(getline(2), 'bar', 'failed at #282')
  call g:assert.equals(getline(3), 'baz', 'failed at #282')

  %delete

  " #283
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #283')
  call g:assert.equals(getline(2), ' bar', 'failed at #283')
  call g:assert.equals(getline(3), ' baz', 'failed at #283')

  %delete

  " #284
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #284')
  call g:assert.equals(getline(2), 'bar ', 'failed at #284')
  call g:assert.equals(getline(3), 'baz ', 'failed at #284')

  %delete

  " #285
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #285')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #286
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #286')
  call g:assert.equals(getline(2), 'bar', 'failed at #286')
  call g:assert.equals(getline(3), 'baz', 'failed at #286')

  %delete

  " #287
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #287')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #287')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #287')

  %delete

  " #288
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #288')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #288')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #288')

  %delete

  " #289
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #289')
  call g:assert.equals(getline(2), '"bar"', 'failed at #289')
  call g:assert.equals(getline(3), '"baz"', 'failed at #289')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #290
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #290')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #290')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #290')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #291
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #291')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #291')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #291')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #292
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #292')
  call g:assert.equals(getline(2), '', 'failed at #292')
  call g:assert.equals(getline(3), '', 'failed at #292')

  set whichwrap&
  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #293
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #293')
  call g:assert.equals(getline(2),   'bar',        'failed at #293')
  call g:assert.equals(getline(3),   'baz',        'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #293')

  %delete

  " #294
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #294')
  call g:assert.equals(getline(2),   'bar',        'failed at #294')
  call g:assert.equals(getline(3),   'baz',        'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #294')

  %delete

  " #295
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #295')
  call g:assert.equals(getline(2),   'bar',        'failed at #295')
  call g:assert.equals(getline(3),   'baz',        'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #295')

  %delete

  " #296
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #296')
  call g:assert.equals(getline(2),   'bar',        'failed at #296')
  call g:assert.equals(getline(3),   'baz',        'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #296')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #297
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #297')
  call g:assert.equals(getline(2),   'bar',        'failed at #297')
  call g:assert.equals(getline(3),   'baz',        'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #297')

  " #298
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #298')
  call g:assert.equals(getline(2),   'bar',        'failed at #298')
  call g:assert.equals(getline(3),   'baz',        'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #298')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #299
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #299')
  call g:assert.equals(getline(2),   'foobar',     'failed at #299')
  call g:assert.equals(getline(3),   'foobar',     'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #299')

  %delete

  " #300
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #300')
  call g:assert.equals(getline(2),   'foobar',     'failed at #300')
  call g:assert.equals(getline(3),   'foobar',     'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #300')

  %delete

  " #301
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #301')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #301')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #301')

  %delete

  " #302
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #302')
  call g:assert.equals(getline(2),   'bar',        'failed at #302')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #303')
  call g:assert.equals(getline(2),   'barbar',     'failed at #303')
  call g:assert.equals(getline(3),   'baz',        'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #303')

  %delete

  " #304
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #304')
  call g:assert.equals(getline(2),   'bar',        'failed at #304')
  call g:assert.equals(getline(3),   'baz',        'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #304')

  %delete

  """ terminal-extended block-wise visual mode
  " #305
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #305')
  call g:assert.equals(getline(2),   'baaar',      'failed at #305')
  call g:assert.equals(getline(3),   'baz',        'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #306')
  call g:assert.equals(getline(2),   'bar',        'failed at #306')
  call g:assert.equals(getline(3),   'baaz',       'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #307')
  call g:assert.equals(getline(2),   '',           'failed at #307')
  call g:assert.equals(getline(3),   'baz',        'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #307')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #308
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #308')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #309
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #309')
  call g:assert.equals(getline(2),   '',           'failed at #309')
  call g:assert.equals(getline(3),   '',           'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #309')

  %delete

  " #310
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #310')
  call g:assert.equals(getline(2),   'foobar',     'failed at #310')
  call g:assert.equals(getline(3),   'foobar',     'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #310')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #311
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #311')

  " #312
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #312')

  " #313
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #314')
  call g:assert.equals(getline(2),   'bar',        'failed at #314')
  call g:assert.equals(getline(3),   'baz',        'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #314')

  %delete

  " #315
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #315')
  call g:assert.equals(getline(2),   'bar',        'failed at #315')
  call g:assert.equals(getline(3),   'baz',        'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #315')

  %delete

  " #316
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #316')
  call g:assert.equals(getline(2),   'abarb',      'failed at #316')
  call g:assert.equals(getline(3),   'baz',        'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #316')

  %delete

  " #317
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #317')
  call g:assert.equals(getline(2),   'bar',        'failed at #317')
  call g:assert.equals(getline(3),   'abazb',      'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #317')
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

  " #318
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #318')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #318')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #318')

  %delete

  " #319
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #319')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #319')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #319')

  %delete

  " #320
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #320')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #320')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #320')

  %delete

  " #321
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #321')
  call g:assert.equals(getline(2), 'bar', 'failed at #321')
  call g:assert.equals(getline(3), 'baz', 'failed at #321')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #322
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #322')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #322')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #322')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #322')

  " #323
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #323')
  call g:assert.equals(getline(2),   'bar',        'failed at #323')
  call g:assert.equals(getline(3),   'baz',        'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #323')

  %delete

  """ keep
  " #324
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #324')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #324')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #324')

  " #325
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #325')
  call g:assert.equals(getline(2),   'bar',        'failed at #325')
  call g:assert.equals(getline(3),   'baz',        'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #325')

  %delete

  """ inner_tail
  " #326
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #326')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #326')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #326')

  " #327
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #327')
  call g:assert.equals(getline(2),   'bar',        'failed at #327')
  call g:assert.equals(getline(3),   'baz',        'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #327')

  %delete

  """ front
  " #328
  call operator#sandwich#set('delete', 'block', 'cursor', 'front')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #328')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #328')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #328')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #328')

  " #329
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #329')
  call g:assert.equals(getline(2),   'bar',        'failed at #329')
  call g:assert.equals(getline(3),   'baz',        'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #329')

  %delete

  """ end
  " #330
  call operator#sandwich#set('delete', 'block', 'cursor', 'end')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #330')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #330')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #330')

  " #331
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #331')
  call g:assert.equals(getline(2),   'bar',        'failed at #331')
  call g:assert.equals(getline(3),   'baz',        'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #331')

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
  " #332
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #332')
  call g:assert.equals(getline(2), '(bar)', 'failed at #332')
  call g:assert.equals(getline(3), '(baz)', 'failed at #332')

  %delete

  " #333
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4llsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #333')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #333')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #333')

  %delete

  """ off
  " #334
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #334')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #334')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #334')

  %delete

  " #335
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #335')
  call g:assert.equals(getline(2), '{bar}', 'failed at #335')
  call g:assert.equals(getline(3), '{baz}', 'failed at #335')

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
  " #336
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #336')
  call g:assert.equals(getline(2), 'bar', 'failed at #336')
  call g:assert.equals(getline(3), 'baz', 'failed at #336')

  %delete

  " #337
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #337')
  call g:assert.equals(getline(2), '88bar88', 'failed at #337')
  call g:assert.equals(getline(3), '88baz88', 'failed at #337')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  " #338
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #338')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #338')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #338')

  %delete

  " #339
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #339')
  call g:assert.equals(getline(2), 'bar', 'failed at #339')
  call g:assert.equals(getline(3), 'baz', 'failed at #339')

  call operator#sandwich#set('delete', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #340
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #340')
  call g:assert.equals(getline(2), 'bar', 'failed at #340')
  call g:assert.equals(getline(3), 'baz', 'failed at #340')

  %delete

  " #341
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #341')
  call g:assert.equals(getline(2), ' bar', 'failed at #341')
  call g:assert.equals(getline(3), ' baz', 'failed at #341')

  %delete

  " #342
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #342')
  call g:assert.equals(getline(2), 'bar ', 'failed at #342')
  call g:assert.equals(getline(3), 'baz ', 'failed at #342')

  %delete

  " #343
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #343')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)
  " #344
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #344')
  call g:assert.equals(getline(2), 'bar', 'failed at #344')
  call g:assert.equals(getline(3), 'baz', 'failed at #344')

  %delete

  " #345
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #345')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #345')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #345')

  %delete

  " #346
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #346')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #346')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #346')

  %delete

  " #347
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #347')
  call g:assert.equals(getline(2), '"bar"', 'failed at #347')
  call g:assert.equals(getline(3), '"baz"', 'failed at #347')

  call operator#sandwich#set('delete', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #348
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #348')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #348')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #348')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #349
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #349')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #349')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #349')

  call operator#sandwich#set('delete', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[dv`]'])

  " #350
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #350')
  call g:assert.equals(getline(2), '', 'failed at #350')
  call g:assert.equals(getline(3), '', 'failed at #350')

  call operator#sandwich#set('delete', 'block', 'command', [])
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
