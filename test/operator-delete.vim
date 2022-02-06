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
  silent! xunmap ii
  silent! ounmap ssd
  silent! xunmap i{
  silent! xunmap a{
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  unlet! g:sandwich#input_fallback
  call operator#sandwich#set_default()
  call visualmode(1)
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  nmap sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap sd <Plug>(operator-sandwich-delete)
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

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['add']},
        \ ]

  " #2
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['delete']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['replace']},
        \ ]

  " #4
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['operator']},
        \ ]

  " #5
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'kind': ['all']},
        \ ]

  " #6
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['all']},
        \ ]

  " #4
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['char']},
        \ ]

  " #7
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')

  " #9
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['line']},
        \ ]

  " #10
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #10')

  " #11
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  " #12
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #12')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'motionwise': ['block']},
        \ ]

  " #13
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #13')

  " #14
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #14')

  " #15
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'foo', 'failed at #15')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['n']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'mode': ['x']},
        \ ]

  " #5
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  " #6
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['all']},
        \ ]

  " #2
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['add']},
        \ ]

  " #3
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'action': ['delete']},
        \ ]

  " #4
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')
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

  " #1
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')
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
  " #1
  call setline('.', 'afooa')
  normal 0sdiw
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '*foo*')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #1
  call setline('.', '(foo)bar')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', 'foo(bar)')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #2')

  " #3
  call setline('.', 'foo(bar)baz')
  normal 0fbsda(
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 10)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  let g:operator#sandwich#recipes = [{'buns': ['((', '))']}]

  " #4
  call setline('.', 'foo((bar))baz')
  normal 0sdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #4')

  " #5
  call setline('.', 'foo((bar))baz')
  normal 02lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #5')

  " #6
  call setline('.', 'foo((bar))baz')
  normal 03lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #6')

  " #7
  call setline('.', 'foo((bar))baz')
  normal 04lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #7')

  " #8
  call setline('.', 'foo((bar))baz')
  normal 05lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #8')

  " #9
  call setline('.', 'foo((bar))baz')
  normal 07lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #9')

  " #10
  call setline('.', 'foo((bar))baz')
  normal 08lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #10')

  " #11
  call setline('.', 'foo((bar))baz')
  normal 09lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #11')

  " #12
  call setline('.', 'foo((bar))baz')
  normal 010lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #12')

  " #13
  call setline('.', 'foo((bar))baz')
  normal 012lsdii
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #13')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet g:operator#sandwich#recipes

  " #14
  set whichwrap=h,l
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsd13l
  call g:assert.equals(getline(1),   'foo',        'failed at #14')
  call g:assert.equals(getline(2),   'bar',        'failed at #14')
  call g:assert.equals(getline(3),   'baz',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #14')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #2')
  call g:assert.equals(getline(2),   'a',          'failed at #2')
  call g:assert.equals(getline(3),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(a', ')'])
  normal ggsda(
  call g:assert.equals(getline(1),   'a',          'failed at #3')
  call g:assert.equals(getline(2),   '',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(', 'a)'])
  normal ggsda(
  call g:assert.equals(getline(1),   '',           'failed at #4')
  call g:assert.equals(getline(2),   'a',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0sd2l
  call g:assert.equals(getline('.'), '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo()bar')
  normal 03lsd2l
  call g:assert.equals(getline('.'), 'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete
  set whichwrap=h,l

  " #3
  call append(0, ['(', ')'])
  normal ggsd3l
  call g:assert.equals(getline(1),   '',           'failed at #3')
  call g:assert.equals(getline(2),   '',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #3')

  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd15l
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd21l
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 3, 2)<CR>
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')

  " #3
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggjsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj3lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj5lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #10')

  %delete

  " #11
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj6lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal ggj8lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #13')

  %delete

  " #14
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2jlsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j2lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['fooaa', 'aaabaraaa', 'aabaz'])
  normal gg2j4lsdii
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #16')

  ounmap ii
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #1
  call setline('.', '((foo))')
  normal 02sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 03sd$
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '[(foo bar)]')
  normal 02sd11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #4')

  " #5
  call setline('.', 'foo{[(bar)]}baz')
  normal 03l3sd9l
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #5')
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

  " #1
  call setline('.', '{[(foo)]}')
  normal 02lsd5l
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0lsd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  " #3
  call setline('.', '{[(foo)]}')
  normal 0sd9l
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0sd5l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', '(α)')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'α',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #1')

  " #2
  call setline('.', '(aα)')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'aα',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'αaα')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'a',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  " #4
  call setline('.', 'ααα')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'α',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #4')

  " #5
  call setline('.', 'αaαα')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'aα',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'aαaaα')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'a',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #6')

  " #7
  call setline('.', 'aααaα')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'α',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'aαaαaα')
  normal 0sd6l
  call g:assert.equals(getline('.'), 'aα',         'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #8')

  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '(“)')
  normal 0sd3l
  call g:assert.equals(getline('.'), '“',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #9')

  " #10
  call setline('.', '(a“)')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'a“',         'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', '“a“')
  normal 0sd3l
  call g:assert.equals(getline('.'), 'a',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #11')

  " #12
  call setline('.', '“““')
  normal 0sd3l
  call g:assert.equals(getline('.'), '“',          'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #12')

  " #13
  call setline('.', '“a““')
  normal 0sd4l
  call g:assert.equals(getline('.'), 'a“',         'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a“aa“')
  normal 0sd5l
  call g:assert.equals(getline('.'), 'a',          'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #14')

  " #15
  call setline('.', 'a““a“')
  normal 0sd5l
  call g:assert.equals(getline('.'), '“',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'a“a“a“')
  normal 0sd6l
  call g:assert.equals(getline('.'), 'a“',         'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  " #3
  call setline('.', '(    foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '    foo',    'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')

  """ inner_head
  " #4
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')

  " #5
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')

  " #7
  normal 2lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #8')

  " #9
  normal hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('delete', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')

  " #11
  normal 3lsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('delete', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0l2sd%
  call g:assert.equals(getline('.'), '(foo)',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #12')

  " #13
  normal 3hsda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #4')

  """ off
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0sd7l
  call g:assert.equals(getline('.'), '(foo)', 'failed at #7')

  " #8
  call setline('.', '{(foo)}')
  normal 0lsd5l
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0sd$
  call g:assert.equals(getline('.'), '88foo88', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]

  """ 1
  " #1
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #3')

  " #4
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'char', 'skip_space', 2)

  " #6
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo ', 'failed at #8')

  " #9
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo ', 'failed at #9')

  " " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sd$
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #15')
endfunction
"}}}
function! s:suite.charwise_n_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  " #1
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call operator#sandwich#set('delete', 'char', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '', 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'aa',         'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd9l
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'aa',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   '',           'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  %delete

  """ 2
  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggsd7l
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd11l
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsd5l
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   'bb',         'failed at #10')
  call g:assert.equals(getline(3),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsd9l
  call g:assert.equals(getline(1),   '',           'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes

  set whichwrap&
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #1
  call setline('.', 'afooa')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '*foo*')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #1
  call setline('.', '(foo)bar')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', 'foo(bar)')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #2')

  " #3
  call setline('.', 'foo(bar)baz')
  normal 03lv4lsd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggv2j3lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.charwise_x_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0vlsd
  call g:assert.equals(getline('.'), '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo()bar')
  normal 03lvlsd
  call g:assert.equals(getline('.'), 'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(', ')'])
  normal ggvjsd
  call g:assert.equals(getline(1),   '',           'failed at #3')
  call g:assert.equals(getline(2),   '',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggv2jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggv4jlsd
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #1
  call setline('.', '((foo))')
  normal 0v$2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0v$3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', 'foo{[(bar)]}baz')
  normal 03lv8l3sd
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')
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

  " #1
  call setline('.', '{[(foo)]}')
  normal 02lv4lsd
  call g:assert.equals(getline('.'), '{[foo]}', 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0lv6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  " #3
  call setline('.', '{[(foo)]}')
  normal 0v8lsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0v$sd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', '(α)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #1')

  " #2
  call setline('.', '(aα)')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'αaα')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  " #4
  call setline('.', 'ααα')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #4')

  " #5
  call setline('.', 'αaαα')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'aαaaα')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #6')

  " #7
  call setline('.', 'aααaα')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'α',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'aαaαaα')
  normal 0v5lsd
  call g:assert.equals(getline('.'), 'aα',         'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #8')

  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '(“)')
  normal 0v2lsd
  call g:assert.equals(getline('.'), '“',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #9')

  " #10
  call setline('.', '(a“)')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', '“a“')
  normal 0v2lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #11')

  " #12
  call setline('.', '“““')
  normal 0v2lsd
  call g:assert.equals(getline('.'), '“',          'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #12')

  " #13
  call setline('.', '“a““')
  normal 0v3lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a“aa“')
  normal 0v4lsd
  call g:assert.equals(getline('.'), 'a',          'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #14')

  " #15
  call setline('.', 'a““a“')
  normal 0v4lsd
  call g:assert.equals(getline('.'), '“',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'a“a“a“')
  normal 0v5lsd
  call g:assert.equals(getline('.'), 'a“',         'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  " #3
  call setline('.', '(    foo)')
  normal 0v$sd
  call g:assert.equals(getline('.'), '    foo',    'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')

  """ inner_head
  " #4
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')

  " #5
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('delete', 'char', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #6')

  " #7
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #8')

  " #9
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('delete', 'char', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0lv%2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')

  " #11
  normal va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('delete', 'char', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0lv%o2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #12')

  " #13
  normal va(osd
  call g:assert.equals(getline('.'), 'foo',        'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'char', 'cursor', 'inner_tail')
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #4')

  """ off
  call operator#sandwich#set('delete', 'char', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0v6lsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #7')

  " #8
  call setline('.', '{(foo)}')
  normal 0lv4lsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  """ on
  call operator#sandwich#set('delete', 'char', 'regex', 1)
  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0v$sd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]

  """ 1
  " #1
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #3')

  " #4
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'char', 'skip_space', 2)

  " #6
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #8')

  " #9
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'char', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0v$sd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0v$sd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call setline('.', ' "foo"')
  normal 0sd$
  call g:assert.equals(getline('.'), ' foo', 'failed at #15')
endfunction
"}}}
function! s:suite.charwise_x_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('delete', 'char', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0v$sd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0sd$
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  " #1
  call operator#sandwich#set('delete', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call operator#sandwich#set('delete', 'char', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '(foo)')
  normal 0va(sd
  call g:assert.equals(getline('.'), '', 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'char', 'linewise', 1)

  """ 1
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'aa',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 2, 3, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   '',           'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  %delete

  call operator#sandwich#set('delete', 'char', 'linewise', 2)

  """ 2
  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggv2j2lsd
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjv4lsd
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   'bb',         'failed at #10')
  call g:assert.equals(getline(3),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggv2jsd
  call g:assert.equals(getline(1),   '',           'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes

  set whichwrap&
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['[', 'foo', ']'])
  normal ggsdVa[
  call g:assert.equals(getline('.'), 'foo',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['{', 'foo', '}'])
  normal ggsdVa{
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['<', 'foo', '>'])
  normal ggsdVa<
  call g:assert.equals(getline('.'), 'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #1
  call setline('.', 'afooa')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '*foo*')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['a', 'foo', 'a'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['*', 'foo', '*'])
  normal ggsd2j
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #1
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getline(4),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal gg2jsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getline(4),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggsdVa(
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0sdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(a', ')'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(', 'a)'])
  normal ggsdVa(
  call g:assert.equals(getline('.'), 'a',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0sdVl
  call g:assert.equals(getline('.'), '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', ')'])
  normal ggsdj
  call g:assert.equals(getline(1),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsd4j
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sd6j
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sd10j
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #1
  call setline('.', '((foo))')
  normal 02sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 03sdV$
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0sdV5l
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '[(foo bar)]')
  normal 02sdV11l
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggj3sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'bar',        'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #5')
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

  " #1
  call setline('.', '{[(foo)]}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #1')

  " #2
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0sdV$
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call append(0, ['(', 'α', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'aα', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call append(0, ['α', 'a', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['α', 'α', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['α', 'aα', 'α'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call append(0, ['aα', 'a', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['aα', 'α', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'α', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['aα', 'aα', 'aα'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call append(0, ['(', '“', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['(', 'a“', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['“', 'a', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['“', '“', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['“', 'a“', '“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call append(0, ['a“', 'a', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['a“', '“', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), '“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['a“', 'a“', 'a“'])
  normal ggsd2j
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')

  " #2
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  " #3
  %delete
  call append(0, ['(', '    foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1), '    foo',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')
  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')

  " #5
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03l2sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')

  " #7
  normal lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #8')

  " #9
  normal 2hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 3lsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 02sdVl
  call g:assert.equals(getline('.'), '(foo)',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #12')

  " #13
  normal 3hsdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #4')

  """ off
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0sdVl
  call g:assert.equals(getline('.'), '(foo)', 'failed at #7')

  " #8
  call setline('.', '({foo})')
  normal 0sdVl
  call g:assert.equals(getline('.'), '({foo})', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0sdVl
  call g:assert.equals(getline('.'), '88foo88', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]

  """ 2
  " #1
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #3')

  " #4
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo ', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 1
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)

  " #6
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo ', 'failed at #8')

  " #9
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0sdVl
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call setline('.', ' "foo"')
  normal 0sdVl
  call g:assert.equals(getline('.'), ' foo', 'failed at #15')
endfunction
"}}}
function! s:suite.linewise_n_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #1
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call operator#sandwich#set('delete', 'line', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), '', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '  ',         'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '  ',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'aa',         'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '',           'failed at #4')
  call g:assert.equals(getline(4),   '',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 1}]
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  %delete

  """ 2
  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggsd2j
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjsdVl
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   'bb',         'failed at #10')
  call g:assert.equals(getline(3),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggsd2j
  call g:assert.equals(getline(1),   '',           'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '<foo>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['[', 'foo', ']'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['{', 'foo', '}'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['<', 'foo', '>'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #1
  call setline('.', 'afooa')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '*foo*')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['a', 'foo', 'a'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['*', 'foo', '*'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #1
  call append(0, ['(', 'foo', 'bar', 'baz', ')'])
  normal ggV4jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getline(4),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', '(', 'bar', ')', 'baz'])
  normal ggjV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getline(4),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(foo', 'bar', 'baz)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'a', ')'])
  normal ggV2jsd
  call g:assert.equals(getline('.'), 'a',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(a', ')'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(', 'a)'])
  normal ggVjsd
  call g:assert.equals(getline('.'), 'a',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_nothing_inside() abort "{{{
  " #1
  call setline('.', '()')
  normal 0Vsd
  call g:assert.equals(getline('.'), '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', ')'])
  normal ggVjsd
  call g:assert.equals(getline(1),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 1, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['aa', 'aaafooaaa', 'aa'])
  normal ggsdV2j
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['bb', 'bbb', 'bbfoobb', 'bbb', 'bb'])
  normal ggsdV4j
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['aa', 'aaa', 'aa', 'aaafooaaa', 'aa', 'aaa', 'aa'])
  normal gg2sdV6j
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['bb', 'bbb', 'bb', 'bb', 'bbb', 'bbfoobb', 'bbb', 'bb', 'bb', 'bbb', 'bb'])
  normal gg2sdV10j
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #1
  call setline('.', '((foo))')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  normal 0V3sd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '[(foo bar)]')
  normal 0V2sd
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', '{', '[', '(', 'bar', ')', ']', '}', 'baz'])
  normal ggjV6j3sd
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'bar',        'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #5')
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

  " #1
  call setline('.', '{[(foo)]}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '[(foo)]', 'failed at #1')

  " #2
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '<title>foo</title>')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call append(0, ['(', 'α', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'aα', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call append(0, ['α', 'a', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['α', 'α', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['α', 'aα', 'α'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call append(0, ['aα', 'a', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['aα', 'α', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'α', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('α')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['aα', 'aα', 'aα'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aα')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call append(0, ['(', '“', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['(', 'a“', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['“', 'a', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['“', '“', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['“', 'a“', '“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call append(0, ['a“', 'a', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['a“', '“', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['a“', 'a“', 'a“'])
  normal ggV2jsd
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')

  " #2
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  " #3
  %delete
  call append(0, ['(', '    foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1), '    foo',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')
  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_head')
  call setline('.', '(((foo)))')
  normal 0lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')

  " #5
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('delete', 'line', 'cursor', 'keep')
  call setline('.', '(((foo)))')
  normal 03lV2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')

  " #7
  normal lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #8')

  " #9
  normal 2hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('delete', 'line', 'cursor', 'head')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 3lVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('delete', 'line', 'cursor', 'tail')
  call setline('.', '(((foo)))')
  normal 0V2sd
  call g:assert.equals(getline('.'), '(foo)',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #12')

  " #13
  normal 3hVsd
  call g:assert.equals(getline('.'), 'foo',        'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call setline('.', '(foo)')
  normal 0sdVl
  call g:assert.equals(getline('.'), 'foo',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #2')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #3')

  " #4
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #4')

  """ off
  call operator#sandwich#set('delete', 'line', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{(foo)}', 'failed at #5')

  " #6
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '{foo}', 'failed at #6')

  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call setline('.', '{(foo)}')
  normal 0Vsd
  call g:assert.equals(getline('.'), '(foo)', 'failed at #7')

  " #8
  call setline('.', '({foo})')
  normal 0Vsd
  call g:assert.equals(getline('.'), '({foo})', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #2')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #3')

  " #4
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  """ on
  call operator#sandwich#set('delete', 'line', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), '\d\+foo\d\+', 'failed at #5')

  " #6
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call setline('.', '\d\+foo\d\+')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '888foo888')
  normal 0Vsd
  call g:assert.equals(getline('.'), '88foo88', 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]

  """ 2
  " #1
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #2')

  " #3
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #3')

  " #4
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo ', 'failed at #4')

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #5')

  """ 1
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'line', 'skip_space', 1)

  " #6
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  " #7
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #7')

  " #8
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo ', 'failed at #8')

  " #9
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #9')

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #10')

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'line', 'skip_space', 0)

  " #11
  call setline('.', '"foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #11')

  " #12
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' "foo"', 'failed at #12')

  " #13
  call setline('.', '"foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo" ', 'failed at #13')

  " #14
  " do not skip!
  call setline('.', ' "foo" ')
  normal 0Vsd
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call setline('.', ' "foo"')
  normal 0Vsd
  call g:assert.equals(getline('.'), ' foo', 'failed at #15')
endfunction
"}}}
function! s:suite.linewise_x_option_skip_char() abort "{{{
  """ off
  " #1
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #1')

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  """ on
  call operator#sandwich#set('delete', 'line', 'skip_char', 1)

  " #3
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aafoobb', 'failed at #3')

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call setline('.', 'aa(foo)bb')
  normal 0Vsd
  call g:assert.equals(getline('.'), 'aa(foo)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'command', ['normal! `[d`]'])

  " #1
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call operator#sandwich#set('delete', 'line', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call setline('.', '(foo)')
  normal 0Vsd
  call g:assert.equals(getline('.'), '', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort  "{{{
  call operator#sandwich#set('delete', 'line', 'linewise', 0)

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '  ',         'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '  ',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'aa',         'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '',           'failed at #4')
  call g:assert.equals(getline(4),   '',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   'aa',         'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #5')

  %delete

  " #6
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 1}]
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #6')
  unlet! g:operator#sandwich#recipes

  %delete

  call operator#sandwich#set('delete', 'line', 'linewise', 2)

  """ 2
  " #7
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(  ', 'foo', '  )'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(aa', 'foo', 'aa)'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['aa', '(foo)', 'bb'])
  normal ggjVsd
  call g:assert.equals(getline(1),   'aa',         'failed at #10')
  call g:assert.equals(getline(2),   'bb',         'failed at #10')
  call g:assert.equals(getline(3),   '',           'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 2, 1, 0], 'failed at #10')

  %delete

  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'linewise': 0}]
  call append(0, ['(', 'foo', ')'])
  normal ggV2jsd
  call g:assert.equals(getline(1),   '',           'failed at #11')
  call g:assert.equals(getline(2),   'foo',        'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #11')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #4')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  " #2
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #1')
  call g:assert.equals(getline(2),   'foobar',     'failed at #1')
  call g:assert.equals(getline(3),   'foobar',     'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3lsd\<C-v>23l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #2')
  call g:assert.equals(getline(2),   'foobar',     'failed at #2')
  call g:assert.equals(getline(3),   'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3lsd\<C-v>29l"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'barbar',     'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>18l"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #6')
  call g:assert.equals(getline(2),   'bar',        'failed at #6')
  call g:assert.equals(getline(3),   'baz',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getline(2),   'baar',       'failed at #7')
  call g:assert.equals(getline(3),   'baaz',       'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1),   'fooo',       'failed at #8')
  call g:assert.equals(getline(2),   'bar',        'failed at #8')
  call g:assert.equals(getline(3),   'baaz',       'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #8')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  execute "normal 0sd\<C-v>a("
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.blockwise_n_nothing_inside() abort  "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['()', '()', '()'])
  execute "normal ggsd\<C-v>9l"
  call g:assert.equals(getline(1),   '',           'failed at #1')
  call g:assert.equals(getline(2),   '',           'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3lsd\<C-v>20l"
  call g:assert.equals(getline(1),   'foobar',     'failed at #2')
  call g:assert.equals(getline(2),   'foobar',     'failed at #2')
  call g:assert.equals(getline(3),   'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #1
  call setline('.', '((foo))')
  execute "normal 02sd\<C-v>7l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  execute "normal 03sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  execute "normal 0sd\<C-v>5l"
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', '[(foo bar)]')
  execute "normal 02sd\<C-v>11l"
  call g:assert.equals(getline('.'), 'foo bar',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #4')

  " #5
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l3sd\<C-v>9l"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #6')
  call g:assert.equals(getline(2),   'bar',        'failed at #6')
  call g:assert.equals(getline(3),   'baz',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'afoob',      'failed at #7')
  call g:assert.equals(getline(2),   'bar',        'failed at #7')
  call g:assert.equals(getline(3),   'baz',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getline(2),   'abarb',      'failed at #8')
  call g:assert.equals(getline(3),   'baz',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg3sd\<C-v>29l"
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getline(2),   'bar',        'failed at #9')
  call g:assert.equals(getline(3),   'abazb',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #9')

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

  " #1
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2lsd\<C-v>25l"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #1')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #1')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #1')

  %delete

  " #2
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gglsd\<C-v>27l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #2')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #2')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #2')

  %delete

  " #3
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #3')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #3')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #3')

  %delete

  " #4
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal ggsd\<C-v>56l"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')

  %delete

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  normal ggsd17l
  call g:assert.equals(getline(1), '(foo)', 'failed at #5')
  call g:assert.equals(getline(2), '(bar)', 'failed at #5')
  call g:assert.equals(getline(3), '(baz)', 'failed at #5')

  set whichwrap&
  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #1
  call append(0, ['(α)', '(β)', '(γ)'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'α', 'failed at #1')
  call g:assert.equals(getline(2), 'β', 'failed at #1')
  call g:assert.equals(getline(3), 'γ', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(aα)', '(bβ)', '(cγ)'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'aα', 'failed at #2')
  call g:assert.equals(getline(2), 'bβ', 'failed at #2')
  call g:assert.equals(getline(3), 'cγ', 'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call append(0, ['αaα', 'αbα', 'αcα'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'a', 'failed at #3')
  call g:assert.equals(getline(2), 'b', 'failed at #3')
  call g:assert.equals(getline(3), 'c', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['ααα', 'αβα', 'αγα'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getline(2), 'β', 'failed at #4')
  call g:assert.equals(getline(3), 'γ', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['αaαα', 'αbβα', 'αcγα'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'aα', 'failed at #5')
  call g:assert.equals(getline(2), 'bβ', 'failed at #5')
  call g:assert.equals(getline(3), 'cγ', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call append(0, ['aαaaα', 'aαbaα', 'aαcaα'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'a', 'failed at #6')
  call g:assert.equals(getline(2), 'b', 'failed at #6')
  call g:assert.equals(getline(3), 'c', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['aααaα', 'aαβaα', 'aαγaα'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'α', 'failed at #7')
  call g:assert.equals(getline(2), 'β',  'failed at #7')
  call g:assert.equals(getline(3), 'γ', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['aαaαaα', 'aαbβaα', 'aαcγaα'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getline(2), 'bβ', 'failed at #8')
  call g:assert.equals(getline(3), 'cγ', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call append(0, ['(“)', '(“)', '(“)'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), '“', 'failed at #9')
  call g:assert.equals(getline(2), '“', 'failed at #9')
  call g:assert.equals(getline(3), '“', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['(a“)', '(b“)', '(c“)'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'a“', 'failed at #10')
  call g:assert.equals(getline(2), 'b“', 'failed at #10')
  call g:assert.equals(getline(3), 'c“', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['“a“', '“b“', '“c“'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), 'a', 'failed at #11')
  call g:assert.equals(getline(2), 'b', 'failed at #11')
  call g:assert.equals(getline(3), 'c', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['“““', '“““', '“““'])
  execute "normal ggsd\<C-v>11l"
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getline(2), '“', 'failed at #12')
  call g:assert.equals(getline(3), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['“a““', '“b““', '“c““'])
  execute "normal ggsd\<C-v>14l"
  call g:assert.equals(getline(1), 'a“', 'failed at #13')
  call g:assert.equals(getline(2), 'b“', 'failed at #13')
  call g:assert.equals(getline(3), 'c“', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call append(0, ['a“aa“', 'a“ba“', 'a“ca“'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), 'a', 'failed at #14')
  call g:assert.equals(getline(2), 'b', 'failed at #14')
  call g:assert.equals(getline(3), 'c', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['a““a“', 'a““a“', 'a““a“'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '“', 'failed at #15')
  call g:assert.equals(getline(2), '“',  'failed at #15')
  call g:assert.equals(getline(3), '“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['a“a“a“', 'a“b“a“', 'a“c“a“'])
  execute "normal ggsd\<C-v>20l"
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getline(2), 'b“', 'failed at #16')
  call g:assert.equals(getline(3), 'c“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  set whichwrap=h,l

  """"" cursor
  """ default
  " #1
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #1')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #1')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(    foo)', '(    bar)', '(    baz)'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1),   '    foo',    'failed at #3')
  call g:assert.equals(getline(2),   '    bar',    'failed at #3')
  call g:assert.equals(getline(3),   '    baz',    'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')

  %delete

  """ inner_head
  " #4
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #4')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #4')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')

  " #5
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'bar',        'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')

  %delete

  """ keep
  " #6
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #6')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #6')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')

  " #7
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getline(2),   'bar',        'failed at #7')
  call g:assert.equals(getline(3),   'baz',        'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')

  %delete

  """ inner_tail
  " #8
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #8')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #8')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #8')

  " #9
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #9')
  call g:assert.equals(getline(2),   'bar',        'failed at #9')
  call g:assert.equals(getline(3),   'baz',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #9')

  %delete

  """ head
  " #10
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #10')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #10')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')

  " #11
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #11')
  call g:assert.equals(getline(2),   'bar',        'failed at #11')
  call g:assert.equals(getline(3),   'baz',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')

  %delete

  """ tail
  " #12
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl2sd\<C-v>27l"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #12')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #12')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #12')

  " #13
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #13')
  call g:assert.equals(getline(2),   'bar',        'failed at #13')
  call g:assert.equals(getline(3),   'baz',        'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1),   'foo',        'failed at #14')
  call g:assert.equals(getline(2),   'bar',        'failed at #14')
  call g:assert.equals(getline(3),   'baz',        'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')

  set whichwrap&
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
  " #1
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')
  call g:assert.equals(getline(2), '(bar)', 'failed at #1')
  call g:assert.equals(getline(3), '(baz)', 'failed at #1')

  %delete

  " #2
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #2')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #2')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #3')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #3')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #3')

  %delete

  " #4
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #4')
  call g:assert.equals(getline(2), '{bar}', 'failed at #4')
  call g:assert.equals(getline(3), '{baz}', 'failed at #4')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #5')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #5')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #5')

  %delete

  " #6
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{foo}', 'failed at #6')
  call g:assert.equals(getline(2), '{bar}', 'failed at #6')
  call g:assert.equals(getline(3), '{baz}', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggsd\<C-v>23l"
  call g:assert.equals(getline(1), '(foo)', 'failed at #7')
  call g:assert.equals(getline(2), '(bar)', 'failed at #7')
  call g:assert.equals(getline(3), '(baz)', 'failed at #7')

  %delete

  " #8
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gglsd\<C-v>21l"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #8')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #8')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #8')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_option_regex() abort  "{{{
  set whichwrap=h,l
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #1')
  call g:assert.equals(getline(2), 'bar', 'failed at #1')
  call g:assert.equals(getline(3), 'baz', 'failed at #1')

  %delete

  " #2
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #2')
  call g:assert.equals(getline(2), '88bar88', 'failed at #2')
  call g:assert.equals(getline(3), '88baz88', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #3')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #3')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #3')

  %delete

  " #4
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #5')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #5')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #5')

  %delete

  " #6
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal ggsd\<C-v>36l"
  call g:assert.equals(getline(1), 'foo', 'failed at #7')
  call g:assert.equals(getline(2), 'bar', 'failed at #7')
  call g:assert.equals(getline(3), 'baz', 'failed at #7')

  %delete

  " #8
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), '88foo88', 'failed at #8')
  call g:assert.equals(getline(2), '88bar88', 'failed at #8')
  call g:assert.equals(getline(3), '88baz88', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  set whichwrap=h,l

  """ 1
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #1')
  call g:assert.equals(getline(2), 'bar', 'failed at #1')
  call g:assert.equals(getline(3), 'baz', 'failed at #1')

  %delete

  " #2
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #2')
  call g:assert.equals(getline(2), ' bar', 'failed at #2')
  call g:assert.equals(getline(3), ' baz', 'failed at #2')

  %delete

  " #3
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #3')
  call g:assert.equals(getline(2), 'bar ', 'failed at #3')
  call g:assert.equals(getline(3), 'baz ', 'failed at #3')

  %delete

  " #4
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  %delete

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #5')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #5')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #5')

  %delete

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)

  " #6
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  %delete

  " #7
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #7')
  call g:assert.equals(getline(2), ' bar', 'failed at #7')
  call g:assert.equals(getline(3), ' baz', 'failed at #7')

  %delete

  " #8
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), 'foo ', 'failed at #8')
  call g:assert.equals(getline(2), 'bar ', 'failed at #8')
  call g:assert.equals(getline(3), 'baz ', 'failed at #8')

  %delete

  " #9
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sd\<C-v>23l"
  call g:assert.equals(getline(1), ' foo ', 'failed at #9')
  call g:assert.equals(getline(2), ' bar ', 'failed at #9')
  call g:assert.equals(getline(3), ' baz ', 'failed at #9')

  %delete

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #10')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #10')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #10')

  %delete

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)

  " #11
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0sd\<C-v>17l"
  call g:assert.equals(getline(1), 'foo', 'failed at #11')
  call g:assert.equals(getline(2), 'bar', 'failed at #11')
  call g:assert.equals(getline(3), 'baz', 'failed at #11')

  %delete

  " #12
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #12')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #12')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #12')

  %delete

  " #13
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #13')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #13')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #13')

  %delete

  " #14
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0sd\<C-v>23l"
  call g:assert.equals(getline(1), '"foo"', 'failed at #14')
  call g:assert.equals(getline(2), '"bar"', 'failed at #14')
  call g:assert.equals(getline(3), '"baz"', 'failed at #14')

  %delete

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0sd\<C-v>20l"
  call g:assert.equals(getline(1), ' foo', 'failed at #15')
  call g:assert.equals(getline(2), ' bar', 'failed at #15')
  call g:assert.equals(getline(3), ' baz', 'failed at #15')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_char() abort "{{{
  set whichwrap=h,l

  """ off
  " #1
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #1')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #1')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #1')

  %delete

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #2')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #2')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)

  " #3
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #3')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #3')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #3')

  %delete

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal ggsd\<C-v>29l"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #4')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #4')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  set whichwrap=h,l
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #1')
  call g:assert.equals(getline(2), '', 'failed at #1')
  call g:assert.equals(getline(3), '', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('delete', 'block', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal ggsd\<C-v>17l"
  call g:assert.equals(getline(1), '', 'failed at #2')
  call g:assert.equals(getline(2), '', 'failed at #2')
  call g:assert.equals(getline(3), '', 'failed at #2')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['[foo]', '[bar]', '[baz]'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['{foo}', '{bar}', '{baz}'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #3')
  call g:assert.equals(getline(2),   'bar',        'failed at #3')
  call g:assert.equals(getline(3),   'baz',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['<foo>', '<bar>', '<baz>'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #1
  call append(0, ['afooa', 'abara', 'abaza'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #1')
  call g:assert.equals(getline(2),   'bar',        'failed at #1')
  call g:assert.equals(getline(3),   'baz',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  " #2
  call append(0, ['*foo*', '*bar*', '*baz*'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #1
  call append(0, ['(foo)bar', '(foo)bar', '(foo)bar'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #1')
  call g:assert.equals(getline(2),   'foobar',     'failed at #1')
  call g:assert.equals(getline(3),   'foobar',     'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo(bar)', 'foo(bar)', 'foo(bar)'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #2')
  call g:assert.equals(getline(2),   'foobar',     'failed at #2')
  call g:assert.equals(getline(3),   'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo(bar)baz', 'foo(bar)baz', 'foo(bar)baz'])
  execute "normal gg3l\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getline(2),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getline(3),   'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['(foo)', '(bar)', 'bazbaz'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'bazbaz',     'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 2, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['(foo)', 'barbar', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #5')
  call g:assert.equals(getline(2),   'barbar',     'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['foofoo', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foofoo',     'failed at #6')
  call g:assert.equals(getline(2),   'bar',        'failed at #6')
  call g:assert.equals(getline(3),   'baz',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['(foo)', '(baar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getline(2),   'baar',       'failed at #7')
  call g:assert.equals(getline(3),   'baaz',       'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['(fooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #8')
  call g:assert.equals(getline(2),   'bar',        'failed at #8')
  call g:assert.equals(getline(3),   'baaz',       'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['(fooo)', '(baar)', '(baz)'])
  set virtualedit=block
  execute "normal gg\<C-v>2j5lsd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #9')
  call g:assert.equals(getline(2),   'baar',       'failed at #9')
  call g:assert.equals(getline(3),   'baz',        'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #9')
  set virtualedit&

  %delete

  """ terminal-extended block-wise visual mode
  " #10
  call append(0, ['(fooo)', '(baaar)', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #10')
  call g:assert.equals(getline(2),   'baaar',      'failed at #10')
  call g:assert.equals(getline(3),   'baz',        'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #10')

  %delete

  " #11
  call append(0, ['(foooo)', '(bar)', '(baaz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'foooo',      'failed at #11')
  call g:assert.equals(getline(2),   'bar',        'failed at #11')
  call g:assert.equals(getline(3),   'baaz',       'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['(fooo)', '', '(baz)'])
  execute "normal gg\<C-v>2j$sd"
  call g:assert.equals(getline(1),   'fooo',       'failed at #12')
  call g:assert.equals(getline(2),   '',           'failed at #12')
  call g:assert.equals(getline(3),   'baz',        'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #12')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #1
  call setline('.', '(a)')
  execute "normal 0\<C-v>2lsd"
  call g:assert.equals(getline('.'), 'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.blockwise_x_nothing_inside() abort  "{{{
  " #1
  call append(0, ['()', '()', '()'])
  execute "normal gg\<C-v>2jlsd"
  call g:assert.equals(getline(1),   '',           'failed at #1')
  call g:assert.equals(getline(2),   '',           'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo()bar', 'foo()bar', 'foo()bar'])
  execute "normal gg3l\<C-v>2jlsd"
  call g:assert.equals(getline(1),   'foobar',     'failed at #2')
  call g:assert.equals(getline(2),   'foobar',     'failed at #2')
  call g:assert.equals(getline(3),   'foobar',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #1
  call setline('.', '((foo))')
  execute "normal 0\<C-v>6l2sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  " #2
  call setline('.', '{[(foo)]}')
  execute "normal 0\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #2')

  " #3
  call setline('.', 'foo{[(bar)]}baz')
  execute "normal 03l\<C-v>8l3sd"
  call g:assert.equals(getline('.'), 'foobarbaz',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['{[afoob]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'afoob',      'failed at #5')
  call g:assert.equals(getline(2),   'bar',        'failed at #5')
  call g:assert.equals(getline(3),   'baz',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['{[(foo)]}', '{[abarb]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #6')
  call g:assert.equals(getline(2),   'abarb',      'failed at #6')
  call g:assert.equals(getline(3),   'baz',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[abazb]}'])
  execute "normal gg\<C-v>2j8l3sd"
  call g:assert.equals(getline(1),   'foo',        'failed at #7')
  call g:assert.equals(getline(2),   'bar',        'failed at #7')
  call g:assert.equals(getline(3),   'abazb',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
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

  " #1
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg2l\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{[foo]}', 'failed at #1')
  call g:assert.equals(getline(2), '{[bar]}', 'failed at #1')
  call g:assert.equals(getline(3), '{[baz]}', 'failed at #1')

  %delete

  " #2
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #2')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #2')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #2')

  %delete

  " #3
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '[(foo)]', 'failed at #3')
  call g:assert.equals(getline(2), '[(bar)]', 'failed at #3')
  call g:assert.equals(getline(3), '[(baz)]', 'failed at #3')

  %delete

  " #4
  call setline('.', '<title>foo</title>')
  call append(0, ['<title>foo</title>', '<title>bar</title>', '<title>baz</title>'])
  execute "normal gg\<C-v>2j17lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')

  %delete

  " #5
  xnoremap ii :<C-u>call TextobjFail()<CR>
  let g:operator#sandwich#recipes = [
        \   {'external': ['ii', 'a('], 'noremap': 0},
        \ ]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #5')
  call g:assert.equals(getline(2), '(bar)', 'failed at #5')
  call g:assert.equals(getline(3), '(baz)', 'failed at #5')

  unlet g:sandwich#recipes
  unlet g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #1
  call append(0, ['(α)', '(β)', '(γ)'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #1')
  call g:assert.equals(getline(2), 'β', 'failed at #1')
  call g:assert.equals(getline(3), 'γ', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['(aα)', '(bβ)', '(cγ)'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #2')
  call g:assert.equals(getline(2), 'bβ', 'failed at #2')
  call g:assert.equals(getline(3), 'cγ', 'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call append(0, ['αaα', 'αbα', 'αcα'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #3')
  call g:assert.equals(getline(2), 'b', 'failed at #3')
  call g:assert.equals(getline(3), 'c', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['ααα', 'αβα', 'αγα'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getline(2), 'β', 'failed at #4')
  call g:assert.equals(getline(3), 'γ', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['αaαα', 'αbβα', 'αcγα'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #5')
  call g:assert.equals(getline(2), 'bβ', 'failed at #5')
  call g:assert.equals(getline(3), 'cγ', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call append(0, ['aαaaα', 'aαbaα', 'aαcaα'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #6')
  call g:assert.equals(getline(2), 'b', 'failed at #6')
  call g:assert.equals(getline(3), 'c', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['aααaα', 'aαβaα', 'aαγaα'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'α', 'failed at #7')
  call g:assert.equals(getline(2), 'β',  'failed at #7')
  call g:assert.equals(getline(3), 'γ', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('γ')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['aαaαaα', 'aαbβaα', 'aαcγaα'])
  execute "normal gg\<C-v>5l2jsd"
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getline(2), 'bβ', 'failed at #8')
  call g:assert.equals(getline(3), 'cγ', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('cγ')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call append(0, ['(“)', '(“)', '(“)'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #9')
  call g:assert.equals(getline(2), '“', 'failed at #9')
  call g:assert.equals(getline(3), '“', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['(a“)', '(b“)', '(c“)'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #10')
  call g:assert.equals(getline(2), 'b“', 'failed at #10')
  call g:assert.equals(getline(3), 'c“', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['“a“', '“b“', '“c“'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #11')
  call g:assert.equals(getline(2), 'b', 'failed at #11')
  call g:assert.equals(getline(3), 'c', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['“““', '“““', '“““'])
  execute "normal gg\<C-v>2l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getline(2), '“', 'failed at #12')
  call g:assert.equals(getline(3), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['“a““', '“b““', '“c““'])
  execute "normal gg\<C-v>3l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #13')
  call g:assert.equals(getline(2), 'b“', 'failed at #13')
  call g:assert.equals(getline(3), 'c“', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call append(0, ['a“aa“', 'a“ba“', 'a“ca“'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), 'a', 'failed at #14')
  call g:assert.equals(getline(2), 'b', 'failed at #14')
  call g:assert.equals(getline(3), 'c', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['a““a“', 'a““a“', 'a““a“'])
  execute "normal gg\<C-v>4l2jsd"
  call g:assert.equals(getline(1), '“', 'failed at #15')
  call g:assert.equals(getline(2), '“',  'failed at #15')
  call g:assert.equals(getline(3), '“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['a“a“a“', 'a“b“a“', 'a“c“a“'])
  execute "normal gg\<C-v>5l2jsd"
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getline(2), 'b“', 'failed at #16')
  call g:assert.equals(getline(3), 'c“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('c“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #1')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #1')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['(    foo)', '(    bar)', '(    baz)'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1),   '    foo',    'failed at #3')
  call g:assert.equals(getline(2),   '    bar',    'failed at #3')
  call g:assert.equals(getline(3),   '    baz',    'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #3')

  %delete

  """ inner_head
  " #1
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #1')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #1')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   'bar',        'failed at #2')
  call g:assert.equals(getline(3),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  %delete

  """ keep
  " #3
  call operator#sandwich#set('delete', 'block', 'cursor', 'keep')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #3')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #3')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #3')

  " #4
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz',        'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')

  %delete

  """ inner_tail
  " #5
  call operator#sandwich#set('delete', 'block', 'cursor', 'inner_tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #5')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #5')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #5')

  " #6
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #6')
  call g:assert.equals(getline(2),   'bar',        'failed at #6')
  call g:assert.equals(getline(3),   'baz',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #6')

  %delete

  """ head
  " #7
  call operator#sandwich#set('delete', 'block', 'cursor', 'head')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #7')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #7')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')

  " #8
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #8')
  call g:assert.equals(getline(2),   'bar',        'failed at #8')
  call g:assert.equals(getline(3),   'baz',        'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #8')

  %delete

  """ tail
  " #9
  call operator#sandwich#set('delete', 'block', 'cursor', 'tail')
  call append(0, ['{[(foo)]}', '{[(bar)]}', '{[(baz)]}'])
  execute "normal ggl\<C-v>2j6l2sd"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #9')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #9')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 4, 0], 'failed at #9')

  " #10
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #10')
  call g:assert.equals(getline(2),   'bar',        'failed at #10')
  call g:assert.equals(getline(3),   'baz',        'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #10')

  """"" recipe option
  " #11
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head'}]
  call operator#sandwich#set('delete', 'line', 'cursor', 'inner_tail')
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1),   'foo',        'failed at #11')
  call g:assert.equals(getline(2),   'bar',        'failed at #11')
  call g:assert.equals(getline(3),   'baz',        'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #11')
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')
  call g:assert.equals(getline(2), '(bar)', 'failed at #1')
  call g:assert.equals(getline(3), '(baz)', 'failed at #1')

  %delete

  " #2
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #2')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #2')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]

  " #3
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #3')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #3')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #3')

  %delete

  " #4
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #4')
  call g:assert.equals(getline(2), '{bar}', 'failed at #4')
  call g:assert.equals(getline(3), '{baz}', 'failed at #4')

  %delete

  """ off
  call operator#sandwich#set('delete', 'block', 'noremap', 0)
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #5')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #5')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #5')

  %delete

  " #6
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{foo}', 'failed at #6')
  call g:assert.equals(getline(2), '{bar}', 'failed at #6')
  call g:assert.equals(getline(3), '{baz}', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]

  " #7
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal gg\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '(foo)', 'failed at #7')
  call g:assert.equals(getline(2), '(bar)', 'failed at #7')
  call g:assert.equals(getline(3), '(baz)', 'failed at #7')

  %delete

  " #8
  call append(0, ['{(foo)}', '{(bar)}', '{(baz)}'])
  execute "normal ggl\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '{(foo)}', 'failed at #8')
  call g:assert.equals(getline(2), '{(bar)}', 'failed at #8')
  call g:assert.equals(getline(3), '{(baz)}', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_x_option_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #1')
  call g:assert.equals(getline(2), 'bar', 'failed at #1')
  call g:assert.equals(getline(3), 'baz', 'failed at #1')

  %delete

  " #2
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #2')
  call g:assert.equals(getline(2), '88bar88', 'failed at #2')
  call g:assert.equals(getline(3), '88baz88', 'failed at #2')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]

  " #3
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #3')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #3')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #3')

  %delete

  " #4
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'regex', 1)
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #5
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), '\d\+foo\d\+', 'failed at #5')
  call g:assert.equals(getline(2), '\d\+bar\d\+', 'failed at #5')
  call g:assert.equals(getline(3), '\d\+baz\d\+', 'failed at #5')

  %delete

  " #6
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  %delete
  let g:operator#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]

  " #7
  call append(0, ['\d\+foo\d\+', '\d\+bar\d\+', '\d\+baz\d\+'])
  execute "normal gg\<C-v>2j10lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #7')
  call g:assert.equals(getline(2), 'bar', 'failed at #7')
  call g:assert.equals(getline(3), 'baz', 'failed at #7')

  %delete

  " #8
  call append(0, ['888foo888', '888bar888', '888baz888'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), '88foo88', 'failed at #8')
  call g:assert.equals(getline(2), '88bar88', 'failed at #8')
  call g:assert.equals(getline(3), '88baz88', 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]

  """ 1
  " #1
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #1')
  call g:assert.equals(getline(2), 'bar', 'failed at #1')
  call g:assert.equals(getline(3), 'baz', 'failed at #1')

  %delete

  " #2
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #2')
  call g:assert.equals(getline(2), ' bar', 'failed at #2')
  call g:assert.equals(getline(3), ' baz', 'failed at #2')

  %delete

  " #3
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #3')
  call g:assert.equals(getline(2), 'bar ', 'failed at #3')
  call g:assert.equals(getline(3), 'baz ', 'failed at #3')

  %delete

  " #4
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #4')
  call g:assert.equals(getline(2), '"bar"', 'failed at #4')
  call g:assert.equals(getline(3), '"baz"', 'failed at #4')

  %delete

  " #5
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #5')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #5')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #5')

  %delete

  """ 2
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'block', 'skip_space', 2)

  " #6
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  %delete

  " #7
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #7')
  call g:assert.equals(getline(2), ' bar', 'failed at #7')
  call g:assert.equals(getline(3), ' baz', 'failed at #7')

  %delete

  " #8
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), 'foo ', 'failed at #8')
  call g:assert.equals(getline(2), 'bar ', 'failed at #8')
  call g:assert.equals(getline(3), 'baz ', 'failed at #8')

  %delete

  " #9
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), ' foo ', 'failed at #9')
  call g:assert.equals(getline(2), ' bar ', 'failed at #9')
  call g:assert.equals(getline(3), ' baz ', 'failed at #9')

  %delete

  " #10
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 0}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #10')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #10')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #10')

  %delete

  """ 0
  let g:operator#sandwich#recipes = [{'buns': ['"', '"']}]
  call operator#sandwich#set('delete', 'block', 'skip_space', 0)

  " #11
  call append(0, ['"foo"', '"bar"', '"baz"'])
  execute "normal gg0\<C-v>2j4lsd"
  call g:assert.equals(getline(1), 'foo', 'failed at #11')
  call g:assert.equals(getline(2), 'bar', 'failed at #11')
  call g:assert.equals(getline(3), 'baz', 'failed at #11')

  %delete

  " #12
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' "foo"', 'failed at #12')
  call g:assert.equals(getline(2), ' "bar"', 'failed at #12')
  call g:assert.equals(getline(3), ' "baz"', 'failed at #12')

  %delete

  " #13
  call append(0, ['"foo" ', '"bar" ', '"baz" '])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), '"foo" ', 'failed at #13')
  call g:assert.equals(getline(2), '"bar" ', 'failed at #13')
  call g:assert.equals(getline(3), '"baz" ', 'failed at #13')

  %delete

  " #14
  " do not skip!
  call append(0, [' "foo" ', ' "bar" ', ' "baz" '])
  execute "normal gg0\<C-v>2j6lsd"
  call g:assert.equals(getline(1), '"foo"', 'failed at #14')
  call g:assert.equals(getline(2), '"bar"', 'failed at #14')
  call g:assert.equals(getline(3), '"baz"', 'failed at #14')

  %delete

  " #15
  let g:operator#sandwich#recipes = [{'buns': ['"', '"'], 'skip_space': 1}]
  call append(0, [' "foo"', ' "bar"', ' "baz"'])
  execute "normal gg0\<C-v>2j5lsd"
  call g:assert.equals(getline(1), ' foo', 'failed at #15')
  call g:assert.equals(getline(2), ' bar', 'failed at #15')
  call g:assert.equals(getline(3), ' baz', 'failed at #15')
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_char() abort "{{{
  """ off
  " #1
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #1')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #1')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #1')

  %delete

  " #2
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 1}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #2')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #2')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #2')
  unlet! g:operator#sandwich#recipes

  %delete

  """ on
  call operator#sandwich#set('delete', 'block', 'skip_char', 1)
  " #2
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aafoobb', 'failed at #2')
  call g:assert.equals(getline(2), 'aabarbb', 'failed at #2')
  call g:assert.equals(getline(3), 'aabazbb', 'failed at #2')

  %delete

  " #4
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'skip_char': 0}]
  call append(0, ['aa(foo)bb', 'aa(bar)bb', 'aa(baz)bb'])
  execute "normal gg\<C-v>2j8lsd"
  call g:assert.equals(getline(1), 'aa(foo)bb', 'failed at #4')
  call g:assert.equals(getline(2), 'aa(bar)bb', 'failed at #4')
  call g:assert.equals(getline(3), 'aa(baz)bb', 'failed at #4')
  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  call operator#sandwich#set('delete', 'block', 'command', ['normal! `[d`]'])

  " #1
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #1')
  call g:assert.equals(getline(2), '', 'failed at #1')
  call g:assert.equals(getline(3), '', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('delete', 'block', 'command', [])
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'command': ['normal! `[d`]']}]
  call append(0, ['(foo)', '(bar)', '(baz)'])
  execute "normal gg\<C-v>2j4lsd"
  call g:assert.equals(getline(1), '', 'failed at #2')
  call g:assert.equals(getline(2), '', 'failed at #2')
  call g:assert.equals(getline(3), '', 'failed at #2')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssd <Esc>:call operator#sandwich#prerequisite('delete', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #1
  call setline('.', '(foo)')
  normal 0sda(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0sda[
  call g:assert.equals(getline('.'), 'foo',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0ssda(
  call g:assert.equals(getline('.'), 'foo',        'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #3')

  " #4
  call setline('.', '[foo]')
  normal 0ssda[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #4')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #1
  call setline('.', '(((foo)))')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #1')

  " #2
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 02sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #2')

  " #3
  call setline('.', '(((foo)))')
  let &undolevels = &undolevels
  normal 03sd$
  normal! u
  call g:assert.equals(getline('.'), '(((foo)))', 'failed at #3')
endfunction
"}}}

" When a assigned region is invalid
function! s:suite.invalid_region() abort  "{{{
  nmap sd' <Plug>(operator-sandwich-delete)i'

  " #1
  call setline('.', 'foo')
  normal 0lsd'
  call g:assert.equals(getline('.'), 'foo',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  nunmap sd'
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
