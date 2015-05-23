let s:suite = themis#suite('operator-sandwich: add:')

function! s:suite.before_each() abort "{{{
  %delete
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

" character-wise
function! s:suite.charwise_n_default_recipes() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0saiw]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0saiw>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_not_registered() abort "{{{
  " #9
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #9')

  " #10
  call setline('.', 'foo')
  normal 0saiw*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #10')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #11
  call setline('.', 'foobar')
  normal 0sa3l(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #11')

  " #12
  call setline('.', 'foobar')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #12')

  " #13
  call setline('.', 'foobarbaz')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #13')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #14
  call setline('.', 'foobarbaz')
  normal 0saii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #14')

  " #15
  call setline('.', 'foobarbaz')
  normal 02lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #15')

  " #16
  call setline('.', 'foobarbaz')
  normal 03lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #16')

  " #17
  call setline('.', 'foobarbaz')
  normal 05lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #17')

  " #18
  call setline('.', 'foobarbaz')
  normal 06lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #18')

  " #19
  call setline('.', 'foobarbaz')
  normal 08lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #19')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  %delete

  " #20
  set whichwrap=h,l
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa11l(
  call g:assert.equals(getline(1),   '(foo',       'failed at #20')
  call g:assert.equals(getline(2),   'bar',        'failed at #20')
  call g:assert.equals(getline(3),   'baz)',       'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #20')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #21
  call setline('.', 'a')
  normal 0sal(
  call g:assert.equals(getline('.'), '(a)',        'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #21')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #21')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \   {'buns': ["cc\n cc", "ccc\n  "], 'input':['c']},
        \ ]

  " #22
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1),   'aa',         'failed at #22')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #22')
  call g:assert.equals(getline(3),   'aa',         'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #22')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #22')

  %delete

  " #23
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline(1),   'bb',         'failed at #23')
  call g:assert.equals(getline(2),   'bbb',        'failed at #23')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #23')
  call g:assert.equals(getline(4),   'bbb',        'failed at #23')
  call g:assert.equals(getline(5),   'bb',         'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #23')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #24
  call setline('.', 'foobarbaz')
  normal ggsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #24')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #24')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #24')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #24')

  %delete

  " #25
  call setline('.', 'foobarbaz')
  normal gg2lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #25')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #25')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #25')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #25')

  %delete

  " #26
  call setline('.', 'foobarbaz')
  normal gg3lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #26')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #26')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #26')

  %delete

  " #27
  call setline('.', 'foobarbaz')
  normal gg5lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #27')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #27')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #27')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #27')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #27')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #27')

  %delete

  " #28
  call setline('.', 'foobarbaz')
  normal gg6lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #28')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #28')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #28')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #28')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #28')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #28')

  %delete

  " #29
  call setline('.', 'foobarbaz')
  normal gg$saiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #29')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #29')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #29')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #29')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #29')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #29')

  %delete

  set autoindent
  onoremap ii :<C-u>call TextobjCoord(1, 8, 1, 10)<CR>

  " #30
  call setline('.', '    foobarbaz')
  normal ggsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #30')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #30')
  call g:assert.equals(getline(3),   '      baz',     'failed at #30')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],    'failed at #30')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #30')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #30')

  %delete

  " #31
  call setline('.', '    foobarbaz')
  normal gg2lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #31')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #31')
  call g:assert.equals(getline(3),   '      baz',     'failed at #31')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],    'failed at #31')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #31')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #31')

  %delete

  " #32
  call setline('.', '    foobarbaz')
  normal gg3lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #32')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #32')
  call g:assert.equals(getline(3),   '      baz',     'failed at #32')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0],    'failed at #32')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #32')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #32')

  %delete

  " #33
  call setline('.', '    foobarbaz')
  normal gg5lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #33')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #33')
  call g:assert.equals(getline(3),   '      baz',     'failed at #33')
  call g:assert.equals(getpos('.'),  [0, 2, 10, 0],   'failed at #33')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #33')
  call g:assert.equals(getpos("']"), [0, 3,  7, 0],   'failed at #33')

  %delete

  " #34
  call setline('.', '    foobarbaz')
  normal gg6lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #34')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #34')
  call g:assert.equals(getline(3),   '      baz',     'failed at #34')
  call g:assert.equals(getpos('.'),  [0, 3, 7, 0],    'failed at #34')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #34')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #34')

  %delete

  " #35
  call setline('.', '    foobarbaz')
  normal gg$saiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #35')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #35')
  call g:assert.equals(getline(3),   '      baz',     'failed at #35')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #35')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #35')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0],    'failed at #35')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #36
  call setline('.', 'foo')
  normal 02saiw([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #36')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #36')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #36')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #36')

  " #37
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #37')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #37')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #37')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #37')

  " #38
  call setline('.', 'foo bar')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #38')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #38')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #38')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #38')

  " #39
  call setline('.', 'foo bar')
  normal 0sa3iw(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #39')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #39')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #39')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #39')

  " #40
  call setline('.', 'foo bar')
  normal 02sa3iw([
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #40')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #40')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #40')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #40')

  " #41
  call setline('.', 'foobarbaz')
  normal 03l2sa3l([
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #41')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #41')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #41')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #41')

  " #42
  call setline('.', 'foobarbaz')
  normal 03l3sa3l([{
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #42')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #42')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #42')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #42')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #43
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #43')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #43')

  " #44
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #44')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #44')

  """ keep
  " #45
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #45')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #45')

  " #46
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #46')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #46')

  """ inner_tail
  " #47
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #47')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #47')

  " #48
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #48')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #48')

  """ front
  " #49
  call operator#sandwich#set('add', 'char', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #49')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #49')

  " #50
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #50')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #50')

  """ end
  " #51
  call operator#sandwich#set('add', 'char', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #51')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #51')

  " #52
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #52')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #52')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #53
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #53')

  %delete

  """ on
  " #54
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #54')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #55
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #55')

  """ 1
  " #56
  call operator#sandwich#set('add', 'char', 'eval', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #56')

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
  " #57
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #57')

  """ off
  " #58
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #58')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'char', 'noremap', 1)
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #59
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #59')

  """ on
  " #60
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #60')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  """"" command
  " #61
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '()',  'failed at #61')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #62
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #62')
  call g:assert.equals(getline(2), 'foo', 'failed at #62')
  call g:assert.equals(getline(3), ')',   'failed at #62')

  %delete

  " #63
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #63')
  call g:assert.equals(getline(2),   '    foo',    'failed at #63')
  call g:assert.equals(getline(3),   '    )',      'failed at #63')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #63')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #63')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #63')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #64
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #64')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #64')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #64')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #64')

  " #65
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #65')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #65')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #65')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #65')

  " #66
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #66')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #66')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #66')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #66')

  " #67
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #67')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #67')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #67')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #67')

  " #68
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #68')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #68')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #68')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #68')

  " #69
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #69')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #69')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #69')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #69')

  " #70
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #70')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #70')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #70')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #70')

  " #71
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #71')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #71')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #71')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #71')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #72
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #72')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #72')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #72')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #72')

  " #73
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #73')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #73')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #73')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #73')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #74
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #74')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #74')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #74')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #74')

  " #75
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #75')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #75')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #75')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #75')

  " #76
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #76')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #76')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #76')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #76')

  " #77
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #77')
  call g:assert.equals(getline(2),   'bar',        'failed at #77')
  call g:assert.equals(getline(3),   'baz)',       'failed at #77')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #77')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #77')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #77')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #78
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #78')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #78')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #78')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #78')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #79
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #79')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #79')
  call g:assert.equals(getline(3), 'aa',           'failed at #79')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #79')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #79')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #79')

  %delete

  " #80
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #80')
  call g:assert.equals(getline(2),   'bbb',        'failed at #80')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #80')
  call g:assert.equals(getline(4),   'bbb',        'failed at #80')
  call g:assert.equals(getline(5),   'bb',         'failed at #80')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #80')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #80')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #80')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #81
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #81')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #81')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #81')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #81')

  " #82
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #82')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #82')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #82')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #82')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #83
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #83')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #83')

  " #84
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #84')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #84')

  """ keep
  " #85
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #85')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #85')

  " #86
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #86')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #86')

  """ inner_tail
  " #87
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #87')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #87')

  " #88
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #88')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #88')

  """ front
  " #89
  call operator#sandwich#set('add', 'char', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #89')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #89')

  " #90
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #90')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #90')

  """ end
  " #91
  call operator#sandwich#set('add', 'char', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #91')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #91')

  " #92
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #92')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #92')

  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #93
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #93')

  """ on
  " #94
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #94')

  call operator#sandwich#set('add', 'char', 'query_once', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #95
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #95')

  """ 1
  " #96
  call operator#sandwich#set('add', 'char', 'eval', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #96')

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
  " #97
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #97')

  """ off
  " #98
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #98')

  call operator#sandwich#set('add', 'char', 'noremap', 1)
  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ off
  " #99
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #99')

  """ on
  " #100
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #100')

  call operator#sandwich#set('add', 'char', 'skip_space', 0)
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  """"" command
  " #101
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '()',  'failed at #101')

  call operator#sandwich#set('add', 'char', 'command', [])
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  """"" linewise
  """ on
  " #102
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #102')
  call g:assert.equals(getline(2), 'foo', 'failed at #102')
  call g:assert.equals(getline(3), ')',   'failed at #102')

  %delete

  " #103
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #62')
  call g:assert.equals(getline(2),   '    foo',    'failed at #62')
  call g:assert.equals(getline(3),   '    )',      'failed at #62')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #62')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #62')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #62')

  set autoindent&
  call operator#sandwich#set('add', 'char', 'linewise', 0)
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #104
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #104')
  call g:assert.equals(getline(2),   'foo',        'failed at #104')
  call g:assert.equals(getline(3),   ')',          'failed at #104')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #104')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #104')

  %delete

  " #105
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #105')
  call g:assert.equals(getline(2),   'foo',        'failed at #105')
  call g:assert.equals(getline(3),   ')',          'failed at #105')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #105')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #105')

  %delete

  " #106
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #106')
  call g:assert.equals(getline(2),   'foo',        'failed at #106')
  call g:assert.equals(getline(3),   ']',          'failed at #106')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #106')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #106')

  %delete

  " #107
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #107')
  call g:assert.equals(getline(2),   'foo',        'failed at #107')
  call g:assert.equals(getline(3),   ']',          'failed at #107')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #107')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #107')

  %delete

  " #108
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #108')
  call g:assert.equals(getline(2),   'foo',        'failed at #108')
  call g:assert.equals(getline(3),   '}',          'failed at #108')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #108')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #108')

  %delete

  " #109
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #109')
  call g:assert.equals(getline(2),   'foo',        'failed at #109')
  call g:assert.equals(getline(3),   '}',          'failed at #109')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #109')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #109')

  %delete

  " #110
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #110')
  call g:assert.equals(getline(2),   'foo',        'failed at #110')
  call g:assert.equals(getline(3),   '>',          'failed at #110')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #110')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #110')

  %delete

  " #111
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #111')
  call g:assert.equals(getline(2),   'foo',        'failed at #111')
  call g:assert.equals(getline(3),   '>',          'failed at #111')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #111')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #111')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #112
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #112')
  call g:assert.equals(getline(2),   'foo',        'failed at #112')
  call g:assert.equals(getline(3),   'a',          'failed at #112')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #112')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #112')

  %delete

  " #113
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #113')
  call g:assert.equals(getline(2),   'foo',        'failed at #113')
  call g:assert.equals(getline(3),   '*',          'failed at #113')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #113')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #113')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #114
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #114')
  call g:assert.equals(getline(2),   'foo',        'failed at #114')
  call g:assert.equals(getline(3),   'bar',        'failed at #114')
  call g:assert.equals(getline(4),   'baz',        'failed at #114')
  call g:assert.equals(getline(5),   ')',          'failed at #114')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #114')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #114')

  " #115
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #115')
  call g:assert.equals(getline(2),   '(',          'failed at #115')
  call g:assert.equals(getline(3),   'bar',        'failed at #115')
  call g:assert.equals(getline(4),   ')',          'failed at #115')
  call g:assert.equals(getline(5),   'baz',        'failed at #115')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #115')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #115')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #116
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #116')
  call g:assert.equals(getline(2),   'a',          'failed at #116')
  call g:assert.equals(getline(3),   ')',          'failed at #116')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #116')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #116')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #117
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #117')
  call g:assert.equals(getline(2),   'aaa',        'failed at #117')
  call g:assert.equals(getline(3),   'foo',        'failed at #117')
  call g:assert.equals(getline(4),   'aaa',        'failed at #117')
  call g:assert.equals(getline(5),   'aa',         'failed at #117')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #117')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #117')

  %delete

  " #118
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #118')
  call g:assert.equals(getline(2),   'bbb',        'failed at #118')
  call g:assert.equals(getline(3),   'bb',         'failed at #118')
  call g:assert.equals(getline(4),   'foo',        'failed at #118')
  call g:assert.equals(getline(5),   'bb',         'failed at #118')
  call g:assert.equals(getline(6),   'bbb',        'failed at #118')
  call g:assert.equals(getline(7),   'bb',         'failed at #118')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #118')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #118')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #119
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #119')
  call g:assert.equals(getline(2),   '(',          'failed at #119')
  call g:assert.equals(getline(3),   'foo',        'failed at #119')
  call g:assert.equals(getline(4),   ')',          'failed at #119')
  call g:assert.equals(getline(5),   ']',          'failed at #119')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #119')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #119')

  %delete

  " #120
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #120')
  call g:assert.equals(getline(2),   '[',          'failed at #120')
  call g:assert.equals(getline(3),   '(',          'failed at #120')
  call g:assert.equals(getline(4),   'foo',        'failed at #120')
  call g:assert.equals(getline(5),   ')',          'failed at #120')
  call g:assert.equals(getline(6),   ']',          'failed at #120')
  call g:assert.equals(getline(7),   '}',          'failed at #120')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #120')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #120')

  %delete

  " #121
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #121')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #121')
  call g:assert.equals(getline(3), ')',            'failed at #121')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #121')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #121')

  %delete

  " #122
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #122')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #122')
  call g:assert.equals(getline(3), ')',            'failed at #122')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #122')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #122')

  %delete

  " #123
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #123')
  call g:assert.equals(getline(2), '(',            'failed at #123')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #123')
  call g:assert.equals(getline(4), ')',            'failed at #123')
  call g:assert.equals(getline(5), ']',            'failed at #123')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #123')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #123')

  %delete

  " #124
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #124')
  call g:assert.equals(getline(2), '[',            'failed at #124')
  call g:assert.equals(getline(3), '(',            'failed at #124')
  call g:assert.equals(getline(4), 'foo',          'failed at #124')
  call g:assert.equals(getline(5), ')',            'failed at #124')
  call g:assert.equals(getline(6), ']',            'failed at #124')
  call g:assert.equals(getline(7), 'aa',           'failed at #124')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #124')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #124')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #125
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #125')
  call g:assert.equals(getline(2),   '(',          'failed at #125')
  call g:assert.equals(getline(3),   'foo',        'failed at #125')
  call g:assert.equals(getline(4),   ')',          'failed at #125')
  call g:assert.equals(getline(5),   ')',          'failed at #125')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #125')

  " #126
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #126')
  call g:assert.equals(getline(2),   '(',          'failed at #126')
  call g:assert.equals(getline(3),   '(',          'failed at #126')
  call g:assert.equals(getline(4),   'foo',        'failed at #126')
  call g:assert.equals(getline(5),   ')',          'failed at #126')
  call g:assert.equals(getline(6),   ')',          'failed at #126')
  call g:assert.equals(getline(7),   ')',          'failed at #126')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #126')

  %delete

  """ keep
  " #127
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #127')
  call g:assert.equals(getline(2),   '(',          'failed at #127')
  call g:assert.equals(getline(3),   'foo',        'failed at #127')
  call g:assert.equals(getline(4),   ')',          'failed at #127')
  call g:assert.equals(getline(5),   ')',          'failed at #127')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #127')

  " #128
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #128')
  call g:assert.equals(getline(2),   '(',          'failed at #128')
  call g:assert.equals(getline(3),   '(',          'failed at #128')
  call g:assert.equals(getline(4),   'foo',        'failed at #128')
  call g:assert.equals(getline(5),   ')',          'failed at #128')
  call g:assert.equals(getline(6),   ')',          'failed at #128')
  call g:assert.equals(getline(7),   ')',          'failed at #128')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #128')

  %delete

  """ inner_tail
  " #129
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #129')
  call g:assert.equals(getline(2),   '(',          'failed at #129')
  call g:assert.equals(getline(3),   'foo',        'failed at #129')
  call g:assert.equals(getline(4),   ')',          'failed at #129')
  call g:assert.equals(getline(5),   ')',          'failed at #129')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #129')

  " #130
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #130')
  call g:assert.equals(getline(2),   '(',          'failed at #130')
  call g:assert.equals(getline(3),   '(',          'failed at #130')
  call g:assert.equals(getline(4),   'foo',        'failed at #130')
  call g:assert.equals(getline(5),   ')',          'failed at #130')
  call g:assert.equals(getline(6),   ')',          'failed at #130')
  call g:assert.equals(getline(7),   ')',          'failed at #130')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #130')

  %delete

  """ front
  " #131
  call operator#sandwich#set('add', 'line', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #131')
  call g:assert.equals(getline(2),   '(',          'failed at #131')
  call g:assert.equals(getline(3),   'foo',        'failed at #131')
  call g:assert.equals(getline(4),   ')',          'failed at #131')
  call g:assert.equals(getline(5),   ')',          'failed at #131')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #131')

  " #132
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #132')
  call g:assert.equals(getline(2),   '(',          'failed at #132')
  call g:assert.equals(getline(3),   '(',          'failed at #132')
  call g:assert.equals(getline(4),   'foo',        'failed at #132')
  call g:assert.equals(getline(5),   ')',          'failed at #132')
  call g:assert.equals(getline(6),   ')',          'failed at #132')
  call g:assert.equals(getline(7),   ')',          'failed at #132')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #132')

  %delete

  """ end
  " #133
  call operator#sandwich#set('add', 'line', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #133')
  call g:assert.equals(getline(2),   '(',          'failed at #133')
  call g:assert.equals(getline(3),   'foo',        'failed at #133')
  call g:assert.equals(getline(4),   ')',          'failed at #133')
  call g:assert.equals(getline(5),   ')',          'failed at #133')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #133')

  " #134
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #134')
  call g:assert.equals(getline(2),   '(',          'failed at #134')
  call g:assert.equals(getline(3),   '(',          'failed at #134')
  call g:assert.equals(getline(4),   'foo',        'failed at #134')
  call g:assert.equals(getline(5),   ')',          'failed at #134')
  call g:assert.equals(getline(6),   ')',          'failed at #134')
  call g:assert.equals(getline(7),   ')',          'failed at #134')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #134')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #135
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #135')
  call g:assert.equals(getline(2), '[',   'failed at #135')
  call g:assert.equals(getline(3), '(',   'failed at #135')
  call g:assert.equals(getline(4), 'foo', 'failed at #135')
  call g:assert.equals(getline(5), ')',   'failed at #135')
  call g:assert.equals(getline(6), ']',   'failed at #135')
  call g:assert.equals(getline(7), '}',   'failed at #135')

  %delete

  """ on
  " #136
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #136')
  call g:assert.equals(getline(2), '(',   'failed at #136')
  call g:assert.equals(getline(3), '(',   'failed at #136')
  call g:assert.equals(getline(4), 'foo', 'failed at #136')
  call g:assert.equals(getline(5), ')',   'failed at #136')
  call g:assert.equals(getline(6), ')',   'failed at #136')
  call g:assert.equals(getline(7), ')',   'failed at #136')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_n_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #137
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #137')
  call g:assert.equals(getline(2), 'foo', 'failed at #137')
  call g:assert.equals(getline(3), '1+2', 'failed at #137')

  %delete

  """ 1
  " #138
  call operator#sandwich#set('add', 'line', 'eval', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #138')
  call g:assert.equals(getline(2), 'foo', 'failed at #138')
  call g:assert.equals(getline(3), '3',   'failed at #138')

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
  " #139
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '[[',  'failed at #139')
  call g:assert.equals(getline(2), 'foo', 'failed at #139')
  call g:assert.equals(getline(3), ']]',  'failed at #139')

  %delete

  """ off
  " #140
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '{{',  'failed at #140')
  call g:assert.equals(getline(2), 'foo', 'failed at #140')
  call g:assert.equals(getline(3), '}}',  'failed at #140')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #141
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #141')
  call g:assert.equals(getline(2), 'foo ', 'failed at #141')
  call g:assert.equals(getline(3), ')',    'failed at #141')

  %delete

  """ off
  " #142
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #142')
  call g:assert.equals(getline(2), 'foo ', 'failed at #142')
  call g:assert.equals(getline(3), ')',    'failed at #142')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  """"" command
  " #143
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(', 'failed at #143')
  call g:assert.equals(getline(2), '',  'failed at #143')
  call g:assert.equals(getline(3), ')', 'failed at #143')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #144
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #144')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #145
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #145')
  call g:assert.equals(getline(2),   '    foo',    'failed at #145')
  call g:assert.equals(getline(3),   '    )',      'failed at #145')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #145')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #145')

  set autoindent&
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #146
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #146')
  call g:assert.equals(getline(2),   'foo',        'failed at #146')
  call g:assert.equals(getline(3),   ')',          'failed at #146')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #146')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #146')

  %delete

  " #147
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #147')
  call g:assert.equals(getline(2),   'foo',        'failed at #147')
  call g:assert.equals(getline(3),   ')',          'failed at #147')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #147')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #147')

  %delete

  " #148
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #148')
  call g:assert.equals(getline(2),   'foo',        'failed at #148')
  call g:assert.equals(getline(3),   ']',          'failed at #148')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #148')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #148')

  %delete

  " #149
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #149')
  call g:assert.equals(getline(2),   'foo',        'failed at #149')
  call g:assert.equals(getline(3),   ']',          'failed at #149')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #149')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #149')

  %delete

  " #150
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #150')
  call g:assert.equals(getline(2),   'foo',        'failed at #150')
  call g:assert.equals(getline(3),   '}',          'failed at #150')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #150')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #150')

  %delete

  " #151
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #151')
  call g:assert.equals(getline(2),   'foo',        'failed at #151')
  call g:assert.equals(getline(3),   '}',          'failed at #151')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #151')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #151')

  %delete

  " #152
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #152')
  call g:assert.equals(getline(2),   'foo',        'failed at #152')
  call g:assert.equals(getline(3),   '>',          'failed at #152')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #152')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #152')

  %delete

  " #153
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #153')
  call g:assert.equals(getline(2),   'foo',        'failed at #153')
  call g:assert.equals(getline(3),   '>',          'failed at #153')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #153')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #153')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #154
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #154')
  call g:assert.equals(getline(2), 'foo',          'failed at #154')
  call g:assert.equals(getline(3), 'a',            'failed at #154')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #154')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #154')

  %delete

  " #155
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #155')
  call g:assert.equals(getline(2), 'foo',          'failed at #155')
  call g:assert.equals(getline(3), '*',            'failed at #155')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #155')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #155')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #156
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #156')
  call g:assert.equals(getline(2),   'foo',        'failed at #156')
  call g:assert.equals(getline(3),   'bar',        'failed at #156')
  call g:assert.equals(getline(4),   'baz',        'failed at #156')
  call g:assert.equals(getline(5),   ')',          'failed at #156')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #156')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #156')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #157
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #157')
  call g:assert.equals(getline(2),   'a',          'failed at #157')
  call g:assert.equals(getline(3),   ')',          'failed at #157')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #157')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #157')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #158
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #158')
  call g:assert.equals(getline(2),   'aaa',        'failed at #158')
  call g:assert.equals(getline(3),   'foo',        'failed at #158')
  call g:assert.equals(getline(4),   'aaa',        'failed at #158')
  call g:assert.equals(getline(5),   'aa',         'failed at #158')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #158')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #158')

  %delete

  " #159
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #159')
  call g:assert.equals(getline(2),   'bbb',        'failed at #159')
  call g:assert.equals(getline(3),   'bb',         'failed at #159')
  call g:assert.equals(getline(4),   'foo',        'failed at #159')
  call g:assert.equals(getline(5),   'bb',         'failed at #159')
  call g:assert.equals(getline(6),   'bbb',        'failed at #159')
  call g:assert.equals(getline(7),   'bb',         'failed at #159')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #159')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #159')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #160
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #160')
  call g:assert.equals(getline(2),   '(',          'failed at #160')
  call g:assert.equals(getline(3),   'foo',        'failed at #160')
  call g:assert.equals(getline(4),   ')',          'failed at #160')
  call g:assert.equals(getline(5),   ']',          'failed at #160')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #160')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #160')

  %delete

  " #161
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #161')
  call g:assert.equals(getline(2),   '[',          'failed at #161')
  call g:assert.equals(getline(3),   '(',          'failed at #161')
  call g:assert.equals(getline(4),   'foo',        'failed at #161')
  call g:assert.equals(getline(5),   ')',          'failed at #161')
  call g:assert.equals(getline(6),   ']',          'failed at #161')
  call g:assert.equals(getline(7),   '}',          'failed at #161')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #161')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #161')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #162
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #162')
  call g:assert.equals(getline(2),   '(',          'failed at #162')
  call g:assert.equals(getline(3),   'foo',        'failed at #162')
  call g:assert.equals(getline(4),   ')',          'failed at #162')
  call g:assert.equals(getline(5),   ')',          'failed at #162')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #162')

  " #163
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #163')
  call g:assert.equals(getline(2),   '(',          'failed at #163')
  call g:assert.equals(getline(3),   '(',          'failed at #163')
  call g:assert.equals(getline(4),   'foo',        'failed at #163')
  call g:assert.equals(getline(5),   ')',          'failed at #163')
  call g:assert.equals(getline(6),   ')',          'failed at #163')
  call g:assert.equals(getline(7),   ')',          'failed at #163')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #163')

  %delete

  """ keep
  " #164
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #164')
  call g:assert.equals(getline(2),   '(',          'failed at #164')
  call g:assert.equals(getline(3),   'foo',        'failed at #164')
  call g:assert.equals(getline(4),   ')',          'failed at #164')
  call g:assert.equals(getline(5),   ')',          'failed at #164')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #164')

  " #165
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #165')
  call g:assert.equals(getline(2),   '(',          'failed at #165')
  call g:assert.equals(getline(3),   '(',          'failed at #165')
  call g:assert.equals(getline(4),   'foo',        'failed at #165')
  call g:assert.equals(getline(5),   ')',          'failed at #165')
  call g:assert.equals(getline(6),   ')',          'failed at #165')
  call g:assert.equals(getline(7),   ')',          'failed at #165')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #165')

  %delete

  """ inner_tail
  " #166
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #166')
  call g:assert.equals(getline(2),   '(',          'failed at #166')
  call g:assert.equals(getline(3),   'foo',        'failed at #166')
  call g:assert.equals(getline(4),   ')',          'failed at #166')
  call g:assert.equals(getline(5),   ')',          'failed at #166')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #166')

  " #167
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #167')
  call g:assert.equals(getline(2),   '(',          'failed at #167')
  call g:assert.equals(getline(3),   '(',          'failed at #167')
  call g:assert.equals(getline(4),   'foo',        'failed at #167')
  call g:assert.equals(getline(5),   ')',          'failed at #167')
  call g:assert.equals(getline(6),   ')',          'failed at #167')
  call g:assert.equals(getline(7),   ')',          'failed at #167')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #167')

  %delete

  """ front
  " #168
  call operator#sandwich#set('add', 'line', 'cursor', 'front')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #168')
  call g:assert.equals(getline(2),   '(',          'failed at #168')
  call g:assert.equals(getline(3),   'foo',        'failed at #168')
  call g:assert.equals(getline(4),   ')',          'failed at #168')
  call g:assert.equals(getline(5),   ')',          'failed at #168')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #168')

  " #169
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #169')
  call g:assert.equals(getline(2),   '(',          'failed at #169')
  call g:assert.equals(getline(3),   '(',          'failed at #169')
  call g:assert.equals(getline(4),   'foo',        'failed at #169')
  call g:assert.equals(getline(5),   ')',          'failed at #169')
  call g:assert.equals(getline(6),   ')',          'failed at #169')
  call g:assert.equals(getline(7),   ')',          'failed at #169')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #169')

  %delete

  """ end
  " #170
  call operator#sandwich#set('add', 'line', 'cursor', 'end')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #170')
  call g:assert.equals(getline(2),   '(',          'failed at #170')
  call g:assert.equals(getline(3),   'foo',        'failed at #170')
  call g:assert.equals(getline(4),   ')',          'failed at #170')
  call g:assert.equals(getline(5),   ')',          'failed at #170')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #170')

  " #171
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #171')
  call g:assert.equals(getline(2),   '(',          'failed at #171')
  call g:assert.equals(getline(3),   '(',          'failed at #171')
  call g:assert.equals(getline(4),   'foo',        'failed at #171')
  call g:assert.equals(getline(5),   ')',          'failed at #171')
  call g:assert.equals(getline(6),   ')',          'failed at #171')
  call g:assert.equals(getline(7),   ')',          'failed at #171')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #171')

  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #172
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #172')
  call g:assert.equals(getline(2), '[',   'failed at #172')
  call g:assert.equals(getline(3), '(',   'failed at #172')
  call g:assert.equals(getline(4), 'foo', 'failed at #172')
  call g:assert.equals(getline(5), ')',   'failed at #172')
  call g:assert.equals(getline(6), ']',   'failed at #172')
  call g:assert.equals(getline(7), '}',   'failed at #172')

  %delete

  """ on
  " #173
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #173')
  call g:assert.equals(getline(2), '(',   'failed at #173')
  call g:assert.equals(getline(3), '(',   'failed at #173')
  call g:assert.equals(getline(4), 'foo', 'failed at #173')
  call g:assert.equals(getline(5), ')',   'failed at #173')
  call g:assert.equals(getline(6), ')',   'failed at #173')
  call g:assert.equals(getline(7), ')',   'failed at #173')

  call operator#sandwich#set('add', 'line', 'query_once', 0)
endfunction
"}}}
function! s:suite.linewise_x_option_eval() abort  "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #174
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #174')
  call g:assert.equals(getline(2), 'foo', 'failed at #174')
  call g:assert.equals(getline(3), '1+2', 'failed at #174')

  %delete

  """ 1
  " #175
  call operator#sandwich#set('add', 'line', 'eval', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #175')
  call g:assert.equals(getline(2), 'foo', 'failed at #175')
  call g:assert.equals(getline(3), '3',   'failed at #175')

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
  " #176
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '[[',  'failed at #176')
  call g:assert.equals(getline(2), 'foo', 'failed at #176')
  call g:assert.equals(getline(3), ']]',  'failed at #176')

  %delete

  """ off
  " #177
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '{{',  'failed at #177')
  call g:assert.equals(getline(2), 'foo', 'failed at #177')
  call g:assert.equals(getline(3), '}}',  'failed at #177')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'line', 'noremap', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #178
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #178')
  call g:assert.equals(getline(2), 'foo ', 'failed at #178')
  call g:assert.equals(getline(3), ')',    'failed at #178')

  %delete

  """ off
  " #179
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #179')
  call g:assert.equals(getline(2), 'foo ', 'failed at #179')
  call g:assert.equals(getline(3), ')',    'failed at #179')

  call operator#sandwich#set('add', 'line', 'skip_space', 1)
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  """"" command
  " #180
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[dv`]"])
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(', 'failed at #180')
  call g:assert.equals(getline(2), '',  'failed at #180')
  call g:assert.equals(getline(3), ')', 'failed at #180')

  call operator#sandwich#set('add', 'line', 'command', [])
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  """"" linewise
  """ off
  " #181
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #181')

  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #182
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #182')
  call g:assert.equals(getline(2),   '    foo',    'failed at #182')
  call g:assert.equals(getline(3),   '    )',      'failed at #182')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #182')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #182')

  set autoindent&
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #183
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #183')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #183')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #183')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #183')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #183')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #183')

  %delete

  " #184
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #184')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #184')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #184')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #184')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #184')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #184')

  %delete

  " #185
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #185')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #185')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #185')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #185')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #185')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #185')

  %delete

  " #186
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #186')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #186')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #186')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #186')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #186')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #186')

  %delete

  " #187
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #187')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #187')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #187')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #187')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #187')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #187')

  %delete

  " #188
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #188')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #188')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #188')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #188')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #188')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #188')

  %delete

  " #189
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #189')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #189')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #189')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #189')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #189')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #189')

  %delete

  " #190
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #190')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #190')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #190')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #190')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #190')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #190')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #191
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #191')
  call g:assert.equals(getline(2),   'abara',      'failed at #191')
  call g:assert.equals(getline(3),   'abaza',      'failed at #191')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #191')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #191')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #191')

  %delete

  " #192
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #192')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #192')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #192')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #192')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #192')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #192')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #193
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #193')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #193')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #193')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #193')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #193')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #193')

  %delete

  " #194
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #194')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #194')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #194')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #194')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #194')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #194')

  %delete

  " #195
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #195')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #195')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #195')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #195')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #195')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #195')

  %delete

  " #196
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #196')
  call g:assert.equals(getline(2),   '',           'failed at #196')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #196')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #196')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #196')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #196')

  %delete

  " #197
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #197')
  call g:assert.equals(getline(2),   'ba',         'failed at #197')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #197')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #197')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #197')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #197')

  %delete

  " #198
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   'fo',         'failed at #198')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #198')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #198')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #198')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #198')

  %delete

  " #199
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #199')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #199')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #199')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #199')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #199')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #199')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #200
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #200')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #200')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #200')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #200')

  %delete

  " #201
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #201')
  call g:assert.equals(getline(2),   '(a)',        'failed at #201')
  call g:assert.equals(getline(3),   '(a)',        'failed at #201')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #201')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #201')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #201')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #202
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #202')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #202')
  call g:assert.equals(getline(3),   'aa',         'failed at #202')
  call g:assert.equals(getline(4),   'aa',         'failed at #202')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #202')
  call g:assert.equals(getline(6),   'aa',         'failed at #202')
  call g:assert.equals(getline(7),   'aa',         'failed at #202')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #202')
  call g:assert.equals(getline(9),   'aa',         'failed at #202')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #202')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #202')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #202')

  %delete

  " #203
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #203')
  call g:assert.equals(getline(2),   'bbb',         'failed at #203')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #203')
  call g:assert.equals(getline(4),   'bbb',         'failed at #203')
  call g:assert.equals(getline(5),   'bb',          'failed at #203')
  call g:assert.equals(getline(6),   'bb',          'failed at #203')
  call g:assert.equals(getline(7),   'bbb',         'failed at #203')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #203')
  call g:assert.equals(getline(9),   'bbb',         'failed at #203')
  call g:assert.equals(getline(10),  'bb',          'failed at #203')
  call g:assert.equals(getline(11),  'bb',          'failed at #203')
  call g:assert.equals(getline(12),  'bbb',         'failed at #203')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #203')
  call g:assert.equals(getline(14),  'bbb',         'failed at #203')
  call g:assert.equals(getline(15),  'bb',          'failed at #203')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #203')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #203')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #203')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #204
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #204')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #204')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #204')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #204')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #204')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #204')

  %delete

  " #205
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #205')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #205')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #205')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #205')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #205')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #205')

  %delete

  " #206
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #206')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #206')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #206')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #206')

  %delete

  " #207
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #207')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #207')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #207')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #207')

  %delete

  " #208
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #208')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #208')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #208')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #208')
  %delete

  " #209
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #209')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #209')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #209')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #209')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #209')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #209')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  %delete

  """"" cursor
  """ inner_head
  " #210
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #210')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #210')

  " #211
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #211')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #211')

  """ keep
  " #212
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #212')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #212')

  " #213
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #213')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #213')

  """ inner_tail
  " #214
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #214')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #214')

  " #215
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #215')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #215')

  """ front
  " #216
  call operator#sandwich#set('add', 'block', 'cursor', 'front')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #216')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #216')

  " #217
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #217')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #217')

  """ end
  " #218
  call operator#sandwich#set('add', 'block', 'cursor', 'end')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #218')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #218')

  " #219
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #219')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #219')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #220
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #220')

  %delete

  """ on
  " #221
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #221')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_n_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #222
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #222')

  """ 1
  " #223
  call operator#sandwich#set('add', 'block', 'eval', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #223')

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
  " #224
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[[foo]]',  'failed at #224')

  """ off
  " #225
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '{{foo}}',  'failed at #225')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #226
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #226')

  """ off
  " #227
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #227')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  """"" command
  " #228
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '()',  'failed at #228')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #229
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #229')
  call g:assert.equals(getline(2), 'foo', 'failed at #229')
  call g:assert.equals(getline(3), ')',   'failed at #229')

  %delete

  " #230
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #230')
  call g:assert.equals(getline(2),   '    foo',    'failed at #230')
  call g:assert.equals(getline(3),   '    )',      'failed at #230')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #230')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #230')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #230')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #231
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #231')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #231')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #231')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #231')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #231')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #231')

  " #232
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #232')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #232')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #232')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #232')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #232')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #232')

  " #233
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #233')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #233')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #233')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #233')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #233')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #233')

  " #234
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #234')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #234')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #234')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #234')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #234')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #234')

  " #235
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #235')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #235')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #235')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #235')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #235')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #235')

  " #236
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #236')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #236')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #236')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #236')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #236')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #236')

  " #237
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #237')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #237')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #237')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #237')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #237')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #237')

  " #238
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #238')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #238')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #238')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #238')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #238')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #238')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #239
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #239')
  call g:assert.equals(getline(2),   'abara',      'failed at #239')
  call g:assert.equals(getline(3),   'abaza',      'failed at #239')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #239')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #239')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #239')

  %delete

  " #240
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #240')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #240')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #240')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #240')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #240')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #240')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #241
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #241')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #241')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #241')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #241')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #241')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #241')

  %delete

  " #242
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #242')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #242')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #242')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #242')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #242')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #242')

  %delete

  " #243
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #243')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #243')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #243')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #243')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #243')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #243')

  %delete

  " #244
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #244')
  call g:assert.equals(getline(2),   '',           'failed at #244')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #244')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #244')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #244')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #244')

  %delete

  " #245
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #245')
  call g:assert.equals(getline(2),   'ba',         'failed at #245')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #245')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #245')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #245')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #245')

  %delete

  " #246
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'fo',         'failed at #246')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #246')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #246')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #246')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #246')

  %delete

  " #247
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #247')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #247')
  call g:assert.equals(getline(3),   'ba',         'failed at #247')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #247')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #247')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #247')

  %delete

  " #248
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #248')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #248')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #248')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #248')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #248')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #248')

  %delete

  """ terminal-extended block-wise visual mode
  " #249
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #249')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #249')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #249')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #249')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #249')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #249')

  %delete

  " #250
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #250')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #250')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #250')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #250')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #250')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #250')

  %delete

  " #251
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #251')
  call g:assert.equals(getline(2),   '',           'failed at #251')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #251')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #251')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #251')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #251')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #252
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #252')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #252')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #252')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #252')

  %delete

  " #253
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #253')
  call g:assert.equals(getline(2),   '(a)',        'failed at #253')
  call g:assert.equals(getline(3),   '(a)',        'failed at #253')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #253')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #253')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #253')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #254
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #254')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #254')
  call g:assert.equals(getline(3),   'aa',         'failed at #254')
  call g:assert.equals(getline(4),   'aa',         'failed at #254')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #254')
  call g:assert.equals(getline(6),   'aa',         'failed at #254')
  call g:assert.equals(getline(7),   'aa',         'failed at #254')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #254')
  call g:assert.equals(getline(9),   'aa',         'failed at #254')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #254')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #254')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #254')

  %delete

  " #255
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #255')
  call g:assert.equals(getline(2),   'bbb',         'failed at #255')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #255')
  call g:assert.equals(getline(4),   'bbb',         'failed at #255')
  call g:assert.equals(getline(5),   'bb',          'failed at #255')
  call g:assert.equals(getline(6),   'bb',          'failed at #255')
  call g:assert.equals(getline(7),   'bbb',         'failed at #255')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #255')
  call g:assert.equals(getline(9),   'bbb',         'failed at #255')
  call g:assert.equals(getline(10),  'bb',          'failed at #255')
  call g:assert.equals(getline(11),  'bb',          'failed at #255')
  call g:assert.equals(getline(12),  'bbb',         'failed at #255')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #255')
  call g:assert.equals(getline(14),  'bbb',         'failed at #255')
  call g:assert.equals(getline(15),  'bb',          'failed at #255')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #255')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #255')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #255')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #256
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #256')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #256')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #256')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #256')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #256')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #256')

  %delete

  " #257
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #257')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #257')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #257')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #257')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #257')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #257')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ inner_head
  " #258
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #258')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #258')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #258')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #258')

  " #259
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #259')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #259')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #259')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #259')

  %delete

  """ keep
  " #260
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #260')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #260')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #260')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #260')

  " #261
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #261')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #261')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #261')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #261')

  %delete

  """ inner_tail
  " #262
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #262')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #262')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #262')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #262')

  " #263
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #263')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #263')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #263')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #263')

  %delete

  """ front
  " #264
  call operator#sandwich#set('add', 'block', 'cursor', 'front')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #264')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #264')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #264')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #264')

  " #265
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #265')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #265')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #265')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #265')

  %delete

  """ end
  " #266
  call operator#sandwich#set('add', 'block', 'cursor', 'end')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #266')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #266')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #266')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #266')

  " #267
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #267')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #267')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #267')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #267')

  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  """"" query_once
  """ off
  " #268
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #268')

  %delete

  """ on
  " #269
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #269')

  call operator#sandwich#set('add', 'block', 'query_once', 0)
endfunction
"}}}
function! s:suite.blockwise_x_option_eval() abort "{{{
  """"" eval
  let g:operator#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input':['a']}]

  """ 0
  " #270
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #270')

  """ 1
  " #271
  call operator#sandwich#set('add', 'block', 'eval', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #271')

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
  " #272
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '[[foo]]', 'failed at #272')

  """ off
  " #273
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '{{foo}}', 'failed at #273')

  unlet! g:operator#sandwich#recipes
  iunmap [
  iunmap ]
  call operator#sandwich#set('add', 'block', 'noremap', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  """"" skip_space
  """ on
  " #274
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #274')

  """ off
  " #275
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #275')

  call operator#sandwich#set('add', 'block', 'skip_space', 1)
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  """"" command
  " #276
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[dv`]'])
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline('.'), '()',  'failed at #276')

  call operator#sandwich#set('add', 'block', 'command', [])
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  """"" add_linewise
  """ on
  " #277
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #277')
  call g:assert.equals(getline(2), 'foo', 'failed at #277')
  call g:assert.equals(getline(3), ')',   'failed at #277')

  %delete

  " #278
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #278')
  call g:assert.equals(getline(2),   '    foo',    'failed at #278')
  call g:assert.equals(getline(3),   '    )',      'failed at #278')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #278')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #278')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #278')

  set autoindent&
  call operator#sandwich#set('add', 'block', 'linewise', 0)
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
