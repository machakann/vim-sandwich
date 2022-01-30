scriptencoding utf-8

let s:suite = themis#suite('textobj-sandwich: auto:')

function! s:suite.before() abort  "{{{
  omap ib <Plug>(textobj-sandwich-auto-i)
  xmap ib <Plug>(textobj-sandwich-auto-i)
  omap ab <Plug>(textobj-sandwich-auto-a)
  xmap ab <Plug>(textobj-sandwich-auto-a)
endfunction
"}}}
function! s:suite.before_each() abort "{{{
  %delete
  syntax off
  set filetype=
  set virtualedit&
  set whichwrap&
  call textobj#sandwich#set_default()
  call operator#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:textobj#sandwich#recipes
  silent! xunmap i{
  silent! xunmap a{
  silent! ounmap iib
  silent! ounmap aab
  silent! nunmap sd
  silent! xunmap sd
  silent! nunmap sdb
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  ounmap ib
  xunmap ib
  ounmap ab
  xunmap ab
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  normal 02ldib
  call g:assert.equals(getline('.'), '{}', 'failed at #2')

  " #3
  call setline('.', '<foo>')
  normal 02ldib
  call g:assert.equals(getline('.'), '<>', 'failed at #3')

  set filetype=vim

  " #4
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  normal 02ldib
  call g:assert.equals(getline('.'), '{}', 'failed at #5')

  " #6
  call setline('.', '<foo>')
  normal 02ldib
  call g:assert.equals(getline('.'), '<foo>', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query']},
        \ ]

  " #2
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto']},
        \ ]

  " #3
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #3')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj']},
        \ ]

  " #4
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #5
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #5')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']']},
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #1')

  " #2
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o']},
        \ ]

  " #3
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #3')

  " #4
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '()', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x']},
        \ ]

  " #5
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #5')

  " #6
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
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
  normal 0dib
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0dib
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #4')

  " #5
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #6')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'bb', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'bb', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #36')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'nesting': 0}, {'external': ['it', 'at'], 'input': ['t']}]

  " #37
  call setline('.', '<a href="http://www.url.com" target="_blank">Anchor Text</a>')
  let @@ = 'fail'
  normal 0fwyib
  call g:assert.equals(@@, 'http://www.url.com', 'failed at #37')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'aa', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'aa', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'aa', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'aa', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'cc', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'cc', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'cc', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'cc', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'cc', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'cc', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'cc', 'failed at #36')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #1')
endfunction
"}}}
function! s:suite.i_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #2')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 1}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yib
  call g:assert.equals(@@, '', 'failed at #7')

  " #9
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 0}]
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #9')
endfunction
"}}}
function! s:suite.i_o_option_listexpr() abort "{{{
  let g:sandwich#recipes = []

  """ on
  call textobj#sandwich#set('auto', 'listexpr', 1)
  " #1
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprBuns(0)'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("former")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("latter")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("both")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #6')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #1
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'fooa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "''foo''", 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #3')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #1
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\n", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyib
  call g:assert.equals(@@, "", 'failed at #4')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #8')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #12')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #4')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #8')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #1')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #3')

  call textobj#sandwich#set('auto', 'syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'syntax': ['Special']}]

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #1')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #3')

  call textobj#sandwich#set('auto', 'inner_syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'inner_syntax': ['Special']}]

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []

  """ 0 (test recipe-local)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'match_syntax': 1}]
  call textobj#sandwich#set('auto', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #3')

  """ 1
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #6')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #7')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #8')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #9')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #10
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #10')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #11
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #11')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #12
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #12')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #13
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #13')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #14
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #14')
endfunction
"}}}
function! s:suite.i_o_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\nfoo\n", 'failed at #1')

  %delete

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'skip_break': 1}]
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, 'foo', 'failed at #2')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  " #3
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #3')

  %delete

  " #4
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #4')

  %delete

  " #5
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, "  foo  ", 'failed at #5')
endfunction
"}}}
function! s:suite.i_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('auto', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #3')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #1
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #1')

  " #2
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #3
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo", 'failed at #3')

  " #4
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo''bar", 'failed at #4')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #5
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'oobarbaz', 'failed at #5')

  " #6
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bar', 'failed at #6')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #7
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #7')

  " #8
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #9
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #9')

  " #10
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #10')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #4')

  " #5
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #6')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #36')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'nesting': 0}, {'external': ['it', 'at'], 'input': ['t']}]

  " #37
  call setline('.', '<a href="http://www.url.com" target="_blank">Anchor Text</a>')
  let @@ = 'fail'
  normal 0fwviby
  call g:assert.equals(@@, 'http://www.url.com', 'failed at #37')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #36')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #1')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #1
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #1')

  " #2
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #2')

  " #3
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #3')

  %delete

  " #4
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['if', 'endif'], 'nesting': 1},
        \   {'buns': ['if', 'else'], 'nesting': 1},
        \   {'buns': ['else', 'endif'], 'nesting': 1},
        \ ]
  call append(0, ['if', '  foo', '  foo', 'else', '  bar', '  bar', 'endif'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\n  foo\n  foo\n", 'failed at #4')

  " #5
  let @@ = 'fail'
  normal ggvibiby
  call g:assert.equals(@@, "\n  foo\n  foo\nelse\n  bar\n  bar\n", 'failed at #5')

  " #6
  let @@ = 'fail'
  normal 5Gviby
  call g:assert.equals(@@, "\n  bar\n  bar\n", 'failed at #6')

  " #7
  let @@ = 'fail'
  normal 5Gvibiby
  call g:assert.equals(@@, "\n  foo\n  foo\nelse\n  bar\n  bar\n", 'failed at #7')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #1
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #1')

  %delete

  " #2
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #4')

  %delete

  " #5
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #5')
endfunction
"}}}
function! s:suite.i_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #2')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 1}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $viby
  call g:assert.equals(@@, '3', 'failed at #7')

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 0}]
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #8')
endfunction
"}}}
function! s:suite.i_x_option_listexpr() abort "{{{
  let g:sandwich#recipes = []

  """ on
  call textobj#sandwich#set('auto', 'listexpr', 1)
  " #1
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprBuns(0)'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("former")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'f', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("latter")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'f', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("both")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'f', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #6')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #1
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #2')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "''foo''", 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #3')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #1
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jviby
  call g:assert.equals(@@, 'b', 'failed at #4')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #8')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #12')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #4')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #8')
endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #1')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #3')

  call textobj#sandwich#set('auto', 'syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'syntax': ['Special']}]

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #1')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #3')

  call textobj#sandwich#set('auto', 'inner_syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'inner_syntax': ['Special']}]

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []

  """ 0 (test recipe-local)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'match_syntax': 1}]
  call textobj#sandwich#set('auto', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #3')

  """ 1
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #3')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #6')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #7
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #7')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #8')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #9')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #10
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #10')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #11
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #11')
endfunction
"}}}
function! s:suite.i_x_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #1')

  %delete

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'skip_break': 1}]
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, 'foo', 'failed at #2')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  " #2
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #2')

  %delete

  " #3
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #3')

  %delete

  " #4
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, "  foo  ", 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #2')

  """ recipe-local
  call textobj#sandwich#set('auto', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #3')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #1
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #1')

  " #2
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #3
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo", 'failed at #3')

  " #4
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo''bar", 'failed at #4')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #5
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'oobarbaz', 'failed at #5')

  " #6
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bar', 'failed at #6')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #7
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #7')

  " #8
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #9
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #9')

  " #10
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #10')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #4')

  " #5
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #6')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #36')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'nesting': 0}, {'external': ['it', 'at'], 'input': ['t']}]

  " #37
  call setline('.', '<a href="http://www.url.com" target="_blank">Anchor Text</a>')
  let @@ = 'fail'
  normal 0fwyab
  call g:assert.equals(@@, '"http://www.url.com"', 'failed at #37')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #36')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #1')
endfunction
"}}}
function! s:suite.a_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'αbbα', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'aαbbaα', 'failed at #2')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 1}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yab
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 0}]
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #8')
endfunction
"}}}
function! s:suite.a_o_option_listexpr() abort "{{{
  let g:sandwich#recipes = []

  """ on
  call textobj#sandwich#set('auto', 'listexpr', 1)
  " #1
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprBuns(0)'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("former")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("latter")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("both")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #6')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #1
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'''foo'''", 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  " call setline('.', '"aa\"bb"')
  " let @@ = 'fail'
  " normal 0yab
  " call g:assert.equals(@@, '"aa\"', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #3')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #1
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyab
  call g:assert.equals(@@, '', 'failed at #4')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #8')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #12')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #4')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #8')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  call textobj#sandwich#set('auto', 'syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'syntax': ['Special']}]

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #1')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #3')

  call textobj#sandwich#set('auto', 'inner_syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'inner_syntax': ['Special']}]

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []

  """ 0 (test recipe-local)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'match_syntax': 1}]
  call textobj#sandwich#set('auto', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 1
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #6')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #7')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #8')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #9')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #10
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #10')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #11
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #11')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #12
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #12')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #13
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #13')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #14
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #14')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #1
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'synchro': 1, 'nesting': 1}]
  call textobj#sandwich#set('auto', 'synchro', 0)

  " #3
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)

  " #5
  call setline('.', '<bar>foo</bar>')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  " #6
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'synchro': 1}]
  call textobj#sandwich#set('auto', 'synchro', 0)

  " #7
  call setline('.', '<bar>foo</bar>')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #8')

  let g:sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}, {'buns': ["'", "'"], 'nesting': 0}]
  let g:textobj#sandwich#recipes = []
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-synchro-count)<Plug>(textobj-sandwich-auto-a)

  " #9
  call setline('.', "(a'b((c))b'a)")
  normal 0fc3sdb
  call g:assert.equals(getline('.'), '(ab((c))ba)', 'failed at #9')

  call operator#sandwich#set('all', 'all', 'skip_char', 1)

  " #10
  call setline('.', "(a'b((c))b'a)")
  normal 0fc3sdb
  call g:assert.equals(getline('.'), '(abcba)', 'failed at #10')
endfunction
"}}}
function! s:suite.a_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('auto', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #3')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #1
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #1')

  " #2
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #2')

  " #3
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #5
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo'", 'failed at #5')

  " #6
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo''bar'", 'failed at #6')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #7
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #7')

  " #8
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '^bar$', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #9
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '2foo2', 'failed at #9')

  " #10
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #10')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #11
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '[foo]', 'failed at #11')

  " #12
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '{foo}', 'failed at #12')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #3')

  " #4
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #4')

  " #5
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #5')

  " #6
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #6')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #36')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'nesting': 0}, {'external': ['it', 'at'], 'input': ['t']}]

  " #37
  call setline('.', '<a href="http://www.url.com" target="_blank">Anchor Text</a>')
  let @@ = 'fail'
  normal 0fwvaby
  call g:assert.equals(@@, '"http://www.url.com"', 'failed at #37')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #36')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #1')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #1
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #1')

  " #2
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #2')

  " #3
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #3')

  %delete

  " #4
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['if', 'endif'], 'nesting': 1},
        \   {'buns': ['if', 'else'], 'nesting': 1},
        \   {'buns': ['else', 'endif'], 'nesting': 1},
        \ ]
  call append(0, ['if', '  foo', '  foo', 'else', '  bar', '  bar', 'endif'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse", 'failed at #4')

  " #5
  let @@ = 'fail'
  normal ggvababy
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse\n  bar\n  bar\nendif", 'failed at #5')

  " #6
  let @@ = 'fail'
  normal 5Gvaby
  call g:assert.equals(@@, "else\n  bar\n  bar\nendif", 'failed at #6')

  " #7
  let @@ = 'fail'
  normal 5Gvababy
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse\n  bar\n  bar\nendif", 'failed at #7')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #1
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #1')

  %delete

  " #2
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #4')

  %delete

  " #5
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #5')
endfunction
"}}}
function! s:suite.a_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'αbbα', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'aαbbaα', 'failed at #2')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 1}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $vaby
  call g:assert.equals(@@, '3', 'failed at #7')

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'expr': 0}]
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #8')
endfunction
"}}}
function! s:suite.a_x_option_listexpr() abort "{{{
  let g:sandwich#recipes = []

  """ on
  call textobj#sandwich#set('auto', 'listexpr', 1)
  " #1
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprBuns(0)'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("former")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'f', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("latter")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'f', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': 'SandwichListexprEmpty("both")'}]
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'f', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 1}]
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #3')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #5')

  " #6
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'regex': 0}]
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #6')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #1
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #1')

  " #2
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'a', 'failed at #2')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'''foo'''", 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"', 'failed at #2')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #3')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #1')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #1
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvaby
  call g:assert.equals(@@, 'b', 'failed at #4')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #8')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #12')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #2')

  " #3
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 0}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #4')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #6')

  " #7
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'noremap': 1}]
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #8')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  call textobj#sandwich#set('auto', 'syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'syntax': ['Special']}]

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #1')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #3')

  call textobj#sandwich#set('auto', 'inner_syntax', [])
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'inner_syntax': ['Special']}]

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []

  """ 0 (test recipe-local)
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'match_syntax': 1}]
  call textobj#sandwich#set('auto', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 1
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #6')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #7
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #7')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #8')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #9')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #10
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #10')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #11
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #11')
endfunction
"}}}
function! s:suite.a_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('auto', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #3')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #1
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #1')

  " #2
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #2')

  " #3
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #5
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo'", 'failed at #5')

  " #6
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo''bar'", 'failed at #6')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #7
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #7')

  " #8
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '^bar$', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #9
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '2foo2', 'failed at #9')

  " #10
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #10')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #11
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '[foo]', 'failed at #11')

  " #12
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '{foo}', 'failed at #12')
endfunction
"}}}

" Function interface
function! s:suite.i_function_interface() abort  "{{{
  omap <expr> iib textobj#sandwich#auto('o', 'i', {'quoteescape': 0}, [{'buns': ['"', '"']}, {'buns': ['(', ')']}])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"']},
        \   {'buns': ['[', ']']},
        \ ]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #1
  call setline('.', '"foo\""')
  normal 0dib
  call g:assert.equals(getline('.'), '""', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #3')

  " #4
  call setline('.', '"foo\""')
  normal 0diib
  call g:assert.equals(getline('.'), '"""', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0diib
  call g:assert.equals(getline('.'), '()', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0diib
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.a_function_interface() abort  "{{{
  omap <expr> aab textobj#sandwich#auto('o', 'a', {'quoteescape': 0}, [{'buns': ['"', '"']}, {'buns': ['(', ')']}])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"']},
        \   {'buns': ['[', ']']},
        \ ]
  call textobj#sandwich#set('auto', 'quoteescape', 1)

  " #1
  call setline('.', '"foo\""')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0dab
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #3')

  " #4
  call setline('.', '"foo\""')
  normal 0daab
  call g:assert.equals(getline('.'), '"', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0daab
  call g:assert.equals(getline('.'), '', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0daab
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
