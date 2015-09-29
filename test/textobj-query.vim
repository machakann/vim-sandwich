scriptencoding utf-8

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
        \   {'buns': ['<', '>'], 'filetype': ['']}
        \ ]

  " #20
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #20')

  " #21
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #21')

  " #22
  call setline('.', '<foo>')
  normal 02ldis<
  call g:assert.equals(getline('.'), '<>', 'failed at #22')

  set filetype=vim

  " #23
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #23')

  " #24
  call setline('.', '{foo}')
  normal 02ldis{
  call g:assert.equals(getline('.'), '{}', 'failed at #24')

  " #25
  call setline('.', '<foo>')
  normal 02ldis<
  call g:assert.equals(getline('.'), '<foo>', 'failed at #25')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \   {'buns': ['(', ')']},
        \ ]

  " #26
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #26')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query'], 'input': ['(', ')']},
        \ ]

  " #27
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #27')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto'], 'input': ['(', ')']},
        \ ]

  " #28
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #28')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj'], 'input': ['(', ')']},
        \ ]

  " #29
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #29')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all'], 'input': ['(', ')']},
        \ ]

  " #30
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #30')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'input': ['(', ')']},
        \ ]

  " #31
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #31')

  " #32
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '([])', 'failed at #32')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o'], 'input': ['(', ')']},
        \ ]

  " #33
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '([])', 'failed at #33')

  " #34
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '()', 'failed at #34')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x'], 'input': ['(', ')']},
        \ ]

  " #35
  call setline('.', '([foo])')
  normal 03ldis(
  call g:assert.equals(getline('.'), '()', 'failed at #35')

  " #36
  call setline('.', '([foo])')
  normal 03lvis(d
  call g:assert.equals(getline('.'), '([])', 'failed at #36')
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

  " #37
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '()', 'failed at #37')

  " #38
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #38')

  " #39
  call setline('.', '{foo}')
  normal 0dis{
  call g:assert.equals(getline('.'), '{foo}', 'failed at #39')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #40
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'foo', 'failed at #40')

  " #41
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyis)
  call g:assert.equals(@@, 'foo', 'failed at #41')

  " #42
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis[
  call g:assert.equals(@@, 'foo', 'failed at #42')

  " #43
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyis]
  call g:assert.equals(@@, 'foo', 'failed at #43')

  " #44
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis{
  call g:assert.equals(@@, 'foo', 'failed at #44')

  " #45
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyis}
  call g:assert.equals(@@, 'foo', 'failed at #45')

  " #46
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis<
  call g:assert.equals(@@, 'foo', 'failed at #46')

  " #47
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyis>
  call g:assert.equals(@@, 'foo', 'failed at #47')

  " #48
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'foo', 'failed at #48')

  " #49
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyis'
  call g:assert.equals(@@, 'foo', 'failed at #49')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #50
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #50')

  " #51
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'a', 'failed at #51')

  " #52
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #52')

  " #53
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #53')

  " #54
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #54')

  " #55
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #55')

  " #56
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #56')

  " #57
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #57')

  " #58
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'cc', 'failed at #58')

  " #59
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'cc', 'failed at #59')

  " #60
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'cc', 'failed at #60')

  " #61
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'cc', 'failed at #61')

  " #62
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #62')

  " #63
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #63')

  " #64
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #64')

  " #65
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #65')

  " #66
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #66')

  " #67
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #67')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #68
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #68')

  " #69
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #69')

  " #70
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #70')

  " #71
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #71')

  " #72
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #72')

  " #73
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyis(
  call g:assert.equals(@@, 'bb', 'failed at #73')

  " #74
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyis(
  call g:assert.equals(@@, 'bb', 'failed at #74')

  " #75
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyis(
  call g:assert.equals(@@, 'bb', 'failed at #75')

  " #76
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyis(
  call g:assert.equals(@@, 'bb', 'failed at #76')

  " #77
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyis(
  call g:assert.equals(@@, 'bb', 'failed at #77')

  " #78
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyis(
  call g:assert.equals(@@, 'bb', 'failed at #78')

  " #79
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyis(
  call g:assert.equals(@@, 'bb', 'failed at #79')

  " #80
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyis(
  call g:assert.equals(@@, 'bb', 'failed at #80')

  " #81
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #81')

  " #82
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #82')

  " #83
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #83')

  " #84
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #84')

  " #85
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyis(
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #85')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #86
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '', 'failed at #86')

  " #87
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'a', 'failed at #87')

  " #88
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #88')

  " #89
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #89')

  " #90
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #90')

  " #91
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #91')

  " #92
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'bb', 'failed at #92')

  " #93
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'bb', 'failed at #93')

  " #94
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'cc', 'failed at #94')

  " #95
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'cc', 'failed at #95')

  " #96
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'cc', 'failed at #96')

  " #97
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'cc', 'failed at #97')

  " #98
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'bb', 'failed at #98')

  " #99
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'bb', 'failed at #99')

  " #100
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'aa', 'failed at #100')

  " #101
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'aa', 'failed at #101')

  " #102
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'aa', 'failed at #102')

  " #103
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'aa', 'failed at #103')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #104
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #104')

  " #105
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyis"
  call g:assert.equals(@@, 'aa', 'failed at #105')

  " #106
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyis"
  call g:assert.equals(@@, 'aa', 'failed at #106')

  " #107
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyis"
  call g:assert.equals(@@, 'aa', 'failed at #107')

  " #108
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyis"
  call g:assert.equals(@@, 'aa', 'failed at #108')

  " #109
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyis"
  call g:assert.equals(@@, 'aa', 'failed at #109')

  " #110
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyis"
  call g:assert.equals(@@, 'aa', 'failed at #110')

  " #111
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyis"
  call g:assert.equals(@@, 'aa', 'failed at #111')

  " #112
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyis"
  call g:assert.equals(@@, 'bb', 'failed at #112')

  " #113
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyis"
  call g:assert.equals(@@, 'bb', 'failed at #113')

  " #114
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyis"
  call g:assert.equals(@@, 'cc', 'failed at #114')

  " #115
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyis"
  call g:assert.equals(@@, 'cc', 'failed at #115')

  " #116
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyis"
  call g:assert.equals(@@, 'cc', 'failed at #116')

  " #117
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyis"
  call g:assert.equals(@@, 'cc', 'failed at #117')

  " #118
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyis"
  call g:assert.equals(@@, 'cc', 'failed at #118')

  " #119
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyis"
  call g:assert.equals(@@, 'cc', 'failed at #119')

  " #120
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyis"
  call g:assert.equals(@@, 'cc', 'failed at #120')

  " #121
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyis"
  call g:assert.equals(@@, 'cc', 'failed at #121')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #122
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyist
  call g:assert.equals(@@, 'bb', 'failed at #122')
