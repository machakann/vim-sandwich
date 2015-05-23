let s:suite = themis#suite('operator-sandwich: replace:')

function! s:suite.before() abort  "{{{
  nmap sr <Plug>(operator-sandwich-replace)
  xmap sr <Plug>(operator-sandwich-replace)
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
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sra[{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sra{<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
call setline('.', '<foo>')
  normal 0sra<(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0sra(]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0sra[}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #6')

  " #7
  call setline('.', '{foo}')
  normal 0sra{>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #7')

  " #8
  call setline('.', '<foo>')
  normal 0sra<)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #9
  call setline('.', 'afooa')
  normal 0sriwb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #9')

  " #10
  call setline('.', '+foo+')
  normal 0sr$*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #10')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #11
  call setline('.', '(foo)bar')
  normal 0sra([
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #11')

  " #12
  call setline('.', 'foo(bar)')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #12')

  " #13
  call setline('.', 'foo(bar)baz')
  normal 0fbsra([
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #13')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))'], 'input': ['(']}, {'buns': ['[', ']']}]

  " #14
  call setline('.', 'foo((bar))baz')
  normal 0srii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #14')

  " #15
  call setline('.', 'foo((bar))baz')
  normal 02lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #15')

  " #16
  call setline('.', 'foo((bar))baz')
  normal 03lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #16')

  " #17
  call setline('.', 'foo((bar))baz')
  normal 04lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #17')

  " #18
  call setline('.', 'foo((bar))baz')
  normal 05lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #18')

  " #19
  call setline('.', 'foo((bar))baz')
  normal 07lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #19')

  " #20
  call setline('.', 'foo((bar))baz')
  normal 08lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #20')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #20')

  " #21
  call setline('.', 'foo((bar))baz')
  normal 09lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #21')

  " #22
  call setline('.', 'foo((bar))baz')
  normal 010lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #22')

  " #23
  call setline('.', 'foo((bar))baz')
  normal 012lsrii[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #23')

  " #24
  call setline('.', 'foo[[bar]]baz')
  normal 03lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0],     'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #24')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #24')

  " #25
  call setline('.', 'foo[[bar]]baz')
  normal 09lsrii(
  call g:assert.equals(getline('.'), 'foo(([bar]))baz', 'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #25')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #26
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsr13l[
  call g:assert.equals(getline(1),   '[foo',       'failed at #26')
  call g:assert.equals(getline(2),   'bar',        'failed at #26')
  call g:assert.equals(getline(3),   'baz]',       'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #26')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #27
  call setline('.', '(a)')
  normal 0sra([
  call g:assert.equals(getline('.'), '[a]',        'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #27')

  %delete

  " #28
  call append(0, ['(', 'a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #28')
  call g:assert.equals(getline(2),   'a',          'failed at #28')
  call g:assert.equals(getline(3),   ']',          'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #28')

  %delete

  " #29
  call append(0, ['(a', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[a',         'failed at #29')
  call g:assert.equals(getline(2),   ']',          'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #29')

  %delete

  " #30
  call append(0, ['(', 'a)'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #30')
  call g:assert.equals(getline(2),   'a]',         'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #30')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #30')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #31
  call setline('.', '()')
  normal 0sra([
  call g:assert.equals(getline('.'), '[]',         'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #31')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #31')

  " #32
  call setline('.', 'foo()bar')
  normal 03lsra([
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #32')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #32')

  %delete

  " #33
  call append(0, ['(', ')'])
  normal ggsra([
  call g:assert.equals(getline(1),   '[',          'failed at #33')
  call g:assert.equals(getline(2),   ']',          'failed at #33')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #33')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #33')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #33')
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #34
  call setline('.', '([foo])')
  normal 02sr%[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #34')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #34')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #34')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #34')

  " #35
  call setline('.', '[({foo})]')
  normal 03sr%{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #35')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #35')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #35')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #35')

  " #36
  call setline('.', '[foo ]bar')
  normal 0sr6l(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #36')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #36')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #36')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #36')

  " #37
  call setline('.', '[foo bar]')
  normal 0sr9l(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #37')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #37')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #37')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #37')

  " #38
  call setline('.', '{[foo bar]}')
  normal 02sr11l[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #38')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #38')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #38')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #38')

  " #39
  call setline('.', 'foo{[bar]}baz')
  normal 03l2sr7l[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #39')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #39')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #39')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #39')

  " #40
  call setline('.', 'foo({[bar]})baz')
  normal 03l3sr9l{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #40')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #40')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #40')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #40')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #41
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #41')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #41')

  %delete

  " #42
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21l(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #42')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #42')

  %delete

  " #43
  call setline('.', '(foo)')
  normal 0sr5la
  call g:assert.equals(getline(1),   'aa',         'failed at #43')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #43')
  call g:assert.equals(getline(3),   'aa',         'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #43')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #43')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #43')

  %delete

  " #44
  call setline('.', '(foo)')
  normal 0sr5lb
  call g:assert.equals(getline(1),   'bb',         'failed at #44')
  call g:assert.equals(getline(2),   'bbb',        'failed at #44')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #44')
  call g:assert.equals(getline(4),   'bbb',        'failed at #44')
  call g:assert.equals(getline(5),   'bb',         'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #44')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #44')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #44')

  %delete

  " #45
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr15lb
  call g:assert.equals(getline(1),   'bb',         'failed at #45')
  call g:assert.equals(getline(2),   'bbb',        'failed at #45')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #45')
  call g:assert.equals(getline(4),   'bbb',        'failed at #45')
  call g:assert.equals(getline(5),   'bb',         'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #45')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #45')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #45')

  %delete

  " #46
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr21la
  call g:assert.equals(getline(1),   'aa',         'failed at #46')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #46')
  call g:assert.equals(getline(3),   'aa',         'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #46')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #46')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #46')

  %delete

  " #47
  call append(0, ['aa', 'aaaaa', 'aaafooaaa', 'aaaaa', 'aa'])
  normal gg2sr27lbb
  call g:assert.equals(getline(1),   'bb',         'failed at #47')
  call g:assert.equals(getline(2),   'bbb',        'failed at #47')
  call g:assert.equals(getline(3),   'bbbb',       'failed at #47')
  call g:assert.equals(getline(4),   'bbb',        'failed at #47')
  call g:assert.equals(getline(5),   'bbfoobb',    'failed at #47')
  call g:assert.equals(getline(6),   'bbb',        'failed at #47')
  call g:assert.equals(getline(7),   'bbbb',       'failed at #47')
  call g:assert.equals(getline(8),   'bbb',        'failed at #47')
  call g:assert.equals(getline(9),   'bb',         'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #47')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #47')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #47')

  %delete

  " #48
  call append(0, ['bb', 'bbb', 'bbbb', 'bbb', 'bbfoobb', 'bbb', 'bbbb', 'bbb', 'bb'])
  normal gg2sr39laa
  call g:assert.equals(getline(1),   'aa',         'failed at #48')
  call g:assert.equals(getline(2),   'aaaaa',      'failed at #48')
  call g:assert.equals(getline(3),   'aaafooaaa',  'failed at #48')
  call g:assert.equals(getline(4),   'aaaaa',      'failed at #48')
  call g:assert.equals(getline(5),   'aa',         'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #48')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #48')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #48')

  %delete
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 8)<CR>

  " #49
  call setline('.', ['foo(bar)baz'])
  normal 0sriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #49')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #49')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #49')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #49')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #49')

  %delete

  " #50
  call setline('.', ['foo(bar)baz'])
  normal 02lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #50')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #50')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #50')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #50')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #50')

  %delete

  " #51
  call setline('.', ['foo(bar)baz'])
  normal 03lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #51')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #51')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #51')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #51')

  %delete

  " #52
  call setline('.', ['foo(bar)baz'])
  normal 04lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #52')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #52')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #52')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #52')

  %delete

  " #53
  call setline('.', ['foo(bar)baz'])
  normal 06lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #53')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #53')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #53')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #53')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #53')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #53')

  %delete

  " #54
  call setline('.', ['foo(bar)baz'])
  normal 07lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #54')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #54')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #54')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #54')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #54')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #54')

  %delete

  " #55
  call setline('.', ['foo(bar)baz'])
  normal 08lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #55')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #55')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #55')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #55')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #55')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #55')

  %delete

  " #56
  call setline('.', ['foo(bar)baz'])
  normal 010lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #56')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #56')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #56')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #56')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #56')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #56')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>

  " #57
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #57')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #57')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #57')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #57')

  %delete

  " #58
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #58')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #58')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #58')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #58')

  %delete

  " #59
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #59')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #59')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #59')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #59')

  %delete

  " #60
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #60')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #60')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #60')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #60')

  %delete

  " #61
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #61')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #61')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #61')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #61')

  %delete

  " #62
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0],  'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #62')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #62')

  %delete

  " #63
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #63')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #63')

  %delete

  " #64
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #64')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #64')

  %delete

  " #65
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #65')

  %delete

  " #66
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #66')

  %delete

  " #67
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #67')

  %delete

  " #68
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0],  'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #68')

  %delete

  " #69
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #69')

  %delete

  " #70
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsrii(
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #70')

  %delete

  " #71
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #71')
  call g:assert.equals(getline(2),   'bbb',        'failed at #71')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #71')
  call g:assert.equals(getline(4),   'bbb',        'failed at #71')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #71')

  %delete

  " #72
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #72')
  call g:assert.equals(getline(2),   'bbb',        'failed at #72')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #72')
  call g:assert.equals(getline(4),   'bbb',        'failed at #72')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #72')

  %delete

  " #73
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #73')
  call g:assert.equals(getline(2),   'bbb',        'failed at #73')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #73')
  call g:assert.equals(getline(4),   'bbb',        'failed at #73')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #73')

  %delete

  " #74
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #74')
  call g:assert.equals(getline(2),   'bbb',        'failed at #74')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #74')
  call g:assert.equals(getline(4),   'bbb',        'failed at #74')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #74')

  %delete

  " #75
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #75')
  call g:assert.equals(getline(2),   'bbb',        'failed at #75')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #75')
  call g:assert.equals(getline(4),   'bbb',        'failed at #75')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #75')

  %delete

  " #76
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #76')
  call g:assert.equals(getline(2),   'bbb',        'failed at #76')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #76')
  call g:assert.equals(getline(4),   'bbb',        'failed at #76')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #76')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #76')

  %delete

  " #77
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #77')
  call g:assert.equals(getline(2),   'bbb',        'failed at #77')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #77')
  call g:assert.equals(getline(4),   'bbb',        'failed at #77')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #77')

  %delete

  " #78
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #78')
  call g:assert.equals(getline(2),   'bbb',        'failed at #78')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #78')
  call g:assert.equals(getline(4),   'bbb',        'failed at #78')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #78')

  %delete

  " #79
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #79')
  call g:assert.equals(getline(2),   'bbb',        'failed at #79')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #79')
  call g:assert.equals(getline(4),   'bbb',        'failed at #79')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #79')

  %delete

  " #80
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #80')
  call g:assert.equals(getline(2),   'bbb',        'failed at #80')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #80')
  call g:assert.equals(getline(4),   'bbb',        'failed at #80')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 3, 6, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #80')

  %delete

  " #81
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj7lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #81')
  call g:assert.equals(getline(2),   'bbb',        'failed at #81')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #81')
  call g:assert.equals(getline(4),   'bbb',        'failed at #81')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #81')

  %delete

  " #82
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #82')
  call g:assert.equals(getline(2),   'bbb',        'failed at #82')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #82')
  call g:assert.equals(getline(4),   'bbb',        'failed at #82')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #82')

  %delete

  " #83
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #83')
  call g:assert.equals(getline(2),   'bbb',        'failed at #83')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #83')
  call g:assert.equals(getline(4),   'bbb',        'failed at #83')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #83')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #83')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #83')

  %delete

  " #84
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #84')
  call g:assert.equals(getline(2),   'bbb',        'failed at #84')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #84')
  call g:assert.equals(getline(4),   'bbb',        'failed at #84')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #84')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #84')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #84')

  %delete

  " #85
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #85')
  call g:assert.equals(getline(2),   'bbb',        'failed at #85')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #85')
  call g:assert.equals(getline(4),   'bbb',        'failed at #85')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 5, 3, 0], 'failed at #85')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #85')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #85')

  %delete

  " #86
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsriib
  call g:assert.equals(getline(1),   'foobb',      'failed at #86')
  call g:assert.equals(getline(2),   'bbb',        'failed at #86')
  call g:assert.equals(getline(3),   'bbbarbb',    'failed at #86')
  call g:assert.equals(getline(4),   'bbb',        'failed at #86')
  call g:assert.equals(getline(5),   'bbbaz',      'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 5, 5, 0], 'failed at #86')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #86')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #86')

  %delete
  onoremap ii :<C-u>call TextobjCoord(1, 4, 5, 2)<CR>

  " #87
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #87')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #87')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #87')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #87')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #87')

  %delete

  " #88
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #88')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #88')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #88')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #88')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #88')

  %delete

  " #89
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #89')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #89')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #89')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #89')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #89')

  %delete

  " #90
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #90')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #90')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #90')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #90')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #90')

  %delete

  " #91
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #91')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #91')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #91')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #91')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #91')

  %delete

  " #92
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggjlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #92')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #92')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #92')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #92')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #92')

  %delete

  " #93
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal ggj2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #93')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #93')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #93')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #93')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #93')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #93')

  %delete

  " #94
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #94')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #94')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #94')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #94')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #94')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #94')

  %delete

  " #95
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #95')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #95')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #95')
  call g:assert.equals(getpos('.'),  [0, 2, 3, 0], 'failed at #95')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #95')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #95')

  %delete

  " #96
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #96')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #96')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #96')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #96')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #96')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #96')

  %delete

  " #97
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #97')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #97')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #97')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #97')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #97')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #97')

  %delete

  " #98
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j5lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #98')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #98')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #98')
  call g:assert.equals(getpos('.'),  [0, 2, 7, 0], 'failed at #98')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #98')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #98')

  %delete

  " #99
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg2j6lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #99')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #99')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #99')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0], 'failed at #99')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #99')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #99')

  %delete

  " #100
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #100')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #100')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #100')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #100')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #100')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #100')

  %delete

  " #101
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #101')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #101')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #101')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #101')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #101')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #101')

  %delete

  " #102
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg3j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #102')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #102')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #102')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #102')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #102')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #102')

  %delete

  " #103
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #103')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #103')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #103')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #103')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #103')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #103')

  %delete

  " #104
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4jlsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #104')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #104')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #104')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #104')

  %delete

  " #105
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j2lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #105')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #105')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #105')

  %delete

  " #106
  call append(0, ['foobb', 'bbb', 'bbbarbb', 'bbb', 'bbbaz'])
  normal gg4j4lsriia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #106')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #106')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #106')

  ounmap ii
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
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

  " #107
  call setline('.', '{[(foo)]}')
  normal 02lsr5l"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #107')

  " #108
  call setline('.', '{[(foo)]}')
  normal 0lsr7l"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #108')

  " #109
  call setline('.', '{[(foo)]}')
  normal 0sr9l"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #109')

  " #110
  call setline('.', '<title>foo</title>')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #110')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #111
  call setline('.', '(((foo)))')
  normal 0l2sr%[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #111')

  " #112
  normal 0sra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #112')

  """ keep
  " #113
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #113')

  " #114
  normal lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #114')

  """ inner_tail
  " #115
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #115')

  " #116
  normal hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #116')

  """ front
  " #117
  call operator#sandwich#set('replace', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #117')

  " #118
  normal 3lsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #118')

  """ end
  " #119
  call operator#sandwich#set('replace', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 04l2sr2a([[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #119')

  " #120
  normal 3hsra([
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #120')

  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #121
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #121')

  " #122
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #122')

  """ off
  " #123
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0sr7l"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #123')

  " #124
  call setline('.', '{(foo)}')
  normal 0lsr5l"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #124')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #125
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #125')

  " #126
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #126')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #127
  call setline('.', '\d\+foo\d\+')
  normal 0sr$"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #127')

  " #128
  call setline('.', '888foo888')
  normal 0sr$"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #128')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """ on
  " #129
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #129')

  " #130
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #130')

  " #131
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #131')

  " #132
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #132')

  """ off
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #133
  call setline('.', '"foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #133')

  " #134
  call setline('.', ' "foo"')
  normal 0sr$(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #134')

  " #135
  call setline('.', '"foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #135')

  " #136
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sr$(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #136')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #137
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #137')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #138
  call setline('.', 'aa(foo)bb')
  normal 0sr$"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #138')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #139
  call setline('.', '(foo)')
  normal 0sra("
  call g:assert.equals(getline('.'), '""', 'failed at #139')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #140
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #140')
  call g:assert.equals(getline(2),   'foo',        'failed at #140')
  call g:assert.equals(getline(3),   ']',          'failed at #140')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #140')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #140')

  %delete

  " #141
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #141')
  call g:assert.equals(getline(2),   'foo',        'failed at #141')
  call g:assert.equals(getline(3),   ']',          'failed at #141')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #141')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #141')

  %delete

  " #142
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #142')
  call g:assert.equals(getline(2),   'foo',        'failed at #142')
  call g:assert.equals(getline(3),   'aa]',        'failed at #142')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #142')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #142')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #142')

  %delete

  " #143
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[aa',        'failed at #143')
  call g:assert.equals(getline(2),   'foo',        'failed at #143')
  call g:assert.equals(getline(3),   ']',          'failed at #143')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #143')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #143')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #143')

  %delete

  " #144
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr9l[
  call g:assert.equals(getline(1),   '[',          'failed at #144')
  call g:assert.equals(getline(2),   'foo',        'failed at #144')
  call g:assert.equals(getline(3),   'aa]',        'failed at #144')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #144')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #144')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #145
  call append(0, ['(', 'foo', ')'])
  normal ggsr7l[
  call g:assert.equals(getline(1),   '[',          'failed at #145')
  call g:assert.equals(getline(2),   'foo',        'failed at #145')
  call g:assert.equals(getline(3),   ']',          'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #145')

  %delete

  " #146
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #146')
  call g:assert.equals(getline(2),   'foo',        'failed at #146')
  call g:assert.equals(getline(3),   ']',          'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #146')

  %delete

  " #147
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr11l[
  call g:assert.equals(getline(1),   '[',          'failed at #147')
  call g:assert.equals(getline(2),   'foo',        'failed at #147')
  call g:assert.equals(getline(3),   ']',          'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #147')

  %delete

  " #148
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsr5l[
  call g:assert.equals(getline(1),   'aa',         'failed at #148')
  call g:assert.equals(getline(2),   '[',          'failed at #148')
  call g:assert.equals(getline(3),   'bb',         'failed at #148')
  call g:assert.equals(getline(4),   '',           'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #148')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #149
  call setline('.', '"""foo"""')
  normal 03sr$([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #149')

  %delete

  """ on
  " #150
  call operator#sandwich#set('replace', 'char', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03sr$(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #150')

  call operator#sandwich#set('replace', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #151
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #151')

  """ 1
  " #152
  call operator#sandwich#set('replace', 'char', 'eval', 1)
  call setline('.', '"foo"')
  normal 0sra"a
  call g:assert.equals(getline('.'), '2foo3',  'failed at #152')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'char', 'eval', 0)
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #153
  call setline('.', '(foo)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #153')

  " #154
  call setline('.', '[foo]')
  normal 0va[sr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #154')

  " #155
  call setline('.', '{foo}')
  normal 0va{sr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #155')

  " #156
  call setline('.', '<foo>')
  normal 0va<sr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #156')

  " #157
  call setline('.', '(foo)')
  normal 0va(sr]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #157')

  " #158
  call setline('.', '[foo]')
  normal 0va[sr}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #158')

  " #159
  call setline('.', '{foo}')
  normal 0va{sr>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #159')

  " #160
  call setline('.', '<foo>')
  normal 0va<sr)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #160')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #161
  call setline('.', 'afooa')
  normal 0viwsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #161')

  " #162
  call setline('.', '+foo+')
  normal 0v$sr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #162')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #162')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #162')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #163
  call setline('.', '(foo)bar')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[foo]bar',   'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #163')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #163')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #163')

  " #164
  call setline('.', 'foo(bar)')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]',   'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #164')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #164')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #164')

  " #165
  call setline('.', 'foo(bar)baz')
  normal 0fbva(sr[
  call g:assert.equals(getline('.'), 'foo[bar]baz', 'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #165')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #165')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #165')

  " #166
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv12lsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #166')
  call g:assert.equals(getline(2),   'bar',        'failed at #166')
  call g:assert.equals(getline(3),   'baz]',       'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #166')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #166')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #166')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #167
  call setline('.', '(a)')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[a]',        'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #167')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #167')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #167')

  %delete

  " #168
  call append(0, ['(', 'a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #168')
  call g:assert.equals(getline(2),   'a',          'failed at #168')
  call g:assert.equals(getline(3),   ']',          'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #168')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #168')

  %delete

  " #169
  call append(0, ['(a', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[a',         'failed at #169')
  call g:assert.equals(getline(2),   ']',          'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #169')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #169')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #169')

  %delete

  " #170
  call append(0, ['(', 'a)'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #170')
  call g:assert.equals(getline(2),   'a]',         'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #170')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #170')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #171
  call setline('.', '()')
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[]',         'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #171')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #171')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #171')

  " #172
  call setline('.', 'foo()bar')
  normal 03lva(sr[
  call g:assert.equals(getline('.'), 'foo[]bar',   'failed at #172')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #172')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #172')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #172')

  %delete

  " #173
  call append(0, ['(', ')'])
  normal ggva(sr[
  call g:assert.equals(getline(1),   '[',          'failed at #173')
  call g:assert.equals(getline(2),   ']',          'failed at #173')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #173')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #173')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #174
  call setline('.', '([foo])')
  normal 0v%2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #174')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #174')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #174')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #174')

  " #175
  call setline('.', '[({foo})]')
  normal 0v%3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #175')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #175')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #175')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #175')

  " #176
  call setline('.', '{[foo bar]}')
  normal 0v10l2sr[(
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #176')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #176')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #176')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #176')

  " #177
  call setline('.', 'foo{[bar]}baz')
  normal 03lv6l2sr[(
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #177')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #177')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #177')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #177')

  " #178
  call setline('.', 'foo({[bar]})baz')
  normal 03lv8l3sr{[(
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #178')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #178')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #178')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #178')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #179
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv14lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #179')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #179')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #179')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #179')

  %delete

  " #180
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv20lsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #180')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #180')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #180')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #180')

  %delete

  " #181
  call setline('.', '(foo)')
  normal 0v4lsra
  call g:assert.equals(getline(1),   'aa',         'failed at #181')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #181')
  call g:assert.equals(getline(3),   'aa',         'failed at #181')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #181')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #181')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #181')

  %delete

  " #182
  call setline('.', '(foo)')
  normal 0v4lsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #182')
  call g:assert.equals(getline(2),   'bbb',        'failed at #182')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #182')
  call g:assert.equals(getline(4),   'bbb',        'failed at #182')
  call g:assert.equals(getline(5),   'bb',         'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #182')
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

  " #183
  call setline('.', '{[(foo)]}')
  normal 02lv4lsr"
  call g:assert.equals(getline('.'), '{["foo"]}', 'failed at #183')

  " #184
  call setline('.', '{[(foo)]}')
  normal 0lv6lsr"
  call g:assert.equals(getline('.'), '{"(foo)"}', 'failed at #184')

  " #185
  call setline('.', '{[(foo)]}')
  normal 0v8lsr"
  call g:assert.equals(getline('.'), '"[(foo)]"', 'failed at #185')

  " #186
  call setline('.', '<title>foo</title>')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #186')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #187
  call setline('.', '(((foo)))')
  normal 0lv%2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #187')

  " #188
  normal 0va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #188')

  """ keep
  " #189
  call operator#sandwich#set('replace', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #189')

  " #190
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #190')

  """ inner_tail
  " #191
  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #191')

  " #192
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #192')

  """ front
  " #193
  call operator#sandwich#set('replace', 'char', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #193')

  " #194
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #194')

  """ end
  " #195
  call operator#sandwich#set('replace', 'char', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 0lva(2sr[[
  call g:assert.equals(getline('.'), '([[foo]])',  'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #195')

  " #196
  normal va(sr[
  call g:assert.equals(getline('.'), '[[[foo]]]',  'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #196')

  call operator#sandwich#set('replace', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #197
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '"(foo)"', 'failed at #197')

  " #198
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #198')

  """ off
  " #199
  call operator#sandwich#set('replace', 'char', 'noremap', 0)
  call setline('.', '{(foo)}')
  normal 0v6lsr"
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #199')

  " #200
  call setline('.', '{(foo)}')
  normal 0lv4lsr"
  call g:assert.equals(getline('.'), '{"foo"}', 'failed at #200')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #201
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #201')

  " #202
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #202')

  """ on
  call operator#sandwich#set('replace', 'char', 'regex', 1)
  " #203
  call setline('.', '\d\+foo\d\+')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #203')

  " #204
  call setline('.', '888foo888')
  normal 0v$sr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #204')

  call operator#sandwich#set('replace', 'char', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """ on
  " #205
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #205')

  " #206
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #206')

  " #207
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #207')

  " #208
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #208')

  """ off
  call operator#sandwich#set('replace', 'char', 'skip_space', 0)
  " #209
  call setline('.', '"foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #209')

  " #210
  call setline('.', ' "foo"')
  normal 0v$sr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #210')

  " #211
  call setline('.', '"foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #211')

  " #212
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #212')

  call operator#sandwich#set('replace', 'char', 'skip_space', 1)
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #213
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #213')

  """ on
  call operator#sandwich#set('replace', 'char', 'skip_char', 1)
  " #214
  call setline('.', 'aa(foo)bb')
  normal 0v$sr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #214')

  call operator#sandwich#set('replace', 'char', 'skip_char', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'char', 'command', ['normal! `[dv`]'])

  " #215
  call setline('.', '(foo)')
  normal 0va(sr"
  call g:assert.equals(getline('.'), '""', 'failed at #215')

  call operator#sandwich#set('replace', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'char', 'linewise', 1)

  """ 1
  " #216
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #216')
  call g:assert.equals(getline(2),   'foo',        'failed at #216')
  call g:assert.equals(getline(3),   ']',          'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #216')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #216')

  %delete

  " #217
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #217')
  call g:assert.equals(getline(2),   'foo',        'failed at #217')
  call g:assert.equals(getline(3),   ']',          'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #217')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #217')

  %delete

  " #218
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #218')
  call g:assert.equals(getline(2),   'foo',        'failed at #218')
  call g:assert.equals(getline(3),   'aa]',        'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #218')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #218')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #218')

  %delete

  " #219
  call append(0, ['(aa', 'foo', ')'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #219')
  call g:assert.equals(getline(2),   'foo',        'failed at #219')
  call g:assert.equals(getline(3),   ']',          'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #219')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #219')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #219')

  %delete

  " #220
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv8lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #220')
  call g:assert.equals(getline(2),   'foo',        'failed at #220')
  call g:assert.equals(getline(3),   'aa]',        'failed at #220')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #220')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #220')

  %delete

  call operator#sandwich#set('replace', 'char', 'linewise', 2)

  """ 2
  " #221
  call append(0, ['(', 'foo', ')'])
  normal ggv6lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #221')
  call g:assert.equals(getline(2),   'foo',        'failed at #221')
  call g:assert.equals(getline(3),   ']',          'failed at #221')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #221')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #221')

  %delete

  " #222
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #222')
  call g:assert.equals(getline(2),   'foo',        'failed at #222')
  call g:assert.equals(getline(3),   ']',          'failed at #222')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #222')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #222')

  %delete

  " #223
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv10lsr[
  call g:assert.equals(getline(1),   '[',          'failed at #223')
  call g:assert.equals(getline(2),   'foo',        'failed at #223')
  call g:assert.equals(getline(3),   ']',          'failed at #223')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #223')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #223')

  %delete

  " #224
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #224')
  call g:assert.equals(getline(2),   '[',          'failed at #224')
  call g:assert.equals(getline(3),   'bb',         'failed at #224')
  call g:assert.equals(getline(4),   '',           'failed at #224')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #224')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #224')

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #225
  call setline('.', '(foo)')
  normal srVl[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #225')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #225')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #225')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #225')

  " #226
  call setline('.', '[foo]')
  normal srVl{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #226')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #226')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #226')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #226')

  " #227
  call setline('.', '{foo}')
  normal srVl<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #227')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #227')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #227')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #227')

  " #228
  call setline('.', '<foo>')
  normal srVl(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #228')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #228')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #228')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #228')

  %delete

  " #229
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j]
  call g:assert.equals(getline(1),   '[',          'failed at #229')
  call g:assert.equals(getline(2),   'foo',        'failed at #229')
  call g:assert.equals(getline(3),   ']',          'failed at #229')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #229')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #229')

  " #230
  call append(0, ['[', 'foo', ']'])
  normal ggsr2j}
  call g:assert.equals(getline(1),   '{',          'failed at #230')
  call g:assert.equals(getline(2),   'foo',        'failed at #230')
  call g:assert.equals(getline(3),   '}',          'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #230')

  " #231
  call append(0, ['{', 'foo', '}'])
  normal ggsr2j>
  call g:assert.equals(getline(1),   '<',          'failed at #231')
  call g:assert.equals(getline(2),   'foo',        'failed at #231')
  call g:assert.equals(getline(3),   '>',          'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #231')

  " #232
  call append(0, ['<', 'foo', '>'])
  normal ggsr2j)
  call g:assert.equals(getline(1),   '(',          'failed at #232')
  call g:assert.equals(getline(2),   'foo',        'failed at #232')
  call g:assert.equals(getline(3),   ')',          'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #232')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #233
  call setline('.', 'afooa')
  normal srVlb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #233')

  " #234
  call setline('.', '+foo+')
  normal srVl*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #234')

  %delete

  " #233
  call append(0, ['a', 'foo', 'a'])
  normal ggsr2jb
  call g:assert.equals(getline(1),   'b',          'failed at #233')
  call g:assert.equals(getline(2),   'foo',        'failed at #233')
  call g:assert.equals(getline(3),   'b',          'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #233')

  %delete

  " #234
  call append(0, ['+', 'foo', '+'])
  normal ggsr2j*
  call g:assert.equals(getline(1),   '*',          'failed at #234')
  call g:assert.equals(getline(2),   'foo',        'failed at #234')
  call g:assert.equals(getline(3),   '*',          'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #234')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #235
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #235')
  call g:assert.equals(getline(2),   'foo',        'failed at #235')
  call g:assert.equals(getline(3),   'bar',        'failed at #235')
  call g:assert.equals(getline(4),   'baz',        'failed at #235')
  call g:assert.equals(getline(5),   ']',          'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #235')

  %delete

  " #236
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsrVa([
  call g:assert.equals(getline(1),   'foo',        'failed at #236')
  call g:assert.equals(getline(2),   '[',          'failed at #236')
  call g:assert.equals(getline(3),   'bar',        'failed at #236')
  call g:assert.equals(getline(4),   ']',          'failed at #236')
  call g:assert.equals(getline(5),   'baz',        'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #236')

  %delete

  " #237
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[foo',       'failed at #237')
  call g:assert.equals(getline(2),   'bar',        'failed at #237')
  call g:assert.equals(getline(3),   'baz]',       'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #237')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #238
  call setline('.', '()')
  normal srVa([
  call g:assert.equals(getline('.'), '[]',         'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #238')

  %delete

  " #239
  call append(0, ['(', ')'])
  normal ggsrVa([
  call g:assert.equals(getline(1),   '[',          'failed at #239')
  call g:assert.equals(getline(2),   ']',          'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #239')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #240
  call setline('.', '([foo])')
  normal 2srVl[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #240')

  " #241
  call setline('.', '[({foo})]')
  normal 3srVl{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #241')

  %delete

  " #242
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sr6j({[
  call g:assert.equals(getline(1),   'foo',        'failed at #242')
  call g:assert.equals(getline(2),   '(',          'failed at #242')
  call g:assert.equals(getline(3),   '{',          'failed at #242')
  call g:assert.equals(getline(4),   '[',          'failed at #242')
  call g:assert.equals(getline(5),   'bar',        'failed at #242')
  call g:assert.equals(getline(6),   ']',          'failed at #242')
  call g:assert.equals(getline(7),   '}',          'failed at #242')
  call g:assert.equals(getline(8),   ')',          'failed at #242')
  call g:assert.equals(getline(9),   'baz',        'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #242')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #243
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsr2j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsr4j(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #244')

  %delete

  " #245
  call setline('.', '(foo)')
  normal srVla
  call g:assert.equals(getline(1),   'aa',         'failed at #245')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #245')
  call g:assert.equals(getline(3),   'aa',         'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #245')

  %delete

  " #246
  call setline('.', '(foo)')
  normal srVlb
  call g:assert.equals(getline(1),   'bb',         'failed at #246')
  call g:assert.equals(getline(2),   'bbb',        'failed at #246')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #246')
  call g:assert.equals(getline(4),   'bbb',        'failed at #246')
  call g:assert.equals(getline(5),   'bb',         'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal gg2sr8j((
  call g:assert.equals(getline(1),   '(',          'failed at #247')
  call g:assert.equals(getline(2),   '(',          'failed at #247')
  call g:assert.equals(getline(3),   'foo',        'failed at #247')
  call g:assert.equals(getline(4),   ')',          'failed at #247')
  call g:assert.equals(getline(5),   ')',          'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #247')

  %delete

  " #248
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sr12j((
  call g:assert.equals(getline(1),   '(',          'failed at #248')
  call g:assert.equals(getline(2),   '(',          'failed at #248')
  call g:assert.equals(getline(3),   'foo',        'failed at #248')
  call g:assert.equals(getline(4),   ')',          'failed at #248')
  call g:assert.equals(getline(5),   ')',          'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #248')

  unlet! g:operator#sandwich#recipes
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

  " #249
  call setline('.', '(foo)')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #249')

  " #250
  call setline('.', '[foo]')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #250')

  " #251
  call setline('.', '{foo}')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #251')

  " #252
  call setline('.', '<title>foo</title>')
  normal srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #252')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #253
  call setline('.', '(((foo)))')
  normal 02srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #253')

  " #254
  normal srVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #254')

  """ keep
  " #255
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #255')

  " #256
  normal lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #256')

  """ inner_tail
  " #257
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #257')

  " #258
  normal hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #258')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #258')

  """ front
  " #259
  call operator#sandwich#set('replace', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #259')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #259')

  " #260
  normal 3lsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #260')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #260')

  """ end
  " #261
  call operator#sandwich#set('replace', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 04l2srVl[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #261')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #261')

  " #262
  normal 3hsrVl(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #262')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #262')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #263
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #263')

  " #264
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #264')

  """ off
  " #265
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal 0srVl"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #265')

  " #266
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #266')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #267
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #267')

  " #268
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #268')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #269
  call setline('.', '\d\+foo\d\+')
  normal 0srVl"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #269')

  " #270
  call setline('.', '888foo888')
  normal 0srVl"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #270')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """ on
  " #271
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #271')

  " #272
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #272')

  " #273
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #273')

  " #274
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #274')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #275
  call setline('.', '"foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #275')

  " #276
  call setline('.', ' "foo"')
  normal 0srVl(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #276')

  " #277
  call setline('.', '"foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #277')

  " #278
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0srVl(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #278')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #279
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #279')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #280
  call setline('.', 'aa(foo)bb')
  normal 0srVl"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #280')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #281
  call setline('.', '(foo)')
  normal 0srVl"
  call g:assert.equals(getline('.'), '""', 'failed at #281')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #282
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #282')
  call g:assert.equals(getline(2),   'foo',        'failed at #282')
  call g:assert.equals(getline(3),   ']',          'failed at #282')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #282')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #282')

  %delete

  " #283
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[  ',        'failed at #283')
  call g:assert.equals(getline(2),   'foo',        'failed at #283')
  call g:assert.equals(getline(3),   '  ]',        'failed at #283')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #283')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #283')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #283')

  %delete

  " #284
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #284')
  call g:assert.equals(getline(2),   'foo',        'failed at #284')
  call g:assert.equals(getline(3),   'aa]',        'failed at #284')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #284')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #284')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #284')

  %delete

  " #285
  call append(0, ['(aa', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[aa',        'failed at #285')
  call g:assert.equals(getline(2),   'foo',        'failed at #285')
  call g:assert.equals(getline(3),   ']',          'failed at #285')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #285')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #285')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #285')

  %delete

  " #286
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #286')
  call g:assert.equals(getline(2),   'foo',        'failed at #286')
  call g:assert.equals(getline(3),   'aa]',        'failed at #286')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #286')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #286')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #287
  call append(0, ['(', 'foo', ')'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #287')
  call g:assert.equals(getline(2),   'foo',        'failed at #287')
  call g:assert.equals(getline(3),   ']',          'failed at #287')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #287')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #287')

  %delete

  " #288
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #288')
  call g:assert.equals(getline(2),   'foo',        'failed at #288')
  call g:assert.equals(getline(3),   ']',          'failed at #288')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #288')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #288')

  %delete

  " #289
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsr2j[
  call g:assert.equals(getline(1),   '[',          'failed at #289')
  call g:assert.equals(getline(2),   'foo',        'failed at #289')
  call g:assert.equals(getline(3),   ']',          'failed at #289')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #289')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #289')

  %delete

  " #290
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsrVl[
  call g:assert.equals(getline(1),   'aa',         'failed at #290')
  call g:assert.equals(getline(2),   '[',          'failed at #290')
  call g:assert.equals(getline(3),   'bb',         'failed at #290')
  call g:assert.equals(getline(4),   '',           'failed at #290')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #290')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #290')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #291
  call setline('.', '"""foo"""')
  normal 03srVl([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #291')

  %delete

  """ on
  " #292
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal 03srVl(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #292')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #293
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #293')

  """ 1
  " #294
  call operator#sandwich#set('replace', 'line', 'eval', 1)
  call setline('.', '"foo"')
  normal 0srVla
  call g:assert.equals(getline('.'), '2foo3',  'failed at #294')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'eval', 0)
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #295
  call setline('.', '(foo)')
  normal Vsr[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #295')

  " #296
  call setline('.', '[foo]')
  normal Vsr{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #296')

  " #297
  call setline('.', '{foo}')
  normal Vsr<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #297')

  " #298
  call setline('.', '<foo>')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #298')

  %delete

  " #299
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr]
  call g:assert.equals(getline(1),   '[',          'failed at #299')
  call g:assert.equals(getline(2),   'foo',        'failed at #299')
  call g:assert.equals(getline(3),   ']',          'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #299')

  " #300
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsr}
  call g:assert.equals(getline(1),   '{',          'failed at #300')
  call g:assert.equals(getline(2),   'foo',        'failed at #300')
  call g:assert.equals(getline(3),   '}',          'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #300')

  " #301
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsr>
  call g:assert.equals(getline(1),   '<',          'failed at #301')
  call g:assert.equals(getline(2),   'foo',        'failed at #301')
  call g:assert.equals(getline(3),   '>',          'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #301')

  " #302
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsr)
  call g:assert.equals(getline(1),   '(',          'failed at #302')
  call g:assert.equals(getline(2),   'foo',        'failed at #302')
  call g:assert.equals(getline(3),   ')',          'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #302')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #303
  call setline('.', 'afooa')
  normal Vsrb
  call g:assert.equals(getline('.'), 'bfoob',      'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #303')

  " #304
  call setline('.', '+foo+')
  normal Vsr*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #304')

  %delete

  " #303
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsrb
  call g:assert.equals(getline(1),   'b',          'failed at #303')
  call g:assert.equals(getline(2),   'foo',        'failed at #303')
  call g:assert.equals(getline(3),   'b',          'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #303')

  %delete

  " #304
  call append(0, ['+', 'foo', '+'])
  normal ggV2jsr*
  call g:assert.equals(getline(1),   '*',          'failed at #304')
  call g:assert.equals(getline(2),   'foo',        'failed at #304')
  call g:assert.equals(getline(3),   '*',          'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #304')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #305
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #305')
  call g:assert.equals(getline(2),   'foo',        'failed at #305')
  call g:assert.equals(getline(3),   'bar',        'failed at #305')
  call g:assert.equals(getline(4),   'baz',        'failed at #305')
  call g:assert.equals(getline(5),   ']',          'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsr[
  call g:assert.equals(getline(1),   'foo',        'failed at #306')
  call g:assert.equals(getline(2),   '[',          'failed at #306')
  call g:assert.equals(getline(3),   'bar',        'failed at #306')
  call g:assert.equals(getline(4),   ']',          'failed at #306')
  call g:assert.equals(getline(5),   'baz',        'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #306')

  %delete

  " #307
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[foo',       'failed at #307')
  call g:assert.equals(getline(2),   'bar',        'failed at #307')
  call g:assert.equals(getline(3),   'baz]',       'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #307')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #308
  call setline('.', '()')
  normal Vsr[
  call g:assert.equals(getline('.'), '[]',         'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 1, 3, 0], 'failed at #308')

  %delete

  " #309
  call append(0, ['(', ')'])
  normal ggVjsr[
  call g:assert.equals(getline(1),   '[',          'failed at #309')
  call g:assert.equals(getline(2),   ']',          'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #309')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #310
  call setline('.', '([foo])')
  normal V2sr[(
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #310')

  " #311
  call setline('.', '[({foo})]')
  normal V3sr{[(
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sr({[
  call g:assert.equals(getline(1),   'foo',        'failed at #312')
  call g:assert.equals(getline(2),   '(',          'failed at #312')
  call g:assert.equals(getline(3),   '{',          'failed at #312')
  call g:assert.equals(getline(4),   '[',          'failed at #312')
  call g:assert.equals(getline(5),   'bar',        'failed at #312')
  call g:assert.equals(getline(6),   ']',          'failed at #312')
  call g:assert.equals(getline(7),   '}',          'failed at #312')
  call g:assert.equals(getline(8),   ')',          'failed at #312')
  call g:assert.equals(getline(9),   'baz',        'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 8, 2, 0], 'failed at #312')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #313
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggV2jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggV4jsr(
  call g:assert.equals(getline(1),   '(foo)',      'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #314')

  %delete

  " #315
  call setline('.', '(foo)')
  normal Vsra
  call g:assert.equals(getline(1),   'aa',         'failed at #315')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #315')
  call g:assert.equals(getline(3),   'aa',         'failed at #315')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #315')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #315')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #315')

  %delete

  " #316
  call setline('.', '(foo)')
  normal Vsrb
  call g:assert.equals(getline(1),   'bb',         'failed at #316')
  call g:assert.equals(getline(2),   'bbb',        'failed at #316')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #316')
  call g:assert.equals(getline(4),   'bbb',        'failed at #316')
  call g:assert.equals(getline(5),   'bb',         'failed at #316')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #316')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #316')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #316')

  %delete

  " #317
  call append(0, ['aa', 'aaa', 'aa', 'aaa', 'foo', 'aaa', 'aa', 'aaa', 'aa'])
  normal ggV8j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #317')
  call g:assert.equals(getline(2),   '(',          'failed at #317')
  call g:assert.equals(getline(3),   'foo',        'failed at #317')
  call g:assert.equals(getline(4),   ')',          'failed at #317')
  call g:assert.equals(getline(5),   ')',          'failed at #317')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #317')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #317')

  %delete

  " #318
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bb', 'foo', 'bb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal ggV12j2sr((
  call g:assert.equals(getline(1),   '(',          'failed at #318')
  call g:assert.equals(getline(2),   '(',          'failed at #318')
  call g:assert.equals(getline(3),   'foo',        'failed at #318')
  call g:assert.equals(getline(4),   ')',          'failed at #318')
  call g:assert.equals(getline(5),   ')',          'failed at #318')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #318')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #318')

  unlet! g:operator#sandwich#recipes
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

  " #319
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #319')

  " #320
  call setline('.', '[foo]')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #320')

  " #321
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #321')

  " #322
  call setline('.', '<title>foo</title>')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #322')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #323
  call setline('.', '(((foo)))')
  normal 0V2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #323')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #323')

  " #324
  normal Vsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #324')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #324')

  """ keep
  " #325
  call operator#sandwich#set('replace', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #325')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #325')

  " #326
  normal lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #326')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #326')

  """ inner_tail
  " #327
  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #327')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #327')

  " #328
  normal hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #328')
  call g:assert.equals(getpos('.'),  [0, 1, 8, 0], 'failed at #328')

  """ front
  " #329
  call operator#sandwich#set('replace', 'line', 'cursor', 'front')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #329')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #329')

  " #330
  normal 3lVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #330')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #330')

  """ end
  " #331
  call operator#sandwich#set('replace', 'line', 'cursor', 'end')
  call setline('.', '(((foo)))')
  normal 04lV2sr[[
  call g:assert.equals(getline('.'), '[[(foo)]]',  'failed at #331')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #331')

  " #332
  normal 3hVsr(
  call g:assert.equals(getline('.'), '([(foo)])',  'failed at #332')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #332')

  call operator#sandwich#set('replace', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #333
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #333')

  " #334
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #334')

  """ off
  " #335
  call operator#sandwich#set('replace', 'line', 'noremap', 0)
  call setline('.', '{foo}')
  normal Vsr"
  call g:assert.equals(getline('.'), '{foo}', 'failed at #335')

  " #336
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #336')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #337
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #337')

  " #338
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"88foo88"', 'failed at #338')

  """ on
  call operator#sandwich#set('replace', 'line', 'regex', 1)
  " #339
  call setline('.', '\d\+foo\d\+')
  normal Vsr"
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #339')

  " #340
  call setline('.', '888foo888')
  normal Vsr"
  call g:assert.equals(getline('.'), '"foo"', 'failed at #340')

  call operator#sandwich#set('replace', 'line', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """ on
  " #341
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #341')

  " #342
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' (foo)', 'failed at #342')

  " #343
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #343')

  " #344
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #344')

  """ off
  call operator#sandwich#set('replace', 'line', 'skip_space', 0)
  " #345
  call setline('.', '"foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #345')

  " #346
  call setline('.', ' "foo"')
  normal Vsr(
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #346')

  " #347
  call setline('.', '"foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #347')

  " #348
  " do not skip!
  call setline('.', ' "foo" ')
  normal Vsr(
  call g:assert.equals(getline('.'), '("foo")', 'failed at #348')

  call operator#sandwich#set('replace', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #349
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #349')

  """ on
  call operator#sandwich#set('replace', 'line', 'skip_char', 1)
  " #350
  call setline('.', 'aa(foo)bb')
  normal Vsr"
  call g:assert.equals(getline('.'), 'aa"foo"bb', 'failed at #350')

  call operator#sandwich#set('replace', 'line', 'skip_char', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'command', ['normal! `[dv`]'])

  " #351
  call setline('.', '(foo)')
  normal Vsr"
  call g:assert.equals(getline('.'), '""', 'failed at #351')

  call operator#sandwich#set('replace', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('replace', 'line', 'linewise', 0)

  """ 0
  " #352
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #352')
  call g:assert.equals(getline(2),   'foo',        'failed at #352')
  call g:assert.equals(getline(3),   ']',          'failed at #352')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #352')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #352')

  %delete

  " #353
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[  ',        'failed at #353')
  call g:assert.equals(getline(2),   'foo',        'failed at #353')
  call g:assert.equals(getline(3),   '  ]',        'failed at #353')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #353')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #353')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #353')

  %delete

  " #354
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #354')
  call g:assert.equals(getline(2),   'foo',        'failed at #354')
  call g:assert.equals(getline(3),   'aa]',        'failed at #354')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #354')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #354')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #354')

  %delete

  " #355
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[aa',        'failed at #355')
  call g:assert.equals(getline(2),   'foo',        'failed at #355')
  call g:assert.equals(getline(3),   ']',          'failed at #355')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #355')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #355')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #355')

  %delete

  " #356
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #356')
  call g:assert.equals(getline(2),   'foo',        'failed at #356')
  call g:assert.equals(getline(3),   'aa]',        'failed at #356')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #356')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #356')

  %delete

  call operator#sandwich#set('replace', 'line', 'linewise', 2)

  """ 2
  " #357
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #357')
  call g:assert.equals(getline(2),   'foo',        'failed at #357')
  call g:assert.equals(getline(3),   ']',          'failed at #357')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #357')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #357')

  %delete

  " #358
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #358')
  call g:assert.equals(getline(2),   'foo',        'failed at #358')
  call g:assert.equals(getline(3),   ']',          'failed at #358')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #358')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #358')

  %delete

  " #359
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsr[
  call g:assert.equals(getline(1),   '[',          'failed at #359')
  call g:assert.equals(getline(2),   'foo',        'failed at #359')
  call g:assert.equals(getline(3),   ']',          'failed at #359')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #359')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #359')

  %delete

  " #360
  " FIXME: I have no idea what is the expexted behavior.
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsr[
  call g:assert.equals(getline(1),   'aa',         'failed at #360')
  call g:assert.equals(getline(2),   '[',          'failed at #360')
  call g:assert.equals(getline(3),   'bb',         'failed at #360')
  call g:assert.equals(getline(4),   '',           'failed at #360')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #360')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #360')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #361
  call setline('.', '"""foo"""')
  normal V3sr([{
  call g:assert.equals(getline('.'), '([{foo}])',  'failed at #361')

  %delete

  """ on
  " #362
  call operator#sandwich#set('replace', 'line', 'query_once', 1)
  call setline('.', '"""foo"""')
  normal V3sr(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #362')

  call operator#sandwich#set('replace', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #363
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #363')

  """ 1
  " #364
  call operator#sandwich#set('replace', 'line', 'eval', 1)
  call setline('.', '"foo"')
  normal Vsra
  call g:assert.equals(getline('.'), '2foo3',  'failed at #364')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'line', 'eval', 0)
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #236
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #236')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #236')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #236')

  %delete

  " #237
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #237')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #237')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #237')

  %delete

  " #238
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #238')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #238')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #238')

  %delete

  " #239
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #239')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #239')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #239')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #240
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsr\<C-v>17lb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #240')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #240')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #240')

  " #241
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal ggsr\<C-v>17l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #241')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #241')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #241')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #241')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #242
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsr\<C-v>23l["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #242')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #242')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #242')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #242')

  %delete

  " #243
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsr\<C-v>23l["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #243')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #243')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsr\<C-v>29l["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #244')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #244')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #244')

  %delete

  " #245
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsr\<C-v>17l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #245')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #245')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #246')
  call g:assert.equals(getline(2),   'barbar',     'failed at #246')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>18l["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #247')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #247')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #247')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #248
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal ggsr\<C-v>11l["
  call g:assert.equals(getline(1),   '[a]',        'failed at #248')
  call g:assert.equals(getline(2),   '[b]',        'failed at #248')
  call g:assert.equals(getline(3),   '[c]',        'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #248')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort "{{{
  set whichwrap=h,l

  " #249
  call append(0, ['()', '()', '()'])
  execute "normal ggsr\<C-v>8l["
  call g:assert.equals(getline(1),   '[]',         'failed at #249')
  call g:assert.equals(getline(2),   '[]',         'failed at #249')
  call g:assert.equals(getline(3),   '[]',         'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #249')

  %delete

  " #250
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsr\<C-v>20l["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #250')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #250')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #250')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #251
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg3sr\<C-v>23l({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #251')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #251')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #251')

  %delete

  " #252
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #252')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #252')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #252')

  %delete

  " #253
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #253')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #253')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #253')

  %delete

  " #254
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #254')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #254')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #254')

  %delete

  " #255
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sr\<C-v>29l({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #255')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #255')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #255')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #255')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_external_textobj() abort "{{{
  set whichwrap=h,l

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #256
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #256')
  call g:assert.equals(getline(2), '"bar"', 'failed at #256')
  call g:assert.equals(getline(3), '"baz"', 'failed at #256')

  %delete

  " #257
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #257')
  call g:assert.equals(getline(2), '"bar"', 'failed at #257')
  call g:assert.equals(getline(3), '"baz"', 'failed at #257')

  %delete

  " #258
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #258')
  call g:assert.equals(getline(2), '"bar"', 'failed at #258')
  call g:assert.equals(getline(3), '"baz"', 'failed at #258')

  %delete

  " #259
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsr\<C-v>56l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #259')
  call g:assert.equals(getline(2), '"bar"', 'failed at #259')
  call g:assert.equals(getline(3), '"baz"', 'failed at #259')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ inner_head
  " #260
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #260')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #260')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #260')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #260')

  " #261
  execute "normal sr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #261')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #261')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #261')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #261')

  %delete

  """ keep
  " #262
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #262')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #262')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #262')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #262')

  " #263
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #263')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #263')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #263')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #263')

  %delete

  """ inner_tail
  " #264
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #264')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #264')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #264')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #264')

  " #265
  execute "normal gg2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #265')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #265')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #265')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #265')

  %delete

  """ front
  " #266
  call operator#sandwich#set('replace', 'block', 'cursor', 'front')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #266')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #266')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #266')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #266')

  " #267
  execute "normal 2lsr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #267')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #267')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #267')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #267')

  %delete

  """ end
  " #268
  call operator#sandwich#set('replace', 'block', 'cursor', 'end')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg2sr\<C-v>29l[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #268')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #268')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #268')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #268')

  " #269
  execute "normal 6h2ksr\<C-v>25l["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #269')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #269')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #269')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #269')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
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
  " #270
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #270')
  call g:assert.equals(getline(2), '"bar"', 'failed at #270')
  call g:assert.equals(getline(3), '"baz"', 'failed at #270')

  %delete

  " #271
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #271')
  call g:assert.equals(getline(2), '(bar)', 'failed at #271')
  call g:assert.equals(getline(3), '(baz)', 'failed at #271')

  %delete

  """ off
  " #272
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #272')
  call g:assert.equals(getline(2), '{bar}', 'failed at #272')
  call g:assert.equals(getline(3), '{baz}', 'failed at #272')

  %delete

  " #273
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #273')
  call g:assert.equals(getline(2), '"bar"', 'failed at #273')
  call g:assert.equals(getline(3), '"baz"', 'failed at #273')

  set whichwrap&
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_regex() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #274
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #274')
  call g:assert.equals(getline(2), '"bar"', 'failed at #274')
  call g:assert.equals(getline(3), '"baz"', 'failed at #274')

  %delete

  " #275
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #275')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #275')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #275')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #276
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsr\<C-v>35l\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #276')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #276')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #276')

  %delete

  " #277
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #277')
  call g:assert.equals(getline(2), '"bar"', 'failed at #277')
  call g:assert.equals(getline(3), '"baz"', 'failed at #277')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  set whichwrap=h,l

  """ on
  " #278
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #278')
  call g:assert.equals(getline(2), '(bar)', 'failed at #278')
  call g:assert.equals(getline(3), '(baz)', 'failed at #278')

  %delete

  " #279
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #279')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #279')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #279')

  %delete

  " #280
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #280')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #280')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #280')

  %delete

  " #281
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #281')
  call g:assert.equals(getline(2), '("bar")', 'failed at #281')
  call g:assert.equals(getline(3), '("baz")', 'failed at #281')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #282
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17l("
  call g:assert.equals(getline(1), '(foo)', 'failed at #282')
  call g:assert.equals(getline(2), '(bar)', 'failed at #282')
  call g:assert.equals(getline(3), '(baz)', 'failed at #282')

  %delete

  " #283
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #283')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #283')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #283')

  %delete

  " #284
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal ggsr\<C-v>20l("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #284')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #284')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #284')

  %delete

  " #285
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal ggsr\<C-v>23l("
  call g:assert.equals(getline(1), '("foo")', 'failed at #285')
  call g:assert.equals(getline(2), '("bar")', 'failed at #285')
  call g:assert.equals(getline(3), '("baz")', 'failed at #285')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #286
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #286')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #286')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #286')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #287
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsr\<C-v>29l\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #287')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #287')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #287')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #288
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsr\<C-v>17l\""
  call g:assert.equals(getline(1), '""', 'failed at #288')
  call g:assert.equals(getline(2), '""', 'failed at #288')
  call g:assert.equals(getline(3), '""', 'failed at #288')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  set whichwrap=h,l

  """"" query_once
  """ off
  " #288
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #288')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #288')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #288')

  %delete

  """ on
  " #289
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg3sr\<C-v>29l("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #289')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #289')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #289')

  set whichwrap&
  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_eval() abort "{{{
  """"" eval
  set whichwrap=h,l
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #290
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #290')

  %delete

  """ 1
  " #291
  call operator#sandwich#set('replace', 'block', 'eval', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal ggsr\<C-v>17la"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #291')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  set whichwrap&
  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'eval', 0)
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #292
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #292')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #292')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #292')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #292')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #292')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #292')

  %delete

  " #293
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #293')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #293')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #293')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #293')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #293')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #293')

  %delete

  " #294
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #294')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #294')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #294')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #294')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #294')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #294')

  %delete

  " #295
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #295')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #295')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #295')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #295')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #295')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #295')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #296
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsrb"
  call g:assert.equals(getline(1),   'bfoob',      'failed at #296')
  call g:assert.equals(getline(2),   'bbarb',      'failed at #296')
  call g:assert.equals(getline(3),   'bbazb',      'failed at #296')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #296')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #296')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #296')

  " #297
  call append(0, ['+foo+', '+bar+', '+baz+'])
  execute "normal gg\<C-v>2j4lsr*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #297')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #297')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #297')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #297')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #297')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #297')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #298
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]bar',   'failed at #298')
  call g:assert.equals(getline(2),   '[foo]bar',   'failed at #298')
  call g:assert.equals(getline(3),   '[foo]bar',   'failed at #298')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #298')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #298')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #298')

  %delete

  " #299
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]',   'failed at #299')
  call g:assert.equals(getline(2),   'foo[bar]',   'failed at #299')
  call g:assert.equals(getline(3),   'foo[bar]',   'failed at #299')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #299')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #299')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0], 'failed at #299')

  %delete

  " #300
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foo[bar]baz', 'failed at #300')
  call g:assert.equals(getline(2),   'foo[bar]baz', 'failed at #300')
  call g:assert.equals(getline(3),   'foo[bar]baz', 'failed at #300')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #300')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #300')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #300')

  %delete

  " #301
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #301')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #301')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #301')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #301')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #301')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #301')

  %delete

  " #302
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #302')
  call g:assert.equals(getline(2),   'barbar',     'failed at #302')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #302')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #302')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #302')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #302')

  %delete

  " #303
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr["
  call g:assert.equals(getline(1),   'foofoo',     'failed at #303')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #303')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #303')
  call g:assert.equals(getpos('.'),  [0, 2, 2, 0], 'failed at #303')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #303')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #303')

  %delete

  """ terminal-extended block-wise visual mode
  " #304
  call append(0, ['"fooo"', '"baaar"', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #304')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #304')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #304')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #304')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #304')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #304')

  %delete

  " #305
  call append(0, ['"foooo"', '"bar"', '"baaz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #305')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #305')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #305')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #305')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #305')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #305')

  %delete

  " #306
  call append(0, ['"fooo"', '', '"baz"'])
  execute "normal gg\<C-v>2j$sr("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #306')
  call g:assert.equals(getline(2),   '',           'failed at #306')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #306')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #306')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #306')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #306')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #307
  call append(0, ['(a)', '(b)', '(c)'])
  execute "normal gg\<C-v>2j2lsr["
  call g:assert.equals(getline(1),   '[a]',        'failed at #307')
  call g:assert.equals(getline(2),   '[b]',        'failed at #307')
  call g:assert.equals(getline(3),   '[c]',        'failed at #307')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #307')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #307')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #307')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort "{{{
  " #308
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsr["
  call g:assert.equals(getline(1),   '[]',         'failed at #308')
  call g:assert.equals(getline(2),   '[]',         'failed at #308')
  call g:assert.equals(getline(3),   '[]',         'failed at #308')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #308')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #308')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #308')

  %delete

  " #309
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsr["
  call g:assert.equals(getline(1),   'foo[]bar',   'failed at #309')
  call g:assert.equals(getline(2),   'foo[]bar',   'failed at #309')
  call g:assert.equals(getline(3),   'foo[]bar',   'failed at #309')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #309')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #309')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #309')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #310
  call append(0, ['[(foo)]', '[(bar)]', '[(baz)]'])
  execute "normal gg\<C-v>2j6l3sr({"
  call g:assert.equals(getline(1),   '({foo})',    'failed at #310')
  call g:assert.equals(getline(2),   '({bar})',    'failed at #310')
  call g:assert.equals(getline(3),   '({baz})',    'failed at #310')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #310')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #310')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #310')

  %delete

  " #311
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #311')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #311')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #311')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #311')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #311')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #311')

  %delete

  " #312
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({afoob})',   'failed at #312')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #312')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #312')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #312')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #312')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #312')

  %delete

  " #313
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #313')
  call g:assert.equals(getline(2),   '({abarb})',   'failed at #313')
  call g:assert.equals(getline(3),   '({[baz]})',   'failed at #313')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #313')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #313')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #313')

  %delete

  " #314
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sr({["
  call g:assert.equals(getline(1),   '({[foo]})',   'failed at #314')
  call g:assert.equals(getline(2),   '({[bar]})',   'failed at #314')
  call g:assert.equals(getline(3),   '({abazb})',   'failed at #314')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #314')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #314')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #314')
endfunction
"}}}
function! s:suite.blockwise_x_external_textobj() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i[', 'a[']},
        \   {'external': ['i(', 'a(']},
        \   {'external': ['it', 'at']},
        \ ]

  " #315
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #315')
  call g:assert.equals(getline(2), '"bar"', 'failed at #315')
  call g:assert.equals(getline(3), '"baz"', 'failed at #315')

  %delete

  " #316
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #316')
  call g:assert.equals(getline(2), '"bar"', 'failed at #316')
  call g:assert.equals(getline(3), '"baz"', 'failed at #316')

  %delete

  " #317
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #317')
  call g:assert.equals(getline(2), '"bar"', 'failed at #317')
  call g:assert.equals(getline(3), '"baz"', 'failed at #317')

  %delete

  " #318
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #318')
  call g:assert.equals(getline(2), '"bar"', 'failed at #318')
  call g:assert.equals(getline(3), '"baz"', 'failed at #318')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #319
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #319')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #319')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #319')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #319')

  " #320
  execute "normal \<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #320')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #320')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #320')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #320')

  %delete

  """ keep
  " #321
  call operator#sandwich#set('replace', 'block', 'cursor', 'keep')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #321')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #321')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #321')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #321')

  " #322
  execute "normal 2h\<C-v>2k4hsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #322')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #322')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #322')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #322')

  %delete

  """ inner_tail
  " #323
  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_tail')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #323')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #323')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #323')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #323')

  " #324
  execute "normal gg2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #324')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #324')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #324')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #324')

  %delete

  """ front
  " #325
  call operator#sandwich#set('replace', 'block', 'cursor', 'front')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #325')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #325')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #325')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #325')

  " #326
  execute "normal 2l\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #326')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #326')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #326')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #326')

  %delete

  """ end
  " #327
  call operator#sandwich#set('replace', 'block', 'cursor', 'end')
  call append(0, ['(((foo)))', '(((bar)))', '(((baz)))'])
  execute "normal gg\<C-v>2j8l2sr[]"
  call g:assert.equals(getline(1),  '[[(foo)]]',  'failed at #327')
  call g:assert.equals(getline(2),  '[[(bar)]]',  'failed at #327')
  call g:assert.equals(getline(3),  '[[(baz)]]',  'failed at #327')
  call g:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #327')

  " #328
  execute "normal 6h2k\<C-v>2j4lsr["
  call g:assert.equals(getline(1),  '[[[foo]]]',  'failed at #328')
  call g:assert.equals(getline(2),  '[[[bar]]]',  'failed at #328')
  call g:assert.equals(getline(3),  '[[[baz]]]',  'failed at #328')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #328')

  call operator#sandwich#set('replace', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #329
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #329')
  call g:assert.equals(getline(2), '"bar"', 'failed at #329')
  call g:assert.equals(getline(3), '"baz"', 'failed at #329')

  %delete

  " #330
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '(foo)', 'failed at #330')
  call g:assert.equals(getline(2), '(bar)', 'failed at #330')
  call g:assert.equals(getline(3), '(baz)', 'failed at #330')

  %delete

  """ off
  " #331
  call operator#sandwich#set('replace', 'block', 'noremap', 0)
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '{foo}', 'failed at #331')
  call g:assert.equals(getline(2), '{bar}', 'failed at #331')
  call g:assert.equals(getline(3), '{baz}', 'failed at #331')

  %delete

  " #332
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #332')
  call g:assert.equals(getline(2), '"bar"', 'failed at #332')
  call g:assert.equals(getline(3), '"baz"', 'failed at #332')

  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  xunmap i{
  xunmap a{
  call operator#sandwich#set('replace', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #333
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #333')
  call g:assert.equals(getline(2), '"bar"', 'failed at #333')
  call g:assert.equals(getline(3), '"baz"', 'failed at #333')

  %delete

  " #334
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"88foo88"', 'failed at #334')
  call g:assert.equals(getline(2), '"88bar88"', 'failed at #334')
  call g:assert.equals(getline(3), '"88baz88"', 'failed at #334')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'regex', 1)
  " #335
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsr\""
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #335')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #335')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #335')

  %delete

  " #336
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), '"foo"', 'failed at #336')
  call g:assert.equals(getline(2), '"bar"', 'failed at #336')
  call g:assert.equals(getline(3), '"baz"', 'failed at #336')

  call operator#sandwich#set('replace', 'block', 'regex', 0)
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """ on
  " #337
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #337')
  call g:assert.equals(getline(2), '(bar)', 'failed at #337')
  call g:assert.equals(getline(3), '(baz)', 'failed at #337')

  %delete

  " #338
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' (foo)', 'failed at #338')
  call g:assert.equals(getline(2), ' (bar)', 'failed at #338')
  call g:assert.equals(getline(3), ' (baz)', 'failed at #338')

  %delete

  " #339
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '(foo) ', 'failed at #339')
  call g:assert.equals(getline(2), '(bar) ', 'failed at #339')
  call g:assert.equals(getline(3), '(baz) ', 'failed at #339')

  %delete

  " #340
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #340')
  call g:assert.equals(getline(2), '("bar")', 'failed at #340')
  call g:assert.equals(getline(3), '("baz")', 'failed at #340')

  %delete

  """ off
  call operator#sandwich#set('replace', 'block', 'skip_space', 0)
  " #341
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsr("
  call g:assert.equals(getline(1), '(foo)', 'failed at #341')
  call g:assert.equals(getline(2), '(bar)', 'failed at #341')
  call g:assert.equals(getline(3), '(baz)', 'failed at #341')

  %delete

  " #342
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsr("
  call g:assert.equals(getline(1), ' "foo"', 'failed at #342')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #342')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #342')

  %delete

  " #343
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg\<C-v>2j5lsr("
  call g:assert.equals(getline(1), '"foo" ', 'failed at #343')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #343')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #343')

  %delete

  " #344
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsr("
  call g:assert.equals(getline(1), '("foo")', 'failed at #344')
  call g:assert.equals(getline(2), '("bar")', 'failed at #344')
  call g:assert.equals(getline(3), '("baz")', 'failed at #344')

  call operator#sandwich#set('replace', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #345
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #345')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #345')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #345')

  %delete

  """ on
  call operator#sandwich#set('replace', 'block', 'skip_char', 1)
  " #346
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsr\""
  call g:assert.equals(getline(1), 'aa"foo"bb', 'failed at #346')
  call g:assert.equals(getline(2), 'aa"bar"bb', 'failed at #346')
  call g:assert.equals(getline(3), 'aa"baz"bb', 'failed at #346')

  call operator#sandwich#set('replace', 'block', 'skip_char', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('replace', 'block', 'command', ["normal! `[d\<C-v>`]"])

  " #347
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsr\""
  call g:assert.equals(getline(1), '""', 'failed at #347')
  call g:assert.equals(getline(2), '""', 'failed at #347')
  call g:assert.equals(getline(3), '""', 'failed at #347')

  call operator#sandwich#set('replace', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #347
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr([{"
  call g:assert.equals(getline(1), '([{foo}])',  'failed at #347')
  call g:assert.equals(getline(2), '([{bar}])',  'failed at #347')
  call g:assert.equals(getline(3), '([{baz}])',  'failed at #347')

  %delete

  """ on
  " #348
  call operator#sandwich#set('replace', 'block', 'query_once', 1)
  call append(0, ['"""foo"""', '"""bar"""', '"""baz"""'])
  execute "normal gg\<C-v>2j8l3sr("
  call g:assert.equals(getline(1), '(((foo)))',  'failed at #348')
  call g:assert.equals(getline(2), '(((bar)))',  'failed at #348')
  call g:assert.equals(getline(3), '(((baz)))',  'failed at #348')

  call operator#sandwich#set('replace', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #349
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #349')

  %delete

  """ 1
  " #350
  call operator#sandwich#set('replace', 'block', 'eval', 1)
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg\<C-v>2j4lsra"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #350')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.

  unlet! g:operator#sandwich#recipes
  call operator#sandwich#set('replace', 'block', 'eval', 0)
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
