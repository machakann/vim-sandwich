let s:suite = themis#suite('textobj-sandwich: query:')

function! s:suite.before_each() abort "{{{
  %delete
  syntax off
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
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \ ]

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

  " #125
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisb
  call g:assert.equals(@@, '', 'failed at #125')

  " #126
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisc
  call g:assert.equals(@@, '', 'failed at #126')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #127
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #127')

  " #128
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #128')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #129
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #129')

  " #130
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #130')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #131
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #131')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #132
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'fooa', 'failed at #132')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #133
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa\"bb', 'failed at #133')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #134
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #134')

  %delete

  " #135
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #135')

  %delete

  " #136
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #136')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #137
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #137')

  %delete

  " #138
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #138')

  %delete

  " #139
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #139')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #140
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #140')

  %delete

  " #141
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #141')

  %delete

  " #142
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #142')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #143
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #143')

  " #144
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #144')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #145
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #145')

  " #146
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #146')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #147
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #147')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #148
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #148')

  highlight link TestParen Special

  " #149
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #149')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #150
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #150')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #151
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #151')

  highlight link TestParen Special

  " #152
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #152')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #153
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #153')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #154
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #154')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #155
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #155')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #156
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #156')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #157
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #157')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #158
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #158')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #159
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #159')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #160
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #160')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #161
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #161')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #162
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #162')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #163
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #163')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #164
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "\nfoo\n", 'failed at #164')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #165
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "foo", 'failed at #165')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #166
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'foo', 'failed at #166')

  " #167
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis)y
  call g:assert.equals(@@, 'foo', 'failed at #167')

  " #168
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis[y
  call g:assert.equals(@@, 'foo', 'failed at #168')

  " #169
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis]y
  call g:assert.equals(@@, 'foo', 'failed at #169')

  " #170
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis{y
  call g:assert.equals(@@, 'foo', 'failed at #170')

  " #171
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis}y
  call g:assert.equals(@@, 'foo', 'failed at #171')

  " #172
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis<y
  call g:assert.equals(@@, 'foo', 'failed at #172')

  " #173
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis>y
  call g:assert.equals(@@, 'foo', 'failed at #173')

  " #174
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'foo', 'failed at #174')

  " #175
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvis'y
  call g:assert.equals(@@, 'foo', 'failed at #175')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #176
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #176')

  " #177
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'a', 'failed at #177')

  " #178
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #178')

  " #179
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #179')

  " #180
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #180')

  " #181
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #181')

  " #182
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #182')

  " #183
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #183')

  " #184
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #184')

  " #185
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #185')

  " #186
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #186')

  " #187
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #187')

  " #188
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #188')

  " #189
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #189')

  " #190
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #190')

  " #191
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #191')

  " #192
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #192')

  " #193
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #193')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #194
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #194')

  " #195
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #195')

  " #196
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #196')

  " #197
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #197')

  " #198
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #198')

  " #199
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #199')

  " #200
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #200')

  " #201
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #201')

  " #202
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #202')

  " #203
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #203')

  " #204
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #204')

  " #205
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #205')

  " #206
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #206')

  " #207
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #207')

  " #208
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #208')

  " #209
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #209')

  " #210
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #210')

  " #211
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #211')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #212
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '"', 'failed at #212')

  " #213
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'a', 'failed at #213')

  " #214
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #214')

  " #215
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #215')

  " #216
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #216')

  " #217
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #217')

  " #218
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #218')

  " #219
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #219')

  " #220
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #220')

  " #221
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #221')

  " #222
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #222')

  " #223
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #223')

  " #224
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #224')

  " #225
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #225')

  " #226
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #226')

  " #227
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #227')

  " #228
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #228')

  " #229
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #229')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #230
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #230')

  " #231
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #231')

  " #232
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #232')

  " #233
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #233')

  " #234
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #234')

  " #235
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #235')

  " #236
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #236')

  " #237
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #237')

  " #238
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #238')

  " #239
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #239')

  " #240
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #240')

  " #241
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #241')

  " #242
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #242')

  " #243
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #243')

  " #244
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #244')

  " #245
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #245')

  " #246
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #246')

  " #247
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #247')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #248
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvisty
  call g:assert.equals(@@, 'bb', 'failed at #248')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #249
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{y
  call g:assert.equals(@@, 'cc', 'failed at #249')

  " #250
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[y
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #250')

  " #251
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[is(y
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #251')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #252
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>is(y"
  call g:assert.equals(@@, " \na\n ", 'failed at #252')

  %delete

  " #253
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #253')

  %delete

  " #254
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #254')

  %delete

  " #255
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #255')

  %delete

  " #256
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #256')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \ ]

  """ off
  " #257
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #257')

  " #258
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '2', 'failed at #258')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #259
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '1', 'failed at #259')

  " #260
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #260')

  " #261
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visby
  call g:assert.equals(@@, '2', 'failed at #261')

  " #262
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viscy
  call g:assert.equals(@@, '2', 'failed at #262')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #261
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #261')

  " #262
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '8', 'failed at #262')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #263
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '\', 'failed at #263')

  " #264
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #264')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #265
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #265')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #266
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'fooa', 'failed at #266')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #267
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa\"bb', 'failed at #267')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #268
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #268')

  %delete

  " #269
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #269')

  %delete

  " #270
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #270')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #271
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #271')

  %delete

  " #272
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #272')

  %delete

  " #273
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #273')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #274
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #274')

  %delete

  " #275
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #275')

  %delete

  " #276
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #276')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #277
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '(', 'failed at #277')

  " #278
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #278')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #279
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #279')

  " #280
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '{', 'failed at #280')
endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #281
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #281')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #282
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #282')

  highlight link TestParen Special

  " #283
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #283')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #284
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #284')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #285
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #285')

  highlight link TestParen Special

  " #286
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #286')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #287
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #287')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #288
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #288')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #289
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #289')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #290
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #290')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #291
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #291')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #292
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #292')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #293
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #293')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #294
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #294')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #295
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #295')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #296
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #296')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #297
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #297')
endfunction
"}}}
function! s:suite.i_x_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #298
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "\nfoo\n", 'failed at #298')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #299
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "foo", 'failed at #299')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #300
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(foo)', 'failed at #300')

  " #301
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas)
  call g:assert.equals(@@, '(foo)', 'failed at #301')

  " #302
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas[
  call g:assert.equals(@@, '[foo]', 'failed at #302')

  " #303
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas]
  call g:assert.equals(@@, '[foo]', 'failed at #303')

  " #304
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas{
  call g:assert.equals(@@, '{foo}', 'failed at #304')

  " #305
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas}
  call g:assert.equals(@@, '{foo}', 'failed at #305')

  " #306
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas<
  call g:assert.equals(@@, '<foo>', 'failed at #306')

  " #307
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas>
  call g:assert.equals(@@, '<foo>', 'failed at #307')

  " #308
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"foo"', 'failed at #308')

  " #309
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyas'
  call g:assert.equals(@@, "'foo'", 'failed at #309')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #310
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '()', 'failed at #310')

  " #311
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(a)', 'failed at #311')

  " #312
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #312')

  " #313
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #313')

  " #314
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #314')

  " #315
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #315')

  " #316
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #316')

  " #317
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #317')

  " #318
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #318')

  " #319
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #319')

  " #320
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #320')

  " #321
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #321')

  " #322
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #322')

  " #323
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #323')

  " #324
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #324')

  " #325
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #325')

  " #326
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #326')

  " #327
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #327')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #328
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #328')

  " #329
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #329')

  " #330
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #330')

  " #331
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #331')

  " #332
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #332')

  " #333
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #333')

  " #334
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #334')

  " #335
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #335')

  " #336
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #336')

  " #337
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #337')

  " #338
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #338')

  " #339
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #339')

  " #340
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #340')

  " #341
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #341')

  " #342
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #342')

  " #343
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #343')

  " #344
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #344')

  " #345
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #345')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #346
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '""', 'failed at #346')

  " #347
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"a"', 'failed at #347')

  " #348
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #348')

  " #349
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #349')

  " #350
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #350')

  " #351
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #351')

  " #352
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #352')

  " #353
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #353')

  " #354
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #354')

  " #355
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #355')

  " #356
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #356')

  " #357
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #357')

  " #358
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #358')

  " #359
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #359')

  " #360
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #360')

  " #361
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #361')

  " #362
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #362')

  " #363
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #363')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #364
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #364')

  " #365
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #365')

  " #366
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #366')

  " #367
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #367')

  " #368
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #368')

  " #369
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #369')

  " #370
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #370')

  " #371
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #371')

  " #372
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #372')

  " #373
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #373')

  " #374
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #374')

  " #375
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #375')

  " #376
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #376')

  " #377
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #377')

  " #378
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #378')

  " #379
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #379')

  " #380
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #380')

  " #381
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #381')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #382
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyast
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #382')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #383
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(
  call g:assert.equals(@@, '(foo)', 'failed at #383')

  " #384
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(((
  call g:assert.equals(@@, '(((foo)))', 'failed at #384')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \ ]

  """ off
  " #385
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #385')

  " #386
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #386')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #387
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #387')

  " #388
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '2aa3', 'failed at #388')

  " #389
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasb
  call g:assert.equals(@@, '', 'failed at #389')

  " #390
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasc
  call g:assert.equals(@@, '', 'failed at #390')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #391
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #391')

  " #392
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #392')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #393
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #393')

  " #394
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '888aa888', 'failed at #394')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #395
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooa', 'failed at #395')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #396
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooaa', 'failed at #396')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #397
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #397')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #398
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #398')

  %delete

  " #399
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #399')

  %delete

  " #400
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #400')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #401
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #401')

  %delete

  " #402
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #402')

  %delete

  " #403
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #403')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #404
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #404')

  %delete

  " #405
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #405')

  %delete

  " #406
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #406')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #407
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #407')

  " #408
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '{foo}', 'failed at #408')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #409
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '(foo)', 'failed at #409')

  " #410
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #410')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #411
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #411')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #412
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #412')

  highlight link TestParen Special

  " #413
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #413')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #414
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #414')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #415
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #415')

  highlight link TestParen Special

  " #416
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #416')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #417
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #417')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #418
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #418')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #419
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #419')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #420
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #420')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #421
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #421')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #422
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #422')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #423
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #423')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #424
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #424')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #425
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #425')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #426
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #426')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #427
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #427')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #428
  call setline('.', '(foo)')
  normal 0sdas(
  call g:assert.equals(getline('.'), 'foo', 'failed at #428')

  " #429
  call setline('.', '((foo))')
  normal 0ff2sd2as(
  call g:assert.equals(getline('.'), 'foo', 'failed at #429')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]
  let g:operator#sandwich#recipes = []

  " #430
  call setline('.', '<bar>foo</bar>')
  normal 0sdast
  call g:assert.equals(getline('.'), 'foo', 'failed at #430')

  " #431
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ast
  call g:assert.equals(getline('.'), 'foo', 'failed at #431')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #432
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(foo)', 'failed at #432')

  " #433
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas)y
  call g:assert.equals(@@, '(foo)', 'failed at #433')

  " #434
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas[y
  call g:assert.equals(@@, '[foo]', 'failed at #434')

  " #435
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas]y
  call g:assert.equals(@@, '[foo]', 'failed at #435')

  " #436
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas{y
  call g:assert.equals(@@, '{foo}', 'failed at #436')

  " #437
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas}y
  call g:assert.equals(@@, '{foo}', 'failed at #437')

  " #438
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas<y
  call g:assert.equals(@@, '<foo>', 'failed at #438')

  " #439
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas>y
  call g:assert.equals(@@, '<foo>', 'failed at #439')

  " #440
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"foo"', 'failed at #440')

  " #441
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvas'y
  call g:assert.equals(@@, "'foo'", 'failed at #441')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #442
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '()', 'failed at #442')

  " #443
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(a)', 'failed at #443')

  " #444
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #444')

  " #445
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #445')

  " #446
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #446')

  " #447
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #447')

  " #448
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #448')

  " #449
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #449')

  " #450
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #450')

  " #451
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #451')

  " #452
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #452')

  " #453
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #453')

  " #454
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #454')

  " #455
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #455')

  " #456
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #456')

  " #457
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #457')

  " #458
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #458')

  " #459
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #459')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #460
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #460')

  " #461
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #461')

  " #462
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #462')

  " #463
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #463')

  " #464
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #464')

  " #465
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #465')

  " #466
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #466')

  " #467
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #467')

  " #468
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #468')

  " #469
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #469')

  " #470
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #470')

  " #471
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #471')

  " #472
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #472')

  " #473
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #473')

  " #474
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #474')

  " #475
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #475')

  " #476
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #476')

  " #477
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #477')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #478
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '""', 'failed at #478')

  " #479
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"a"', 'failed at #479')

  " #480
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #480')

  " #481
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #481')

  " #482
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #482')

  " #483
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #483')

  " #484
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #484')

  " #485
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #485')

  " #486
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #486')

  " #487
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #487')

  " #488
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #488')

  " #489
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #489')

  " #490
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #490')

  " #491
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #491')

  " #492
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #492')

  " #493
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #493')

  " #494
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #494')

  " #495
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #495')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #496
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #496')

  " #497
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #497')

  " #498
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #498')

  " #499
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #499')

  " #500
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #500')

  " #501
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #501')

  " #502
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #502')

  " #503
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #503')

  " #504
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #504')

  " #505
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #505')

  " #506
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #506')

  " #507
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #507')

  " #508
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #508')

  " #509
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #509')

  " #510
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #510')

  " #511
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #511')

  " #512
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #512')

  " #513
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #513')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #514
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvasty
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #514')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #515
  " NOTE: At this moment the first y after vas( is ignored...
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(yy
  call g:assert.equals(@@, '(foo)', 'failed at #515')

  " #516
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(((y
  call g:assert.equals(@@, '(((foo)))', 'failed at #516')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #517
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{y
  call g:assert.equals(@@, '{cc}', 'failed at #517')

  " #518
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[y
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #518')

  " #519
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[as(y
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #519')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #520
  call append(0, ['(aa', 'aa', 'aa)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>as(y"
  call g:assert.equals(@@, "(aa\naa\naa)", 'failed at #520')

  %delete

  " #521
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #521')

  %delete

  " #522
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #522')

  %delete

  " #523
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #523')

  %delete

  " #524
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #524')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \ ]

  """ off
  " #525
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #525')

  " #526
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2', 'failed at #526')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #527
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1', 'failed at #527')

  " #528
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2aa3', 'failed at #528')

  " #529
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasby
  call g:assert.equals(@@, '2', 'failed at #529')

  " #530
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vascy
  call g:assert.equals(@@, '2', 'failed at #530')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #531
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #531')

  " #532
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '8', 'failed at #532')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #533
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\', 'failed at #533')

  " #534
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '888aa888', 'failed at #534')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #535
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooa', 'failed at #535')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #536
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooaa', 'failed at #536')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #537
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #537')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #538
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #538')

  %delete

  " #539
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #539')

  %delete

  " #540
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #540')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #541
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #541')

  %delete

  " #542
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #542')

  %delete

  " #543
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #543')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #544
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #544')

  %delete

  " #545
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #545')

  %delete

  " #546
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #546')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #547
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(', 'failed at #547')

  " #548
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{foo}', 'failed at #548')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #549
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(foo)', 'failed at #549')

  " #550
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{', 'failed at #550')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #551
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #551')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #552
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #552')

  highlight link TestParen Special

  " #553
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #553')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #554
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #554')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #555
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #555')

  highlight link TestParen Special

  " #556
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #556')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('query', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #557
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #557')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #558
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #558')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #559
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #559')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #560
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #560')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #561
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #561')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #562
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #562')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #563
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #563')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #564
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #564')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #565
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #565')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #566
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #566')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #567
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #567')
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

  " #568
  call setline('.', '"foo\""')
  normal 0dis"
  call g:assert.equals(getline('.'), '""', 'failed at #568')

  " #569
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #569')

  " #570
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #570')

  " #571
  call setline('.', '"foo\""')
  normal 0diis"
  call g:assert.equals(getline('.'), '"""', 'failed at #571')

  " #572
  call setline('.', '(foo)')
  normal 0diis(
  call g:assert.equals(getline('.'), '()', 'failed at #572')

  " #573
  call setline('.', '[foo]')
  normal 0diis[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #573')
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

  " #574
  call setline('.', '"foo\""')
  normal 0das"
  call g:assert.equals(getline('.'), '', 'failed at #574')

  " #575
  call setline('.', '(foo)')
  normal 0das(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #575')

  " #576
  call setline('.', '[foo]')
  normal 0das[
  call g:assert.equals(getline('.'), '', 'failed at #576')

  " #577
  call setline('.', '"foo\""')
  normal 0daas"
  call g:assert.equals(getline('.'), '"', 'failed at #577')

  " #578
  call setline('.', '(foo)')
  normal 0daas(
  call g:assert.equals(getline('.'), '', 'failed at #578')

  " #579
  call setline('.', '[foo]')
  normal 0daas[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #579')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