endfunction
"}}}
function! s:suite.i_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #123
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyisa
  call g:assert.equals(@@, 'bb', 'failed at #123')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #124
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyisa
  call g:assert.equals(@@, 'bb', 'failed at #124')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ off
  " #125
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #125')

  " #126
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #126')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #127
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #127')

  " #128
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #128')

  " #129
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisb
  call g:assert.equals(@@, '', 'failed at #129')

  " #130
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yisc
  call g:assert.equals(@@, '', 'failed at #130')

  " #131
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal 0yisd
  call g:assert.equals(@@, 'foo', 'failed at #131')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #132
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #132')

  " #133
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #133')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #134
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #134')

  " #135
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'aa', 'failed at #135')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #136
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #136')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #137
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'fooa', 'failed at #137')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #138
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyis'
  call g:assert.equals(@@, "''foo''", 'failed at #138')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #139
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa\"bb', 'failed at #139')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #140
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #140')

  %delete

  " #141
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #141')

  %delete

  " #142
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #142')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #143
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #143')

  %delete

  " #144
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #144')

  %delete

  " #145
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #145')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #146
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, 'aa', 'failed at #146')

  %delete

  " #147
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyis"
  call g:assert.equals(@@, "\naa\n", 'failed at #147')

  %delete

  " #148
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyis"
  call g:assert.equals(@@, '', 'failed at #148')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #149
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #149')

  " #150
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #150')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #151
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, 'foo', 'failed at #151')

  " #152
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yisa
  call g:assert.equals(@@, '', 'failed at #152')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #153
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #153')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #154
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #154')

  highlight link TestParen Special

  " #155
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #155')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #156
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #156')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #157
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #157')

  highlight link TestParen Special

  " #158
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'bar', 'failed at #158')
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

  " #159
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #159')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #160
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #160')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #161
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #161')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #162
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #162')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #163
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #163')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #164
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #164')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #165
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #165')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #166
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #166')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #167
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, '', 'failed at #167')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #168
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yis(
  call g:assert.equals(@@, 'foo', 'failed at #168')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #169
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yis"
  call g:assert.equals(@@, '%s', 'failed at #169')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #170
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "\nfoo\n", 'failed at #170')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #171
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyis(
  call g:assert.equals(@@, "foo", 'failed at #171')
endfunction
"}}}
function! s:suite.i_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #172
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyisa
  call g:assert.equals(@@, 'aaa', 'failed at #172')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #173
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyisa
  call g:assert.equals(@@, 'aaa', 'failed at #173')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #174
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'foo', 'failed at #174')

  " #175
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvis)y
  call g:assert.equals(@@, 'foo', 'failed at #175')

  " #176
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis[y
  call g:assert.equals(@@, 'foo', 'failed at #176')

  " #177
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvis]y
  call g:assert.equals(@@, 'foo', 'failed at #177')

  " #178
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis{y
  call g:assert.equals(@@, 'foo', 'failed at #178')

  " #179
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvis}y
  call g:assert.equals(@@, 'foo', 'failed at #179')

  " #180
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis<y
  call g:assert.equals(@@, 'foo', 'failed at #180')

  " #181
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvis>y
  call g:assert.equals(@@, 'foo', 'failed at #181')

  " #182
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'foo', 'failed at #182')

  " #183
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvis'y
  call g:assert.equals(@@, 'foo', 'failed at #183')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #184
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #184')

  " #185
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'a', 'failed at #185')

  " #186
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #186')

  " #187
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #187')

  " #188
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #188')

  " #189
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #189')

  " #190
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #190')

  " #191
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #191')

  " #192
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #192')

  " #193
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #193')

  " #194
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #194')

  " #195
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'cc', 'failed at #195')

  " #196
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #196')

  " #197
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #197')

  " #198
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #198')

  " #199
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #199')

  " #200
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #200')

  " #201
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #201')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #202
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #202')

  " #203
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #203')

  " #204
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #204')

  " #205
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #205')

  " #206
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #206')

  " #207
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #207')

  " #208
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #208')

  " #209
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #209')

  " #210
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #210')

  " #211
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #211')

  " #212
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #212')

  " #213
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #213')

  " #214
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvis(y
  call g:assert.equals(@@, 'bb', 'failed at #214')

  " #215
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #215')

  " #216
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #216')

  " #217
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #217')

  " #218
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #218')

  " #219
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvis(y
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #219')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #220
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '"', 'failed at #220')

  " #221
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'a', 'failed at #221')

  " #222
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #222')

  " #223
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #223')

  " #224
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #224')

  " #225
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #225')

  " #226
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #226')

  " #227
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #227')

  " #228
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #228')

  " #229
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #229')

  " #230
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #230')

  " #231
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #231')

  " #232
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #232')

  " #233
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #233')

  " #234
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #234')

  " #235
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #235')

  " #236
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #236')

  " #237
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #237')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #238
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #238')

  " #239
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #239')

  " #240
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #240')

  " #241
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #241')

  " #242
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #242')

  " #243
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #243')

  " #244
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #244')

  " #245
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvis"y
  call g:assert.equals(@@, 'aa', 'failed at #245')

  " #246
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #246')

  " #247
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvis"y
  call g:assert.equals(@@, 'bb', 'failed at #247')

  " #248
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #248')

  " #249
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #249')

  " #250
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #250')

  " #251
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #251')

  " #252
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #252')

  " #253
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #253')

  " #254
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #254')

  " #255
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvis"y
  call g:assert.equals(@@, 'cc', 'failed at #255')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #256
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvisty
  call g:assert.equals(@@, 'bb', 'failed at #256')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #257
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{y
  call g:assert.equals(@@, 'cc', 'failed at #257')

  " #258
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[y
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #258')

  " #259
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvis{is[is(y
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #259')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #260
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>is(y"
  call g:assert.equals(@@, " \na\n ", 'failed at #260')

  %delete

  " #261
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #261')

  %delete

  " #262
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #262')

  %delete

  " #263
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jis(y"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #263')

  %delete

  " #264
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jois(y"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #264')
endfunction
"}}}
function! s:suite.i_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #265
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvisay
  call g:assert.equals(@@, 'bb', 'failed at #265')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #266
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvisay
  call g:assert.equals(@@, 'bb', 'failed at #266')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ off
  " #267
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #267')

  " #268
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '2', 'failed at #268')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #269
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '1', 'failed at #269')

  " #270
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #270')

  " #271
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0visby
  call g:assert.equals(@@, '2', 'failed at #271')

  " #272
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viscy
  call g:assert.equals(@@, '2', 'failed at #272')

  " #273
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal 0visdy
  call g:assert.equals(@@, 'foo', 'failed at #273')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #274
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #274')

  " #275
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '8', 'failed at #275')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #276
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '\', 'failed at #276')

  " #277
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'aa', 'failed at #277')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #278
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #278')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #279
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'fooa', 'failed at #279')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #280
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvis'y
  call g:assert.equals(@@, "''foo''", 'failed at #280')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #281
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa\"bb', 'failed at #281')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #282
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #282')

  %delete

  " #283
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #283')

  %delete

  " #284
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #284')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #285
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #285')

  %delete

  " #286
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #286')

  %delete

  " #287
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #287')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #288
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, 'aa', 'failed at #288')

  %delete

  " #289
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvis"y
  call g:assert.equals(@@, "\naa\n", 'failed at #289')

  %delete

  " #290
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvis"y
  call g:assert.equals(@@, '"', 'failed at #290')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #291
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '(', 'failed at #291')

  " #292
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #292')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #293
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, 'foo', 'failed at #293')

  " #294
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0visay
  call g:assert.equals(@@, '{', 'failed at #294')
endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #295
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #295')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #296
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #296')

  highlight link TestParen Special

  " #297
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #297')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #298
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #298')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #299
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #299')

  highlight link TestParen Special

  " #300
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'bar', 'failed at #300')
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

  " #301
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #301')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #302
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #302')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #303
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #303')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #304
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #304')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #305
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #305')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #306
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #306')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #307
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #307')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #308
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #308')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #309
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, '(', 'failed at #309')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #310
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vis(y
  call g:assert.equals(@@, 'foo', 'failed at #310')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #311
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vis"y
  call g:assert.equals(@@, '%s', 'failed at #311')
endfunction
"}}}
function! s:suite.i_x_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #312
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "\nfoo\n", 'failed at #312')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'skip_break', 1)
  " #313
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggvis(y
  call g:assert.equals(@@, "foo", 'failed at #313')
endfunction
"}}}
function! s:suite.i_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #314
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvisay
  call g:assert.equals(@@, 'aaa', 'failed at #314')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #315
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvisay
  call g:assert.equals(@@, 'aaa', 'failed at #315')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #316
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(foo)', 'failed at #316')

  " #317
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyas)
  call g:assert.equals(@@, '(foo)', 'failed at #317')

  " #318
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas[
  call g:assert.equals(@@, '[foo]', 'failed at #318')

  " #319
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyas]
  call g:assert.equals(@@, '[foo]', 'failed at #319')

  " #320
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas{
  call g:assert.equals(@@, '{foo}', 'failed at #320')

  " #321
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyas}
  call g:assert.equals(@@, '{foo}', 'failed at #321')

  " #322
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas<
  call g:assert.equals(@@, '<foo>', 'failed at #322')

  " #323
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyas>
  call g:assert.equals(@@, '<foo>', 'failed at #323')

  " #324
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"foo"', 'failed at #324')

  " #325
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyas'
  call g:assert.equals(@@, "'foo'", 'failed at #325')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #326
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '()', 'failed at #326')

  " #327
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(a)', 'failed at #327')

  " #328
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #328')

  " #329
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #329')

  " #330
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #330')

  " #331
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #331')

  " #332
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #332')

  " #333
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #333')

  " #334
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #334')

  " #335
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #335')

  " #336
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #336')

  " #337
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(cc)', 'failed at #337')

  " #338
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #338')

  " #339
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #339')

  " #340
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #340')

  " #341
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #341')

  " #342
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #342')

  " #343
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #343')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #344
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #344')

  " #345
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #345')

  " #346
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #346')

  " #347
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #347')

  " #348
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #348')

  " #349
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #349')

  " #350
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #350')

  " #351
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #351')

  " #352
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #352')

  " #353
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #353')

  " #354
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #354')

  " #355
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #355')

  " #356
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyas(
  call g:assert.equals(@@, '(((bb)))', 'failed at #356')

  " #357
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #357')

  " #358
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #358')

  " #359
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #359')

  " #360
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #360')

  " #361
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyas(
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #361')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #362
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '""', 'failed at #362')

  " #363
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"a"', 'failed at #363')

  " #364
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #364')

  " #365
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #365')

  " #366
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #366')

  " #367
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #367')

  " #368
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #368')

  " #369
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #369')

  " #370
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #370')

  " #371
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #371')

  " #372
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #372')

  " #373
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"cc"', 'failed at #373')

  " #374
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #374')

  " #375
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"bb"', 'failed at #375')

  " #376
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #376')

  " #377
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #377')

  " #378
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #378')

  " #379
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"aa"', 'failed at #379')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #380
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #380')

  " #381
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #381')

  " #382
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #382')

  " #383
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #383')

  " #384
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #384')

  " #385
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #385')

  " #386
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #386')

  " #387
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyas"
  call g:assert.equals(@@, '"""aa"""', 'failed at #387')

  " #388
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #388')

  " #389
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyas"
  call g:assert.equals(@@, '"""bb"""', 'failed at #389')

  " #390
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #390')

  " #391
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #391')

  " #392
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #392')

  " #393
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #393')

  " #394
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #394')

  " #395
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #395')

  " #396
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #396')

  " #397
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyas"
  call g:assert.equals(@@, '"""cc"""', 'failed at #397')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #398
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyast
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #398')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #399
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(
  call g:assert.equals(@@, '(foo)', 'failed at #399')

  " #400
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyas(((
  call g:assert.equals(@@, '(((foo)))', 'failed at #400')
endfunction
"}}}
function! s:suite.a_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #401
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyasa
  call g:assert.equals(@@, 'αbbα', 'failed at #401')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #402
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyasa
  call g:assert.equals(@@, 'aαbbaα', 'failed at #402')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ off
  " #403
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #403')

  " #404
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #404')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #405
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #405')

  " #406
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '2aa3', 'failed at #406')

  " #407
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasb
  call g:assert.equals(@@, '', 'failed at #407')

  " #408
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yasc
  call g:assert.equals(@@, '', 'failed at #408')

  " #409
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal 0yasd
  call g:assert.equals(@@, 'headfootail', 'failed at #409')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #410
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #410')

  " #411
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #411')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #412
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #412')

  " #413
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '888aa888', 'failed at #413')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #414
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooa', 'failed at #414')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #415
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, 'afooaa', 'failed at #415')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #416
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyas'
  call g:assert.equals(@@, "'''foo'''", 'failed at #416')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #417
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #417')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #418
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #418')

  %delete

  " #419
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #419')

  %delete

  " #420
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #420')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #421
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #421')

  %delete

  " #422
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #422')

  %delete

  " #423
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #423')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #424
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"aa"', 'failed at #424')

  %delete

  " #425
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyas"
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #425')

  %delete

  " #426
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyas"
  call g:assert.equals(@@, '', 'failed at #426')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #427
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #427')

  " #428
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '{foo}', 'failed at #428')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #429
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '(foo)', 'failed at #429')

  " #430
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yasa
  call g:assert.equals(@@, '', 'failed at #430')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #431
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #431')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #432
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #432')

  highlight link TestParen Special

  " #433
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #433')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #434
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #434')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #435
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #435')

  highlight link TestParen Special

  " #436
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(bar)', 'failed at #436')
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

  " #437
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #437')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #438
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #438')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #439
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #439')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #440
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #440')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #441
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #441')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #442
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #442')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #443
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #443')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #444
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #444')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #445
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '', 'failed at #445')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #446
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yas(
  call g:assert.equals(@@, '(foo)', 'failed at #446')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #447
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yas"
  call g:assert.equals(@@, '"%s"', 'failed at #447')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('query', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #448
  call setline('.', '(foo)')
  normal 0sdas(
  call g:assert.equals(getline('.'), 'foo', 'failed at #448')

  " #449
  call setline('.', '((foo))')
  normal 0ff2sd2as(
  call g:assert.equals(getline('.'), 'foo', 'failed at #449')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]
  let g:operator#sandwich#recipes = []

  " #450
  call setline('.', '<bar>foo</bar>')
  normal 0sdast
  call g:assert.equals(getline('.'), 'foo', 'failed at #450')

  " #451
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ast
  call g:assert.equals(getline('.'), 'foo', 'failed at #451')
endfunction
"}}}
function! s:suite.a_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #452
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyasa
  call g:assert.equals(@@, 'aaaaa', 'failed at #452')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #453
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyasa
  call g:assert.equals(@@, 'aaaaa', 'failed at #453')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #454
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(foo)', 'failed at #454')

  " #455
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvas)y
  call g:assert.equals(@@, '(foo)', 'failed at #455')

  " #456
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas[y
  call g:assert.equals(@@, '[foo]', 'failed at #456')

  " #457
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvas]y
  call g:assert.equals(@@, '[foo]', 'failed at #457')

  " #458
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas{y
  call g:assert.equals(@@, '{foo}', 'failed at #458')

  " #459
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvas}y
  call g:assert.equals(@@, '{foo}', 'failed at #459')

  " #460
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas<y
  call g:assert.equals(@@, '<foo>', 'failed at #460')

  " #461
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvas>y
  call g:assert.equals(@@, '<foo>', 'failed at #461')

  " #462
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"foo"', 'failed at #462')

  " #463
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvas'y
  call g:assert.equals(@@, "'foo'", 'failed at #463')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #464
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '()', 'failed at #464')

  " #465
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(a)', 'failed at #465')

  " #466
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #466')

  " #467
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #467')

  " #468
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #468')

  " #469
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #469')

  " #470
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #470')

  " #471
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #471')

  " #472
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #472')

  " #473
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #473')

  " #474
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #474')

  " #475
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(cc)', 'failed at #475')

  " #476
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #476')

  " #477
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #477')

  " #478
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #478')

  " #479
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #479')

  " #480
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #480')

  " #481
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #481')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1, 'input': ['(']}]

  " #482
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #482')

  " #483
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #483')

  " #484
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #484')

  " #485
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #485')

  " #486
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #486')

  " #487
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #487')

  " #488
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #488')

  " #489
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #489')

  " #490
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #490')

  " #491
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #491')

  " #492
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #492')

  " #493
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #493')

  " #494
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvas(y
  call g:assert.equals(@@, '(((bb)))', 'failed at #494')

  " #495
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #495')

  " #496
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #496')

  " #497
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #497')

  " #498
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #498')

  " #499
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvas(y
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #499')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #500
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '""', 'failed at #500')

  " #501
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"a"', 'failed at #501')

  " #502
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #502')

  " #503
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #503')

  " #504
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #504')

  " #505
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #505')

  " #506
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #506')

  " #507
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #507')

  " #508
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #508')

  " #509
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #509')

  " #510
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #510')

  " #511
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"cc"', 'failed at #511')

  " #512
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #512')

  " #513
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"bb"', 'failed at #513')

  " #514
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #514')

  " #515
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #515')

  " #516
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #516')

  " #517
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"aa"', 'failed at #517')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0, 'input': ['"']}]

  " #518
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #518')

  " #519
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #519')

  " #520
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #520')

  " #521
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #521')

  " #522
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #522')

  " #523
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #523')

  " #524
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #524')

  " #525
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvas"y
  call g:assert.equals(@@, '"""aa"""', 'failed at #525')

  " #526
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #526')

  " #527
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvas"y
  call g:assert.equals(@@, '"""bb"""', 'failed at #527')

  " #528
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #528')

  " #529
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #529')

  " #530
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #530')

  " #531
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #531')

  " #532
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #532')

  " #533
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #533')

  " #534
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #534')

  " #535
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvas"y
  call g:assert.equals(@@, '"""cc"""', 'failed at #535')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'input': ['t']}]

  " #536
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvasty
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #536')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]

  " #537
  " NOTE: At this moment the first y after vas( is ignored...
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(yy
  call g:assert.equals(@@, '(foo)', 'failed at #537')

  " #538
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvas(((y
  call g:assert.equals(@@, '(((foo)))', 'failed at #538')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #539
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{y
  call g:assert.equals(@@, '{cc}', 'failed at #539')

  " #540
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[y
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #540')

  " #541
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvas{as[as(y
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #541')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #542
  call append(0, ['(aa', 'aa', 'aa)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>as(y"
  call g:assert.equals(@@, "(aa\naa\naa)", 'failed at #542')

  %delete

  " #543
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #543')

  %delete

  " #544
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #544')

  %delete

  " #545
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jas(y"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #545')

  %delete

  " #546
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joas(y"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #546')
endfunction
"}}}
function! s:suite.a_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #547
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvasay
  call g:assert.equals(@@, 'αbbα', 'failed at #547')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #548
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvasay
  call g:assert.equals(@@, 'aαbbaα', 'failed at #548')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+2'], 'input': ['a']},
        \   {'buns': ['SandwichExprEmpty()', '1+2'], 'input': ['b']},
        \   {'buns': ['1+1', 'SandwichExprEmpty()'], 'input': ['c']},
        \   {'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']},
        \ ]

  """ off
  " #549
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #549')

  " #550
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2', 'failed at #550')

  """ on
  call textobj#sandwich#set('query', 'expr', 1)
  " #551
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '1', 'failed at #551')

  " #552
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '2aa3', 'failed at #552')

  " #553
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vasby
  call g:assert.equals(@@, '2', 'failed at #553')

  " #554
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vascy
  call g:assert.equals(@@, '2', 'failed at #554')

  " #555
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal 0vasdy
  call g:assert.equals(@@, 'headfootail', 'failed at #555')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+'], 'input': ['a']}]

  """ off
  " #556
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #556')

  " #557
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '8', 'failed at #557')

  """ on
  call textobj#sandwich#set('query', 'regex', 1)
  " #558
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '\', 'failed at #558')

  " #559
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '888aa888', 'failed at #559')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #560
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooa', 'failed at #560')

  """ on
  call textobj#sandwich#set('query', 'skip_regex', ['aa'])
  " #561
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, 'afooaa', 'failed at #561')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('query', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('query', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #562
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvas'y
  call g:assert.equals(@@, "'''foo'''", 'failed at #562')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #563
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #563')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #564
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #564')

  %delete

  " #565
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #565')

  %delete

  " #566
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #566')

  %delete

  """ 0
  call textobj#sandwich#set('query', 'expand_range', 0)
  " #567
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #567')

  %delete

  " #568
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #568')

  %delete

  " #569
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #569')

  %delete

  """ 1
  call textobj#sandwich#set('query', 'expand_range', 1)
  " #570
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"aa"', 'failed at #570')

  %delete

  " #571
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvas"y
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #571')

  %delete

  " #572
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvas"y
  call g:assert.equals(@@, '"', 'failed at #572')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{'], 'input': ['a']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #573
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(', 'failed at #573')

  " #574
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{foo}', 'failed at #574')

  """ off
  call textobj#sandwich#set('query', 'noremap', 0)
  " #575
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '(foo)', 'failed at #575')

  " #576
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vasay
  call g:assert.equals(@@, '{', 'failed at #576')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'syntax', [])

  " #577
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #577')

  call textobj#sandwich#set('query', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #578
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #578')

  highlight link TestParen Special

  " #579
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #579')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('query', 'inner_syntax', [])

  " #580
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #580')

  call textobj#sandwich#set('query', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #581
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #581')

  highlight link TestParen Special

  " #582
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(bar)', 'failed at #582')
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

  " #583
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #583')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #584
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #584')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #585
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #585')

  """ 2
  call textobj#sandwich#set('query', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #586
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #586')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #587
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #587')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #588
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #588')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #589
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #589')

  """ 3
  call textobj#sandwich#set('query', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #590
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #590')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #591
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(', 'failed at #591')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #592
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vas(y
  call g:assert.equals(@@, '(foo)', 'failed at #592')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #593
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vas"y
  call g:assert.equals(@@, '"%s"', 'failed at #593')
endfunction
"}}}
function! s:suite.a_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('query', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #594
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvasay
  call g:assert.equals(@@, 'aaaaa', 'failed at #594')

  %delete

  """ funcref
  call textobj#sandwich#set('query', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #595
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvasay
  call g:assert.equals(@@, 'aaaaa', 'failed at #595')
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

  " #596
  call setline('.', '"foo\""')
  normal 0dis"
  call g:assert.equals(getline('.'), '""', 'failed at #596')

  " #597
  call setline('.', '(foo)')
  normal 0dis(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #597')

  " #598
  call setline('.', '[foo]')
  normal 0dis[
  call g:assert.equals(getline('.'), '[]', 'failed at #598')

  " #599
  call setline('.', '"foo\""')
  normal 0diis"
  call g:assert.equals(getline('.'), '"""', 'failed at #599')

  " #600
  call setline('.', '(foo)')
  normal 0diis(
  call g:assert.equals(getline('.'), '()', 'failed at #600')

  " #601
  call setline('.', '[foo]')
  normal 0diis[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #601')
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

  " #602
  call setline('.', '"foo\""')
  normal 0das"
  call g:assert.equals(getline('.'), '', 'failed at #602')

  " #603
  call setline('.', '(foo)')
  normal 0das(
  call g:assert.equals(getline('.'), '(foo)', 'failed at #603')

  " #604
  call setline('.', '[foo]')
  normal 0das[
  call g:assert.equals(getline('.'), '', 'failed at #604')

  " #605
  call setline('.', '"foo\""')
  normal 0daas"
  call g:assert.equals(getline('.'), '"', 'failed at #605')

  " #606
  call setline('.', '(foo)')
  normal 0daas(
  call g:assert.equals(getline('.'), '', 'failed at #606')

  " #607
  call setline('.', '[foo]')
  normal 0daas[
  call g:assert.equals(getline('.'), '[foo]', 'failed at #607')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
