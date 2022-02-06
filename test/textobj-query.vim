scriptencoding utf-8

let s:suite = themis#suite('textobj-sandwich: query:')

function! s:suite.before() abort  "{{{
  omap is <Plug>(textobj-sandwich-query-i)
  xmap is <Plug>(textobj-sandwich-query-i)
  omap as <Plug>(textobj-sandwich-query-a)
  xmap as <Plug>(textobj-sandwich-query-a)
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
  silent! ounmap iis
  silent! ounmap aas
  silent! nunmap sd
  silent! xunmap sd
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
  ounmap is
  xunmap is
  ounmap as
  xunmap as
endfunction
"}}}

" Input
function! s:suite.input() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  " #1
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'input': ['a', 'b']}]

  " #2
  call setline('.', '(foo)')
  normal 0disa
  call g:assert.equals(getline('.'), '()', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  normal 0disb
  call g:assert.equals(getline('.'), '()', 'failed at #3')

  " #4
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  execute "normal 0dis\<Esc>"
  call g:assert.equals(getline('.'), '(foo)', 'failed at #5')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['`', '`']},
        \   {'buns': ['``', '``']},
        \   {'buns': ['```', '```']},
        \ ]

  " #6
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #6')

  " #7
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```baz````baz```', 'failed at #7')

  " #8
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #8')

  " #9
  call setline('.', '```baz``bar`foo`bar``baz```')
  execute "normal 0ffdis`\<Esc>"
  call g:assert.equals(getline('.'), '```baz``bar`foo`bar``baz```', 'failed at #9')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #10
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #10')

  " #11
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #11')

  " #12
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #12')

  " #13
  call setline('.', '```baz``bar`foo`bar``baz```')
  execute "normal 0ffdis`\<Esc>"
  call g:assert.equals(getline('.'), '```baz``bar`foo`bar``baz```', 'failed at #13')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #14
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #14')

  " #15
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #15')

  " #16
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #16')

  " #17
  call setline('.', '```baz``bar`foo`bar``baz```')
  execute "normal 0ffdis`\<Esc>"
  call g:assert.equals(getline('.'), '```baz``bar`foo`bar``baz```', 'failed at #17')
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim'], 'input': ['(', ')']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #2')

  " #3
  call setline('.', '<foo>')
  normal 02ldis<
  call g:assert.equals(getline('.'), '<>', 'failed at #3')

  set filetype=vim

  " #4
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #5')

  " #6
  call setline('.', '<foo>')
  normal 02ldis<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #6')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \ ]

  " #2
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto'], 'input': ['(', ')']},
        \ ]

  " #3
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #3')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj'], 'input': ['(', ')']},
        \ ]

  " #4
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #5
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #5')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #1')

  " #2
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '([])', 'failed at #2')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o'], 'input': ['(', ')']},
        \ ]

  " #3
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #3')

  " #4
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '()', 'failed at #4')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #5
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #5')

  " #6
  call setline('.', '([foo])')
  normal 03lvis(d
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
  normal 0dis(
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  " #2
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #2')

  " #3
  call setline('.', '{foo}')
  normal 0dis{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #3')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis)
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis[
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis]
  call g:assert.equals(@@, 'foo', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis{
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis}
  call g:assert.equals(@@, 'foo', 'failed at #6')

  " #7
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis<
  call g:assert.equals(@@, 'foo', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis>
  call g:assert.equals(@@, 'foo', 'failed at #8')

  " #9
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'foo', 'failed at #9')

  " #10
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyis'
  call g:assert.equals(@@, 'foo', 'failed at #10')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'bb', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'bb', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #36')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'bb', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'bb', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'bb', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'bb', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'aa', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'aa', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'aa', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'aa', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'aa', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'aa', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'aa', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'cc', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'cc', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'cc', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'cc', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'cc', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'cc', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyis"
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyis"
  call g:assert.equals(@@, 'cc', 'failed at #36')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyist
  call g:assert.equals(@@, 'bb', 'failed at #1')
endfunction
"}}}
function! s:suite.i_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyisa
  call g:assert.equals(@@, 'bb', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyisa
  call g:assert.equals(@@, 'bb', 'failed at #2')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisb
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisc
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yis0
  call g:assert.equals(@@, 'aa', 'failed at #8')
endfunction
"}}}
function! s:suite.i_o_option_listexpr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprEmpty("former")', 'input': ['b']},
        \   {'buns': 'SandwichListexprEmpty("latter")', 'input': ['c']},
        \   {'buns': 'SandwichListexprEmpty("both")', 'input': ['d']},
        \ ]

  """ on
  call textobj#sandwich#set('query', 'listexpr', 1)
  " #1
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'bar', 'failed at #1')

  " #2
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yisb
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yisc
  call g:assert.equals(@@, '', 'failed at #3')

  " #4
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yisd
  call g:assert.equals(@@, '', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['\d\+', '\d\+'], 'input': ['a']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 0, 'input': ['0']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yis0
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
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]

  " #2
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #2')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'fooa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyis'
  call g:assert.equals(@@, "''foo''", 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa\', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa\"bb', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
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
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyis"
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyis"
  call g:assert.equals(@@, "", 'failed at #4')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, '', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyis"
  call g:assert.equals(@@, '', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #8')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyis"
  call g:assert.equals(@@, '', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyis"
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #12')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{'], 'input': ['a']},
        \   {'external': ['i{', 'a{'], 'noremap': 0, 'input': ['0']},
        \   {'external': ['i{', 'a{'], 'noremap': 1, 'input': ['1']},
        \ ]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis0
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yis0
  call g:assert.equals(@@, '', 'failed at #4')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'foo', 'failed at #8')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #1')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #3')

  call textobj#sandwich#set('query', 'syntax', [])

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'foo', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'inner_syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'inner_syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #1')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #3')

  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'bar', 'failed at #4')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'match_syntax': 1, 'input': ['1']},
        \ ]

  """ 0 (test recipe-local)
  call textobj#sandwich#set('query', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'foo', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, '', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis1
  call g:assert.equals(@@, 'foo', 'failed at #3')

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #6')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #7')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #8')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #9')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #10
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #10')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #11
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #11')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #12
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #12')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #13
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #13')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #14
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #14')
endfunction
"}}}
function! s:suite.i_o_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'skip_break': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "\nfoo\n", 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis1
  call g:assert.equals(@@, 'foo', 'failed at #2')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #3
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "foo", 'failed at #3')

  %delete

  " #4
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "foo", 'failed at #4')

  %delete

  " #5
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, "  foo  ", 'failed at #5')
endfunction
"}}}
function! s:suite.i_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyisa
  call g:assert.equals(@@, 'aaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyisa
  call g:assert.equals(@@, 'aaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('query', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyisa
  call g:assert.equals(@@, 'aaa', 'failed at #3')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'foo', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis)y
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis[y
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis]y
  call g:assert.equals(@@, 'foo', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis{y
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis}y
  call g:assert.equals(@@, 'foo', 'failed at #6')

  " #7
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis<y
  call g:assert.equals(@@, 'foo', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis>y
  call g:assert.equals(@@, 'foo', 'failed at #8')

  " #9
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'foo', 'failed at #9')

  " #10
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvis'y
  call g:assert.equals(@@, 'foo', 'failed at #10')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #36')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '"', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'a', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #36')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvisty
  call g:assert.equals(@@, 'bb', 'failed at #1')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #1
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{y
  call g:assert.equals(@@, 'cc', 'failed at #1')

  " #2
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[y
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #2')

  " #3
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[is(y
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #3')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #1
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>is(y"
  call g:assert.equals(@@, " \na\n ", 'failed at #1')

  %delete

  " #2
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #4')

  %delete

  " #5
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #5')
endfunction
"}}}
function! s:suite.i_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvisay
  call g:assert.equals(@@, 'bb', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvisay
  call g:assert.equals(@@, 'bb', 'failed at #2')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '2', 'failed at #2')

  " #3
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '1', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visby
  call g:assert.equals(@@, '2', 'failed at #6')

  " #7
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viscy
  call g:assert.equals(@@, '2', 'failed at #7')

  " #8
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vis0y
  call g:assert.equals(@@, 'aa', 'failed at #8')
endfunction
"}}}
function! s:suite.i_x_option_listexpr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprEmpty("former")', 'input': ['b']},
        \   {'buns': 'SandwichListexprEmpty("latter")', 'input': ['c']},
        \   {'buns': 'SandwichListexprEmpty("both")', 'input': ['d']},
        \ ]

  """ on
  call textobj#sandwich#set('query', 'listexpr', 1)
  " #1
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'bar', 'failed at #1')

  " #2
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0visby
  call g:assert.equals(@@, 'f', 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0viscy
  call g:assert.equals(@@, 'f', 'failed at #3')

  " #4
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0visdy
  call g:assert.equals(@@, 'f', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['\d\+', '\d\+'], 'input': ['a']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 0, 'input': ['0']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '8', 'failed at #2')

  " #3
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'aa', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '\', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #5')

  " #6
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vis0y
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
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['aa']}]

  " #2
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'fooa', 'failed at #2')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'fooa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvis'y
  call g:assert.equals(@@, "''foo''", 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa\', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa\"bb', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
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
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvis"y
  call g:assert.equals(@@, 'b', 'failed at #4')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #8')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvis"y
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #12')
  unlet! g:textobj#sandwich#recipes
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{'], 'input': ['a']},
        \   {'external': ['i{', 'a{'], 'noremap': 0, 'input': ['0']},
        \   {'external': ['i{', 'a{'], 'noremap': 1, 'input': ['1']},
        \ ]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis0y
  call g:assert.equals(@@, 'foo', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vis0y
  call g:assert.equals(@@, '{', 'failed at #4')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '{', 'failed at #6')

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, '(', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'foo', 'failed at #8')
endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #1')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #3')

  call textobj#sandwich#set('query', 'syntax', [])

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'foo', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'inner_syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'inner_syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #1')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #3')

  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'bar', 'failed at #4')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'match_syntax': 1, 'input': ['1']},
        \ ]

  """ 0 (test recipe-local)
  call textobj#sandwich#set('query', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'foo', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis1y
  call g:assert.equals(@@, 'foo', 'failed at #3')

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #6')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #7')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #8')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #9')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #10
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #10')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #11
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #11')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #12
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #12')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #13
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #13')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #14
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #14')
endfunction
"}}}
function! s:suite.i_x_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'skip_break': 1, 'input': ['1']},
        \ ]

  """ 0
  " #1
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "\nfoo\n", 'failed at #1')

  %delete

  " #2
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis1y
  call g:assert.equals(@@, 'foo', 'failed at #2')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #3
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "foo", 'failed at #3')

  %delete

  " #4
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "foo", 'failed at #4')

  %delete

  " #5
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, "  foo  ", 'failed at #5')
endfunction
"}}}
function! s:suite.i_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvisay
  call g:assert.equals(@@, 'aaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvisay
  call g:assert.equals(@@, 'aaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('query', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvisay
  call g:assert.equals(@@, 'aaa', 'failed at #3')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas)
  call g:assert.equals(@@, '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas[
  call g:assert.equals(@@, '[foo]', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas]
  call g:assert.equals(@@, '[foo]', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas{
  call g:assert.equals(@@, '{foo}', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas}
  call g:assert.equals(@@, '{foo}', 'failed at #6')

  " #7
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas<
  call g:assert.equals(@@, '<foo>', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas>
  call g:assert.equals(@@, '<foo>', 'failed at #8')

  " #9
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"foo"', 'failed at #9')

  " #10
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyas'
  call g:assert.equals(@@, "'foo'", 'failed at #10')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '()', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(a)', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #36')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '""', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"a"', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #36')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyast
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #1')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #1
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(h
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(((
  call g:assert.equals(@@, '(((foo)))', 'failed at #2')
endfunction
"}}}
function! s:suite.a_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyasa
  call g:assert.equals(@@, 'αbbα', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyasa
  call g:assert.equals(@@, 'aαbbaα', 'failed at #2')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '2aa3', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '2aa3', 'failed at #5')

  " #6
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasb
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasc
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yas0
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #8')
endfunction
"}}}
function! s:suite.a_o_option_listexpr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprEmpty("former")', 'input': ['b']},
        \   {'buns': 'SandwichListexprEmpty("latter")', 'input': ['c']},
        \   {'buns': 'SandwichListexprEmpty("both")', 'input': ['d']},
        \ ]

  """ on
  call textobj#sandwich#set('query', 'listexpr', 1)
  " #1
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'foobarbaz', 'failed at #1')

  " #2
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yasb
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yasc
  call g:assert.equals(@@, '', 'failed at #3')

  " #4
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0yasd
  call g:assert.equals(@@, '', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['\d\+', '\d\+'], 'input': ['a']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 0, 'input': ['0']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #2')

  " #3
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '888aa888', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '888aa888', 'failed at #5')

  " #6
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yas0
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
  normal 0yasa
  call g:assert.equals(@@, 'afooa', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['a']}]

  " #2
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #2')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooaa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyas'
  call g:assert.equals(@@, "'''foo'''", 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa\"', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #2')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
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
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyas"
  call g:assert.equals(@@, "", 'failed at #4')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #8')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jyas"
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #12')
  unlet! g:textobj#sandwich#recipes
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{'], 'input': ['a']},
        \   {'external': ['i{', 'a{'], 'noremap': 0, 'input': ['0']},
        \   {'external': ['i{', 'a{'], 'noremap': 1, 'input': ['1']},
        \ ]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '{foo}', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas0
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yas0
  call g:assert.equals(@@, '', 'failed at #4')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '(foo)', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #6')

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '{foo}', 'failed at #8')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  call textobj#sandwich#set('query', 'syntax', [])

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'inner_syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'inner_syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #1')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #3')

  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '(bar)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'match_syntax': 1, 'input': ['1']},
        \ ]

  """ 0 (test recipe-local)
  call textobj#sandwich#set('query', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas1
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #6')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #7')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #8')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #9')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #10
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #10')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #11
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #11')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #12
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #12')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #13
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #13')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #14
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #14')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #1
  call setline('.', '(foo)')
  normal 0sdas(
  call g:assert.equals(getline('.'), 'foo', 'failed at #1')

  " #2
  call setline('.', '((foo))')
  normal 0ff2sd2as(
  call g:assert.equals(getline('.'), 'foo', 'failed at #2')

  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'synchro': 1, 'nesting': 1}]
  call textobj#sandwich#set('query', 'synchro', 0)

  " #3
  call setline('.', '(foo)')
  normal 0sdas(
  call g:assert.equals(getline('.'), 'foo', 'failed at #3')

  " #4
  call setline('.', '((foo))')
  normal 0ff2sd2as(
  call g:assert.equals(getline('.'), 'foo', 'failed at #4')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)

  " #5
  call setline('.', '<bar>foo</bar>')
  normal 0sdast
  call g:assert.equals(getline('.'), 'foo', 'failed at #5')

  " #6
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ast
  call g:assert.equals(getline('.'), 'foo', 'failed at #6')

  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'synchro': 1, 'input': ['t']}]
  call textobj#sandwich#set('query', 'synchro', 0)

  " #7
  call setline('.', '<bar>foo</bar>')
  normal 0sdast
  call g:assert.equals(getline('.'), 'foo', 'failed at #7')

  " #8
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ast
  call g:assert.equals(getline('.'), 'foo', 'failed at #8')

  let g:sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}, {'buns': ["'", "'"], 'nesting': 0}]
  let g:textobj#sandwich#recipes = []
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-synchro-count)<Plug>(textobj-sandwich-query-a)

  " #9
  call setline('.', "(a'b((c))b'a)")
  normal 0fc3sd(
  call g:assert.equals(getline('.'), "a'b((c))b'a", 'failed at #9')

  call operator#sandwich#set('all', 'all', 'skip_char', 1)

  " #10
  call setline('.', "(a'b((c))b'a)")
  normal 0fc3sd(
  call g:assert.equals(getline('.'), "a'bcb'a", 'failed at #10')
endfunction
"}}}
function! s:suite.a_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyasa
  call g:assert.equals(@@, 'aaaaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyasa
  call g:assert.equals(@@, 'aaaaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('query', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyasa
  call g:assert.equals(@@, 'aaaaa', 'failed at #3')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas)y
  call g:assert.equals(@@, '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas[y
  call g:assert.equals(@@, '[foo]', 'failed at #3')

  " #4
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas]y
  call g:assert.equals(@@, '[foo]', 'failed at #4')

  " #5
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas{y
  call g:assert.equals(@@, '{foo}', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas}y
  call g:assert.equals(@@, '{foo}', 'failed at #6')

  " #7
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas<y
  call g:assert.equals(@@, '<foo>', 'failed at #7')

  " #8
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas>y
  call g:assert.equals(@@, '<foo>', 'failed at #8')

  " #9
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"foo"', 'failed at #9')

  " #10
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvas'y
  call g:assert.equals(@@, "'foo'", 'failed at #10')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #1
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '()', 'failed at #1')

  " #2
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(a)', 'failed at #2')

  " #3
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #3')

  " #4
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #4')

  " #5
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #5')

  " #6
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #6')

  " #7
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #7')

  " #8
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #19
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #19')

  " #20
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #20')

  " #21
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #21')

  " #22
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #22')

  " #23
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #23')

  " #24
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #24')

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #36')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #1
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '""', 'failed at #1')

  " #2
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"a"', 'failed at #2')

  " #3
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #3')

  " #4
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #4')

  " #5
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  " #6
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #6')

  " #7
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #7')

  " #8
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #8')

  " #9
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #9')

  " #10
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #10')

  " #11
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #11')

  " #12
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #12')

  " #13
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #13')

  " #14
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #14')

  " #15
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #15')

  " #16
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #16')

  " #17
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #17')

  " #18
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #18')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #19
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #19')

  " #20
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #20')

  " #21
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #21')

  " #22
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #22')

  " #23
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #23')

  " #24
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #24')

  " #25
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #25')

  " #26
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #26')

  " #27
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #27')

  " #28
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #28')

  " #29
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #29')

  " #30
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #30')

  " #31
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #31')

  " #32
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #32')

  " #33
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #33')

  " #34
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #34')

  " #35
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #35')

  " #36
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #36')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #1
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvasty
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #1')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #1
  " NOTE: At this moment the first y after vas( is ignored...
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(yy
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  " #2
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(((y
  call g:assert.equals(@@, '(((foo)))', 'failed at #2')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #1
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{y
  call g:assert.equals(@@, '{cc}', 'failed at #1')

  " #2
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[y
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #2')

  " #3
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[as(y
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #3')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #1
  call append(0, ['(aa', 'aa', 'aa)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>as(y"
  call g:assert.equals(@@, "(aa\naa\naa)", 'failed at #1')

  %delete

  " #2
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #2')

  %delete

  " #3
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #3')

  %delete

  " #4
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #4')

  %delete

  " #5
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #5')
endfunction
"}}}
function! s:suite.a_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #1
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvasay
  call g:assert.equals(@@, 'αbbα', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #2
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvasay
  call g:assert.equals(@@, 'aαbbaα', 'failed at #2')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': ['1+1', '1+2'], 'expr': 0, 'input': ['0']},
        \   {'buns': ['1+1', '1+2'], 'expr': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #1')

  " #2
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2', 'failed at #2')

  " #3
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '2aa3', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #4
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1', 'failed at #4')

  " #5
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2aa3', 'failed at #5')

  " #6
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasby
  call g:assert.equals(@@, '2', 'failed at #6')

  " #7
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vascy
  call g:assert.equals(@@, '2', 'failed at #7')

  " #8
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vas0y
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #8')
endfunction
"}}}
function! s:suite.a_x_option_listexpr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': 'SandwichListexprBuns(0)', 'input': ['a']},
        \   {'buns': 'SandwichListexprEmpty("former")', 'input': ['b']},
        \   {'buns': 'SandwichListexprEmpty("latter")', 'input': ['c']},
        \   {'buns': 'SandwichListexprEmpty("both")', 'input': ['d']},
        \ ]

  """ on
  call textobj#sandwich#set('query', 'listexpr', 1)
  " #1
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'foobarbaz', 'failed at #1')

  " #2
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vasby
  call g:assert.equals(@@, 'f', 'failed at #2')

  " #3
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vascy
  call g:assert.equals(@@, 'f', 'failed at #3')

  " #4
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0vasdy
  call g:assert.equals(@@, 'f', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['\d\+', '\d\+'], 'input': ['a']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 0, 'input': ['0']},
        \   {'buns': ['\d\+', '\d\+'], 'regex': 1, 'input': ['1']},
        \ ]

  """ off
  " #1
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #1')

  " #2
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '8', 'failed at #2')

  " #3
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '888aa888', 'failed at #3')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #4
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\', 'failed at #4')

  " #5
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '888aa888', 'failed at #5')

  " #6
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vas0y
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
  normal 0vasay
  call g:assert.equals(@@, 'afooa', 'failed at #1')

  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_regex': ['aa']}]

  " #2
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooaa', 'failed at #2')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  " #3
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooaa', 'failed at #3')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #4
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvas'y
  call g:assert.equals(@@, "'''foo'''", 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  """ off
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  " #2
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa\"', 'failed at #2')

  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'quoteescape': 1}]

  " #3
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #3')

  """ on
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #1
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
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
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #1')

  %delete

  " #2
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #2')

  %delete

  " #3
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #3')

  %delete

  " #4
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 0}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvas"y
  call g:assert.equals(@@, 'b', 'failed at #4')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #5
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #5')

  %delete

  " #6
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #6')

  %delete

  " #7
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #7')

  %delete

  " #8
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': 1}]
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #8')
  unlet! g:textobj#sandwich#recipes

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #9
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #9')

  %delete

  " #10
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #10')

  %delete

  " #11
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #11')

  %delete

  " #12
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"'], 'expand_range': -1}]
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal gg2jvas"y
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #12')
  unlet! g:textobj#sandwich#recipes
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{'], 'input': ['a']},
        \   {'external': ['i{', 'a{'], 'noremap': 0, 'input': ['0']},
        \   {'external': ['i{', 'a{'], 'noremap': 1, 'input': ['1']},
        \ ]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{foo}', 'failed at #2')

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas0y
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vas0y
  call g:assert.equals(@@, '{', 'failed at #4')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(foo)', 'failed at #5')

  " #6
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{', 'failed at #6')

  " #7
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(', 'failed at #7')

  " #8
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '{foo}', 'failed at #8')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  call textobj#sandwich#set('query', 'syntax', [])

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(foo)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  call textobj#sandwich#set('query', 'inner_syntax', [])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'inner_syntax': ['Special'], 'input': ['1']},
        \ ]

  " #1
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #1')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #2
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #2')

  highlight link TestParen Special

  " #3
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #3')

  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #4
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(bar)', 'failed at #4')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['(', ')'], 'match_syntax': 1, 'input': ['1']},
        \ ]

  """ 0 (test recipe-local)
  call textobj#sandwich#set('query', 'match_syntax', 0)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas1y
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #1
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #1')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #2
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #2')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #3
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #3')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #4
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #4')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #5
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #5')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #6
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #6')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #7
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #7')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #8
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #8')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #9
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #9')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #10
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #10')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #11
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #11')
endfunction
"}}}
function! s:suite.a_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #1
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvasay
  call g:assert.equals(@@, 'aaaaa', 'failed at #1')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #2
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvasay
  call g:assert.equals(@@, 'aaaaa', 'failed at #2')

  %delete

  """ recipe-local
  call textobj#sandwich#set('query', 'skip_expr', [])
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a'], 'skip_expr': ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)']}]
  " #3
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvasay
  call g:assert.equals(@@, 'aaaaa', 'failed at #3')
endfunction
"}}}

" Function interface
function! s:suite.i_function_interface() abort  "{{{
  omap <expr> iis textobj#sandwich#query('o', 'i', {'quoteescape': 0}, [{'buns': ['"', '"']}, {'buns': ['(', ')']}])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"']},
        \   {'buns': ['[', ']']},
        \ ]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #1
  call setline('.', '"foo\""')
  normal 0dis"
  call g:assert.equals(getline('.'), '""', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #3')

  " #4
  call setline('.', '"foo\""')
  normal 0diis"
  call g:assert.equals(getline('.'), '"""', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0diis(
  call g:assert.equals(getline('.'), '()', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0diis[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}
function! s:suite.a_function_interface() abort  "{{{
  omap <expr> aas textobj#sandwich#query('o', 'a', {'quoteescape': 0}, [{'buns': ['"', '"']}, {'buns': ['(', ')']}])
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"']},
        \   {'buns': ['[', ']']},
        \ ]
  call textobj#sandwich#set('query', 'quoteescape', 1)

  " #1
  call setline('.', '"foo\""')
  normal 0das"
  call g:assert.equals(getline('.'), '', 'failed at #1')

  " #2
  call setline('.', '(foo)')
  normal 0das(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #2')

  " #3
  call setline('.', '[foo]')
  normal 0das[
  call g:assert.equals(getline('.'), '', 'failed at #3')

  " #4
  call setline('.', '"foo\""')
  normal 0daas"
  call g:assert.equals(getline('.'), '"', 'failed at #4')

  " #5
  call setline('.', '(foo)')
  normal 0daas(
  call g:assert.equals(getline('.'), '', 'failed at #5')

  " #6
  call setline('.', '[foo]')
  normal 0daas[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #6')
endfunction
"}}}

" input_fallback
function! s:suite.input_fallback() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = []

  let g:sandwich#input_fallback = 1
  call setline('.', 'afooa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #1')

  let g:sandwich#input_fallback = 0
  call setline('.', 'afooa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'fail', 'failed at #2')

  unlet! g:sandwich#input_fallback
  call setline('.', 'afooa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #3')
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
