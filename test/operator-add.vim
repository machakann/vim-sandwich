scriptencoding utf-8

let s:suite = themis#suite('operator-sandwich: add:')
let s:object = 'g:operator#sandwich#object'
call themis#helper('command').with(s:)

function! s:suite.before() abort "{{{
  nmap sa <Plug>(sandwich-add)
  xmap sa <Plug>(sandwich-add)
  omap sa <Plug>(sandwich-add)
endfunction
"}}}
function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set whichwrap&
  set ambiwidth&
  set expandtab
  set shiftwidth&
  set softtabstop&
  set autoindent&
  set smartindent&
  set cindent&
  set indentexpr&
  set cinkeys&
  set indentkeys&
  set formatoptions&
  set textwidth&
  silent! mapc!
  silent! ounmap ii
  silent! ounmap ssa
  call operator#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:operator#sandwich#recipes
  unlet! g:sandwich#input_fallback
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  nunmap sa
  xunmap sa
  ounmap sa
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
  normal 0saiw`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '``foo``', 'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 0saiw```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #7')

  " #8
  call setline('.', 'foo')
  execute "normal 0saiw`\<Esc>"
  call g:assert.equals(getline('.'), 'foo', 'failed at #8')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #9
  call setline('.', 'foo')
  normal 0saiw`h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #9')

  " #10
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '`foo`', 'failed at #10')

  " #11
  call setline('.', 'foo')
  normal 0saiw```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #11')

  " #12
  call setline('.', 'foo')
  execute "normal 0saiw`\<Esc>"
  call g:assert.equals(getline('.'), 'foo', 'failed at #12')

  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #13
  call setline('.', 'foo')
  normal 0saiw`h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #13')

  " #14
  call setline('.', 'foo')
  normal 0saiw``h
  call g:assert.equals(getline('.'), '"foo"', 'failed at #14')

  " #15
  call setline('.', 'foo')
  normal 0saiw```
  call g:assert.equals(getline('.'), '```foo```', 'failed at #15')

  " #16
  call setline('.', 'foo')
  execute "normal 0saiw`\<Esc>"
  call g:assert.equals(getline('.'), 'foo', 'failed at #16')
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim'], 'input': ['(', ')']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #3')

  set filetype=vim

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw<
  call g:assert.equals(getline('.'), '<foo<', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['add'], 'input': ['(', ')']},
        \ ]

  " #2
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['delete'], 'input': ['(', ')']},
        \ ]

  " #3
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['replace'], 'input': ['(', ')']},
        \ ]

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['operator'], 'input': ['(', ')']},
        \ ]

  " #5
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #6
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_motionwise() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]
  call operator#sandwich#set('add', 'line', 'linewise', 0)

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  " #3
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['all'], 'input': ['(', ')']},
        \ ]

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  " #6
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['char'], 'input': ['(', ')']},
        \ ]

  " #7
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')

  " #9
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #9')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['line'], 'input': ['(', ')']},
        \ ]

  " #10
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #10')

  " #11
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #11')

  " #12
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(foo)', 'failed at #12')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'motionwise': ['block'], 'input': ['(', ')']},
        \ ]

  " #13
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #13')

  " #14
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #14')

  " #15
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline('.'), '[foo]', 'failed at #15')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['n'], 'input': ['(', ')']},
        \ ]

  " #3
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #5
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_action() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['all'], 'input': ['(', ')']},
        \ ]

  " #3
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['add'], 'input': ['(', ')']},
        \ ]

  " #5
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'action': ['delete'], 'input': ['(', ')']},
        \ ]

  " #7
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #8')
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
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0saiw{
  call g:assert.equals(getline('.'), '{foo{', 'failed at #3')
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
  " #1
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_positioning() abort "{{{
  " #1
  call setline('.', 'foobar')
  normal 0sa3l(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foobar')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  normal 03lsa3l(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #3')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #4
  call setline('.', 'foobarbaz')
  normal 0saii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #4')

  " #5
  call setline('.', 'foobarbaz')
  normal 02lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0],  'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #5')

  " #6
  call setline('.', 'foobarbaz')
  normal 03lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #6')

  " #7
  call setline('.', 'foobarbaz')
  normal 05lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],  'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #7')

  " #8
  call setline('.', 'foobarbaz')
  normal 06lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 9, 0],  'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #8')

  " #9
  call setline('.', 'foobarbaz')
  normal 08lsaii(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 11, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1,  9, 0], 'failed at #9')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  %delete

  " #10
  set whichwrap=h,l
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa11l(
  call g:assert.equals(getline(1),   '(foo',       'failed at #10')
  call g:assert.equals(getline(2),   'bar',        'failed at #10')
  call g:assert.equals(getline(3),   'baz)',       'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #10')
  set whichwrap&
endfunction
"}}}
function! s:suite.charwise_n_a_character() abort "{{{
  " #1
  call setline('.', 'a')
  normal 0sal(
  call g:assert.equals(getline('.'), '(a)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.charwise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \   {'buns': ["cc\n cc", "ccc\n  "], 'input':['c']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1),   'aa',         'failed at #1')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #1')
  call g:assert.equals(getline(3),   'aa',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline(1),   'bb',         'failed at #2')
  call g:assert.equals(getline(2),   'bbb',        'failed at #2')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #2')
  call g:assert.equals(getline(4),   'bbb',        'failed at #2')
  call g:assert.equals(getline(5),   'bb',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #2')

  %delete

  onoremap ii :<C-u>call TextobjCoord(1, 4, 1, 6)<CR>
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')

  " #3
  call setline('.', 'foobarbaz')
  normal ggsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #3')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foobarbaz')
  normal gg2lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #4')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #4')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foobarbaz')
  normal gg3lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #5')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #5')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #5')

  %delete

  " #6
  call setline('.', 'foobarbaz')
  normal gg5lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #6')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #6')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 6, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #6')

  %delete

  " #7
  call setline('.', 'foobarbaz')
  normal gg6lsaiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #7')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #7')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #7')

  %delete

  " #8
  call setline('.', 'foobarbaz')
  normal gg$saiia
  call g:assert.equals(getline(1),   'fooaa',      'failed at #8')
  call g:assert.equals(getline(2),   'aaabaraaa',  'failed at #8')
  call g:assert.equals(getline(3),   'aabaz',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #8')

  %delete

  set autoindent
  onoremap ii :<C-u>call TextobjCoord(1, 8, 1, 10)<CR>

  " #9
  call setline('.', '    foobarbaz')
  normal ggsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #9')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #9')
  call g:assert.equals(getline(3),   '       baz',    'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],    'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0],    'failed at #9')

  %delete

  " #10
  call setline('.', '    foobarbaz')
  normal gg2lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #10')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #10')
  call g:assert.equals(getline(3),   '       baz',    'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0],    'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0],    'failed at #10')

  %delete

  " #11
  call setline('.', '    foobarbaz')
  normal gg3lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #11')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #11')
  call g:assert.equals(getline(3),   '       baz',    'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 8, 0],    'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0],    'failed at #11')

  %delete

  " #12
  call setline('.', '    foobarbaz')
  normal gg5lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #12')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #12')
  call g:assert.equals(getline(3),   '       baz',    'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 10, 0],   'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3,  8, 0],   'failed at #12')

  %delete

  " #13
  call setline('.', '    foobarbaz')
  normal gg6lsaiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #13')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #13')
  call g:assert.equals(getline(3),   '       baz',    'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 8, 0],    'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 8, 0],    'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0],    'failed at #13')

  %delete

  " #14
  call setline('.', '    foobarbaz')
  normal gg$saiic
  call g:assert.equals(getline(1),   '    foocc',     'failed at #14')
  call g:assert.equals(getline(2),   '     ccbarccc', 'failed at #14')
  call g:assert.equals(getline(3),   '       baz',    'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 10, 0],   'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1,  8, 0],   'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3,  8, 0],   'failed at #14')

  ounmap ii
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_n_count() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 02saiw([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')

  " #3
  call setline('.', 'foo bar')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )bar',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 7, 0], 'failed at #3')

  " #4
  call setline('.', 'foo bar')
  normal 0sa3iw(
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #4')

  " #5
  call setline('.', 'foo bar')
  normal 02sa3iw([
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #5')

  " #6
  call setline('.', 'foobarbaz')
  normal 03l2sa3l([
  call g:assert.equals(getline('.'), 'foo[(bar)]baz', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1,  6, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 11, 0],   'failed at #6')

  " #7
  call setline('.', 'foobarbaz')
  normal 03l3sa3l([{
  call g:assert.equals(getline('.'), 'foo{[(bar)]}baz', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 13, 0],     'failed at #7')
endfunction
"}}}
function! s:suite.charwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'α')
  normal 0sal(
  call g:assert.equals(getline('.'), '(α)',       'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #1')

  " #2
  call setline('.', 'aα')
  normal 0sa2l(
  call g:assert.equals(getline('.'), '(aα)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'αaα',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #3')

  " #4
  call setline('.', 'α')
  normal 0sala
  call g:assert.equals(getline('.'), 'ααα',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #4')

  " #5
  call setline('.', 'aα')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'αaαα',    'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'aαaaα',    'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #6')

  " #7
  call setline('.', 'α')
  normal 0sala
  call g:assert.equals(getline('.'), 'aααaα',   'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'aα')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'aαaαaα',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #8')

  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '“')
  normal 0sal(
  call g:assert.equals(getline('.'), '(“)',       'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #9')

  " #10
  call setline('.', 'a“')
  normal 0sa2l(
  call g:assert.equals(getline('.'), '(a“)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), '“a“',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #11')

  " #12
  call setline('.', '“')
  normal 0sala
  call g:assert.equals(getline('.'), '“““',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #12')

  " #13
  call setline('.', 'a“')
  normal 0sa2la
  call g:assert.equals(getline('.'), '“a““',    'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a')
  normal 0sala
  call g:assert.equals(getline('.'), 'a“aa“',    'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #14')

  " #15
  call setline('.', '“')
  normal 0sala
  call g:assert.equals(getline('.'), 'a““a“',   'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'a“')
  normal 0sa2la
  call g:assert.equals(getline('.'), 'a“a“a“',  'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #16')

  " #17
  call setline('.', 'a梵aa')
  normal 0savl"
  call g:assert.equals(getline('.'), '"a梵"aa',  'failed at #16')
endfunction
"}}}
function! s:suite.charwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["(\n    ", "\n)"], 'input':['a']}]
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline(1), '(',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ')',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  %delete
  unlet! g:operator#sandwich#recipes

  """ inner_head
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  " #4
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')

  " #5
  normal 2lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #6')

  " #7
  normal lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #8')

  " #9
  normal 2hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 3lsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saiw()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #12')

  " #13
  normal 3hsaiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0saiw1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_n_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  normal 03saiw([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 03saiw1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saiw(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 03saiw0[{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw1
  call g:assert.equals(getline('.'), '2foo3',  'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0saiwb
  call g:assert.equals(getline('.'), 'foo',  'failed at #4')
  call g:assert.equals(exists(s:object), 0,  'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0saiwc
  call g:assert.equals(getline('.'), 'foo',  'failed at #5')
  call g:assert.equals(exists(s:object), 0,  'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 02saiwab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,   'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 02saiwac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,   'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 02saiwba
  call g:assert.equals(getline('.'), 'foo', 'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  " #9
  call setline('.', 'foo')
  normal 02saiwbc
  call g:assert.equals(getline('.'), 'foo', 'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  " #10
  call setline('.', 'foo')
  normal 0saiw0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0saiwa
  call g:assert.equals(getline('.'), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', 'bar')
  normal 0saiw1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'char', 'listexpr', 1)
  call setline('.', 'bar')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', 'bar')
  normal 0saiwb
  call g:assert.equals(getline('.'), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0saiw0
  call g:assert.equals(getline('.'), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', 'bar')
  normal 0saiw1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw0
  call g:assert.equals(getline('.'), '{foo}', 'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0saiw1
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ off
  " #1
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #1')

  " #2
  call setline('.', 'foo ')
  normal 0sa2iw1
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0sa2iw(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #3')

  " #4
  call setline('.', 'foo ')
  normal 0sa2iw0
  call g:assert.equals(getline('.'), '(foo )',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_n_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'char', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  normal 0ffsaiw(
  call g:assert.equals(getline('.'), '""',  'failed at #1')

  " #2
  call operator#sandwich#set('add', 'char', 'command', [])
  call setline('.', '"foo"')
  normal 0ffsaiw1
  call g:assert.equals(getline('.'), '""',  'failed at #2')
endfunction
"}}}
function! s:suite.charwise_n_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ on
  " #1
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ')',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saiw0
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')

  %delete

  " #3
  set autoindent
  call setline('.', '    foo')
  normal ^saiw(
  call g:assert.equals(getline(1),   '    (',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    )',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  set autoindent&

  %delete

  """ off
  call operator#sandwich#set('add', 'char', 'linewise', 0)

  " #4
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal 0saiw1
  call g:assert.equals(getline(1), '(',   'failed at #5')
  call g:assert.equals(getline(2), 'foo', 'failed at #5')
  call g:assert.equals(getline(3), ')',   'failed at #5')
endfunction
"}}}
function! s:suite.charwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " normal ^saiwa
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^saiw0
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.charwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal ^saiw1
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^saiwa
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal ^saiw1
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

function! s:suite.charwise_x_default_recipes() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline('.'), '(foo)',      'ailed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'ailed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'ailed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'ailed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viwsa)
  call g:assert.equals(getline('.'), '(foo)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0viwsa]
  call g:assert.equals(getline('.'), '[foo]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0viwsa{
  call g:assert.equals(getline('.'), '{foo}',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0viwsa}
  call g:assert.equals(getline('.'), '{foo}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 0viwsa<
  call g:assert.equals(getline('.'), '<foo>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0viwsa>
  call g:assert.equals(getline('.'), '<foo>',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.charwise_x_not_registered() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'afooa',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viwsa*
  call g:assert.equals(getline('.'), '*foo*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_positioning() abort "{{{
  " #1
  call setline('.', 'foobar')
  normal 0v2lsa(
  call g:assert.equals(getline('.'), '(foo)bar',   'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #1')

  " #2
  call setline('.', 'foobar')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0], 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  normal 03lv2lsa(
  call g:assert.equals(getline('.'), 'foo(bar)baz', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 9, 0],  'failed at #3')

  " #4
  call setline('.', '')
  call append(0, ['foo', 'bar', 'baz'])
  normal ggv2j2lsa(
  call g:assert.equals(getline(1),   '(foo',       'failed at #4')
  call g:assert.equals(getline(2),   'bar',        'failed at #4')
  call g:assert.equals(getline(3),   'baz)',       'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_a_character() abort "{{{
  " #1
  call setline('.', 'a')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(a)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.charwise_x_breaking() abort "{{{
  " #1
  call append(0, ['', 'foo'])
  normal ggvj$sa(
  call g:assert.equals(getline(1), '(',    'failed at #1')
  call g:assert.equals(getline(2), 'foo)', 'failed at #1')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 2, 5, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', ''])
  normal ggvjsa(
  call g:assert.equals(getline(1), '(foo', 'failed at #2')
  call g:assert.equals(getline(2), ')',    'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 2, 2, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #3
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline(1), 'aa',           'failed at #3')
  call g:assert.equals(getline(2), 'aaafooaaa',    'failed at #3')
  call g:assert.equals(getline(3), 'aa',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',    'failed at #4')
  call g:assert.equals(getline(4),   'bbb',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  execute "normal 0viwsa\n"
  call g:assert.equals(getline(1),   '',           'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '',           'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 1, 0], 'failed at #5')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.charwise_x_count() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0viw2sa([
  call g:assert.equals(getline('.'), '[(foo)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 8, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'α')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(α)',       'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(α)')+1, 0], 'failed at #1')

  " #2
  call setline('.', 'aα')
  normal 0vlsa(
  call g:assert.equals(getline('.'), '(aα)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(aα)')+1, 0], 'failed at #2')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'αaα',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaα')+1, 0], 'failed at #3')

  " #4
  call setline('.', 'α')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'ααα',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, strlen('ααα')+1, 0], 'failed at #4')

  " #5
  call setline('.', 'aα')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'αaαα',    'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, strlen('αaαα')+1, 0], 'failed at #5')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'aαaaα',    'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaaα')+1, 0], 'failed at #6')

  " #7
  call setline('.', 'α')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'aααaα',   'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aααaα')+1, 0], 'failed at #7')

  " #8
  call setline('.', 'aα')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'aαaαaα',  'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 1, strlen('aαaαaα')+1, 0], 'failed at #8')

  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '“')
  normal 0vsa(
  call g:assert.equals(getline('.'), '(“)',       'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(“)')+1, 0], 'failed at #9')

  " #10
  call setline('.', 'a“')
  normal 0vlsa(
  call g:assert.equals(getline('.'), '(a“)',      'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 1, strlen('(a“)')+1, 0], 'failed at #10')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), '“a“',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a“')+1, 0], 'failed at #11')

  " #12
  call setline('.', '“')
  normal 0vsaa
  call g:assert.equals(getline('.'), '“““',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“““')+1, 0], 'failed at #12')

  " #13
  call setline('.', 'a“')
  normal 0vlsaa
  call g:assert.equals(getline('.'), '“a““',    'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 1, strlen('“a““')+1, 0], 'failed at #13')

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'a“aa“',    'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“aa“')+1, 0], 'failed at #14')

  " #15
  call setline('.', '“')
  normal 0vsaa
  call g:assert.equals(getline('.'), 'a““a“',   'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a““a“')+1, 0], 'failed at #15')

  " #16
  call setline('.', 'a“')
  normal 0vlsaa
  call g:assert.equals(getline('.'), 'a“a“a“',  'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 1, strlen('a“a“a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.charwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["(\n    ", "\n)"], 'input':['a']}]
  call setline('.', 'foo')
  normal viwsaa
  call g:assert.equals(getline(1), '(',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ')',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  %delete
  unlet! g:operator#sandwich#recipes

  """ inner_head
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_head')
  " #4
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')

  " #5
  normal viwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('add', 'char', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #6')

  " #7
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwo2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #8')

  " #9
  normal viwosa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('add', 'char', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 3lviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('add', 'char', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0viw2sa()
  call g:assert.equals(getline('.'), '((foo))',    'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #12')

  " #13
  normal 3hviwsa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'char', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0viwsa1
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.charwise_x_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  normal 0viw3sa([{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viw3sa1
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'char', 'query_once', 1)
  call setline('.', 'foo')
  normal 0viw3sa(
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0viw3sa0[{
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '1+1foo1+2',  'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viwsa1
  call g:assert.equals(getline('.'), '2foo3',  'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'char', 'expr', 1)
  call setline('.', 'foo')
  normal 0viwsaa
  call g:assert.equals(getline('.'), '2foo3',  'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0viwsab
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', 'foo')
  normal 0viwsac
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', 'foo')
  normal 0viw2saab
  call g:assert.equals(getline('.'), '2foo3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0,   'failed at #6')

  " #7
  call setline('.', 'foo')
  normal 0viw2saac
  call g:assert.equals(getline('.'), '2foo3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0,   'failed at #7')

  " #8
  call setline('.', 'foo')
  normal 0viw2saba
  call g:assert.equals(getline('.'), 'foo', 'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  " #9
  call setline('.', 'foo')
  normal 0viw2sabc
  call g:assert.equals(getline('.'), 'foo', 'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  " #10
  call setline('.', 'foo')
  normal 0viwsa0
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0viwsaa
  call g:assert.equals(getline('.'), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', 'bar')
  normal 0viwsa1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'char', 'listexpr', 1)
  call setline('.', 'bar')
  normal 0viwsaa
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', 'bar')
  normal 0viwsab
  call g:assert.equals(getline('.'), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0viwsa0
  call g:assert.equals(getline('.'), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', 'bar')
  normal 0viwsa1
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.charwise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '[foo]',  'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0viwsa0
  call g:assert.equals(getline('.'), '{foo}',  'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'char', 'noremap', 0)
  call setline('.', 'foo')
  normal 0viwsa[
  call g:assert.equals(getline('.'), '{foo}',  'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0viwsa1
  call g:assert.equals(getline('.'), '[foo]',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ off
  " #1
  call setline('.', 'foo ')
  normal 0v2iwsa(
  call g:assert.equals(getline('.'), '(foo )',  'failed at #1')

  " #2
  call setline('.', 'foo ')
  normal 0v2iwsa1
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'char', 'skip_space', 1)
  call setline('.', 'foo ')
  normal 0v2iwsa(
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #3')

  " #4
  call setline('.', 'foo ')
  normal 0v2iwsa0
  call g:assert.equals(getline('.'), '(foo )',  'failed at #4')
endfunction
"}}}
function! s:suite.charwise_x_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'char', 'command', ["normal! `[d`]"])
  call setline('.', '"foo"')
  normal 0ffviwsa(
  call g:assert.equals(getline('.'), '""',  'failed at #1')

  " #2
  call operator#sandwich#set('add', 'char', 'command', [])
  call setline('.', '"foo"')
  normal 0ffviwsa1
  call g:assert.equals(getline('.'), '""',  'failed at #2')
endfunction
"}}}
function! s:suite.charwise_x_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ on
  " #1
  call operator#sandwich#set('add', 'char', 'linewise', 1)
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ')',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0viwsa0
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')

  %delete

  " #3
  set autoindent
  call setline('.', '    foo')
  normal ^viwsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #-39')
  call g:assert.equals(getline(2),   '    foo',    'failed at #-39')
  call g:assert.equals(getline(3),   '    )',      'failed at #-39')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #-39')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #-39')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #-39')
  set autoindent&

  %delete

  """ off
  call operator#sandwich#set('add', 'char', 'linewise', 0)

  " #4
  call setline('.', 'foo')
  normal 0viwsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal 0viwsa1
  call g:assert.equals(getline(1), '(',   'failed at #5')
  call g:assert.equals(getline(2), 'foo', 'failed at #5')
  call g:assert.equals(getline(3), ')',   'failed at #5')
endfunction
"}}}
function! s:suite.charwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " normal ^viwsaa
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'char', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'char', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'char', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal ^viwsa0
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.charwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal ^viwsa1
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'char', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  normal ^viwsaa
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'char', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal ^viwsa1
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

" line-wise
function! s:suite.linewise_n_default_recipes() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saVl)
  call g:assert.equals(getline(1),   '(',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   ')',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', 'foo')
  normal 0saVl[
  call g:assert.equals(getline(1),   '[',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal 0saVl]
  call g:assert.equals(getline(1),   '[',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal 0saVl{
  call g:assert.equals(getline(1),   '{',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '}',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #5')

  %delete

  " #6
  call setline('.', 'foo')
  normal 0saVl}
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  %delete

  " #7
  call setline('.', 'foo')
  normal 0saVl<
  call g:assert.equals(getline(1),   '<',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '>',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call setline('.', 'foo')
  normal 0saVl>
  call g:assert.equals(getline(1),   '<',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '>',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_n_not_registered() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 0saVla
  call g:assert.equals(getline(1),   'a',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'a',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saVl*
  call g:assert.equals(getline(1),   '*',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   '*',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_positioning() abort "{{{
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  normal ggsa2j(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'bar',        'failed at #1')
  call g:assert.equals(getline(4),   'baz',        'failed at #1')
  call g:assert.equals(getline(5),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  normal ggjsaVl(
  call g:assert.equals(getline(1),   'foo',        'failed at #2')
  call g:assert.equals(getline(2),   '(',          'failed at #2')
  call g:assert.equals(getline(3),   'bar',        'failed at #2')
  call g:assert.equals(getline(4),   ')',          'failed at #2')
  call g:assert.equals(getline(5),   'baz',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_a_character() abort "{{{
  " #1
  call setline('.', 'a')
  normal 0saVl(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'a',          'failed at #1')
  call g:assert.equals(getline(3),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.linewise_n_breaking() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1),   'aa',         'failed at #1')
  call g:assert.equals(getline(2),   'aaa',        'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   'aaa',        'failed at #1')
  call g:assert.equals(getline(5),   'aa',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1),   'bb',         'failed at #2')
  call g:assert.equals(getline(2),   'bbb',        'failed at #2')
  call g:assert.equals(getline(3),   'bb',         'failed at #2')
  call g:assert.equals(getline(4),   'foo',        'failed at #2')
  call g:assert.equals(getline(5),   'bb',         'failed at #2')
  call g:assert.equals(getline(6),   'bbb',        'failed at #2')
  call g:assert.equals(getline(7),   'bb',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #2')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_n_count() abort "{{{
  " #1
  call setline('.', 'foo')
  normal 02saViw([
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   '(',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ')',          'failed at #1')
  call g:assert.equals(getline(5),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '[',          'failed at #2')
  call g:assert.equals(getline(3),   '(',          'failed at #2')
  call g:assert.equals(getline(4),   'foo',        'failed at #2')
  call g:assert.equals(getline(5),   ')',          'failed at #2')
  call g:assert.equals(getline(6),   ']',          'failed at #2')
  call g:assert.equals(getline(7),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', 'foo bar')
  normal 0saV2iw(
  call g:assert.equals(getline(1), '(',            'failed at #3')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #3')
  call g:assert.equals(getline(3), ')',            'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo bar')
  normal 0saV3iw(
  call g:assert.equals(getline(1), '(',            'failed at #4')
  call g:assert.equals(getline(2), 'foo bar',      'failed at #4')
  call g:assert.equals(getline(3), ')',            'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo bar')
  normal 02saV3iw([
  call g:assert.equals(getline(1), '[',            'failed at #5')
  call g:assert.equals(getline(2), '(',            'failed at #5')
  call g:assert.equals(getline(3), 'foo bar',      'failed at #5')
  call g:assert.equals(getline(4), ')',            'failed at #5')
  call g:assert.equals(getline(5), ']',            'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['aa', 'foo', 'aa'])
  normal ggj2saViw([
  call g:assert.equals(getline(1), 'aa',           'failed at #6')
  call g:assert.equals(getline(2), '[',            'failed at #6')
  call g:assert.equals(getline(3), '(',            'failed at #6')
  call g:assert.equals(getline(4), 'foo',          'failed at #6')
  call g:assert.equals(getline(5), ')',            'failed at #6')
  call g:assert.equals(getline(6), ']',            'failed at #6')
  call g:assert.equals(getline(7), 'aa',           'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 6, 2, 0], 'failed at #6')
endfunction
"}}}
function! s:suite.linewise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'α')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',            'failed at #1')
  call g:assert.equals(getline(2), 'α',           'failed at #1')
  call g:assert.equals(getline(3), ')',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'aα')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',            'failed at #2')
  call g:assert.equals(getline(2), 'aα',          'failed at #2')
  call g:assert.equals(getline(3), ')',            'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'α', 'failed at #3')
  call g:assert.equals(getline(2), 'a',  'failed at #3')
  call g:assert.equals(getline(3), 'α', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'α')
  normal 0saVla
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getline(2), 'α', 'failed at #4')
  call g:assert.equals(getline(3), 'α', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'aα')
  normal 0saVla
  call g:assert.equals(getline(1), 'α',  'failed at #5')
  call g:assert.equals(getline(2), 'aα', 'failed at #5')
  call g:assert.equals(getline(3), 'α',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #6')
  call g:assert.equals(getline(2), 'a',   'failed at #6')
  call g:assert.equals(getline(3), 'aα', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #6')

  %delete

  " #7
  call setline('.', 'α')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #7')
  call g:assert.equals(getline(2), 'α',  'failed at #7')
  call g:assert.equals(getline(3), 'aα', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #7')

  %delete

  " #8
  call setline('.', 'aα')
  normal 0saVla
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getline(2), 'aα', 'failed at #8')
  call g:assert.equals(getline(3), 'aα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '“')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',  'failed at #9')
  call g:assert.equals(getline(2), '“', 'failed at #9')
  call g:assert.equals(getline(3), ')',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call setline('.', 'a“')
  normal 0saVl(
  call g:assert.equals(getline(1), '(',   'failed at #10')
  call g:assert.equals(getline(2), 'a“', 'failed at #10')
  call g:assert.equals(getline(3), ')',   'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), '“', 'failed at #11')
  call g:assert.equals(getline(2), 'a',  'failed at #11')
  call g:assert.equals(getline(3), '“', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #11')

  %delete

  " #12
  call setline('.', '“')
  normal 0saVla
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getline(2), '“', 'failed at #12')
  call g:assert.equals(getline(3), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call setline('.', 'a“')
  normal 0saVla
  call g:assert.equals(getline(1), '“',  'failed at #13')
  call g:assert.equals(getline(2), 'a“', 'failed at #13')
  call g:assert.equals(getline(3), '“',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #14')
  call g:assert.equals(getline(2), 'a',   'failed at #14')
  call g:assert.equals(getline(3), 'a“', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #14')

  %delete

  " #15
  call setline('.', '“')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #15')
  call g:assert.equals(getline(2), '“',  'failed at #15')
  call g:assert.equals(getline(3), 'a“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #15')

  %delete

  " #16
  call setline('.', 'a“')
  normal 0saVla
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getline(2), 'a“', 'failed at #16')
  call g:assert.equals(getline(3), 'a“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.linewise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   '(',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ')',          'failed at #1')
  call g:assert.equals(getline(5),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')

  " #2
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #2')
  call g:assert.equals(getline(2),   '(',          'failed at #2')
  call g:assert.equals(getline(3),   '(',          'failed at #2')
  call g:assert.equals(getline(4),   'foo',        'failed at #2')
  call g:assert.equals(getline(5),   ')',          'failed at #2')
  call g:assert.equals(getline(6),   ')',          'failed at #2')
  call g:assert.equals(getline(7),   ')',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '    foo')
  normal 0saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   ')',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')

  %delete

  """ inner_head
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
  " #4
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #4')
  call g:assert.equals(getline(2),   '(',          'failed at #4')
  call g:assert.equals(getline(3),   'foo',        'failed at #4')
  call g:assert.equals(getline(4),   ')',          'failed at #4')
  call g:assert.equals(getline(5),   ')',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #4')

  " #5
  normal 2lsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #5')
  call g:assert.equals(getline(2),   '(',          'failed at #5')
  call g:assert.equals(getline(3),   '(',          'failed at #5')
  call g:assert.equals(getline(4),   'foo',        'failed at #5')
  call g:assert.equals(getline(5),   ')',          'failed at #5')
  call g:assert.equals(getline(6),   ')',          'failed at #5')
  call g:assert.equals(getline(7),   ')',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #5')

  %delete

  """ keep
  " #6
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #6')
  call g:assert.equals(getline(2),   '(',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ')',          'failed at #6')
  call g:assert.equals(getline(5),   ')',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #6')

  " #7
  normal saViw(
  call g:assert.equals(getline(1),   '(',          'failed at #7')
  call g:assert.equals(getline(2),   '(',          'failed at #7')
  call g:assert.equals(getline(3),   '(',          'failed at #7')
  call g:assert.equals(getline(4),   'foo',        'failed at #7')
  call g:assert.equals(getline(5),   ')',          'failed at #7')
  call g:assert.equals(getline(6),   ')',          'failed at #7')
  call g:assert.equals(getline(7),   ')',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #7')

  %delete

  """ inner_tail
  " #8
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #8')
  call g:assert.equals(getline(2),   '(',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ')',          'failed at #8')
  call g:assert.equals(getline(5),   ')',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #8')

  " #9
  normal 2hsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #9')
  call g:assert.equals(getline(2),   '(',          'failed at #9')
  call g:assert.equals(getline(3),   '(',          'failed at #9')
  call g:assert.equals(getline(4),   'foo',        'failed at #9')
  call g:assert.equals(getline(5),   ')',          'failed at #9')
  call g:assert.equals(getline(6),   ')',          'failed at #9')
  call g:assert.equals(getline(7),   ')',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #9')

  %delete

  """ head
  " #10
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #10')
  call g:assert.equals(getline(2),   '(',          'failed at #10')
  call g:assert.equals(getline(3),   'foo',        'failed at #10')
  call g:assert.equals(getline(4),   ')',          'failed at #10')
  call g:assert.equals(getline(5),   ')',          'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 2jsaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #11')
  call g:assert.equals(getline(2),   '(',          'failed at #11')
  call g:assert.equals(getline(3),   '(',          'failed at #11')
  call g:assert.equals(getline(4),   'foo',        'failed at #11')
  call g:assert.equals(getline(5),   ')',          'failed at #11')
  call g:assert.equals(getline(6),   ')',          'failed at #11')
  call g:assert.equals(getline(7),   ')',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #11')

  %delete

  """ tail
  " #12
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0l2saViw()
  call g:assert.equals(getline(1),   '(',          'failed at #12')
  call g:assert.equals(getline(2),   '(',          'failed at #12')
  call g:assert.equals(getline(3),   'foo',        'failed at #12')
  call g:assert.equals(getline(4),   ')',          'failed at #12')
  call g:assert.equals(getline(5),   ')',          'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #12')

  " #13
  normal 2ksaViw(
  call g:assert.equals(getline(1),   '(',          'failed at #13')
  call g:assert.equals(getline(2),   '(',          'failed at #13')
  call g:assert.equals(getline(3),   '(',          'failed at #13')
  call g:assert.equals(getline(4),   'foo',        'failed at #13')
  call g:assert.equals(getline(5),   ')',          'failed at #13')
  call g:assert.equals(getline(6),   ')',          'failed at #13')
  call g:assert.equals(getline(7),   ')',          'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #13')

  %delete

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0saViw1
  call g:assert.equals(getline(1), '(',            'failed at #14')
  call g:assert.equals(getline(2), 'foo',          'failed at #14')
  call g:assert.equals(getline(3), ')',            'failed at #14')
  call g:assert.equals(getpos('.'), [0, 2, 1, 0],  'failed at #14')
endfunction
"}}}
function! s:suite.linewise_n_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  normal 03saViw([{
  call g:assert.equals(getline(1), '{',   'failed at #1')
  call g:assert.equals(getline(2), '[',   'failed at #1')
  call g:assert.equals(getline(3), '(',   'failed at #1')
  call g:assert.equals(getline(4), 'foo', 'failed at #1')
  call g:assert.equals(getline(5), ')',   'failed at #1')
  call g:assert.equals(getline(6), ']',   'failed at #1')
  call g:assert.equals(getline(7), '}',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 03saViw1
  call g:assert.equals(getline(1), '(',   'failed at #2')
  call g:assert.equals(getline(2), '(',   'failed at #2')
  call g:assert.equals(getline(3), '(',   'failed at #2')
  call g:assert.equals(getline(4), 'foo', 'failed at #2')
  call g:assert.equals(getline(5), ')',   'failed at #2')
  call g:assert.equals(getline(6), ')',   'failed at #2')
  call g:assert.equals(getline(7), ')',   'failed at #2')

  %delete

  """ on
  " #3
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal 03saViw(
  call g:assert.equals(getline(1), '(',   'failed at #3')
  call g:assert.equals(getline(2), '(',   'failed at #3')
  call g:assert.equals(getline(3), '(',   'failed at #3')
  call g:assert.equals(getline(4), 'foo', 'failed at #3')
  call g:assert.equals(getline(5), ')',   'failed at #3')
  call g:assert.equals(getline(6), ')',   'failed at #3')
  call g:assert.equals(getline(7), ')',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal 03saViw0[{
  call g:assert.equals(getline(1), '{',   'failed at #4')
  call g:assert.equals(getline(2), '[',   'failed at #4')
  call g:assert.equals(getline(3), '(',   'failed at #4')
  call g:assert.equals(getline(4), 'foo', 'failed at #4')
  call g:assert.equals(getline(5), ')',   'failed at #4')
  call g:assert.equals(getline(6), ']',   'failed at #4')
  call g:assert.equals(getline(7), '}',   'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '1+1', 'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), '1+2', 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saViw1
  call g:assert.equals(getline(1), '2',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), '3',   'failed at #2')

  %delete

  """ 1
  " #3
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal 0saViwa
  call g:assert.equals(getline(1), '2',   'failed at #3')
  call g:assert.equals(getline(2), 'foo', 'failed at #3')
  call g:assert.equals(getline(3), '3',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal 0saViwb
  call g:assert.equals(getline(1), 'foo',   'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal 0saViwc
  call g:assert.equals(getline(1), 'foo',   'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call setline('.', 'foo')
  normal 02saViwab
  call g:assert.equals(getline(1), '2',     'failed at #6')
  call g:assert.equals(getline(2), 'foo',   'failed at #6')
  call g:assert.equals(getline(3), '3',     'failed at #6')
  call g:assert.equals(exists(s:object), 0, 'failed at #6')

  %delete

  " #7
  call setline('.', 'foo')
  normal 02saViwac
  call g:assert.equals(getline(1), '2',     'failed at #7')
  call g:assert.equals(getline(2), 'foo',   'failed at #7')
  call g:assert.equals(getline(3), '3',     'failed at #7')
  call g:assert.equals(exists(s:object), 0, 'failed at #7')

  %delete

  " #8
  call setline('.', 'foo')
  normal 02saViwba
  call g:assert.equals(getline(1), 'foo',   'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  %delete

  " #9
  call setline('.', 'foo')
  normal 02saViwca
  call g:assert.equals(getline(1), 'foo',   'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  %delete

  " #10
  call setline('.', 'foo')
  normal 0saViw0
  call g:assert.equals(getline(1), '1+1', 'failed at #10')
  call g:assert.equals(getline(2), 'foo', 'failed at #10')
  call g:assert.equals(getline(3), '1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0saVla
  call g:assert.equals(getline(1), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  %delete

  " #2
  call setline('.', 'bar')
  normal 0saVl1
  call g:assert.equals(getline(1), 'foo', 'failed at #2')
  call g:assert.equals(getline(2), 'bar', 'failed at #2')
  call g:assert.equals(getline(3), 'baz', 'failed at #2')

  %delete

  """ 1
  " #3
  call operator#sandwich#set('add', 'line', 'listexpr', 1)
  call setline('.', 'bar')
  normal 0saVla
  call g:assert.equals(getline(1), 'foo', 'failed at #3')
  call g:assert.equals(getline(2), 'bar', 'failed at #3')
  call g:assert.equals(getline(3), 'baz', 'failed at #3')

  %delete

  " #4
  call setline('.', 'bar')
  normal 0saVlb
  call g:assert.equals(getline(1), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0saVl0
  call g:assert.equals(getline(1), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call setline('.', 'bar')
  normal 0saVl1
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_n_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  normal 0saViw[
  call g:assert.equals(getline(1), '[',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ']',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saViw0
  call g:assert.equals(getline(1), '{',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), '}',   'failed at #2')

  %delete

  """ off
  " #3
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal 0saViw[
  call g:assert.equals(getline(1), '{',   'failed at #3')
  call g:assert.equals(getline(2), 'foo', 'failed at #3')
  call g:assert.equals(getline(3), '}',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal 0saViw1
  call g:assert.equals(getline(1), '[',   'failed at #4')
  call g:assert.equals(getline(2), 'foo', 'failed at #4')
  call g:assert.equals(getline(3), ']',   'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ on
  " #1
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #1')
  call g:assert.equals(getline(2), 'foo ', 'failed at #1')
  call g:assert.equals(getline(3), ')',    'failed at #1')

  %delete

  " #2
  call setline('.', 'foo ')
  normal 0saViw0
  call g:assert.equals(getline(1), '(',    'failed at #2')
  call g:assert.equals(getline(2), 'foo ', 'failed at #2')
  call g:assert.equals(getline(3), ')',    'failed at #2')

  %delete

  """ off
  " #3
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal 0saViw(
  call g:assert.equals(getline(1), '(',    'failed at #3')
  call g:assert.equals(getline(2), 'foo ', 'failed at #3')
  call g:assert.equals(getline(3), ')',    'failed at #3')

  %delete

  " #4
  call setline('.', 'foo ')
  normal 0saViw1
  call g:assert.equals(getline(1), '(',    'failed at #4')
  call g:assert.equals(getline(2), 'foo ', 'failed at #4')
  call g:assert.equals(getline(3), ')',    'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjsaViw(
  call g:assert.equals(getline(1), '[', 'failed at #1')
  call g:assert.equals(getline(2), ']', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('add', 'line', 'command', [])
  call append(0, ['[', 'foo', ']'])
  normal ggjsaViw1
  call g:assert.equals(getline(1), '[', 'failed at #2')
  call g:assert.equals(getline(2), ']', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_n_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ off
  " #1
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal 0saViw(
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0saViw1
  call g:assert.equals(getline(1), '(',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), ')',   'failed at #2')

  %delete
  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #3
  set autoindent
  call setline('.', '    foo')
  normal ^saViw(
  call g:assert.equals(getline(1),   '    (',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    )',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  set autoindent&

  %delete

  " #4
  call setline('.', 'foo')
  normal 0saViw0
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getline(4),   '    foo',    'failed at #1')
  call g:assert.equals(getline(5),   '',           'failed at #1')
  call g:assert.equals(getline(6),   ']',          'failed at #1')
  call g:assert.equals(getline(7),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '',           'failed at #2')
  call g:assert.equals(getline(4),   '    foo',    'failed at #2')
  call g:assert.equals(getline(5),   '',           'failed at #2')
  call g:assert.equals(getline(6),   '    ]',      'failed at #2')
  call g:assert.equals(getline(7),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #3')
  call g:assert.equals(getline(2),   '    [',       'failed at #3')
  call g:assert.equals(getline(3),   '',            'failed at #3')
  call g:assert.equals(getline(4),   '    foo',     'failed at #3')
  call g:assert.equals(getline(5),   '',            'failed at #3')
  call g:assert.equals(getline(6),   '    ]',       'failed at #3')
  call g:assert.equals(getline(7),   '}',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #4')
  call g:assert.equals(getline(2),   '    [',       'failed at #4')
  call g:assert.equals(getline(3),   '',            'failed at #4')
  call g:assert.equals(getline(4),   '    foo',     'failed at #4')
  call g:assert.equals(getline(5),   '',            'failed at #4')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #4')
  call g:assert.equals(getline(7),   '}',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #4')
  call g:assert.equals(&l:autoindent,  1,           'failed at #4')
  call g:assert.equals(&l:smartindent, 1,           'failed at #4')
  call g:assert.equals(&l:cindent,     1,           'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " normal saVla
  " call g:assert.equals(getline(1),   '       {',              'failed at #5')
  " call g:assert.equals(getline(2),   '           [',          'failed at #5')
  " call g:assert.equals(getline(3),   '',                      'failed at #5')
  " call g:assert.equals(getline(4),   '    foo',               'failed at #5')
  " call g:assert.equals(getline(5),   '',                      'failed at #5')
  " call g:assert.equals(getline(6),   '            ]',         'failed at #5')
  " call g:assert.equals(getline(7),   '                    }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 4,  5, 0],           'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  1, 0],           'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 7, 22, 0],           'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                     'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                     'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                     'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',        'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getline(4),   '    foo',    'failed at #6')
  call g:assert.equals(getline(5),   '',           'failed at #6')
  call g:assert.equals(getline(6),   ']',          'failed at #6')
  call g:assert.equals(getline(7),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   '',           'failed at #7')
  call g:assert.equals(getline(4),   '    foo',    'failed at #7')
  call g:assert.equals(getline(5),   '',           'failed at #7')
  call g:assert.equals(getline(6),   ']',          'failed at #7')
  call g:assert.equals(getline(7),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   '',           'failed at #8')
  call g:assert.equals(getline(4),   '    foo',    'failed at #8')
  call g:assert.equals(getline(5),   '',           'failed at #8')
  call g:assert.equals(getline(6),   ']',          'failed at #8')
  call g:assert.equals(getline(7),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   '',           'failed at #9')
  call g:assert.equals(getline(4),   '    foo',    'failed at #9')
  call g:assert.equals(getline(5),   '',           'failed at #9')
  call g:assert.equals(getline(6),   ']',          'failed at #9')
  call g:assert.equals(getline(7),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   '',               'failed at #10')
  call g:assert.equals(getline(4),   '    foo',        'failed at #10')
  call g:assert.equals(getline(5),   '',               'failed at #10')
  call g:assert.equals(getline(6),   ']',              'failed at #10')
  call g:assert.equals(getline(7),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getline(4),   '    foo',    'failed at #11')
  call g:assert.equals(getline(5),   '',           'failed at #11')
  call g:assert.equals(getline(6),   '    ]',      'failed at #11')
  call g:assert.equals(getline(7),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '',           'failed at #12')
  call g:assert.equals(getline(4),   '    foo',    'failed at #12')
  call g:assert.equals(getline(5),   '',           'failed at #12')
  call g:assert.equals(getline(6),   '    ]',      'failed at #12')
  call g:assert.equals(getline(7),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '',           'failed at #13')
  call g:assert.equals(getline(4),   '    foo',    'failed at #13')
  call g:assert.equals(getline(5),   '',           'failed at #13')
  call g:assert.equals(getline(6),   '    ]',      'failed at #13')
  call g:assert.equals(getline(7),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '',           'failed at #14')
  call g:assert.equals(getline(4),   '    foo',    'failed at #14')
  call g:assert.equals(getline(5),   '',           'failed at #14')
  call g:assert.equals(getline(6),   '    ]',      'failed at #14')
  call g:assert.equals(getline(7),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '',               'failed at #15')
  call g:assert.equals(getline(4),   '    foo',        'failed at #15')
  call g:assert.equals(getline(5),   '',               'failed at #15')
  call g:assert.equals(getline(6),   '    ]',          'failed at #15')
  call g:assert.equals(getline(7),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #16')
  call g:assert.equals(getline(2),   '    [',       'failed at #16')
  call g:assert.equals(getline(3),   '',            'failed at #16')
  call g:assert.equals(getline(4),   '    foo',     'failed at #16')
  call g:assert.equals(getline(5),   '',            'failed at #16')
  call g:assert.equals(getline(6),   '    ]',       'failed at #16')
  call g:assert.equals(getline(7),   '}',           'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #17')
  call g:assert.equals(getline(2),   '    [',       'failed at #17')
  call g:assert.equals(getline(3),   '',            'failed at #17')
  call g:assert.equals(getline(4),   '    foo',     'failed at #17')
  call g:assert.equals(getline(5),   '',            'failed at #17')
  call g:assert.equals(getline(6),   '    ]',       'failed at #17')
  call g:assert.equals(getline(7),   '}',           'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #18')
  call g:assert.equals(getline(2),   '    [',       'failed at #18')
  call g:assert.equals(getline(3),   '',            'failed at #18')
  call g:assert.equals(getline(4),   '    foo',     'failed at #18')
  call g:assert.equals(getline(5),   '',            'failed at #18')
  call g:assert.equals(getline(6),   '    ]',       'failed at #18')
  call g:assert.equals(getline(7),   '}',           'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #19')
  call g:assert.equals(getline(2),   '    [',       'failed at #19')
  call g:assert.equals(getline(3),   '',            'failed at #19')
  call g:assert.equals(getline(4),   '    foo',     'failed at #19')
  call g:assert.equals(getline(5),   '',            'failed at #19')
  call g:assert.equals(getline(6),   '    ]',       'failed at #19')
  call g:assert.equals(getline(7),   '}',           'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #20')
  call g:assert.equals(getline(2),   '    [',          'failed at #20')
  call g:assert.equals(getline(3),   '',               'failed at #20')
  call g:assert.equals(getline(4),   '    foo',        'failed at #20')
  call g:assert.equals(getline(5),   '',               'failed at #20')
  call g:assert.equals(getline(6),   '    ]',          'failed at #20')
  call g:assert.equals(getline(7),   '}',              'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #21')
  call g:assert.equals(getline(2),   '    [',       'failed at #21')
  call g:assert.equals(getline(3),   '',            'failed at #21')
  call g:assert.equals(getline(4),   '    foo',     'failed at #21')
  call g:assert.equals(getline(5),   '',            'failed at #21')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #21')
  call g:assert.equals(getline(7),   '}',           'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #21')
  call g:assert.equals(&l:autoindent,  0,           'failed at #21')
  call g:assert.equals(&l:smartindent, 0,           'failed at #21')
  call g:assert.equals(&l:cindent,     0,           'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #22')
  call g:assert.equals(getline(2),   '    [',       'failed at #22')
  call g:assert.equals(getline(3),   '',            'failed at #22')
  call g:assert.equals(getline(4),   '    foo',     'failed at #22')
  call g:assert.equals(getline(5),   '',            'failed at #22')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #22')
  call g:assert.equals(getline(7),   '}',           'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #22')
  call g:assert.equals(&l:autoindent,  1,           'failed at #22')
  call g:assert.equals(&l:smartindent, 0,           'failed at #22')
  call g:assert.equals(&l:cindent,     0,           'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #23')
  call g:assert.equals(getline(2),   '    [',       'failed at #23')
  call g:assert.equals(getline(3),   '',            'failed at #23')
  call g:assert.equals(getline(4),   '    foo',     'failed at #23')
  call g:assert.equals(getline(5),   '',            'failed at #23')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #23')
  call g:assert.equals(getline(7),   '}',           'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #23')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #23')
  call g:assert.equals(&l:autoindent,  1,           'failed at #23')
  call g:assert.equals(&l:smartindent, 1,           'failed at #23')
  call g:assert.equals(&l:cindent,     0,           'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',           'failed at #24')
  call g:assert.equals(getline(2),   '    [',       'failed at #24')
  call g:assert.equals(getline(3),   '',            'failed at #24')
  call g:assert.equals(getline(4),   '    foo',     'failed at #24')
  call g:assert.equals(getline(5),   '',            'failed at #24')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #24')
  call g:assert.equals(getline(7),   '}',           'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #24')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #24')
  call g:assert.equals(&l:autoindent,  1,           'failed at #24')
  call g:assert.equals(&l:smartindent, 1,           'failed at #24')
  call g:assert.equals(&l:cindent,     1,           'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '',               'failed at #25')
  call g:assert.equals(getline(4),   '    foo',        'failed at #25')
  call g:assert.equals(getline(5),   '',               'failed at #25')
  " call g:assert.equals(getline(6),   '        ]',      'failed at #25')
  call g:assert.equals(getline(7),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal saVl0
  call g:assert.equals(getline(1),   '{',          'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   '',           'failed at #26')
  call g:assert.equals(getline(4),   '    foo',    'failed at #26')
  call g:assert.equals(getline(5),   '',           'failed at #26')
  call g:assert.equals(getline(6),   ']',          'failed at #26')
  call g:assert.equals(getline(7),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.linewise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{", "}"], 'input': ['a']},
        \   {'buns': ["{", "}"], 'indentkeys': '0},0),:,0#,!^F,o,e', 'input': ['1']},
        \ ]

  """ cinkeys
  setlocal autoindent
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '    foo',    'failed at #1')
  call g:assert.equals(getline(3),   '    }',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #2
  setlocal cinkeys=0},0),:,0#,!^F,o,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,0{')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,0{')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    }',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal saVl1
  call g:assert.equals(getline(1),   '    {',      'failed at #4')
  call g:assert.equals(getline(2),   '    foo',    'failed at #4')
  call g:assert.equals(getline(3),   '    }',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #5')
  call g:assert.equals(getline(2),   '    foo',       'failed at #5')
  call g:assert.equals(getline(3),   '            }', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0},0),:,0#,!^F,o,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,0{')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '       {',      'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,0{')
  call setline('.', '    foo')
  normal saVla
  call g:assert.equals(getline(1),   '    {',         'failed at #7')
  call g:assert.equals(getline(2),   '    foo',       'failed at #7')
  call g:assert.equals(getline(3),   '            }', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal saVl1
  call g:assert.equals(getline(1),   '    {',         'failed at #8')
  call g:assert.equals(getline(2),   '    foo',       'failed at #8')
  call g:assert.equals(getline(3),   '            }', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

function! s:suite.linewise_x_default_recipes() abort "{{{
  " #1
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal Vsa)
  call g:assert.equals(getline(1),   '(',          'failed at #2')
  call g:assert.equals(getline(2),   'foo',        'failed at #2')
  call g:assert.equals(getline(3),   ')',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1),   '[',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   ']',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal Vsa]
  call g:assert.equals(getline(1),   '[',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   ']',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal Vsa{
  call g:assert.equals(getline(1),   '{',          'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '}',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #5')

  %delete

  " #6
  call setline('.', 'foo')
  normal Vsa}
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   'foo',        'failed at #6')
  call g:assert.equals(getline(3),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #6')

  %delete

  " #7
  call setline('.', 'foo')
  normal Vsa<
  call g:assert.equals(getline(1),   '<',          'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '>',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #7')

  %delete

  " #8
  call setline('.', 'foo')
  normal Vsa>
  call g:assert.equals(getline(1),   '<',          'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '>',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.linewise_x_not_registered() abort "{{{
  " #1
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), 'a',            'failed at #1')
  call g:assert.equals(getline(2), 'foo',          'failed at #1')
  call g:assert.equals(getline(3), 'a',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal Vsa*
  call g:assert.equals(getline(1), '*',            'failed at #2')
  call g:assert.equals(getline(2), 'foo',          'failed at #2')
  call g:assert.equals(getline(3), '*',            'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_positioning() abort "{{{
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  normal ggV2jsa(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   'bar',        'failed at #1')
  call g:assert.equals(getline(4),   'baz',        'failed at #1')
  call g:assert.equals(getline(5),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.linewise_x_a_character() abort "{{{
  " #1
  call setline('.', 'a')
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   'a',          'failed at #1')
  call g:assert.equals(getline(3),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
endfunction
"}}}
function! s:suite.linewise_x_breaking() abort "{{{
  " #1
  call append(0, ['', 'foo'])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #1')
  call g:assert.equals(getline(2), '',             'failed at #1')
  call g:assert.equals(getline(3), 'foo',          'failed at #1')
  call g:assert.equals(getline(4), ')',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', ''])
  normal ggVjsa(
  call g:assert.equals(getline(1), '(',            'failed at #2')
  call g:assert.equals(getline(2), 'foo',          'failed at #2')
  call g:assert.equals(getline(3), '',             'failed at #2')
  call g:assert.equals(getline(4), ')',            'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 4, 2, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #3
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaa',        'failed at #3')
  call g:assert.equals(getline(3),   'foo',        'failed at #3')
  call g:assert.equals(getline(4),   'aaa',        'failed at #3')
  call g:assert.equals(getline(5),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 3, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1),   'bb',         'failed at #4')
  call g:assert.equals(getline(2),   'bbb',        'failed at #4')
  call g:assert.equals(getline(3),   'bb',         'failed at #4')
  call g:assert.equals(getline(4),   'foo',        'failed at #4')
  call g:assert.equals(getline(5),   'bb',         'failed at #4')
  call g:assert.equals(getline(6),   'bbb',        'failed at #4')
  call g:assert.equals(getline(7),   'bb',         'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 7, 3, 0], 'failed at #4')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.linewise_x_count() abort "{{{
  " #1
  call setline('.', 'foo')
  normal V2sa([
  call g:assert.equals(getline(1),   '[',          'failed at #1')
  call g:assert.equals(getline(2),   '(',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ')',          'failed at #1')
  call g:assert.equals(getline(5),   ']',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '[',          'failed at #2')
  call g:assert.equals(getline(3),   '(',          'failed at #2')
  call g:assert.equals(getline(4),   'foo',        'failed at #2')
  call g:assert.equals(getline(5),   ')',          'failed at #2')
  call g:assert.equals(getline(6),   ']',          'failed at #2')
  call g:assert.equals(getline(7),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call setline('.', 'α')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',            'failed at #1')
  call g:assert.equals(getline(2), 'α',           'failed at #1')
  call g:assert.equals(getline(3), ')',            'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')

  %delete

  " #2
  call setline('.', 'aα')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',            'failed at #2')
  call g:assert.equals(getline(2), 'aα',          'failed at #2')
  call g:assert.equals(getline(3), ')',            'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α', 'failed at #3')
  call g:assert.equals(getline(2), 'a',  'failed at #3')
  call g:assert.equals(getline(3), 'α', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'α')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α', 'failed at #4')
  call g:assert.equals(getline(2), 'α', 'failed at #4')
  call g:assert.equals(getline(3), 'α', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'aα')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'α',  'failed at #5')
  call g:assert.equals(getline(2), 'aα', 'failed at #5')
  call g:assert.equals(getline(3), 'α',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('α')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #6')
  call g:assert.equals(getline(2), 'a',   'failed at #6')
  call g:assert.equals(getline(3), 'aα', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #6')

  %delete

  " #7
  call setline('.', 'α')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #7')
  call g:assert.equals(getline(2), 'α',  'failed at #7')
  call g:assert.equals(getline(3), 'aα', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #7')

  %delete

  " #8
  call setline('.', 'aα')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'aα', 'failed at #8')
  call g:assert.equals(getline(2), 'aα', 'failed at #8')
  call g:assert.equals(getline(3), 'aα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aα')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call setline('.', '“')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',  'failed at #9')
  call g:assert.equals(getline(2), '“', 'failed at #9')
  call g:assert.equals(getline(3), ')',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #9')

  %delete

  " #10
  call setline('.', 'a“')
  normal 0Vsa(
  call g:assert.equals(getline(1), '(',   'failed at #10')
  call g:assert.equals(getline(2), 'a“', 'failed at #10')
  call g:assert.equals(getline(3), ')',   'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“', 'failed at #11')
  call g:assert.equals(getline(2), 'a',  'failed at #11')
  call g:assert.equals(getline(3), '“', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #11')

  %delete

  " #12
  call setline('.', '“')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“', 'failed at #12')
  call g:assert.equals(getline(2), '“', 'failed at #12')
  call g:assert.equals(getline(3), '“', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #12')

  %delete

  " #13
  call setline('.', 'a“')
  normal 0Vsaa
  call g:assert.equals(getline(1), '“',  'failed at #13')
  call g:assert.equals(getline(2), 'a“', 'failed at #13')
  call g:assert.equals(getline(3), '“',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call setline('.', 'a')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #14')
  call g:assert.equals(getline(2), 'a',   'failed at #14')
  call g:assert.equals(getline(3), 'a“', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #14')

  %delete

  " #15
  call setline('.', '“')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #15')
  call g:assert.equals(getline(2), '“',  'failed at #15')
  call g:assert.equals(getline(3), 'a“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #15')

  %delete

  " #16
  call setline('.', 'a“')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'a“', 'failed at #16')
  call g:assert.equals(getline(2), 'a“', 'failed at #16')
  call g:assert.equals(getline(3), 'a“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.linewise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #1')
  call g:assert.equals(getline(2),   '(',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ')',          'failed at #1')
  call g:assert.equals(getline(5),   ')',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')

  " #2
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #2')
  call g:assert.equals(getline(2),   '(',          'failed at #2')
  call g:assert.equals(getline(3),   '(',          'failed at #2')
  call g:assert.equals(getline(4),   'foo',        'failed at #2')
  call g:assert.equals(getline(5),   ')',          'failed at #2')
  call g:assert.equals(getline(6),   ')',          'failed at #2')
  call g:assert.equals(getline(7),   ')',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', '    foo')
  normal 0Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   ')',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')

  %delete

  """ inner_head
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_head')
  " #4
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #4')
  call g:assert.equals(getline(2),   '(',          'failed at #4')
  call g:assert.equals(getline(3),   'foo',        'failed at #4')
  call g:assert.equals(getline(4),   ')',          'failed at #4')
  call g:assert.equals(getline(5),   ')',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #4')

  " #5
  normal 2lVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #5')
  call g:assert.equals(getline(2),   '(',          'failed at #5')
  call g:assert.equals(getline(3),   '(',          'failed at #5')
  call g:assert.equals(getline(4),   'foo',        'failed at #5')
  call g:assert.equals(getline(5),   ')',          'failed at #5')
  call g:assert.equals(getline(6),   ')',          'failed at #5')
  call g:assert.equals(getline(7),   ')',          'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 4, 1, 0], 'failed at #5')

  %delete

  """ keep
  " #6
  call operator#sandwich#set('add', 'line', 'cursor', 'keep')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #6')
  call g:assert.equals(getline(2),   '(',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ')',          'failed at #6')
  call g:assert.equals(getline(5),   ')',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 2, 0], 'failed at #6')

  " #7
  normal Vsa(
  call g:assert.equals(getline(1),   '(',          'failed at #7')
  call g:assert.equals(getline(2),   '(',          'failed at #7')
  call g:assert.equals(getline(3),   '(',          'failed at #7')
  call g:assert.equals(getline(4),   'foo',        'failed at #7')
  call g:assert.equals(getline(5),   ')',          'failed at #7')
  call g:assert.equals(getline(6),   ')',          'failed at #7')
  call g:assert.equals(getline(7),   ')',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 2, 0], 'failed at #7')

  %delete

  """ inner_tail
  " #8
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #8')
  call g:assert.equals(getline(2),   '(',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ')',          'failed at #8')
  call g:assert.equals(getline(5),   ')',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 3, 0], 'failed at #8')

  " #9
  normal 2hVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #9')
  call g:assert.equals(getline(2),   '(',          'failed at #9')
  call g:assert.equals(getline(3),   '(',          'failed at #9')
  call g:assert.equals(getline(4),   'foo',        'failed at #9')
  call g:assert.equals(getline(5),   ')',          'failed at #9')
  call g:assert.equals(getline(6),   ')',          'failed at #9')
  call g:assert.equals(getline(7),   ')',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 3, 0], 'failed at #9')

  %delete

  """ head
  " #10
  call operator#sandwich#set('add', 'line', 'cursor', 'head')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #10')
  call g:assert.equals(getline(2),   '(',          'failed at #10')
  call g:assert.equals(getline(3),   'foo',        'failed at #10')
  call g:assert.equals(getline(4),   ')',          'failed at #10')
  call g:assert.equals(getline(5),   ')',          'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  normal 2jVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #11')
  call g:assert.equals(getline(2),   '(',          'failed at #11')
  call g:assert.equals(getline(3),   '(',          'failed at #11')
  call g:assert.equals(getline(4),   'foo',        'failed at #11')
  call g:assert.equals(getline(5),   ')',          'failed at #11')
  call g:assert.equals(getline(6),   ')',          'failed at #11')
  call g:assert.equals(getline(7),   ')',          'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #11')

  %delete

  """ tail
  " #12
  call operator#sandwich#set('add', 'line', 'cursor', 'tail')
  call setline('.', 'foo')
  normal 0lV2sa()
  call g:assert.equals(getline(1),   '(',          'failed at #12')
  call g:assert.equals(getline(2),   '(',          'failed at #12')
  call g:assert.equals(getline(3),   'foo',        'failed at #12')
  call g:assert.equals(getline(4),   ')',          'failed at #12')
  call g:assert.equals(getline(5),   ')',          'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #12')

  " #13
  normal 2kVsa(
  call g:assert.equals(getline(1),   '(',          'failed at #13')
  call g:assert.equals(getline(2),   '(',          'failed at #13')
  call g:assert.equals(getline(3),   '(',          'failed at #13')
  call g:assert.equals(getline(4),   'foo',        'failed at #13')
  call g:assert.equals(getline(5),   ')',          'failed at #13')
  call g:assert.equals(getline(6),   ')',          'failed at #13')
  call g:assert.equals(getline(7),   ')',          'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 5, 1, 0], 'failed at #13')

  %delete

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'line', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  normal Vsa1
  call g:assert.equals(getline(1), '(',            'failed at #14')
  call g:assert.equals(getline(2), 'foo',          'failed at #14')
  call g:assert.equals(getline(3), ')',            'failed at #14')
  call g:assert.equals(getpos('.'), [0, 2, 1, 0],  'failed at #14')
endfunction
"}}}
function! s:suite.linewise_x_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  normal V3sa([{
  call g:assert.equals(getline(1), '{',   'failed at #1')
  call g:assert.equals(getline(2), '[',   'failed at #1')
  call g:assert.equals(getline(3), '(',   'failed at #1')
  call g:assert.equals(getline(4), 'foo', 'failed at #1')
  call g:assert.equals(getline(5), ')',   'failed at #1')
  call g:assert.equals(getline(6), ']',   'failed at #1')
  call g:assert.equals(getline(7), '}',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal V3sa1
  call g:assert.equals(getline(1), '(',   'failed at #2')
  call g:assert.equals(getline(2), '(',   'failed at #2')
  call g:assert.equals(getline(3), '(',   'failed at #2')
  call g:assert.equals(getline(4), 'foo', 'failed at #2')
  call g:assert.equals(getline(5), ')',   'failed at #2')
  call g:assert.equals(getline(6), ')',   'failed at #2')
  call g:assert.equals(getline(7), ')',   'failed at #2')

  %delete

  """ on
  " #3
  call operator#sandwich#set('add', 'line', 'query_once', 1)
  call setline('.', 'foo')
  normal V3sa(
  call g:assert.equals(getline(1), '(',   'failed at #3')
  call g:assert.equals(getline(2), '(',   'failed at #3')
  call g:assert.equals(getline(3), '(',   'failed at #3')
  call g:assert.equals(getline(4), 'foo', 'failed at #3')
  call g:assert.equals(getline(5), ')',   'failed at #3')
  call g:assert.equals(getline(6), ')',   'failed at #3')
  call g:assert.equals(getline(7), ')',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal V3sa0[{
  call g:assert.equals(getline(1), '{',   'failed at #4')
  call g:assert.equals(getline(2), '[',   'failed at #4')
  call g:assert.equals(getline(3), '(',   'failed at #4')
  call g:assert.equals(getline(4), 'foo', 'failed at #4')
  call g:assert.equals(getline(5), ')',   'failed at #4')
  call g:assert.equals(getline(6), ']',   'failed at #4')
  call g:assert.equals(getline(7), '}',   'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_option_expr() abort  "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '1+1', 'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), '1+2', 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal 0Vsa1
  call g:assert.equals(getline(1), '2',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), '3',   'failed at #2')

  %delete

  """ 1
  " #3
  call operator#sandwich#set('add', 'line', 'expr', 1)
  call setline('.', 'foo')
  normal Vsaa
  call g:assert.equals(getline(1), '2',   'failed at #3')
  call g:assert.equals(getline(2), 'foo', 'failed at #3')
  call g:assert.equals(getline(3), '3',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal Vsab
  call g:assert.equals(getline(1), 'foo',   'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  normal Vsac
  call g:assert.equals(getline(1), 'foo',   'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call setline('.', 'foo')
  normal V2saab
  call g:assert.equals(getline(1), '2',     'failed at #6')
  call g:assert.equals(getline(2), 'foo',   'failed at #6')
  call g:assert.equals(getline(3), '3',     'failed at #6')
  call g:assert.equals(exists(s:object), 0, 'failed at #6')

  %delete

  " #7
  call setline('.', 'foo')
  normal V2saac
  call g:assert.equals(getline(1), '2',     'failed at #7')
  call g:assert.equals(getline(2), 'foo',   'failed at #7')
  call g:assert.equals(getline(3), '3',     'failed at #7')
  call g:assert.equals(exists(s:object), 0, 'failed at #7')

  %delete

  " #8
  call setline('.', 'foo')
  normal V2saba
  call g:assert.equals(getline(1), 'foo',   'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  %delete

  " #9
  call setline('.', 'foo')
  normal V2saca
  call g:assert.equals(getline(1), 'foo',   'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  %delete

  " #10
  call setline('.', 'foo')
  normal 0Vsa0
  call g:assert.equals(getline(1), '1+1', 'failed at #10')
  call g:assert.equals(getline(2), 'foo', 'failed at #10')
  call g:assert.equals(getline(3), '1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0Vsaa
  call g:assert.equals(getline(1), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  %delete

  " #2
  call setline('.', 'bar')
  normal 0Vsa1
  call g:assert.equals(getline(1), 'foo', 'failed at #2')
  call g:assert.equals(getline(2), 'bar', 'failed at #2')
  call g:assert.equals(getline(3), 'baz', 'failed at #2')

  %delete

  """ 1
  " #3
  call operator#sandwich#set('add', 'line', 'listexpr', 1)
  call setline('.', 'bar')
  normal 0Vsaa
  call g:assert.equals(getline(1), 'foo', 'failed at #3')
  call g:assert.equals(getline(2), 'bar', 'failed at #3')
  call g:assert.equals(getline(3), 'baz', 'failed at #3')

  %delete

  " #4
  call setline('.', 'bar')
  normal 0Vsab
  call g:assert.equals(getline(1), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :normal 0Vsa0
  call g:assert.equals(getline(1), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call setline('.', 'bar')
  normal 0Vsa1
  call g:assert.equals(getline(1), 'foo', 'failed at #6')
  call g:assert.equals(getline(2), 'bar', 'failed at #6')
  call g:assert.equals(getline(3), 'baz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.linewise_x_option_noremap() abort "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1), '[',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ']',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal Vsa0
  call g:assert.equals(getline(1), '{',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), '}',   'failed at #2')

  %delete

  """ off
  " #3
  call operator#sandwich#set('add', 'line', 'noremap', 0)
  call setline('.', 'foo')
  normal Vsa[
  call g:assert.equals(getline(1), '{',   'failed at #3')
  call g:assert.equals(getline(2), 'foo', 'failed at #3')
  call g:assert.equals(getline(3), '}',   'failed at #3')

  %delete

  " #4
  call setline('.', 'foo')
  normal Vsa1
  call g:assert.equals(getline(1), '[',   'failed at #4')
  call g:assert.equals(getline(2), 'foo', 'failed at #4')
  call g:assert.equals(getline(3), ']',   'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ on
  " #1
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #1')
  call g:assert.equals(getline(2), 'foo ', 'failed at #1')
  call g:assert.equals(getline(3), ')',    'failed at #1')

  %delete

  " #2
  call setline('.', 'foo ')
  normal Vsa0
  call g:assert.equals(getline(1), '(',    'failed at #2')
  call g:assert.equals(getline(2), 'foo ', 'failed at #2')
  call g:assert.equals(getline(3), ')',    'failed at #2')

  %delete

  """ off
  " #3
  call operator#sandwich#set('add', 'line', 'skip_space', 0)
  call setline('.', 'foo ')
  normal Vsa(
  call g:assert.equals(getline(1), '(',    'failed at #3')
  call g:assert.equals(getline(2), 'foo ', 'failed at #3')
  call g:assert.equals(getline(3), ')',    'failed at #3')

  %delete

  " #4
  call setline('.', 'foo ')
  normal Vsa1
  call g:assert.equals(getline(1), '(',    'failed at #4')
  call g:assert.equals(getline(2), 'foo ', 'failed at #4')
  call g:assert.equals(getline(3), ')',    'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'line', 'command', ["normal! `[d`]"])
  call append(0, ['[', 'foo', ']'])
  normal ggjVsa(
  call g:assert.equals(getline(1), '[', 'failed at #1')
  call g:assert.equals(getline(2), ']', 'failed at #1')

  %delete

  " #2
  call operator#sandwich#set('add', 'line', 'command', [])
  call append(0, ['[', 'foo', ']'])
  normal ggjVsa1
  call g:assert.equals(getline(1), '[', 'failed at #2')
  call g:assert.equals(getline(2), ']', 'failed at #2')
endfunction
"}}}
function! s:suite.linewise_x_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ off
  " #1
  call operator#sandwich#set('add', 'line', 'linewise', 0)
  call setline('.', 'foo')
  normal Vsa(
  call g:assert.equals(getline(1), '(foo)', 'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  normal Vsa1
  call g:assert.equals(getline(1), '(',   'failed at #2')
  call g:assert.equals(getline(2), 'foo', 'failed at #2')
  call g:assert.equals(getline(3), ')',   'failed at #2')

  %delete
  call operator#sandwich#set('add', 'line', 'linewise', 1)

  """ on
  " #3
  set autoindent
  call setline('.', '    foo')
  normal Vsa(
  call g:assert.equals(getline(1),   '    (',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    )',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  set autoindent&

  %delete

  " #4
  call setline('.', 'foo')
  normal Vsa0
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.linewise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   '',           'failed at #1')
  call g:assert.equals(getline(4),   '    foo',    'failed at #1')
  call g:assert.equals(getline(5),   '',           'failed at #1')
  call g:assert.equals(getline(6),   ']',          'failed at #1')
  call g:assert.equals(getline(7),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '',           'failed at #2')
  call g:assert.equals(getline(4),   '    foo',    'failed at #2')
  call g:assert.equals(getline(5),   '',           'failed at #2')
  call g:assert.equals(getline(6),   '    ]',      'failed at #2')
  call g:assert.equals(getline(7),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #3')
  call g:assert.equals(getline(2),   '    [',       'failed at #3')
  call g:assert.equals(getline(3),   '',            'failed at #3')
  call g:assert.equals(getline(4),   '    foo',     'failed at #3')
  call g:assert.equals(getline(5),   '',            'failed at #3')
  call g:assert.equals(getline(6),   '    ]',       'failed at #3')
  call g:assert.equals(getline(7),   '}',           'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #4')
  call g:assert.equals(getline(2),   '    [',       'failed at #4')
  call g:assert.equals(getline(3),   '',            'failed at #4')
  call g:assert.equals(getline(4),   '    foo',     'failed at #4')
  call g:assert.equals(getline(5),   '',            'failed at #4')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #4')
  call g:assert.equals(getline(7),   '}',           'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #4')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #4')
  call g:assert.equals(&l:autoindent,  1,           'failed at #4')
  call g:assert.equals(&l:smartindent, 1,           'failed at #4')
  call g:assert.equals(&l:cindent,     1,           'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " normal Vsaa
  " call g:assert.equals(getline(1),   '       {',              'failed at #5')
  " call g:assert.equals(getline(2),   '           [',          'failed at #5')
  " call g:assert.equals(getline(3),   '',                      'failed at #5')
  " call g:assert.equals(getline(4),   '    foo',               'failed at #5')
  " call g:assert.equals(getline(5),   '',                      'failed at #5')
  " call g:assert.equals(getline(6),   '            ]',         'failed at #5')
  " call g:assert.equals(getline(7),   '                    }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 4,  5, 0],           'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  1, 0],           'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 7, 22, 0],           'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                     'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                     'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                     'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',        'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'line', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   '',           'failed at #6')
  call g:assert.equals(getline(4),   '    foo',    'failed at #6')
  call g:assert.equals(getline(5),   '',           'failed at #6')
  call g:assert.equals(getline(6),   ']',          'failed at #6')
  call g:assert.equals(getline(7),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   '',           'failed at #7')
  call g:assert.equals(getline(4),   '    foo',    'failed at #7')
  call g:assert.equals(getline(5),   '',           'failed at #7')
  call g:assert.equals(getline(6),   ']',          'failed at #7')
  call g:assert.equals(getline(7),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   '',           'failed at #8')
  call g:assert.equals(getline(4),   '    foo',    'failed at #8')
  call g:assert.equals(getline(5),   '',           'failed at #8')
  call g:assert.equals(getline(6),   ']',          'failed at #8')
  call g:assert.equals(getline(7),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   '',           'failed at #9')
  call g:assert.equals(getline(4),   '    foo',    'failed at #9')
  call g:assert.equals(getline(5),   '',           'failed at #9')
  call g:assert.equals(getline(6),   ']',          'failed at #9')
  call g:assert.equals(getline(7),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   '',               'failed at #10')
  call g:assert.equals(getline(4),   '    foo',        'failed at #10')
  call g:assert.equals(getline(5),   '',               'failed at #10')
  call g:assert.equals(getline(6),   ']',              'failed at #10')
  call g:assert.equals(getline(7),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'line', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '',           'failed at #11')
  call g:assert.equals(getline(4),   '    foo',    'failed at #11')
  call g:assert.equals(getline(5),   '',           'failed at #11')
  call g:assert.equals(getline(6),   '    ]',      'failed at #11')
  call g:assert.equals(getline(7),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '',           'failed at #12')
  call g:assert.equals(getline(4),   '    foo',    'failed at #12')
  call g:assert.equals(getline(5),   '',           'failed at #12')
  call g:assert.equals(getline(6),   '    ]',      'failed at #12')
  call g:assert.equals(getline(7),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '',           'failed at #13')
  call g:assert.equals(getline(4),   '    foo',    'failed at #13')
  call g:assert.equals(getline(5),   '',           'failed at #13')
  call g:assert.equals(getline(6),   '    ]',      'failed at #13')
  call g:assert.equals(getline(7),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '',           'failed at #14')
  call g:assert.equals(getline(4),   '    foo',    'failed at #14')
  call g:assert.equals(getline(5),   '',           'failed at #14')
  call g:assert.equals(getline(6),   '    ]',      'failed at #14')
  call g:assert.equals(getline(7),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '',               'failed at #15')
  call g:assert.equals(getline(4),   '    foo',        'failed at #15')
  call g:assert.equals(getline(5),   '',               'failed at #15')
  call g:assert.equals(getline(6),   '    ]',          'failed at #15')
  call g:assert.equals(getline(7),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 7, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'line', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #16')
  call g:assert.equals(getline(2),   '    [',       'failed at #16')
  call g:assert.equals(getline(3),   '',            'failed at #16')
  call g:assert.equals(getline(4),   '    foo',     'failed at #16')
  call g:assert.equals(getline(5),   '',            'failed at #16')
  call g:assert.equals(getline(6),   '    ]',       'failed at #16')
  call g:assert.equals(getline(7),   '}',           'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #17')
  call g:assert.equals(getline(2),   '    [',       'failed at #17')
  call g:assert.equals(getline(3),   '',            'failed at #17')
  call g:assert.equals(getline(4),   '    foo',     'failed at #17')
  call g:assert.equals(getline(5),   '',            'failed at #17')
  call g:assert.equals(getline(6),   '    ]',       'failed at #17')
  call g:assert.equals(getline(7),   '}',           'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #18')
  call g:assert.equals(getline(2),   '    [',       'failed at #18')
  call g:assert.equals(getline(3),   '',            'failed at #18')
  call g:assert.equals(getline(4),   '    foo',     'failed at #18')
  call g:assert.equals(getline(5),   '',            'failed at #18')
  call g:assert.equals(getline(6),   '    ]',       'failed at #18')
  call g:assert.equals(getline(7),   '}',           'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #19')
  call g:assert.equals(getline(2),   '    [',       'failed at #19')
  call g:assert.equals(getline(3),   '',            'failed at #19')
  call g:assert.equals(getline(4),   '    foo',     'failed at #19')
  call g:assert.equals(getline(5),   '',            'failed at #19')
  call g:assert.equals(getline(6),   '    ]',       'failed at #19')
  call g:assert.equals(getline(7),   '}',           'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #20')
  call g:assert.equals(getline(2),   '    [',          'failed at #20')
  call g:assert.equals(getline(3),   '',               'failed at #20')
  call g:assert.equals(getline(4),   '    foo',        'failed at #20')
  call g:assert.equals(getline(5),   '',               'failed at #20')
  call g:assert.equals(getline(6),   '    ]',          'failed at #20')
  call g:assert.equals(getline(7),   '}',              'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #21')
  call g:assert.equals(getline(2),   '    [',       'failed at #21')
  call g:assert.equals(getline(3),   '',            'failed at #21')
  call g:assert.equals(getline(4),   '    foo',     'failed at #21')
  call g:assert.equals(getline(5),   '',            'failed at #21')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #21')
  call g:assert.equals(getline(7),   '}',           'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #21')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #21')
  call g:assert.equals(&l:autoindent,  0,           'failed at #21')
  call g:assert.equals(&l:smartindent, 0,           'failed at #21')
  call g:assert.equals(&l:cindent,     0,           'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #22')
  call g:assert.equals(getline(2),   '    [',       'failed at #22')
  call g:assert.equals(getline(3),   '',            'failed at #22')
  call g:assert.equals(getline(4),   '    foo',     'failed at #22')
  call g:assert.equals(getline(5),   '',            'failed at #22')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #22')
  call g:assert.equals(getline(7),   '}',           'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #22')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #22')
  call g:assert.equals(&l:autoindent,  1,           'failed at #22')
  call g:assert.equals(&l:smartindent, 0,           'failed at #22')
  call g:assert.equals(&l:cindent,     0,           'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #23')
  call g:assert.equals(getline(2),   '    [',       'failed at #23')
  call g:assert.equals(getline(3),   '',            'failed at #23')
  call g:assert.equals(getline(4),   '    foo',     'failed at #23')
  call g:assert.equals(getline(5),   '',            'failed at #23')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #23')
  call g:assert.equals(getline(7),   '}',           'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #23')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #23')
  call g:assert.equals(&l:autoindent,  1,           'failed at #23')
  call g:assert.equals(&l:smartindent, 1,           'failed at #23')
  call g:assert.equals(&l:cindent,     0,           'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',           'failed at #24')
  call g:assert.equals(getline(2),   '    [',       'failed at #24')
  call g:assert.equals(getline(3),   '',            'failed at #24')
  call g:assert.equals(getline(4),   '    foo',     'failed at #24')
  call g:assert.equals(getline(5),   '',            'failed at #24')
  " call g:assert.equals(getline(6),   '        ]',   'failed at #24')
  call g:assert.equals(getline(7),   '}',           'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],  'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #24')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],  'failed at #24')
  call g:assert.equals(&l:autoindent,  1,           'failed at #24')
  call g:assert.equals(&l:smartindent, 1,           'failed at #24')
  call g:assert.equals(&l:cindent,     1,           'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '',               'failed at #25')
  call g:assert.equals(getline(4),   '    foo',        'failed at #25')
  call g:assert.equals(getline(5),   '',               'failed at #25')
  " call g:assert.equals(getline(6),   '        ]',      'failed at #25')
  call g:assert.equals(getline(7),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  normal Vsa0
  call g:assert.equals(getline(1),   '{',          'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   '',           'failed at #26')
  call g:assert.equals(getline(4),   '    foo',    'failed at #26')
  call g:assert.equals(getline(5),   '',           'failed at #26')
  call g:assert.equals(getline(6),   ']',          'failed at #26')
  call g:assert.equals(getline(7),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 4, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 7, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.linewise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{", "}"], 'input': ['a']},
        \   {'buns': ["{", "}"], 'indentkeys': '0},0),:,0#,!^F,o,e', 'input': ['1']},
        \ ]

  """ cinkeys
  setlocal autoindent
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '    foo',    'failed at #1')
  call g:assert.equals(getline(3),   '    }',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #2
  setlocal cinkeys=0},0),:,0#,!^F,o,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,0{')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,0{')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    }',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal Vsa1
  call g:assert.equals(getline(1),   '    {',      'failed at #4')
  call g:assert.equals(getline(2),   '    foo',    'failed at #4')
  call g:assert.equals(getline(3),   '    }',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys', '0},0),:,0#,!^F,o,e')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #5')
  call g:assert.equals(getline(2),   '    foo',       'failed at #5')
  call g:assert.equals(getline(3),   '            }', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0},0),:,0#,!^F,o,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys+', 'O,0{')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '       {',      'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'line', 'indentkeys-', 'O,0{')
  call setline('.', '    foo')
  normal Vsaa
  call g:assert.equals(getline(1),   '    {',         'failed at #7')
  call g:assert.equals(getline(2),   '    foo',       'failed at #7')
  call g:assert.equals(getline(3),   '            }', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'line', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  normal Vsa1
  call g:assert.equals(getline(1),   '    {',         'failed at #8')
  call g:assert.equals(getline(2),   '    foo',       'failed at #8')
  call g:assert.equals(getline(3),   '            }', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0],   'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

" block-wise
function! s:suite.blockwise_n_default_recipes() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #1')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #2')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  %delete

  " #3
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #3')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #3')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #4')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #4')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #5')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #5')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #6')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #6')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #7')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #7')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #8')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #8')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_not_registered() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'afooa',      'failed at #1')
  call g:assert.equals(getline(2),   'abara',      'failed at #1')
  call g:assert.equals(getline(3),   'abaza',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11l*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #2')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #2')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_positioning() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggsa\<C-v>23l("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #1')

  %delete

  " #2
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal ggfbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #2')

  %delete

  " #3
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg2fbsa\<C-v>23l("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', '', 'baz'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #4')
  call g:assert.equals(getline(2),   '',           'failed at #4')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #5')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #5')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>10l("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #6')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #6')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal ggsa\<C-v>12l("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #7')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #7')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_a_character() abort "{{{
  set whichwrap=h,l

  " #1
  call setline('.', 'a')
  execute "normal 0sa\<C-v>l("
  call g:assert.equals(getline('.'), '(a)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['a', 'a', 'a'])
  execute "normal ggsa\<C-v>2j("
  call g:assert.equals(getline(1),   '(a)',        'failed at #2')
  call g:assert.equals(getline(2),   '(a)',        'failed at #2')
  call g:assert.equals(getline(3),   '(a)',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')

  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_breaking() abort "{{{
  set whichwrap=h,l

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11la"
  call g:assert.equals(getline(1),   'aa',         'failed at #1')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #1')
  call g:assert.equals(getline(3),   'aa',         'failed at #1')
  call g:assert.equals(getline(4),   'aa',         'failed at #1')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #1')
  call g:assert.equals(getline(6),   'aa',         'failed at #1')
  call g:assert.equals(getline(7),   'aa',         'failed at #1')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #1')
  call g:assert.equals(getline(9),   'aa',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1),   'bb',          'failed at #2')
  call g:assert.equals(getline(2),   'bbb',         'failed at #2')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #2')
  call g:assert.equals(getline(4),   'bbb',         'failed at #2')
  call g:assert.equals(getline(5),   'bb',          'failed at #2')
  call g:assert.equals(getline(6),   'bb',          'failed at #2')
  call g:assert.equals(getline(7),   'bbb',         'failed at #2')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #2')
  call g:assert.equals(getline(9),   'bbb',         'failed at #2')
  call g:assert.equals(getline(10),  'bb',          'failed at #2')
  call g:assert.equals(getline(11),  'bb',          'failed at #2')
  call g:assert.equals(getline(12),  'bbb',         'failed at #2')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #2')
  call g:assert.equals(getline(14),  'bbb',         'failed at #2')
  call g:assert.equals(getline(15),  'bb',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #2')

  unlet! g:operator#sandwich#recipes
  set whichwrap&
endfunction
"}}}
function! s:suite.blockwise_n_count() abort "{{{
  set whichwrap=h,l

  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11l(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #1')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #1')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg3sa\<C-v>11l([{"
  call g:assert.equals(getline(1),   '{[(foo)]}',   'failed at #2')
  call g:assert.equals(getline(2),   '{[(bar)]}',   'failed at #2')
  call g:assert.equals(getline(3),   '{[(baz)]}',   'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #2')

  %delete

  " #3
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) bar',  'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #3')

  %delete

  " #4
  call setline('.', 'foo bar')
  execute "normal 0sa\<C-v>3iw("
  call g:assert.equals(getline('.'), '(foo bar)',   'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1,  2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 1, 10, 0], 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo bar')
  execute "normal 02sa\<C-v>3iw(["
  call g:assert.equals(getline('.'), '[(foo bar)]', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1,  3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 1, 12, 0], 'failed at #5')
  %delete

  " #6
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l3sa\<C-v>23l([{"
  call g:assert.equals(getline(1),   'foo{[(bar)]}baz', 'failed at #6')
  call g:assert.equals(getline(2),   'foo{[(bar)]}baz', 'failed at #6')
  call g:assert.equals(getline(3),   'foo{[(bar)]}baz', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1,  7, 0],     'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  4, 0],     'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 13, 0],     'failed at #6')
endfunction
"}}}
function! s:suite.blockwise_n_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  set whichwrap=h,l

  " #1
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5l("
  call g:assert.equals(getline(1), '(α)',         'failed at #1')
  call g:assert.equals(getline(2), '(β)',         'failed at #1')
  call g:assert.equals(getline(3), '(γ)',         'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1), '(aα)',        'failed at #2')
  call g:assert.equals(getline(2), '(bβ)',        'failed at #2')
  call g:assert.equals(getline(3), '(cγ)',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #3
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'αaα', 'failed at #3')
  call g:assert.equals(getline(2), 'αbα', 'failed at #3')
  call g:assert.equals(getline(3), 'αcα', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'ααα', 'failed at #4')
  call g:assert.equals(getline(2), 'αβα', 'failed at #4')
  call g:assert.equals(getline(3), 'αγα', 'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'αaαα', 'failed at #5')
  call g:assert.equals(getline(2), 'αbβα', 'failed at #5')
  call g:assert.equals(getline(3), 'αcγα', 'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #5')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #6
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'aαaaα', 'failed at #6')
  call g:assert.equals(getline(2), 'aαbaα', 'failed at #6')
  call g:assert.equals(getline(3), 'aαcaα', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['α', 'β', 'γ'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'aααaα', 'failed at #7')
  call g:assert.equals(getline(2), 'aαβaα',  'failed at #7')
  call g:assert.equals(getline(3), 'aαγaα', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'aαaαaα', 'failed at #8')
  call g:assert.equals(getline(2), 'aαbβaα', 'failed at #8')
  call g:assert.equals(getline(3), 'aαcγaα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #8')

  %delete
  unlet g:operator#sandwich#recipes

  " #9
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5l("
  call g:assert.equals(getline(1), '(“)', 'failed at #9')
  call g:assert.equals(getline(2), '(“)', 'failed at #9')
  call g:assert.equals(getline(3), '(“)', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8l("
  call g:assert.equals(getline(1), '(a“)', 'failed at #10')
  call g:assert.equals(getline(2), '(b“)', 'failed at #10')
  call g:assert.equals(getline(3), '(c“)', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #10')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #11
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), '“a“', 'failed at #11')
  call g:assert.equals(getline(2), '“b“', 'failed at #11')
  call g:assert.equals(getline(3), '“c“', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), '“““', 'failed at #12')
  call g:assert.equals(getline(2), '“““', 'failed at #12')
  call g:assert.equals(getline(3), '“““', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #12')

  %delete

  " #13
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), '“a““', 'failed at #13')
  call g:assert.equals(getline(2), '“b““', 'failed at #13')
  call g:assert.equals(getline(3), '“c““', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #13')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #14
  call append(0, ['a', 'b', 'c'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'a“aa“', 'failed at #14')
  call g:assert.equals(getline(2), 'a“ba“', 'failed at #14')
  call g:assert.equals(getline(3), 'a“ca“', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #14')

  %delete

  " #15
  call append(0, ['“', '“', '“'])
  execute "normal ggsa\<C-v>5la"
  call g:assert.equals(getline(1), 'a““a“', 'failed at #15')
  call g:assert.equals(getline(2), 'a““a“',  'failed at #15')
  call g:assert.equals(getline(3), 'a““a“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal ggsa\<C-v>8la"
  call g:assert.equals(getline(1), 'a“a“a“', 'failed at #16')
  call g:assert.equals(getline(2), 'a“b“a“', 'failed at #16')
  call g:assert.equals(getline(3), 'a“c“a“', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #16')
endfunction
"}}}
function! s:suite.blockwise_n_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')

  " #2
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #2')

  " #3
  let g:operator#sandwich#recipes = [{'buns': ["(\n    ", "\n)"], 'input':['a']}]
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline(1), '(',       'failed at #3')
  call g:assert.equals(getline(2), '    foo', 'failed at #3')
  call g:assert.equals(getline(3), ')',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  %delete
  unlet! g:operator#sandwich#recipes

  """ inner_head
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
  " #4
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #4')

  " #5
  execute "normal 2lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #5')

  """ keep
  " #6
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #6')

  " #7
  execute "normal lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #7')

  """ inner_tail
  " #8
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0], 'failed at #8')

  " #9
  execute "normal 2hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 6, 0], 'failed at #9')

  """ head
  " #10
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 1, 0], 'failed at #10')

  " #11
  execute "normal 3lsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #11')

  """ tail
  " #12
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call setline('.', 'foo')
  execute "normal 0l2sa\<C-v>iw()"
  call g:assert.equals(getline('.'), '((foo))',    'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #12')

  " #13
  execute "normal 3hsa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 7, 0], 'failed at #13')

  """"" recipe option
  " #14
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call setline('.', 'foo')
  execute "normal 0lsa\<C-v>iw1"
  call g:assert.equals(getline('.'), '(foo)',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
endfunction
"}}}
function! s:suite.blockwise_n_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw1"
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', 'foo')
  execute "normal 03sa\<C-v>iw0[{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_n_option_expr() abort "{{{
  set whichwrap=h,l

  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw1"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #2')

  """ 1
  " #2
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #2')

  %delete

  " #3
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lb"
  call g:assert.equals(getline(1), 'foo', 'failed at #3')
  call g:assert.equals(getline(2), 'bar', 'failed at #3')
  call g:assert.equals(getline(3), 'baz', 'failed at #3')
  call g:assert.equals(exists(s:object), 0, 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal ggsa\<C-v>11lc"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #5')
  call g:assert.equals(getline(2), '2bar3', 'failed at #5')
  call g:assert.equals(getline(3), '2baz3', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #6')
  call g:assert.equals(getline(2), '2bar3', 'failed at #6')
  call g:assert.equals(getline(3), '2baz3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0, 'failed at #6')

  %delete

  " #7
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lba"
  call g:assert.equals(getline(1), 'foo', 'failed at #7')
  call g:assert.equals(getline(2), 'bar', 'failed at #7')
  call g:assert.equals(getline(3), 'baz', 'failed at #7')
  call g:assert.equals(exists(s:object), 0, 'failed at #7')

  %delete

  " #8
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg2sa\<C-v>11lca"
  call g:assert.equals(getline(1), 'foo', 'failed at #8')
  call g:assert.equals(getline(2), 'bar', 'failed at #8')
  call g:assert.equals(getline(3), 'baz', 'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  %delete

  " #9
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw0"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #9')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_n_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', 'bar')
  execute "normal 0sa\<C-v>iw1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'block', 'listexpr', 1)
  call setline('.', 'bar')
  execute "normal 0sa\<C-v>iwa"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', 'bar')
  execute "normal 0sa\<C-v>iwb"
  call g:assert.equals(getline('.'), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal 0sa\<C-v>iw0"
  call g:assert.equals(getline('.'), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', 'bar')
  execute "normal 0sa\<C-v>iw1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_n_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw["
  call g:assert.equals(getline('.'), '[foo]',  'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw0"
  call g:assert.equals(getline('.'), '{foo}',  'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw["
  call g:assert.equals(getline('.'), '{foo}',  'failed at #3')

  " #4
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw1"
  call g:assert.equals(getline('.'), '[foo]',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_n_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ on
  " #1
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #1')

  " #2
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw0"
  call g:assert.equals(getline('.'), '(foo )',  'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw("
  call g:assert.equals(getline('.'), '(foo )',  'failed at #3')

  " #4
  call setline('.', 'foo ')
  execute "normal 0sa\<C-v>2iw1"
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_n_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ffsa\<C-v>iw("
  call g:assert.equals(getline('.'), '""',  'failed at #1')

  " #2
  call operator#sandwich#set('add', 'block', 'command', [])
  call setline('.', '"foo"')
  execute "normal 0ffsa\<C-v>iw1"
  call g:assert.equals(getline('.'), '""',  'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_n_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ on
  " #1
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ')',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw0"
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')

  %delete

  " #3
  set autoindent
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw("
  call g:assert.equals(getline(1),   '    (',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    )',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  set autoindent&

  %delete

  """ off
  call operator#sandwich#set('add', 'block', 'linewise', 0)

  " #4
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw("
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  execute "normal 0sa\<C-v>iw1"
  call g:assert.equals(getline(1), '(',   'failed at #5')
  call g:assert.equals(getline(2), 'foo', 'failed at #5')
  call g:assert.equals(getline(3), ')',   'failed at #5')
endfunction
"}}}
function! s:suite.blockwise_n_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " execute "normal ^sa\<C-v>iwa"
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw0"
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.blockwise_n_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw1"
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iwa"
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  execute "normal ^sa\<C-v>iw1"
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

function! s:suite.blockwise_x_default_recipes() abort "{{{
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #1')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #1')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa)"
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #2')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')

  " #3
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa["
  call g:assert.equals(getline(1),   '[foo]',      'failed at #3')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #3')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')

  " #4
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa]"
  call g:assert.equals(getline(1),   '[foo]',      'failed at #4')
  call g:assert.equals(getline(2),   '[bar]',      'failed at #4')
  call g:assert.equals(getline(3),   '[baz]',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')

  " #5
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa{"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #5')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #5')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  " #6
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa}"
  call g:assert.equals(getline(1),   '{foo}',      'failed at #6')
  call g:assert.equals(getline(2),   '{bar}',      'failed at #6')
  call g:assert.equals(getline(3),   '{baz}',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  " #7
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa<"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #7')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #7')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')

  " #8
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa>"
  call g:assert.equals(getline(1),   '<foo>',      'failed at #8')
  call g:assert.equals(getline(2),   '<bar>',      'failed at #8')
  call g:assert.equals(getline(3),   '<baz>',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
endfunction
"}}}
function! s:suite.blockwise_x_not_registered() abort "{{{
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'afooa',      'failed at #1')
  call g:assert.equals(getline(2),   'abara',      'failed at #1')
  call g:assert.equals(getline(3),   'abaza',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa*"
  call g:assert.equals(getline(1),   '*foo*',      'failed at #2')
  call g:assert.equals(getline(2),   '*bar*',      'failed at #2')
  call g:assert.equals(getline(3),   '*baz*',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_positioning() abort "{{{
  " #1
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getline(2),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getline(3),   '(foo)barbaz', 'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0],  'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],  'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0],  'failed at #1')

  %delete

  " #2
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg3l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getline(2),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getline(3),   'foo(bar)baz', 'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 5, 0],  'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 4, 0],  'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 9, 0],  'failed at #2')

  %delete

  " #3
  call append(0, ['foobarbaz', 'foobarbaz', 'foobarbaz'])
  execute "normal gg6l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getline(2),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getline(3),   'foobar(baz)', 'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1,  8, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1,  7, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 12, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', '', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #4')
  call g:assert.equals(getline(2),   '',           'failed at #4')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', 'ba', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #5')
  call g:assert.equals(getline(2),   '(ba)',       'failed at #5')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')

  %delete

  " #6
  call append(0, ['fo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(fo)',       'failed at #6')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #6')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #6')

  %delete

  " #7
  call append(0, ['foo', 'bar', 'ba'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #7')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #7')
  call g:assert.equals(getline(3),   '(ba)',       'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['foo', 'bar*', 'baz'])
  execute "normal gg\<C-v>2j2lsa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #8')
  call g:assert.equals(getline(2),   '(bar)*',     'failed at #8')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')

  %delete

  """ terminal-extended block-wise visual mode
  " #9
  call append(0, ['fooo', 'baaar', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #9')
  call g:assert.equals(getline(2),   '(baaar)',    'failed at #9')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #9')

  %delete

  " #10
  call append(0, ['foooo', 'bar', 'baaz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(foooo)',    'failed at #10')
  call g:assert.equals(getline(2),   '(bar)',      'failed at #10')
  call g:assert.equals(getline(3),   '(baaz)',     'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, 7, 0], 'failed at #10')

  %delete

  " #11
  call append(0, ['fooo', '', 'baz'])
  execute "normal gg\<C-v>2j$sa("
  call g:assert.equals(getline(1),   '(fooo)',     'failed at #11')
  call g:assert.equals(getline(2),   '',           'failed at #11')
  call g:assert.equals(getline(3),   '(baz)',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #11')
endfunction
"}}}
function! s:suite.blockwise_x_a_character() abort "{{{
  " #1
  call setline('.', 'a')
  execute "normal 0\<C-v>sa("
  call g:assert.equals(getline('.'), '(a)',        'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 1, 4, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['a', 'a', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1),   '(a)',        'failed at #2')
  call g:assert.equals(getline(2),   '(a)',        'failed at #2')
  call g:assert.equals(getline(3),   '(a)',        'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_breaking() abort "{{{
  " #1
  call append(0, ['', 'foo'])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '',           'failed at #1')
  call g:assert.equals(getline(2),   '(foo)',      'failed at #1')
  " call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 2, 6, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', ''])
  execute "normal gg\<C-v>j$sa("
  call g:assert.equals(getline(1),   '(foo)',      'failed at #2')
  call g:assert.equals(getline(2),   '',           'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 1, 6, 0], 'failed at #2')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ["aa\naaa", "aaa\naa"], 'input':['a']},
        \   {'buns': ["bb\nbbb\nbb", "bb\nbbb\nbb"], 'input':['b']},
        \ ]

  " #3
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsaa"
  call g:assert.equals(getline(1),   'aa',         'failed at #3')
  call g:assert.equals(getline(2),   'aaafooaaa',  'failed at #3')
  call g:assert.equals(getline(3),   'aa',         'failed at #3')
  call g:assert.equals(getline(4),   'aa',         'failed at #3')
  call g:assert.equals(getline(5),   'aaabaraaa',  'failed at #3')
  call g:assert.equals(getline(6),   'aa',         'failed at #3')
  call g:assert.equals(getline(7),   'aa',         'failed at #3')
  call g:assert.equals(getline(8),   'aaabazaaa',  'failed at #3')
  call g:assert.equals(getline(9),   'aa',         'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 4, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 9, 3, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1),   'bb',          'failed at #4')
  call g:assert.equals(getline(2),   'bbb',         'failed at #4')
  call g:assert.equals(getline(3),   'bbfoobb',     'failed at #4')
  call g:assert.equals(getline(4),   'bbb',         'failed at #4')
  call g:assert.equals(getline(5),   'bb',          'failed at #4')
  call g:assert.equals(getline(6),   'bb',          'failed at #4')
  call g:assert.equals(getline(7),   'bbb',         'failed at #4')
  call g:assert.equals(getline(8),   'bbbarbb',     'failed at #4')
  call g:assert.equals(getline(9),   'bbb',         'failed at #4')
  call g:assert.equals(getline(10),  'bb',          'failed at #4')
  call g:assert.equals(getline(11),  'bb',          'failed at #4')
  call g:assert.equals(getline(12),  'bbb',         'failed at #4')
  call g:assert.equals(getline(13),  'bbbazbb',     'failed at #4')
  call g:assert.equals(getline(14),  'bbb',         'failed at #4')
  call g:assert.equals(getline(15),  'bb',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0,  3, 3, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0,  1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 15, 3, 0], 'failed at #4')

  unlet! g:operator#sandwich#recipes
endfunction
"}}}
function! s:suite.blockwise_x_count() abort "{{{
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa(["
  call g:assert.equals(getline(1),   '[(foo)]',    'failed at #1')
  call g:assert.equals(getline(2),   '[(bar)]',    'failed at #1')
  call g:assert.equals(getline(3),   '[(baz)]',    'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 8, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l3sa([{"
  call g:assert.equals(getline(1), '{[(foo)]}',     'failed at #2')
  call g:assert.equals(getline(2), '{[(bar)]}',     'failed at #2')
  call g:assert.equals(getline(3), '{[(baz)]}',     'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1,  4, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1,  1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 10, 0], 'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_multibyte() abort  "{{{
  " The reason why I use strlen() is that the byte length of a multibyte character is varied by 'encoding' option.

  " #1
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(α)',          'failed at #1')
  call g:assert.equals(getline(2), '(β)',          'failed at #1')
  call g:assert.equals(getline(3), '(γ)',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(γ)')+1, 0], 'failed at #1')

  %delete

  " #2
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsa("
  call g:assert.equals(getline(1), '(aα)',         'failed at #2')
  call g:assert.equals(getline(2), '(bβ)',         'failed at #2')
  call g:assert.equals(getline(3), '(cγ)',         'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(cγ)')+1, 0], 'failed at #2')

  %delete
  set ambiwidth=double

  " #3
  call append(0, ['a', 'α', 'a'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(a)',          'failed at #3')
  call g:assert.equals(getline(2), '(α)',          'failed at #3')
  call g:assert.equals(getline(3), '(a)',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 4, 0], 'failed at #3')

  %delete

  " #4
  call append(0, ['a', 'a', 'α'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(a)',          'failed at #4')
  call g:assert.equals(getline(2), '(a)',          'failed at #4')
  call g:assert.equals(getline(3), '(α)',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(α)')+1, 0], 'failed at #4')

  %delete

  " #5
  call append(0, ['abc', 'αβγ', 'abc'])
  execute "normal ggl\<C-v>2jsa("
  call g:assert.equals(getline(1), 'a(b)c',        'failed at #5')
  call g:assert.equals(getline(2), '(α)βγ',        'failed at #5')
  call g:assert.equals(getline(3), 'a(b)c',        'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 2, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #5')

  %delete
  set ambiwidth=single

  " #6
  call append(0, ['abc', 'αβγ', 'abc'])
  execute "normal ggl\<C-v>2jsa("
  call g:assert.equals(getline(1), 'a(b)c',        'failed at #6')
  call g:assert.equals(getline(2), 'α(β)γ',        'failed at #6')
  call g:assert.equals(getline(3), 'a(b)c',        'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 1, 3, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 2, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 5, 0], 'failed at #6')

  set ambiwidth&
  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['α', 'α'], 'input': ['a']}
        \ ]

  " #7
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'αaα', 'failed at #7')
  call g:assert.equals(getline(2), 'αbα', 'failed at #7')
  call g:assert.equals(getline(3), 'αcα', 'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcα')+1, 0], 'failed at #7')

  %delete

  " #8
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'ααα', 'failed at #8')
  call g:assert.equals(getline(2), 'αβα', 'failed at #8')
  call g:assert.equals(getline(3), 'αγα', 'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αγα')+1, 0], 'failed at #8')

  %delete

  " #9
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'αaαα', 'failed at #9')
  call g:assert.equals(getline(2), 'αbβα', 'failed at #9')
  call g:assert.equals(getline(3), 'αcγα', 'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('α')+1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 3, strlen('αcγα')+1, 0], 'failed at #9')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['aα', 'aα'], 'input': ['a']}
        \ ]

  " #10
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'aαaaα', 'failed at #10')
  call g:assert.equals(getline(2), 'aαbaα', 'failed at #10')
  call g:assert.equals(getline(3), 'aαcaα', 'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #10')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcaα')+1, 0], 'failed at #10')

  %delete

  " #11
  call append(0, ['α', 'β', 'γ'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'aααaα', 'failed at #11')
  call g:assert.equals(getline(2), 'aαβaα',  'failed at #11')
  call g:assert.equals(getline(3), 'aαγaα', 'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαγaα')+1, 0], 'failed at #11')

  %delete

  " #12
  call append(0, ['aα', 'bβ', 'cγ'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'aαaαaα', 'failed at #12')
  call g:assert.equals(getline(2), 'aαbβaα', 'failed at #12')
  call g:assert.equals(getline(3), 'aαcγaα', 'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('aα')+1, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 3, strlen('aαcγaα')+1, 0], 'failed at #12')

  %delete
  unlet g:operator#sandwich#recipes

  " #13
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsa("
  call g:assert.equals(getline(1), '(“)', 'failed at #13')
  call g:assert.equals(getline(2), '(“)', 'failed at #13')
  call g:assert.equals(getline(3), '(“)', 'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(“)')+1, 0], 'failed at #13')

  %delete

  " #14
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsa("
  call g:assert.equals(getline(1), '(a“)', 'failed at #14')
  call g:assert.equals(getline(2), '(b“)', 'failed at #14')
  call g:assert.equals(getline(3), '(c“)', 'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 3, strlen('(c“)')+1, 0], 'failed at #14')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['“', '“'], 'input': ['a']}
        \ ]

  " #15
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), '“a“', 'failed at #15')
  call g:assert.equals(getline(2), '“b“', 'failed at #15')
  call g:assert.equals(getline(3), '“c“', 'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #15')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c“')+1, 0], 'failed at #15')

  %delete

  " #16
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), '“““', 'failed at #16')
  call g:assert.equals(getline(2), '“““', 'failed at #16')
  call g:assert.equals(getline(3), '“““', 'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #16')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“““')+1, 0], 'failed at #16')

  %delete

  " #17
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), '“a““', 'failed at #17')
  call g:assert.equals(getline(2), '“b““', 'failed at #17')
  call g:assert.equals(getline(3), '“c““', 'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('“')+1, 0], 'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #17')
  call g:assert.equals(getpos("']"), [0, 3, strlen('“c““')+1, 0], 'failed at #17')

  %delete

  let g:operator#sandwich#recipes = [
        \   {'buns': ['a“', 'a“'], 'input': ['a']}
        \ ]

  " #18
  call append(0, ['a', 'b', 'c'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'a“aa“', 'failed at #18')
  call g:assert.equals(getline(2), 'a“ba“', 'failed at #18')
  call g:assert.equals(getline(3), 'a“ca“', 'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #18')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“ca“')+1, 0], 'failed at #18')

  %delete

  " #19
  call append(0, ['“', '“', '“'])
  execute "normal gg\<C-v>2jsaa"
  call g:assert.equals(getline(1), 'a““a“', 'failed at #19')
  call g:assert.equals(getline(2), 'a““a“',  'failed at #19')
  call g:assert.equals(getline(3), 'a““a“', 'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #19')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a““a“')+1, 0], 'failed at #19')

  %delete

  " #20
  call append(0, ['a“', 'b“', 'c“'])
  execute "normal gg\<C-v>l2jsaa"
  call g:assert.equals(getline(1), 'a“a“a“', 'failed at #20')
  call g:assert.equals(getline(2), 'a“b“a“', 'failed at #20')
  call g:assert.equals(getline(3), 'a“c“a“', 'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 1, strlen('a“')+1, 0], 'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #20')
  call g:assert.equals(getpos("']"), [0, 3, strlen('a“c“a“')+1, 0], 'failed at #20')
endfunction
"}}}
function! s:suite.blockwise_x_option_cursor() abort  "{{{
  """"" cursor
  """ default
  " #1
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #1')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #1')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #1')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #1')

  " #2
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #2')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #2')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #2')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #2')

  %delete

  """ inner_head
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_head')
  " #3
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #3')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #3')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #3')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #3')

  " #4
  execute "normal \<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #4')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #4')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #4')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #4')

  %delete

  """ keep
  " #5
  call operator#sandwich#set('add', 'block', 'cursor', 'keep')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #5')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #5')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #5')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #5')

  " #6
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #6')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #6')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #6')
  call g:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #6')

  %delete

  """ inner_tail
  " #7
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #7')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #7')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #7')
  call g:assert.equals(getpos('.'), [0, 3, 5, 0], 'failed at #7')

  " #8
  execute "normal \<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #8')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #8')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #8')
  call g:assert.equals(getpos('.'), [0, 3, 6, 0], 'failed at #8')

  %delete

  """ head
  " #9
  call operator#sandwich#set('add', 'block', 'cursor', 'head')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #9')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #9')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #9')
  call g:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #9')

  " #10
  execute "normal 2l\<C-v>2j2lsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #10')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #10')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #10')
  call g:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #10')

  %delete

  """ tail
  " #11
  call operator#sandwich#set('add', 'block', 'cursor', 'tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2sa()"
  call g:assert.equals(getline(1),  '((foo))',    'failed at #11')
  call g:assert.equals(getline(2),  '((bar))',    'failed at #11')
  call g:assert.equals(getline(3),  '((baz))',    'failed at #11')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #11')

  " #12
  execute "normal 2h\<C-v>2k2hsa("
  call g:assert.equals(getline(1),  '(((foo)))',  'failed at #12')
  call g:assert.equals(getline(2),  '(((bar)))',  'failed at #12')
  call g:assert.equals(getline(3),  '(((baz)))',  'failed at #12')
  call g:assert.equals(getpos('.'), [0, 3, 7, 0], 'failed at #12')

  %delete

  """"" recipe option
  " #13
  let g:operator#sandwich#recipes = [{'buns': ['(', ')'], 'cursor': 'inner_head', 'input':['1']}]
  call operator#sandwich#set('add', 'block', 'cursor', 'inner_tail')
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsa1"
  call g:assert.equals(getline(1), '(foo)',      'failed at #13')
  call g:assert.equals(getline(2), '(bar)',      'failed at #13')
  call g:assert.equals(getline(3), '(baz)',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #13')
endfunction
"}}}
function! s:suite.blockwise_x_option_query_once() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'query_once': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'query_once': 1, 'input':['1']},
        \ ]

  """"" query_once
  """ off
  " #1
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa([{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa1"
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #2')

  """ on
  " #3
  call operator#sandwich#set('add', 'block', 'query_once', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa("
  call g:assert.equals(getline('.'), '(((foo)))',  'failed at #3')

  " #4
  call setline('.', 'foo')
  execute "normal 0\<C-v>iw3sa0[{"
  call g:assert.equals(getline('.'), '{[(foo)]}',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_option_expr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input':['a']},
        \   {'buns': ['SandwichExprCancel()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprCancel()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa1"
  call g:assert.equals(getline('.'), '2foo3',  'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'block', 'expr', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), '2foo3', 'failed at #3')

  %delete

  " #4
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsab"
  call g:assert.equals(getline(1), 'foo', 'failed at #4')
  call g:assert.equals(getline(2), 'bar', 'failed at #4')
  call g:assert.equals(getline(3), 'baz', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  %delete

  " #5
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2lsac"
  call g:assert.equals(getline(1), 'foo', 'failed at #5')
  call g:assert.equals(getline(2), 'bar', 'failed at #5')
  call g:assert.equals(getline(3), 'baz', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  %delete

  " #6
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saab"
  call g:assert.equals(getline(1), '2foo3', 'failed at #6')
  call g:assert.equals(getline(2), '2bar3', 'failed at #6')
  call g:assert.equals(getline(3), '2baz3', 'failed at #6')
  call g:assert.equals(exists(s:object), 0, 'failed at #6')

  %delete

  " #7
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saac"
  call g:assert.equals(getline(1), '2foo3', 'failed at #7')
  call g:assert.equals(getline(2), '2bar3', 'failed at #7')
  call g:assert.equals(getline(3), '2baz3', 'failed at #7')
  call g:assert.equals(exists(s:object), 0, 'failed at #7')

  %delete

  " #8
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saba"
  call g:assert.equals(getline(1), 'foo', 'failed at #8')
  call g:assert.equals(getline(2), 'bar', 'failed at #8')
  call g:assert.equals(getline(3), 'baz', 'failed at #8')
  call g:assert.equals(exists(s:object), 0, 'failed at #8')

  %delete

  " #9
  call append(0, ['foo', 'bar', 'baz'])
  execute "normal gg\<C-v>2j2l2saca"
  call g:assert.equals(getline(1), 'foo', 'failed at #9')
  call g:assert.equals(getline(2), 'bar', 'failed at #9')
  call g:assert.equals(getline(3), 'baz', 'failed at #9')
  call g:assert.equals(exists(s:object), 0, 'failed at #9')

  %delete

  " #10
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa0"
  call g:assert.equals(getline('.'), '1+1foo1+2', 'failed at #10')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_x_option_listexpr() abort "{{{
  """"" expr
  let g:operator#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprBuns(1)', 'input': ['b']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 0, 'input': ['0']},
        \   {'buns': 'SandwichListexprBuns(0)', 'listexpr': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), 'bar', 'failed at #1')
  call g:assert.equals(exists(s:object), 0, 'failed at #1')

  " #2
  call setline('.', 'bar')
  execute "normal 0\<C-v>iwsa1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #2')

  """ 1
  " #3
  call operator#sandwich#set('add', 'block', 'listexpr', 1)
  call setline('.', 'bar')
  execute "normal 0\<C-v>iwsaa"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #3')

  " #4
  call setline('.', 'bar')
  execute "normal 0\<C-v>iwsab"
  call g:assert.equals(getline('.'), 'bar', 'failed at #4')
  call g:assert.equals(exists(s:object), 0, 'failed at #4')

  " #5
  call setline('.', 'bar')
  Throws /^Vim(echoerr):operator-sandwich: Incorrect buns./ :execute "normal 0\<C-v>iwsa0"
  call g:assert.equals(getline('.'), 'bar', 'failed at #5')
  call g:assert.equals(exists(s:object), 0, 'failed at #5')

  " #6
  call setline('.', 'bar')
  execute "normal 0\<C-v>iwsa1"
  call g:assert.equals(getline('.'), 'foobarbaz', 'failed at #6')

  """ 2
  " This case cannot be tested since this option makes difference only in
  " dot-repeat.
endfunction
"}}}
function! s:suite.blockwise_x_option_noremap() abort  "{{{
  """"" noremap
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'input':['[']},
        \   {'buns': ['[', ']'], 'noremap': 0, 'input':['0']},
        \   {'buns': ['[', ']'], 'noremap': 1, 'input':['1']},
        \ ]
  inoremap [ {
  inoremap ] }

  """ on
  " #1
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa["
  call g:assert.equals(getline('.'), '[foo]', 'failed at #1')

  " #2
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa0"
  call g:assert.equals(getline('.'), '{foo}',  'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'block', 'noremap', 0)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa["
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')

  " #4
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa1"
  call g:assert.equals(getline('.'), '[foo]', 'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_option_skip_space() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'skip_space': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'skip_space': 1, 'input':['1']},
        \ ]

  """"" skip_space
  """ on
  " #1
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo) ', 'failed at #1')

  " #2
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa0"
  call g:assert.equals(getline('.'), '(foo )',  'failed at #2')

  """ off
  " #3
  call operator#sandwich#set('add', 'block', 'skip_space', 0)
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa("
  call g:assert.equals(getline('.'), '(foo )', 'failed at #3')

  " #4
  call setline('.', 'foo ')
  execute "normal 0\<C-v>2iwsa1"
  call g:assert.equals(getline('.'), '(foo) ',  'failed at #4')
endfunction
"}}}
function! s:suite.blockwise_x_option_command() abort  "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'command': ['normal! `[d`]'], 'input':['1']},
        \ ]

  """"" command
  " #1
  call operator#sandwich#set('add', 'block', 'command', ['normal! `[d`]'])
  call setline('.', '"foo"')
  execute "normal 0ff\<C-v>iwsa("
  call g:assert.equals(getline('.'), '""',  'failed at #1')

  " #2
  call operator#sandwich#set('add', 'block', 'command', [])
  call setline('.', '"foo"')
  execute "normal 0ff\<C-v>iwsa1"
  call g:assert.equals(getline('.'), '""',  'failed at #2')
endfunction
"}}}
function! s:suite.blockwise_x_option_linewise() abort "{{{
  let g:operator#sandwich#recipes = [
        \   {'buns': ['(', ')'], 'linewise': 0, 'input':['0']},
        \   {'buns': ['(', ')'], 'linewise': 1, 'input':['1']},
        \ ]

  """"" linewise
  """ on
  " #1
  call operator#sandwich#set('add', 'block', 'linewise', 1)
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(',   'failed at #1')
  call g:assert.equals(getline(2), 'foo', 'failed at #1')
  call g:assert.equals(getline(3), ')',   'failed at #1')

  %delete

  " #2
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa0"
  call g:assert.equals(getline(1), '(foo)', 'failed at #2')

  %delete

  " #3
  set autoindent
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa("
  call g:assert.equals(getline(1),   '    (',      'failed at #3')
  call g:assert.equals(getline(2),   '    foo',    'failed at #3')
  call g:assert.equals(getline(3),   '    )',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #3')
  set autoindent&

  %delete

  """ off
  call operator#sandwich#set('add', 'block', 'linewise', 0)

  " #4
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa("
  call g:assert.equals(getline(1), '(foo)', 'failed at #4')

  %delete

  " #5
  call setline('.', 'foo')
  execute "normal 0\<C-v>iwsa1"
  call g:assert.equals(getline(1), '(',   'failed at #5')
  call g:assert.equals(getline(2), 'foo', 'failed at #5')
  call g:assert.equals(getline(3), ')',   'failed at #5')
endfunction
"}}}
function! s:suite.blockwise_x_option_autoindent() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n[\n", "\n]\n}"], 'input': ['a']},
        \   {'buns': ["{\n[\n", "\n]\n}"], 'autoindent': 0, 'input': ['0']},
        \ ]

  """ -1
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #1
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #1')
  call g:assert.equals(getline(2),   '[',          'failed at #1')
  call g:assert.equals(getline(3),   'foo',        'failed at #1')
  call g:assert.equals(getline(4),   ']',          'failed at #1')
  call g:assert.equals(getline(5),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #1')
  call g:assert.equals(&l:autoindent,  0,          'failed at #1')
  call g:assert.equals(&l:smartindent, 0,          'failed at #1')
  call g:assert.equals(&l:cindent,     0,          'failed at #1')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #1')

  %delete

  " #2
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #2')
  call g:assert.equals(getline(2),   '    [',      'failed at #2')
  call g:assert.equals(getline(3),   '    foo',    'failed at #2')
  call g:assert.equals(getline(4),   '    ]',      'failed at #2')
  call g:assert.equals(getline(5),   '    }',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #2')
  call g:assert.equals(&l:autoindent,  1,          'failed at #2')
  call g:assert.equals(&l:smartindent, 0,          'failed at #2')
  call g:assert.equals(&l:cindent,     0,          'failed at #2')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #2')

  %delete

  " #3
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #3')
  call g:assert.equals(getline(2),   '        [',   'failed at #3')
  call g:assert.equals(getline(3),   '        foo', 'failed at #3')
  call g:assert.equals(getline(4),   '        ]',   'failed at #3')
  call g:assert.equals(getline(5),   '    }',       'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #3')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #3')
  call g:assert.equals(&l:autoindent,  1,           'failed at #3')
  call g:assert.equals(&l:smartindent, 1,           'failed at #3')
  call g:assert.equals(&l:cindent,     0,           'failed at #3')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #3')

  %delete

  " #4
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',             'failed at #4')
  call g:assert.equals(getline(2),   '    [',         'failed at #4')
  call g:assert.equals(getline(3),   '        foo',   'failed at #4')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #4')
  call g:assert.equals(getline(5),   '}',             'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #4')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #4')
  call g:assert.equals(&l:autoindent,  1,             'failed at #4')
  call g:assert.equals(&l:smartindent, 1,             'failed at #4')
  call g:assert.equals(&l:cindent,     1,             'failed at #4')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #4')

  %delete

  " #5
  " setlocal indentexpr=TestIndent()
  " call setline('.', '    foo')
  " execute "normal ^\<C-v>iwsaa"
  " call g:assert.equals(getline(1),   '        {',           'failed at #5')
  " call g:assert.equals(getline(2),   '            [',       'failed at #5')
  " call g:assert.equals(getline(3),   '                foo', 'failed at #5')
  " call g:assert.equals(getline(4),   '                        ]',         'failed at #5')
  " call g:assert.equals(getline(5),   '                                }', 'failed at #5')
  " call g:assert.equals(getpos('.'),  [0, 3, 17, 0],         'failed at #5')
  " call g:assert.equals(getpos("'["), [0, 1,  9, 0],         'failed at #5')
  " call g:assert.equals(getpos("']"), [0, 5, 34, 0],         'failed at #5')
  " call g:assert.equals(&l:autoindent,  1,                   'failed at #5')
  " call g:assert.equals(&l:smartindent, 1,                   'failed at #5')
  " call g:assert.equals(&l:cindent,     1,                   'failed at #5')
  " call g:assert.equals(&l:indentexpr,  'TestIndent()',      'failed at #5')

  %delete

  """ 0
  call operator#sandwich#set('add', 'block', 'autoindent', 0)

  " #6
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #6')
  call g:assert.equals(getline(2),   '[',          'failed at #6')
  call g:assert.equals(getline(3),   'foo',        'failed at #6')
  call g:assert.equals(getline(4),   ']',          'failed at #6')
  call g:assert.equals(getline(5),   '}',          'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #6')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #6')
  call g:assert.equals(&l:autoindent,  0,          'failed at #6')
  call g:assert.equals(&l:smartindent, 0,          'failed at #6')
  call g:assert.equals(&l:cindent,     0,          'failed at #6')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #6')

  %delete

  " #7
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #7')
  call g:assert.equals(getline(2),   '[',          'failed at #7')
  call g:assert.equals(getline(3),   'foo',        'failed at #7')
  call g:assert.equals(getline(4),   ']',          'failed at #7')
  call g:assert.equals(getline(5),   '}',          'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #7')
  call g:assert.equals(&l:autoindent,  1,          'failed at #7')
  call g:assert.equals(&l:smartindent, 0,          'failed at #7')
  call g:assert.equals(&l:cindent,     0,          'failed at #7')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #7')

  %delete

  " #8
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #8')
  call g:assert.equals(getline(2),   '[',          'failed at #8')
  call g:assert.equals(getline(3),   'foo',        'failed at #8')
  call g:assert.equals(getline(4),   ']',          'failed at #8')
  call g:assert.equals(getline(5),   '}',          'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #8')
  call g:assert.equals(&l:autoindent,  1,          'failed at #8')
  call g:assert.equals(&l:smartindent, 1,          'failed at #8')
  call g:assert.equals(&l:cindent,     0,          'failed at #8')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #8')

  %delete

  " #9
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #9')
  call g:assert.equals(getline(2),   '[',          'failed at #9')
  call g:assert.equals(getline(3),   'foo',        'failed at #9')
  call g:assert.equals(getline(4),   ']',          'failed at #9')
  call g:assert.equals(getline(5),   '}',          'failed at #9')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #9')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #9')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #9')
  call g:assert.equals(&l:autoindent,  1,          'failed at #9')
  call g:assert.equals(&l:smartindent, 1,          'failed at #9')
  call g:assert.equals(&l:cindent,     1,          'failed at #9')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #9')

  %delete

  " #10
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #10')
  call g:assert.equals(getline(2),   '[',              'failed at #10')
  call g:assert.equals(getline(3),   'foo',            'failed at #10')
  call g:assert.equals(getline(4),   ']',              'failed at #10')
  call g:assert.equals(getline(5),   '}',              'failed at #10')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0],     'failed at #10')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #10')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #10')
  call g:assert.equals(&l:autoindent,  1,              'failed at #10')
  call g:assert.equals(&l:smartindent, 1,              'failed at #10')
  call g:assert.equals(&l:cindent,     1,              'failed at #10')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #10')

  %delete

  """ 1
  call operator#sandwich#set('add', 'block', 'autoindent', 1)

  " #11
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #11')
  call g:assert.equals(getline(2),   '    [',      'failed at #11')
  call g:assert.equals(getline(3),   '    foo',    'failed at #11')
  call g:assert.equals(getline(4),   '    ]',      'failed at #11')
  call g:assert.equals(getline(5),   '    }',      'failed at #11')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #11')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #11')
  call g:assert.equals(&l:autoindent,  0,          'failed at #11')
  call g:assert.equals(&l:smartindent, 0,          'failed at #11')
  call g:assert.equals(&l:cindent,     0,          'failed at #11')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #11')

  %delete

  " #12
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #12')
  call g:assert.equals(getline(2),   '    [',      'failed at #12')
  call g:assert.equals(getline(3),   '    foo',    'failed at #12')
  call g:assert.equals(getline(4),   '    ]',      'failed at #12')
  call g:assert.equals(getline(5),   '    }',      'failed at #12')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #12')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #12')
  call g:assert.equals(&l:autoindent,  1,          'failed at #12')
  call g:assert.equals(&l:smartindent, 0,          'failed at #12')
  call g:assert.equals(&l:cindent,     0,          'failed at #12')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #12')

  %delete

  " #13
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #13')
  call g:assert.equals(getline(2),   '    [',      'failed at #13')
  call g:assert.equals(getline(3),   '    foo',    'failed at #13')
  call g:assert.equals(getline(4),   '    ]',      'failed at #13')
  call g:assert.equals(getline(5),   '    }',      'failed at #13')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #13')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #13')
  call g:assert.equals(&l:autoindent,  1,          'failed at #13')
  call g:assert.equals(&l:smartindent, 1,          'failed at #13')
  call g:assert.equals(&l:cindent,     0,          'failed at #13')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #13')

  %delete

  " #14
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',      'failed at #14')
  call g:assert.equals(getline(2),   '    [',      'failed at #14')
  call g:assert.equals(getline(3),   '    foo',    'failed at #14')
  call g:assert.equals(getline(4),   '    ]',      'failed at #14')
  call g:assert.equals(getline(5),   '    }',      'failed at #14')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #14')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0], 'failed at #14')
  call g:assert.equals(&l:autoindent,  1,          'failed at #14')
  call g:assert.equals(&l:smartindent, 1,          'failed at #14')
  call g:assert.equals(&l:cindent,     1,          'failed at #14')
  call g:assert.equals(&l:indentexpr,  '',         'failed at #14')

  %delete

  " #15
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #15')
  call g:assert.equals(getline(2),   '    [',          'failed at #15')
  call g:assert.equals(getline(3),   '    foo',        'failed at #15')
  call g:assert.equals(getline(4),   '    ]',          'failed at #15')
  call g:assert.equals(getline(5),   '    }',          'failed at #15')
  call g:assert.equals(getpos('.'),  [0, 3, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #15')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #15')
  call g:assert.equals(&l:autoindent,  1,              'failed at #15')
  call g:assert.equals(&l:smartindent, 1,              'failed at #15')
  call g:assert.equals(&l:cindent,     1,              'failed at #15')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #15')

  %delete

  """ 2
  call operator#sandwich#set('add', 'block', 'autoindent', 2)

  " #16
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #16')
  call g:assert.equals(getline(2),   '        [',   'failed at #16')
  call g:assert.equals(getline(3),   '        foo', 'failed at #16')
  call g:assert.equals(getline(4),   '        ]',   'failed at #16')
  call g:assert.equals(getline(5),   '    }',       'failed at #16')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #16')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #16')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #16')
  call g:assert.equals(&l:autoindent,  0,           'failed at #16')
  call g:assert.equals(&l:smartindent, 0,           'failed at #16')
  call g:assert.equals(&l:cindent,     0,           'failed at #16')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #16')

  %delete

  " #17
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #17')
  call g:assert.equals(getline(2),   '        [',   'failed at #17')
  call g:assert.equals(getline(3),   '        foo', 'failed at #17')
  call g:assert.equals(getline(4),   '        ]',   'failed at #17')
  call g:assert.equals(getline(5),   '    }',       'failed at #17')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #17')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #17')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #17')
  call g:assert.equals(&l:autoindent,  1,           'failed at #17')
  call g:assert.equals(&l:smartindent, 0,           'failed at #17')
  call g:assert.equals(&l:cindent,     0,           'failed at #17')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #17')

  %delete

  " #18
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #18')
  call g:assert.equals(getline(2),   '        [',   'failed at #18')
  call g:assert.equals(getline(3),   '        foo', 'failed at #18')
  call g:assert.equals(getline(4),   '        ]',   'failed at #18')
  call g:assert.equals(getline(5),   '    }',       'failed at #18')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #18')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #18')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #18')
  call g:assert.equals(&l:autoindent,  1,           'failed at #18')
  call g:assert.equals(&l:smartindent, 1,           'failed at #18')
  call g:assert.equals(&l:cindent,     0,           'failed at #18')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #18')

  %delete

  " #19
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',       'failed at #19')
  call g:assert.equals(getline(2),   '        [',   'failed at #19')
  call g:assert.equals(getline(3),   '        foo', 'failed at #19')
  call g:assert.equals(getline(4),   '        ]',   'failed at #19')
  call g:assert.equals(getline(5),   '    }',       'failed at #19')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],  'failed at #19')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],  'failed at #19')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],  'failed at #19')
  call g:assert.equals(&l:autoindent,  1,           'failed at #19')
  call g:assert.equals(&l:smartindent, 1,           'failed at #19')
  call g:assert.equals(&l:cindent,     1,           'failed at #19')
  call g:assert.equals(&l:indentexpr,  '',          'failed at #19')

  %delete

  " #20
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '    {',          'failed at #20')
  call g:assert.equals(getline(2),   '        [',      'failed at #20')
  call g:assert.equals(getline(3),   '        foo',    'failed at #20')
  call g:assert.equals(getline(4),   '        ]',      'failed at #20')
  call g:assert.equals(getline(5),   '    }',          'failed at #20')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #20')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0],     'failed at #20')
  call g:assert.equals(getpos("']"), [0, 5, 6, 0],     'failed at #20')
  call g:assert.equals(&l:autoindent,  1,              'failed at #20')
  call g:assert.equals(&l:smartindent, 1,              'failed at #20')
  call g:assert.equals(&l:cindent,     1,              'failed at #20')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #20')

  %delete

  """ 3
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #21
  setlocal noautoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',             'failed at #21')
  call g:assert.equals(getline(2),   '    [',         'failed at #21')
  call g:assert.equals(getline(3),   '        foo',   'failed at #21')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #21')
  call g:assert.equals(getline(5),   '}',             'failed at #21')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #21')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #21')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #21')
  call g:assert.equals(&l:autoindent,  0,             'failed at #21')
  call g:assert.equals(&l:smartindent, 0,             'failed at #21')
  call g:assert.equals(&l:cindent,     0,             'failed at #21')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #21')

  %delete

  " #22
  setlocal autoindent
  setlocal nosmartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',             'failed at #22')
  call g:assert.equals(getline(2),   '    [',         'failed at #22')
  call g:assert.equals(getline(3),   '        foo',   'failed at #22')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #22')
  call g:assert.equals(getline(5),   '}',             'failed at #22')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #22')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #22')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #22')
  call g:assert.equals(&l:autoindent,  1,             'failed at #22')
  call g:assert.equals(&l:smartindent, 0,             'failed at #22')
  call g:assert.equals(&l:cindent,     0,             'failed at #22')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #22')

  %delete

  " #23
  setlocal smartindent
  setlocal nocindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',             'failed at #23')
  call g:assert.equals(getline(2),   '    [',         'failed at #23')
  call g:assert.equals(getline(3),   '        foo',   'failed at #23')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #23')
  call g:assert.equals(getline(5),   '}',             'failed at #23')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #23')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #23')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #23')
  call g:assert.equals(&l:autoindent,  1,             'failed at #23')
  call g:assert.equals(&l:smartindent, 1,             'failed at #23')
  call g:assert.equals(&l:cindent,     0,             'failed at #23')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #23')

  %delete

  " #24
  setlocal cindent
  setlocal indentexpr=
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',             'failed at #24')
  call g:assert.equals(getline(2),   '    [',         'failed at #24')
  call g:assert.equals(getline(3),   '        foo',   'failed at #24')
  " call g:assert.equals(getline(4),   '            ]', 'failed at #24')
  call g:assert.equals(getline(5),   '}',             'failed at #24')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],    'failed at #24')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],    'failed at #24')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],    'failed at #24')
  call g:assert.equals(&l:autoindent,  1,             'failed at #24')
  call g:assert.equals(&l:smartindent, 1,             'failed at #24')
  call g:assert.equals(&l:cindent,     1,             'failed at #24')
  call g:assert.equals(&l:indentexpr,  '',            'failed at #24')

  %delete

  " #25
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',              'failed at #25')
  call g:assert.equals(getline(2),   '    [',          'failed at #25')
  call g:assert.equals(getline(3),   '        foo',    'failed at #25')
  " call g:assert.equals(getline(4),   '            ]',  'failed at #25')
  call g:assert.equals(getline(5),   '}',              'failed at #25')
  call g:assert.equals(getpos('.'),  [0, 3, 9, 0],     'failed at #25')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0],     'failed at #25')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0],     'failed at #25')
  call g:assert.equals(&l:autoindent,  1,              'failed at #25')
  call g:assert.equals(&l:smartindent, 1,              'failed at #25')
  call g:assert.equals(&l:cindent,     1,              'failed at #25')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #25')

  %delete

  " #26
  setlocal indentexpr=TestIndent()
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa0"
  call g:assert.equals(getline(1),   '    {',      'failed at #26')
  call g:assert.equals(getline(2),   '[',          'failed at #26')
  call g:assert.equals(getline(3),   'foo',        'failed at #26')
  call g:assert.equals(getline(4),   ']',          'failed at #26')
  call g:assert.equals(getline(5),   '}',          'failed at #26')
  call g:assert.equals(getpos('.'),  [0, 3, 1, 0], 'failed at #26')
  call g:assert.equals(getpos("'["), [0, 1, 5, 0], 'failed at #26')
  call g:assert.equals(getpos("']"), [0, 5, 2, 0], 'failed at #26')
  call g:assert.equals(&l:autoindent,  1,          'failed at #26')
  call g:assert.equals(&l:smartindent, 1,          'failed at #26')
  call g:assert.equals(&l:cindent,     1,          'failed at #26')
  call g:assert.equals(&l:indentexpr,  'TestIndent()', 'failed at #26')
endfunction
"}}}
function! s:suite.blockwise_x_option_indentkeys() abort  "{{{
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ["{\n", "\n}"], 'input': ['a']},
        \   {'buns': ["{\n", "\n}"], 'indentkeys': '0{,0},0),:,0#,!^F,e', 'input': ['1']},
        \ ]

  """ cinkeys
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #1
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #1')
  call g:assert.equals(getline(2),   'foo',        'failed at #1')
  call g:assert.equals(getline(3),   '}',          'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #1')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #1')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #1')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #1')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #2
  setlocal cinkeys=0{,0},0),:,0#,!^F,e
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #2')
  call g:assert.equals(getline(2),   '    foo',    'failed at #2')
  call g:assert.equals(getline(3),   '}',          'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 2, 5, 0], 'failed at #2')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #2')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #2')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #2')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #2')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #3
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '{',          'failed at #3')
  call g:assert.equals(getline(2),   'foo',        'failed at #3')
  call g:assert.equals(getline(3),   '}',          'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #3')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #3')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #3')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #3')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', 3)

  " #4
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa1"
  call g:assert.equals(getline(1),   '{',          'failed at #4')
  call g:assert.equals(getline(2),   'foo',        'failed at #4')
  call g:assert.equals(getline(3),   '}',          'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("'["), [0, 1, 1, 0], 'failed at #4')
  call g:assert.equals(getpos("']"), [0, 3, 2, 0], 'failed at #4')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #4')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #4')

  """ indentkeys
  %delete
  setlocal indentexpr=TestIndent()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #5
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys', '0{,0},0),:,0#,!^F,e')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #5')
  call g:assert.equals(getline(2),   'foo',        'failed at #5')
  call g:assert.equals(getline(3),   '    }',      'failed at #5')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #5')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #5')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #5')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #5')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #5')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #6
  setlocal cinkeys&
  setlocal indentkeys=0{,0},0),:,0#,!^F,e
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys+', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',     'failed at #6')
  call g:assert.equals(getline(2),   '    foo',       'failed at #6')
  call g:assert.equals(getline(3),   '            }', 'failed at #6')
  call g:assert.equals(getpos('.'),  [0, 2,  5, 0],   'failed at #6')
  call g:assert.equals(getpos("'["), [0, 1,  9, 0],   'failed at #6')
  call g:assert.equals(getpos("']"), [0, 3, 14, 0],   'failed at #6')
  call g:assert.equals(&l:cinkeys,    cinkeys,        'failed at #6')
  call g:assert.equals(&l:indentkeys, indentkeys,     'failed at #6')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #7
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call operator#sandwich#set('add', 'block', 'indentkeys-', 'O,o')
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsaa"
  call g:assert.equals(getline(1),   '        {',  'failed at #7')
  call g:assert.equals(getline(2),   'foo',        'failed at #7')
  call g:assert.equals(getline(3),   '    }',      'failed at #7')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #7')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #7')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #7')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #7')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #7')

  %delete
  call operator#sandwich#set_default()
  call operator#sandwich#set('add', 'block', 'autoindent', -1)

  " #8
  setlocal cinkeys&
  setlocal indentkeys&
  let cinkeys = &l:cinkeys
  let indentkeys = &l:indentkeys
  call setline('.', '    foo')
  execute "normal ^\<C-v>iwsa1"
  call g:assert.equals(getline(1),   '        {',  'failed at #8')
  call g:assert.equals(getline(2),   'foo',        'failed at #8')
  call g:assert.equals(getline(3),   '    }',      'failed at #8')
  call g:assert.equals(getpos('.'),  [0, 2, 1, 0], 'failed at #8')
  call g:assert.equals(getpos("'["), [0, 1, 9, 0], 'failed at #8')
  call g:assert.equals(getpos("']"), [0, 3, 6, 0], 'failed at #8')
  call g:assert.equals(&l:cinkeys,    cinkeys,     'failed at #8')
  call g:assert.equals(&l:indentkeys, indentkeys,  'failed at #8')
endfunction
"}}}

" Function interface
function! s:suite.function_interface() abort  "{{{
  nmap ssa <Esc>:call operator#sandwich#prerequisite('add', 'n', {'cursor': 'inner_tail'}, [{'buns': ['(', ')']}])<CR>g@
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = [
        \   {'buns': ['[', ']']},
        \ ]

  " #1
  call setline('.', 'foo')
  normal 0saiw(
  call g:assert.equals(getline('.'), '(foo(',      'failed at #1')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #1')

  " #2
  call setline('.', 'foo')
  normal 0saiw[
  call g:assert.equals(getline('.'), '[foo]',      'failed at #2')
  call g:assert.equals(getpos('.'),  [0, 1, 2, 0], 'failed at #2')

  " #3
  call setline('.', 'foo')
  normal 0ssaiw(
  call g:assert.equals(getline('.'), '(foo)',      'failed at #3')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #3')

  " #4
  call setline('.', 'foo')
  normal 0ssaiw[
  call g:assert.equals(getline('.'), '[foo[',      'failed at #4')
  call g:assert.equals(getpos('.'),  [0, 1, 4, 0], 'failed at #4')
endfunction
"}}}

" Undo
function! s:suite.undo() abort  "{{{
  " #1
  call setline('.', 'foo')
  " set undo point (see :help :undojoin)
  let &undolevels = &undolevels
  normal 0saiw(
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 02saiw((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  " #3
  call setline('.', 'foo')
  let &undolevels = &undolevels
  normal 03saiw(((
  normal! u
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')
endfunction
"}}}

" auto-indent
function! s:suite.autoindent() abort "{{{
  " #1
  filetype indent on
  set expandtab softtabstop=2 shiftwidth=2
  set indentexpr=TestIndent()
  set indentkeys=>
  call append(0, ['foo', 'bar'])
  call cursor(2, 1)
  execute "normal saiwtbaz\<CR>"
  call g:assert.equals(getline('.'), '    <baz>bar</baz>', 'failed at #1')
endfunction "}}}
function! s:suite.insertspace() abort "{{{
  " #1
  call setline(1, 'foo')
  execute "normal 0saiw\<Space>"
  call g:assert.equals(getline('.'), ' foo ')

  " #2
  call setline(1, 'foo')
  execute "normal 0lsal\<Space>"
  call g:assert.equals(getline('.'), 'f o o')
endfunction "}}}

" auto-formatting
function! s:suite.autoformat() abort "{{{
  " #1
  setlocal formatoptions+=t textwidth=10
  call setline(1, 'ab cd ef gh ij kl mn op')
  call cursor(1, 17)
  execute "normal saiw("
  call g:assert.equals(getline('.'), 'ab cd ef gh ij (kl) mn op', 'failed at #1')
endfunction "}}}

" inappropriate input
function! s:suite.inappropriate_input() abort "{{{
  " #1
  call setline(1, 'abc')
  call cursor(1, 1)
  execute "normal saiw\<Left>l"
  call g:assert.equals(getline('.'), 'abc', 'failed at #1')
endfunction "}}}

" input_fallback
function! s:suite.input_fallback() abort "{{{
  let g:sandwich#recipes = []
  let g:operator#sandwich#recipes = []

  let g:sandwich#input_fallback = 1
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa', 'failed at #1')

  let g:sandwich#input_fallback = 0
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  unlet! g:sandwich#input_fallback
  call setline('.', 'foo')
  normal 0saiwa
  call g:assert.equals(getline('.'), 'afooa', 'failed at #3')
endfunction "}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
