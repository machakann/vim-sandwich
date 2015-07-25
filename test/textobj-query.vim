let s:suite = themis#suite('textobj-sandwich: query:')

function! s:suite.before_each() abort "{{{
  %delete
  set filetype=
  set virtualedit&
  set whichwrap&
  call textobj#sandwich#set_default()
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

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['`', '`']},
        \   {'buns': ['``', '``']},
        \   {'buns': ['```', '```']},
        \ ]

  " #5
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #5')

  " #6
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #6')

  " #7
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``
  call g:assert.equals(getline('.'), '```baz````baz```', 'failed at #7')

  " #8
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```baz````baz```', 'failed at #8')

  " #9
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #9')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['```', '```']},
        \ ]

  " #10
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #10')

  " #11
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #11')

  " #12
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #12')

  " #13
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```baz``bar``bar``baz```', 'failed at #13')

  " #14
  call setline('.', '```baz``bar`foo`bar``baz```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #14')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['"', '"'], 'input': ['`']},
        \   {'buns': ['```', '```']},
        \ ]

  " #15
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis`
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #15')

  " #16
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis`h
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #16')

  " #17
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis``
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #17')

  " #18
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis``h
  call g:assert.equals(getline('.'), '```qux``baz`bar""bar`baz``qux```', 'failed at #18')

  " #19
  call setline('.', '```qux``baz`bar"foo"bar`baz``qux```')
  normal 0ffdis```
  call g:assert.equals(getline('.'), '``````', 'failed at #19')
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim'], 'input': ['(', ')']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \ ]

  " #20
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #20')

  " #21
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #21')

  set filetype=vim

  " #22
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #22')

  " #23
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #23')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #24
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #24')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \ ]

  " #25
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #25')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto'], 'input': ['(', ')']},
        \ ]

  " #26
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #26')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj'], 'input': ['(', ')']},
        \ ]

  " #27
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #27')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #28
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #28')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #29
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #29')

  " #30
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '([])', 'failed at #30')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o'], 'input': ['(', ')']},
        \ ]

  " #31
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #31')

  " #32
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '()', 'failed at #32')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #33
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #33')

  " #34
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '([])', 'failed at #34')
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

  " #35
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '()', 'failed at #35')

  " #36
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #36')

  " #37
  call setline('.', '{foo}')
  normal 0dis{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #37')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #38
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'foo', 'failed at #38')

  " #39
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis)
  call g:assert.equals(@@, 'foo', 'failed at #39')

  " #40
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis[
  call g:assert.equals(@@, 'foo', 'failed at #40')

  " #41
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis]
  call g:assert.equals(@@, 'foo', 'failed at #41')

  " #42
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis{
  call g:assert.equals(@@, 'foo', 'failed at #42')

  " #43
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis}
  call g:assert.equals(@@, 'foo', 'failed at #43')

  " #44
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis<
  call g:assert.equals(@@, 'foo', 'failed at #44')

  " #45
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis>
  call g:assert.equals(@@, 'foo', 'failed at #45')

  " #46
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'foo', 'failed at #46')

  " #47
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyis'
  call g:assert.equals(@@, 'foo', 'failed at #47')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #48
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #48')

  " #49
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'a', 'failed at #49')

  " #50
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #50')

  " #51
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #51')

  " #52
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #52')

  " #53
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #53')

  " #54
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #54')

  " #55
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #55')

  " #56
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'cc', 'failed at #56')

  " #57
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'cc', 'failed at #57')

  " #58
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'cc', 'failed at #58')

  " #59
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'cc', 'failed at #59')

  " #60
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #60')

  " #61
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #61')

  " #62
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #62')

  " #63
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #63')

  " #64
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #64')

  " #65
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #65')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #66
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #66')

  " #67
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #67')

  " #68
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #68')

  " #69
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #69')

  " #70
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #70')

  " #71
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb', 'failed at #71')

  " #72
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'bb', 'failed at #72')

  " #73
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'bb', 'failed at #73')

  " #74
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'bb', 'failed at #74')

  " #75
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'bb', 'failed at #75')

  " #76
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb', 'failed at #76')

  " #77
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb', 'failed at #77')

  " #78
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb', 'failed at #78')

  " #79
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #79')

  " #80
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #80')

  " #81
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #81')

  " #82
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #82')

  " #83
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #83')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #84
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '', 'failed at #84')

  " #85
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'a', 'failed at #85')

  " #86
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #86')

  " #87
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #87')

  " #88
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #88')

  " #89
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #89')

  " #90
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'bb', 'failed at #90')

  " #91
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'bb', 'failed at #91')

  " #92
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'cc', 'failed at #92')

  " #93
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'cc', 'failed at #93')

  " #94
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'cc', 'failed at #94')

  " #95
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'cc', 'failed at #95')

  " #96
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'bb', 'failed at #96')

  " #97
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'bb', 'failed at #97')

  " #98
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'aa', 'failed at #98')

  " #99
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'aa', 'failed at #99')

  " #100
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'aa', 'failed at #100')

  " #101
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'aa', 'failed at #101')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #102
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #102')

  " #103
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #103')

  " #104
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #104')

  " #105
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #105')

  " #106
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'aa', 'failed at #106')

  " #107
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'aa', 'failed at #107')

  " #108
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'aa', 'failed at #108')

  " #109
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'aa', 'failed at #109')

  " #110
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'bb', 'failed at #110')

  " #111
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'bb', 'failed at #111')

  " #112
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'cc', 'failed at #112')

  " #113
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'cc', 'failed at #113')

  " #114
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'cc', 'failed at #114')

  " #115
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'cc', 'failed at #115')

  " #116
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'cc', 'failed at #116')

  " #117
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'cc', 'failed at #117')

  " #118
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyis"
  call g:assert.equals(@@, 'cc', 'failed at #118')

  " #119
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyis"
  call g:assert.equals(@@, 'cc', 'failed at #119')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #120
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyist
  call g:assert.equals(@@, 'bb', 'failed at #120')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input': ['a']}]

  """ off
  " #121
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #121')

  " #122
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #122')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #123
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #123')

  " #124
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #124')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #125
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #125')

  " #126
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #126')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #127
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #127')

  " #128
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #128')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #129
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #129')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #130
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'fooa', 'failed at #130')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #131
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa\"bb', 'failed at #131')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #132
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #132')

  %delete

  " #133
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #133')

  %delete

  " #134
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #134')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #135
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #135')

  %delete

  " #136
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #136')

  %delete

  " #137
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #137')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #138
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #138')

  %delete

  " #139
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #139')

  %delete

  " #140
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #140')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #141
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #141')

  " #142
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #142')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #143
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #143')

  " #144
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #144')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #145
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #145')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #146
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #146')

  highlight link TestParen Special

  " #147
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #147')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #148
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #148')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #149
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #149')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #150
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #150')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #151
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #151')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #152
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #152')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #153
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #153')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #154
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #154')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #155
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "\nfoo\n", 'failed at #155')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #156
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "foo", 'failed at #156')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #157
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'foo', 'failed at #157')

  " #158
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis)y
  call g:assert.equals(@@, 'foo', 'failed at #158')

  " #159
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis[y
  call g:assert.equals(@@, 'foo', 'failed at #159')

  " #160
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis]y
  call g:assert.equals(@@, 'foo', 'failed at #160')

  " #161
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis{y
  call g:assert.equals(@@, 'foo', 'failed at #161')

  " #162
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis}y
  call g:assert.equals(@@, 'foo', 'failed at #162')

  " #163
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis<y
  call g:assert.equals(@@, 'foo', 'failed at #163')

  " #164
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis>y
  call g:assert.equals(@@, 'foo', 'failed at #164')

  " #165
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'foo', 'failed at #165')

  " #166
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvis'y
  call g:assert.equals(@@, 'foo', 'failed at #166')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #167
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #167')

  " #168
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'a', 'failed at #168')

  " #169
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #169')

  " #170
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #170')

  " #171
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #171')

  " #172
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #172')

  " #173
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #173')

  " #174
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #174')

  " #175
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #175')

  " #176
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #176')

  " #177
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #177')

  " #178
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #178')

  " #179
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #179')

  " #180
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #180')

  " #181
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #181')

  " #182
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #182')

  " #183
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #183')

  " #184
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #184')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #185
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #185')

  " #186
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #186')

  " #187
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #187')

  " #188
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #188')

  " #189
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #189')

  " #190
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #190')

  " #191
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #191')

  " #192
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #192')

  " #193
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #193')

  " #194
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #194')

  " #195
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #195')

  " #196
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #196')

  " #197
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #197')

  " #198
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #198')

  " #199
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #199')

  " #200
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #200')

  " #201
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #201')

  " #202
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #202')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #203
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '"', 'failed at #203')

  " #204
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'a', 'failed at #204')

  " #205
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #205')

  " #206
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #206')

  " #207
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #207')

  " #208
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #208')

  " #209
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #209')

  " #210
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #210')

  " #211
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #211')

  " #212
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #212')

  " #213
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #213')

  " #214
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #214')

  " #215
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #215')

  " #216
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #216')

  " #217
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #217')

  " #218
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #218')

  " #219
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #219')

  " #220
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #220')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #221
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #221')

  " #222
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #222')

  " #223
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #223')

  " #224
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #224')

  " #225
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #225')

  " #226
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #226')

  " #227
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #227')

  " #228
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #228')

  " #229
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #229')

  " #230
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #230')

  " #231
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #231')

  " #232
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #232')

  " #233
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #233')

  " #234
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #234')

  " #235
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #235')

  " #236
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #236')

  " #237
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #237')

  " #238
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #238')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #239
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvisty
  call g:assert.equals(@@, 'bb', 'failed at #239')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #240
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{y
  call g:assert.equals(@@, 'cc', 'failed at #240')

  " #241
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[y
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #241')

  " #242
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[is(y
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #242')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #243
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>is(y"
  call g:assert.equals(@@, " \na\n ", 'failed at #243')

  %delete

  " #244
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #244')

  %delete

  " #245
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #245')

  %delete

  " #246
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #246')

  %delete

  " #247
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #247')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input': ['a']}]

  """ off
  " #248
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #248')

  " #249
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '2', 'failed at #249')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #250
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '1', 'failed at #250')

  " #251
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #251')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #252
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #252')

  " #253
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '8', 'failed at #253')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #254
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '\', 'failed at #254')

  " #255
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #255')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #256
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #256')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #257
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'fooa', 'failed at #257')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #258
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa\"bb', 'failed at #258')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #259
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #259')

  %delete

  " #260
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #260')

  %delete

  " #261
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #261')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #262
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #262')

  %delete

  " #263
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #263')

  %delete

  " #264
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #264')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #265
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #265')

  %delete

  " #266
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #266')

  %delete

  " #267
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #267')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #268
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '(', 'failed at #268')

  " #269
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #269')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #270
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #270')

  " #271
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '{', 'failed at #271')
endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #272
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #272')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #273
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #273')

  highlight link TestParen Special

  " #274
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #274')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #275
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #275')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #276
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #276')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #277
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #277')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #278
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #278')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #279
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #279')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #280
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #280')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #281
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #281')
endfunction
"}}}
function! s:suite.i_x_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #282
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "\nfoo\n", 'failed at #282')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #283
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "foo", 'failed at #283')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #284
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(foo)', 'failed at #284')

  " #285
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas)
  call g:assert.equals(@@, '(foo)', 'failed at #285')

  " #286
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas[
  call g:assert.equals(@@, '[foo]', 'failed at #286')

  " #287
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas]
  call g:assert.equals(@@, '[foo]', 'failed at #287')

  " #288
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas{
  call g:assert.equals(@@, '{foo}', 'failed at #288')

  " #289
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas}
  call g:assert.equals(@@, '{foo}', 'failed at #289')

  " #290
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas<
  call g:assert.equals(@@, '<foo>', 'failed at #290')

  " #291
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas>
  call g:assert.equals(@@, '<foo>', 'failed at #291')

  " #292
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"foo"', 'failed at #292')

  " #293
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyas'
  call g:assert.equals(@@, "'foo'", 'failed at #293')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #294
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '()', 'failed at #294')

  " #295
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(a)', 'failed at #295')

  " #296
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #296')

  " #297
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #297')

  " #298
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #298')

  " #299
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #299')

  " #300
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #300')

  " #301
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #301')

  " #302
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #302')

  " #303
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #303')

  " #304
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #304')

  " #305
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #305')

  " #306
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #306')

  " #307
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #307')

  " #308
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #308')

  " #309
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #309')

  " #310
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #310')

  " #311
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #311')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #312
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #312')

  " #313
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #313')

  " #314
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #314')

  " #315
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #315')

  " #316
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #316')

  " #317
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #317')

  " #318
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #318')

  " #319
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #319')

  " #320
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #320')

  " #321
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #321')

  " #322
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #322')

  " #323
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #323')

  " #324
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #324')

  " #325
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #325')

  " #326
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #326')

  " #327
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #327')

  " #328
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #328')

  " #329
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #329')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #330
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '""', 'failed at #330')

  " #331
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"a"', 'failed at #331')

  " #332
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #332')

  " #333
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #333')

  " #334
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #334')

  " #335
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #335')

  " #336
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #336')

  " #337
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #337')

  " #338
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #338')

  " #339
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #339')

  " #340
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #340')

  " #341
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #341')

  " #342
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #342')

  " #343
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #343')

  " #344
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #344')

  " #345
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #345')

  " #346
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #346')

  " #347
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #347')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #348
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #348')

  " #349
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #349')

  " #350
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #350')

  " #351
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #351')

  " #352
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #352')

  " #353
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #353')

  " #354
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #354')

  " #355
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #355')

  " #356
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #356')

  " #357
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #357')

  " #358
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #358')

  " #359
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #359')

  " #360
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #360')

  " #361
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #361')

  " #362
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #362')

  " #363
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #363')

  " #364
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #364')

  " #365
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #365')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #366
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyast
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #366')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #367
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(
  call g:assert.equals(@@, '(foo)', 'failed at #367')

  " #368
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(((
  call g:assert.equals(@@, '(((foo)))', 'failed at #368')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input': ['a']}]

  """ off
  " #369
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #369')

  " #370
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #370')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #371
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #371')

  " #372
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '2aa3', 'failed at #372')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #373
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #373')

  " #374
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #374')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #375
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #375')

  " #376
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '888aa888', 'failed at #376')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #377
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooa', 'failed at #377')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #378
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooaa', 'failed at #378')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #379
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #379')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #380
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #380')

  %delete

  " #381
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #381')

  %delete

  " #382
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #382')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #383
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #383')

  %delete

  " #384
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #384')

  %delete

  " #385
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #385')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #386
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #386')

  %delete

  " #387
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #387')

  %delete

  " #388
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #388')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #389
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #389')

  " #390
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '{foo}', 'failed at #390')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #391
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '(foo)', 'failed at #391')

  " #392
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #392')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #393
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #393')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #394
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #394')

  highlight link TestParen Special

  " #395
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #395')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #396
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #396')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #397
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #397')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #398
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #398')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #399
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #399')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #400
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #400')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #401
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #401')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #402
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #402')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #403
  call setline('.', '(foo)')
  normal 0sdas(
  call g:assert.equals(getline('.'), 'foo', 'failed at #403')

  " #404
  call setline('.', '((foo))')
  normal 0ff2sd2as(
  call g:assert.equals(getline('.'), 'foo', 'failed at #404')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #405
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(foo)', 'failed at #405')

  " #406
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas)y
  call g:assert.equals(@@, '(foo)', 'failed at #406')

  " #407
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas[y
  call g:assert.equals(@@, '[foo]', 'failed at #407')

  " #408
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas]y
  call g:assert.equals(@@, '[foo]', 'failed at #408')

  " #409
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas{y
  call g:assert.equals(@@, '{foo}', 'failed at #409')

  " #410
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas}y
  call g:assert.equals(@@, '{foo}', 'failed at #410')

  " #411
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas<y
  call g:assert.equals(@@, '<foo>', 'failed at #411')

  " #412
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas>y
  call g:assert.equals(@@, '<foo>', 'failed at #412')

  " #413
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"foo"', 'failed at #413')

  " #414
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvas'y
  call g:assert.equals(@@, "'foo'", 'failed at #414')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #415
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '()', 'failed at #415')

  " #416
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(a)', 'failed at #416')

  " #417
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #417')

  " #418
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #418')

  " #419
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #419')

  " #420
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #420')

  " #421
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #421')

  " #422
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #422')

  " #423
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #423')

  " #424
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #424')

  " #425
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #425')

  " #426
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #426')

  " #427
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #427')

  " #428
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #428')

  " #429
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #429')

  " #430
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #430')

  " #431
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #431')

  " #432
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #432')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #433
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #433')

  " #434
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #434')

  " #435
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #435')

  " #436
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #436')

  " #437
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #437')

  " #438
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #438')

  " #439
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #439')

  " #440
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #440')

  " #441
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #441')

  " #442
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #442')

  " #443
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #443')

  " #444
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #444')

  " #445
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #445')

  " #446
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #446')

  " #447
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #447')

  " #448
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #448')

  " #449
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #449')

  " #450
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #450')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #451
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '""', 'failed at #451')

  " #452
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"a"', 'failed at #452')

  " #453
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #453')

  " #454
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #454')

  " #455
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #455')

  " #456
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #456')

  " #457
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #457')

  " #458
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #458')

  " #459
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #459')

  " #460
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #460')

  " #461
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #461')

  " #462
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #462')

  " #463
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #463')

  " #464
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #464')

  " #465
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #465')

  " #466
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #466')

  " #467
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #467')

  " #468
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #468')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #469
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #469')

  " #470
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #470')

  " #471
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #471')

  " #472
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #472')

  " #473
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #473')

  " #474
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #474')

  " #475
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #475')

  " #476
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #476')

  " #477
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #477')

  " #478
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #478')

  " #479
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #479')

  " #480
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #480')

  " #481
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #481')

  " #482
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #482')

  " #483
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #483')

  " #484
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #484')

  " #485
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #485')

  " #486
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #486')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #487
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvasty
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #487')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #488
  " NOTE: At this moment the first y after vas( is ignored...
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(yy
  call g:assert.equals(@@, '(foo)', 'failed at #488')

  " #489
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(((y
  call g:assert.equals(@@, '(((foo)))', 'failed at #489')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #490
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{y
  call g:assert.equals(@@, '{cc}', 'failed at #490')

  " #491
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[y
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #491')

  " #492
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[as(y
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #492')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #493
  call append(0, ['(aa', 'aa', 'aa)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>as(y"
  call g:assert.equals(@@, "(aa\naa\naa)", 'failed at #493')

  %delete

  " #494
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #494')

  %delete

  " #495
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #495')

  %delete

  " #496
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #496')

  %delete

  " #497
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #497')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2'], 'input': ['a']}]

  """ off
  " #498
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #498')

  " #499
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2', 'failed at #499')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #500
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1', 'failed at #500')

  " #501
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2aa3', 'failed at #501')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #502
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #502')

  " #503
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '8', 'failed at #503')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #504
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\', 'failed at #504')

  " #505
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '888aa888', 'failed at #505')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #506
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooa', 'failed at #506')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #507
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooaa', 'failed at #507')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #508
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #508')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #509
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #509')

  %delete

  " #510
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #510')

  %delete

  " #511
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #511')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #512
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #512')

  %delete

  " #513
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #513')

  %delete

  " #514
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #514')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #515
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #515')

  %delete

  " #516
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #516')

  %delete

  " #517
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #517')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #518
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(', 'failed at #518')

  " #519
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{foo}', 'failed at #519')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #520
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(foo)', 'failed at #520')

  " #521
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{', 'failed at #521')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #522
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #522')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #523
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #523')

  highlight link TestParen Special

  " #524
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #524')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #525
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #525')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #526
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #526')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #527
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #527')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #528
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #528')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #529
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #529')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #530
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #530')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #531
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #531')
endfunction
"}}}
function! s:suite.a_x_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  xmap sd <Plug>(operator-sandwich-delete)

  " #532
  call setline('.', 'afooa')
  normal 0vasasd
  call g:assert.equals(getline('.'), 'foo', 'failed at #532')
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

  " #533
  call setline('.', '"foo\""')
  normal 0dis"
  call g:assert.equals(getline('.'), '""', 'failed at #533')

  " #534
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #534')

  " #535
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #535')

  " #536
  call setline('.', '"foo\""')
  normal 0diis"
  call g:assert.equals(getline('.'), '"""', 'failed at #536')

  " #537
  call setline('.', '(foo)')
  normal 0diis(
  call g:assert.equals(getline('.'), '()', 'failed at #537')

  " #538
  call setline('.', '[foo]')
  normal 0diis[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #538')
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

  " #539
  call setline('.', '"foo\""')
  normal 0das"
  call g:assert.equals(getline('.'), '', 'failed at #539')

  " #540
  call setline('.', '(foo)')
  normal 0das(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #540')

  " #541
  call setline('.', '[foo]')
  normal 0das[
  call g:assert.equals(getline('.'), '', 'failed at #541')

  " #542
  call setline('.', '"foo\""')
  normal 0daas"
  call g:assert.equals(getline('.'), '"', 'failed at #542')

  " #543
  call setline('.', '(foo)')
  normal 0daas(
  call g:assert.equals(getline('.'), '', 'failed at #543')

  " #544
  call setline('.', '[foo]')
  normal 0daas[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #544')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
